// Sincroniza los cobros de Mercado Pago de TODAS las cuentas conectadas (tabla mp_cuenta).
// La llama el cron (función de base de datos llamar_movimientos...) con el CRON_SECRET.
// Secrets necesarios: CRON_SECRET, MP_CLIENT_ID, MP_CLIENT_SECRET.
import { createClient, SupabaseClient } from "npm:@supabase/supabase-js@2";

type MpCuenta = {
  user_id: string;
  mp_user_id: number;
  access_token: string;
  refresh_token: string;
  expires_at: string;
};

type Resultado = {
  user_id: string;
  procesados?: number;
  error?: string;
};

const SIETE_DIAS_MS = 7 * 24 * 60 * 60 * 1000;
const SOLAPAMIENTO_MS = 24 * 60 * 60 * 1000; // Revisa 1 día hacia atrás por si algo se aprobó tarde
const PAGINA = 100;
const MAX_PAGINAS = 10;

class TokenInvalidoError extends Error {}

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

// Renueva el token si vence en menos de 7 días. Devuelve el access_token vigente.
async function obtenerTokenVigente(
  supabase: SupabaseClient,
  cuenta: MpCuenta,
): Promise<string> {
  const venceEn = new Date(cuenta.expires_at).getTime() - Date.now();
  if (venceEn > SIETE_DIAS_MS) return cuenta.access_token;

  const res = await fetch("https://api.mercadopago.com/oauth/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "refresh_token",
      client_id: Deno.env.get("MP_CLIENT_ID")!,
      client_secret: Deno.env.get("MP_CLIENT_SECRET")!,
      refresh_token: cuenta.refresh_token,
    }),
  });
  const data = await res.json();

  if (!res.ok || !data.access_token) {
    // invalid_grant / 400 / 401: el permiso ya no sirve, hay que reconectar.
    if (res.status === 400 || res.status === 401) {
      throw new TokenInvalidoError(
        `No se pudo renovar el token: ${data.message ?? data.error ?? res.status}`,
      );
    }
    throw new Error(`Error renovando token (${res.status})`);
  }

  const expiresAt = new Date(
    Date.now() + Number(data.expires_in ?? 15552000) * 1000,
  ).toISOString();

  await supabase
    .from("mp_cuenta")
    .update({
      access_token: data.access_token,
      refresh_token: data.refresh_token ?? cuenta.refresh_token,
      expires_at: expiresAt,
      updated_at: new Date().toISOString(),
    })
    .eq("user_id", cuenta.user_id);

  return data.access_token;
}

// Mismo mapeo que la versión anterior.
// deno-lint-ignore no-explicit-any
function mapearPago(p: any, appUserId: string) {
  let metodoFinal = "TRANSFERENCIA";

  const paymentType = (p.payment_type_id || "").toLowerCase();
  const poiType = (p.point_of_interaction?.type || "").toLowerCase();
  const subType = (p.point_of_interaction?.sub_type || "").toLowerCase();
  const businessUnit = (p.point_of_interaction?.business_info?.sub_unit || "")
    .toLowerCase();
  const businessBranch = (p.point_of_interaction?.business_info?.branch || "")
    .toLowerCase();
  const tags = p.tags || [];

  const esQR = poiType === "qr_code" ||
    subType.includes("qr") ||
    tags.includes("qr") ||
    businessUnit === "qr" ||
    businessBranch === "qr";

  if (paymentType === "ticket" || paymentType === "atm") {
    metodoFinal = "EFECTIVO";
  } else if (esQR) {
    metodoFinal = "QR";
  } else if (
    ["credit_card", "debit_card", "prepaid_card"].includes(paymentType)
  ) {
    metodoFinal = "TARJETA";
  }

  let tipoDoc = null;
  let numDoc = null;

  // Evita tomar el documento propio cuando el pagador es el mismo cobrador.
  if (String(p.payer?.id) !== String(p.collector_id)) {
    const bankPayer = p.point_of_interaction?.transaction_data?.bank_info
      ?.payer;

    tipoDoc = bankPayer?.identification?.type ||
      p.payer?.identification?.type || null;
    numDoc = bankPayer?.identification?.number ||
      p.payer?.identification?.number || null;

    if (tipoDoc && typeof tipoDoc === "object") tipoDoc = null;
    if (numDoc && typeof numDoc === "object") numDoc = null;
  }

  return {
    id_mp: p.id.toString(),
    user_id: appUserId,
    fecha: p.date_created,
    monto: p.transaction_amount,
    metodo_pago: metodoFinal,
    tipo_documento: tipoDoc,
    num_documento: numDoc,
  };
}

