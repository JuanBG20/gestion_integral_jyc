// Devuelve la URL de autorización de Mercado Pago para el usuario logueado.
// Configuración en el dashboard: "Verify JWT" ACTIVADO.
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const clientId = Deno.env.get("MP_CLIENT_ID");
    const redirectUri = Deno.env.get("MP_REDIRECT_URI");

    if (!clientId || !redirectUri) {
      return json({ error: "Faltan MP_CLIENT_ID o MP_REDIRECT_URI" }, 500);
    }

    // Usuario que hace la petición (a partir de su JWT).
    const authHeader = req.headers.get("Authorization") ?? "";
    const userClient = createClient(
      supabaseUrl,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } },
    );
    const { data: { user }, error: userError } = await userClient.auth.getUser();
    if (userError || !user) {
      return json({ error: "No autenticado" }, 401);
    }

    const admin = createClient(
      supabaseUrl,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    // Limpieza de states vencidos (más de 10 minutos) y del usuario actual.
    const tenMinutesAgo = new Date(Date.now() - 10 * 60 * 1000).toISOString();
    await admin.from("mp_oauth_state").delete().lt("created_at", tenMinutesAgo);
    await admin.from("mp_oauth_state").delete().eq("user_id", user.id);

    const { data: stateRow, error: stateError } = await admin
      .from("mp_oauth_state")
      .insert({ user_id: user.id })
      .select("state")
      .single();

    if (stateError || !stateRow) {
      return json({ error: "No se pudo iniciar la conexión" }, 500);
    }

    const url = new URL("https://auth.mercadopago.com.ar/authorization");
    url.searchParams.set("client_id", clientId);
    url.searchParams.set("response_type", "code");
    url.searchParams.set("platform_id", "mp");
    url.searchParams.set("state", stateRow.state);
    url.searchParams.set("redirect_uri", redirectUri);

    return json({ url: url.toString() });
  } catch (e) {
    return json({ error: `Error inesperado: ${e}` }, 500);
  }
});
