// La llama la página de Astro a la que Mercado Pago redirige después de autorizar.
// Recibe { code, state }, cambia el código por los tokens y los guarda en mp_cuenta.
// Configuración en el dashboard: "Verify JWT" DESACTIVADO (la llama una página pública).
// Secrets: MP_CLIENT_ID, MP_CLIENT_SECRET, MP_REDIRECT_URI (= URL de la página de Astro).
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

const fail = (error: string, status = 400) => json({ ok: false, error }, status);

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return fail("Método no permitido", 405);
  }

  try {
    const { code, state } = await req.json().catch(() => ({}));
    if (!code || !state) {
      return fail("Faltan datos en la respuesta de Mercado Pago.");
    }

    const admin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    // Validar y consumir el state (uso único, vence a los 10 minutos).
    const { data: stateRow } = await admin
      .from("mp_oauth_state")
      .delete()
      .eq("state", state)
      .select("user_id, created_at")
      .maybeSingle();

    if (!stateRow) {
      return fail(
        "El enlace ya fue usado o no es válido. Volvé a la app y tocá “Conectar Mercado Pago” otra vez.",
      );
    }
    const ageMs = Date.now() - new Date(stateRow.created_at).getTime();
    if (ageMs > 10 * 60 * 1000) {
      return fail(
        "El enlace venció. Volvé a la app y tocá “Conectar Mercado Pago” otra vez.",
      );
    }

    // Cambiar el código por los tokens.
    const tokenRes = await fetch("https://api.mercadopago.com/oauth/token", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        grant_type: "authorization_code",
        client_id: Deno.env.get("MP_CLIENT_ID")!,
        client_secret: Deno.env.get("MP_CLIENT_SECRET")!,
        code,
        redirect_uri: Deno.env.get("MP_REDIRECT_URI")!,
      }),
    });
    const token = await tokenRes.json();

    if (!tokenRes.ok || !token.access_token) {
      console.error("MP oauth/token error", token);
      return fail("Mercado Pago rechazó la autorización. Intentá de nuevo.", 502);
    }

    // Nombre de la cuenta para mostrar en la app.
    let nickname: string | null = null;
    try {
      const meRes = await fetch("https://api.mercadopago.com/users/me", {
        headers: { Authorization: `Bearer ${token.access_token}` },
      });
      if (meRes.ok) {
        const me = await meRes.json();
        nickname = me.nickname ?? me.email ?? null;
      }
    } catch (_) {
      // No es crítico.
    }

    // Si esta cuenta de MP estaba conectada a otro usuario de la app, se libera.
    await admin
      .from("mp_cuenta")
      .delete()
      .eq("mp_user_id", token.user_id)
      .neq("user_id", stateRow.user_id);

    const expiresAt = new Date(
      Date.now() + Number(token.expires_in ?? 15552000) * 1000,
    ).toISOString();

    const { error: upsertError } = await admin.from("mp_cuenta").upsert(
      {
        user_id: stateRow.user_id,
        mp_user_id: token.user_id,
        nickname,
        access_token: token.access_token,
        refresh_token: token.refresh_token,
        expires_at: expiresAt,
        estado: "activa",
        updated_at: new Date().toISOString(),
      },
      { onConflict: "user_id" },
    );

    if (upsertError) {
      console.error("mp_cuenta upsert error", upsertError);
      return fail("No se pudo guardar la conexión. Intentá de nuevo.", 500);
    }

    return json({ ok: true, nickname });
  } catch (e) {
    console.error(e);
    return fail("Ocurrió un error inesperado. Intentá de nuevo.", 500);
  }
});
