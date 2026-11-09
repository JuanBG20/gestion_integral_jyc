-- =============================================================================
-- Mercado Pago multiusuario (OAuth)
-- Pegar completo en Supabase → SQL Editor → Run.
-- =============================================================================

-- 1) Cuenta de MP conectada de cada usuario.
--    Guarda los tokens: queda bloqueada para la app (RLS sin políticas).
--    Solo las Edge Functions (service role) pueden leerla/escribirla.
CREATE TABLE IF NOT EXISTS public.mp_cuenta (
  user_id        uuid        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  mp_user_id     bigint      NOT NULL UNIQUE,
  nickname       text,
  access_token   text        NOT NULL,
  refresh_token  text        NOT NULL,
  expires_at     timestamptz NOT NULL,
  estado         text        NOT NULL DEFAULT 'activa'
                             CHECK (estado IN ('activa', 'requiere_reconexion')),
  ultimo_sync    timestamptz,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.mp_cuenta ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.mp_cuenta FROM anon, authenticated;

-- 2) Códigos temporales del flujo OAuth (para saber qué usuario autorizó).
CREATE TABLE IF NOT EXISTS public.mp_oauth_state (
  state       uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at  timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.mp_oauth_state ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.mp_oauth_state FROM anon, authenticated;

-- 3) Estado de la conexión del usuario logueado (sin tokens).
CREATE OR REPLACE FUNCTION public.mp_estado_conexion()
RETURNS TABLE (
  conectada    boolean,
  nickname     text,
  estado       text,
  ultimo_sync  timestamptz
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT true, c.nickname, c.estado, c.ultimo_sync
  FROM public.mp_cuenta c
  WHERE c.user_id = auth.uid();
$$;

REVOKE ALL ON FUNCTION public.mp_estado_conexion() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.mp_estado_conexion() TO authenticated;

-- 4) Desconectar la cuenta del usuario logueado (los movimientos se conservan).
CREATE OR REPLACE FUNCTION public.mp_desconectar()
RETURNS void
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  DELETE FROM public.mp_cuenta WHERE user_id = auth.uid();
$$;

REVOKE ALL ON FUNCTION public.mp_desconectar() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.mp_desconectar() TO authenticated;

-- 5) id_mp único por usuario (antes era único en toda la tabla).
ALTER TABLE public.movimiento_mp DROP CONSTRAINT IF EXISTS ck_movimiento_mp_id_mp;
ALTER TABLE public.movimiento_mp
  ADD CONSTRAINT uq_movimiento_mp_user_id_mp UNIQUE (user_id, id_mp);