async function sincronizarCuenta(
  supabase: SupabaseClient,
  cuenta: MpCuenta,
): Promise<number> {
  const accessToken = await obtenerTokenVigente(supabase, cuenta);

  // Desde el último movimiento guardado (menos 1 día de margen), o los últimos 7 días.
  const { data: lastRecord } = await supabase
    .from("movimiento_mp")
    .select("fecha")
    .eq("user_id", cuenta.user_id)
    .order("fecha", { ascending: false })
    .limit(1)
    .maybeSingle();

  const begin = lastRecord?.fecha
    ? new Date(new Date(lastRecord.fecha).getTime() - SOLAPAMIENTO_MS)
    : new Date(Date.now() - SIETE_DIAS_MS);

  const beginDate = begin.toISOString();
  const endDate = new Date().toISOString();

  // deno-lint-ignore no-explicit-any
  const pagos: any[] = [];
  for (let pagina = 0; pagina < MAX_PAGINAS; pagina++) {
    const url = new URL("https://api.mercadopago.com/v1/payments/search");
    url.searchParams.set("sort", "date_created");
    url.searchParams.set("criteria", "desc");
    url.searchParams.set("range", "date_created");
    url.searchParams.set("begin_date", beginDate);
    url.searchParams.set("end_date", endDate);
    url.searchParams.set("limit", String(PAGINA));
    url.searchParams.set("offset", String(pagina * PAGINA));

    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${accessToken}` },
    });

    if (res.status === 401 || res.status === 403) {
      throw new TokenInvalidoError("Mercado Pago rechazó el token");
    }
    if (!res.ok) {
      throw new Error(`Error consultando API de MP: ${await res.text()}`);
    }

    const data = await res.json();
    const results = data.results || [];
    pagos.push(...results);

    if (results.length < PAGINA) break;
  }

  const movimientos = pagos
    .filter((p) =>
      p.status === "approved" &&
      p.transaction_amount > 0 &&
      String(p.collector_id) === String(cuenta.mp_user_id)
    )
    .map((p) => mapearPago(p, cuenta.user_id));

  if (movimientos.length > 0) {
    const { error } = await supabase
      .from("movimiento_mp")
      .upsert(movimientos, { onConflict: "user_id,id_mp" });
    if (error) throw new Error(`Error guardando movimientos: ${error.message}`);
  }

  await supabase
    .from("mp_cuenta")
    .update({ ultimo_sync: new Date().toISOString() })
    .eq("user_id", cuenta.user_id);

  return movimientos.length;
}

Deno.serve(async (req) => {
  try {
    const cronSecret = Deno.env.get("CRON_SECRET");
    const authHeader = req.headers.get("Authorization");

    if (!cronSecret || authHeader !== `Bearer ${cronSecret}`) {
      return json({ error: "Unauthorized" }, 401);
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
    );

    // Cuando exista el webhook de RevenueCat, acá se filtra por usuarios premium vigentes.
    const { data: cuentas, error } = await supabase
      .from("mp_cuenta")
      .select("user_id, mp_user_id, access_token, refresh_token, expires_at")
      .eq("estado", "activa");

    if (error) throw error;

    const resultados: Resultado[] = [];

    // Una cuenta por vez: si una falla, se registra y se sigue con la siguiente.
    for (const cuenta of (cuentas ?? []) as MpCuenta[]) {
      try {
        const procesados = await sincronizarCuenta(supabase, cuenta);
        resultados.push({ user_id: cuenta.user_id, procesados });
      } catch (e) {
        const mensaje = e instanceof Error ? e.message : String(e);
        console.error(`Cuenta ${cuenta.user_id}:`, mensaje);

        if (e instanceof TokenInvalidoError) {
          await supabase
            .from("mp_cuenta")
            .update({
              estado: "requiere_reconexion",
              updated_at: new Date().toISOString(),
            })
            .eq("user_id", cuenta.user_id);
        }

        resultados.push({ user_id: cuenta.user_id, error: mensaje });
      }
    }

    return json({
      message: "Sincronización finalizada",
      cuentas: resultados.length,
      con_error: resultados.filter((r) => r.error).length,
      resultados,
    });
  } catch (error) {
    const mensaje = error instanceof Error ? error.message : String(error);
    return json({ error: mensaje }, 500);
  }
});
