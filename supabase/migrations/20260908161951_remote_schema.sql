SET local check_function_bodies = off;

CREATE EXTENSION "pg_cron";

CREATE EXTENSION "pg_net" SCHEMA "extensions";

CREATE EXTENSION "unaccent" SCHEMA "extensions";

CREATE SEQUENCE "public"."actividad_idactividad_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."cliente_idcliente_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."configuracion_fiscal_activida_idconfiguracion_fiscal_activi_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."configuracion_fiscal_idconfiguracion_fiscal_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."configuracion_fiscal_punto_ve_idconfiguracion_fiscal_punto__seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."contiene_trabajo_idcontiene_trabajo_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."contiene_venta_idcontiene_venta_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."estado_idestado_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."fabrica_idfabrica_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."factura_idfactura_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."historial_estado_idhistorial_estado_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."materia_prima_idmateria_prima_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."movimiento_mp_idmovimiento_mp_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."pago_parcial_idpago_parcial_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."producto_base_idproducto_base_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."producto_variante_idproducto_variante_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."punto_venta_idpunto_venta_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."retazo_idretazo_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."rol_idrol_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."rol_usuario_idrol_usuario_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."trabajo_idtrabajo_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."usuario_idusuario_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."venta_descuento_idventa_descuento_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."venta_idventa_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE TABLE "public"."actividad" (
  "idactividad" integer                NOT NULL DEFAULT nextval('public.actividad_idactividad_seq'::regclass),
  "nombre"      character varying(255) NOT NULL,
  "codigo"      character varying(255) NOT NULL,
  CONSTRAINT "ck_actividad_codigo" UNIQUE (codigo),
  CONSTRAINT "pk_actividad" PRIMARY KEY (idactividad),
  "user_id"     uuid                   DEFAULT auth.uid()
);

ALTER TABLE "public"."actividad"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."cliente" (
  "idcliente"         integer                NOT NULL DEFAULT nextval('public.cliente_idcliente_seq'::regclass),
  "nombre"            character varying(255) NOT NULL,
  "apellido"          character varying(255) NOT NULL,
  "notas_adicionales" text,
  "num_documento"     character varying(50),
  "correo"            character varying(255),
  "telefono"          character varying(255),
  "calle"             character varying(255),
  "numero"            character varying(255),
  "localidad"         character varying(255),
  "piso"              character varying(50),
  "departamento"      character varying(50),
  CONSTRAINT "pk_cliente" PRIMARY KEY (idcliente),
  "user_id"           uuid                   DEFAULT auth.uid()
);

ALTER TABLE "public"."cliente"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."configuracion_fiscal_actividad" (
  "idconfiguracion_fiscal_actividad" integer NOT NULL DEFAULT nextval('public.configuracion_fiscal_activida_idconfiguracion_fiscal_activi_seq'::regclass),
  "configuracion_fiscal"             integer NOT NULL,
  "actividad"                        integer NOT NULL,
  CONSTRAINT "ck_configuracion_fiscal_actividad" UNIQUE (configuracion_fiscal, actividad),
  CONSTRAINT "pk_configuracion_fiscal_actividad" PRIMARY KEY (idconfiguracion_fiscal_actividad)
);

ALTER TABLE "public"."configuracion_fiscal_actividad"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."configuracion_fiscal_punto_venta" (
  "idconfiguracion_fiscal_punto_venta" integer NOT NULL DEFAULT nextval('public.configuracion_fiscal_punto_ve_idconfiguracion_fiscal_punto__seq'::regclass),
  "configuracion_fiscal"               integer NOT NULL,
  "punto_venta"                        integer NOT NULL,
  CONSTRAINT "ck_configuracion_fiscal_punto_venta" UNIQUE (configuracion_fiscal, punto_venta),
  CONSTRAINT "pk_configuracion_fiscal_punto_venta" PRIMARY KEY (idconfiguracion_fiscal_punto_venta)
);

ALTER TABLE "public"."configuracion_fiscal_punto_venta"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."configuracion_fiscal" (
  "idconfiguracion_fiscal" integer                NOT NULL DEFAULT nextval('public.configuracion_fiscal_idconfiguracion_fiscal_seq'::regclass),
  "cuil"                   character varying(255) NOT NULL,
  CONSTRAINT "ck_configuracion_fiscal_cuil" UNIQUE (cuil),
  CONSTRAINT "pk_configuracion_fiscal" PRIMARY KEY (idconfiguracion_fiscal),
  "user_id"                uuid                   DEFAULT auth.uid()
);

ALTER TABLE "public"."configuracion_fiscal"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."contiene_trabajo" (
  "idcontiene_trabajo" integer       NOT NULL DEFAULT nextval('public.contiene_trabajo_idcontiene_trabajo_seq'::regclass),
  "producto_variante"  integer,
  "trabajo"            integer       NOT NULL,
  "cantidad"           integer       NOT NULL,
  "hecho"              boolean       NOT NULL DEFAULT false,
  "precio_unitario"    numeric(10,2) DEFAULT 0,
  "descripcion"        text,
  CONSTRAINT "ck_contiene_trabajo_producto_o_desc" CHECK (((producto_variante IS NOT NULL) OR (descripcion IS NOT NULL))),
  CONSTRAINT "ck_contiene_trabajo" UNIQUE (producto_variante, trabajo),
  CONSTRAINT "pk_contiene_trabajo" PRIMARY KEY (idcontiene_trabajo)
);

ALTER TABLE "public"."contiene_trabajo"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."contiene_venta" (
  "idcontiene_venta"  integer       NOT NULL DEFAULT nextval('public.contiene_venta_idcontiene_venta_seq'::regclass),
  "producto_variante" integer,
  "venta"             integer       NOT NULL,
  "cantidad"          integer       NOT NULL,
  "precio_unitario"   numeric(10,2) DEFAULT 0,
  "descripcion"       text,
  CONSTRAINT "ck_contiene_venta_producto_o_desc" CHECK (((producto_variante IS NOT NULL) OR (descripcion IS NOT NULL))),
  CONSTRAINT "ck_contiene_venta" UNIQUE (producto_variante, venta),
  CONSTRAINT "pk_contiene_venta" PRIMARY KEY (idcontiene_venta)
);

ALTER TABLE "public"."contiene_venta"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."estado" (
  "idestado" integer NOT NULL DEFAULT nextval('public.estado_idestado_seq'::regclass),
  CONSTRAINT "pk_estado" PRIMARY KEY (idestado)
);

ALTER TABLE "public"."estado"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."fabrica" (
  "idfabrica"         integer       NOT NULL DEFAULT nextval('public.fabrica_idfabrica_seq'::regclass),
  "producto_variante" integer       NOT NULL,
  "materia_prima"     integer       NOT NULL,
  "cantidad"          numeric(10,2) NOT NULL,
  CONSTRAINT "ck_fabrica" UNIQUE (producto_variante, materia_prima),
  CONSTRAINT "pk_fabrica" PRIMARY KEY (idfabrica)
);

ALTER TABLE "public"."fabrica"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."factura" (
  "idfactura"      integer                  NOT NULL DEFAULT nextval('public.factura_idfactura_seq'::regclass),
  "respuesta_arca" jsonb                    NOT NULL,
  "exitoso"        boolean                  NOT NULL DEFAULT false,
  "fecha_emision"  timestamp with time zone NOT NULL,
  "cae"            character varying(255),
  "venta"          integer                  NOT NULL,
  CONSTRAINT "pk_factura" PRIMARY KEY (idfactura),
  "user_id"        uuid                     DEFAULT auth.uid()
);

ALTER TABLE "public"."factura"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."historial_estado" (
  "idhistorial_estado" integer                  NOT NULL DEFAULT nextval('public.historial_estado_idhistorial_estado_seq'::regclass),
  "fecha"              timestamp with time zone NOT NULL DEFAULT now(),
  "trabajo"            integer                  NOT NULL,
  "estado"             integer                  NOT NULL,
  CONSTRAINT "pk_historial_estado" PRIMARY KEY (idhistorial_estado)
);

ALTER TABLE "public"."historial_estado"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."materia_prima" (
  "idmateria_prima" integer                NOT NULL DEFAULT nextval('public.materia_prima_idmateria_prima_seq'::regclass),
  "sku"             character varying(255) NOT NULL,
  "stock"           numeric(10,2)          NOT NULL DEFAULT 0,
  "categoria"       character varying(255) NOT NULL,
  "subcategoria"    character varying(255) NOT NULL,
  "descripcion"     text                   NOT NULL,
  "stock_minimo"    numeric(10,2)          NOT NULL DEFAULT 0,
  "precio_unitario" numeric(10,2)          NOT NULL DEFAULT 0,
  CONSTRAINT "ck_materia_prima_sku" UNIQUE (sku),
  CONSTRAINT "pk_materia_prima" PRIMARY KEY (idmateria_prima),
  "user_id"         uuid                   DEFAULT auth.uid()
);

ALTER TABLE "public"."materia_prima"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."movimiento_mp" (
  "idmovimiento_mp" integer                  NOT NULL DEFAULT nextval('public.movimiento_mp_idmovimiento_mp_seq'::regclass),
  "id_mp"           character varying(255)   NOT NULL,
  "fecha"           timestamp with time zone NOT NULL,
  "monto"           numeric(10,2)            NOT NULL,
  "num_documento"   character varying(50),
  CONSTRAINT "ck_movimiento_mp_id_mp" UNIQUE (id_mp),
  CONSTRAINT "pk_movimiento_mp" PRIMARY KEY (idmovimiento_mp),
  "user_id"         uuid                     DEFAULT auth.uid()
);

ALTER TABLE "public"."movimiento_mp"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."mp_venta" (
  "movimiento_mp" integer NOT NULL,
  "venta"         integer NOT NULL,
  CONSTRAINT "pk_mp_venta" PRIMARY KEY (movimiento_mp, venta)
);

ALTER TABLE "public"."mp_venta"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."pago_parcial" (
  "idpago_parcial" integer                  NOT NULL DEFAULT nextval('public.pago_parcial_idpago_parcial_seq'::regclass),
  "monto"          numeric(10,2)            NOT NULL,
  "fecha"          timestamp with time zone NOT NULL DEFAULT now(),
  "trabajo"        integer                  NOT NULL,
  CONSTRAINT "pk_pago_parcial" PRIMARY KEY (idpago_parcial)
);

ALTER TABLE "public"."pago_parcial"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."producto_base" (
  "idproducto_base" integer                NOT NULL DEFAULT nextval('public.producto_base_idproducto_base_seq'::regclass),
  "sku_base"        character varying(255) NOT NULL,
  "categoria"       character varying(255) NOT NULL,
  "subcategoria"    character varying(255) NOT NULL,
  "descripcion"     text                   NOT NULL,
  CONSTRAINT "ck_producto_base_sku" UNIQUE (sku_base),
  CONSTRAINT "pk_producto_base" PRIMARY KEY (idproducto_base),
  "user_id"         uuid                   DEFAULT auth.uid()
);

ALTER TABLE "public"."producto_base"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."producto_variante" (
  "idproducto_variante" integer                NOT NULL DEFAULT nextval('public.producto_variante_idproducto_variante_seq'::regclass),
  "sku_variante"        character varying(255) NOT NULL,
  "stock"               integer                NOT NULL DEFAULT 0,
  "precio_costo"        numeric(10,2)          NOT NULL,
  "precio_venta"        numeric(10,2)          NOT NULL,
  "color"               character varying(255),
  "tamano"              character varying(255),
  "producto_base"       integer                NOT NULL,
  "markup"              numeric(10,2)          NOT NULL DEFAULT 0,
  CONSTRAINT "ck_producto_variante_producto_base" UNIQUE (producto_base, sku_variante),
  CONSTRAINT "ck_producto_variante_sku" UNIQUE (sku_variante),
  CONSTRAINT "pk_producto_variante" PRIMARY KEY (idproducto_variante),
  "user_id"             uuid                   DEFAULT auth.uid()
);

ALTER TABLE "public"."producto_variante"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."punto_venta" (
  "idpunto_venta" integer                NOT NULL DEFAULT nextval('public.punto_venta_idpunto_venta_seq'::regclass),
  "nombre"        character varying(255) NOT NULL,
  "codigo"        character varying(255) NOT NULL,
  CONSTRAINT "ck_punto_venta_codigo" UNIQUE (codigo),
  CONSTRAINT "pk_punto_venta" PRIMARY KEY (idpunto_venta),
  "user_id"       uuid                   DEFAULT auth.uid()
);

ALTER TABLE "public"."punto_venta"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."retazo" (
  "idretazo"      integer       NOT NULL DEFAULT nextval('public.retazo_idretazo_seq'::regclass),
  "ancho"         numeric(10,2) NOT NULL,
  "alto"          numeric(10,2) NOT NULL,
  "stock"         integer       NOT NULL,
  "materia_prima" integer       NOT NULL,
  CONSTRAINT "ck_retazo_materia_prima" UNIQUE (ancho, alto, materia_prima),
  CONSTRAINT "pk_retazo" PRIMARY KEY (idretazo),
  "user_id"       uuid          DEFAULT auth.uid()
);

ALTER TABLE "public"."retazo"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."rol_usuario" (
  "idrol_usuario" integer NOT NULL DEFAULT nextval('public.rol_usuario_idrol_usuario_seq'::regclass),
  "rol"           integer NOT NULL,
  "usuario"       integer NOT NULL,
  CONSTRAINT "ck_rol_usuario" UNIQUE (rol, usuario),
  CONSTRAINT "pk_rol_usuario" PRIMARY KEY (idrol_usuario)
);

ALTER TABLE "public"."rol_usuario"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."rol" (
  "idrol" integer NOT NULL DEFAULT nextval('public.rol_idrol_seq'::regclass),
  CONSTRAINT "pk_rol" PRIMARY KEY (idrol)
);

ALTER TABLE "public"."rol"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."trabajo" (
  "idtrabajo"      integer                  NOT NULL DEFAULT nextval('public.trabajo_idtrabajo_seq'::regclass),
  "fecha_creacion" timestamp with time zone NOT NULL DEFAULT now(),
  "fecha_limite"   timestamp with time zone,
  "cliente"        integer                  NOT NULL,
  CONSTRAINT "pk_trabajo" PRIMARY KEY (idtrabajo),
  "user_id"        uuid                     DEFAULT auth.uid()
);

ALTER TABLE "public"."trabajo"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."usuario" (
  "idusuario" integer                NOT NULL DEFAULT nextval('public.usuario_idusuario_seq'::regclass),
  "id_auth"   uuid                   NOT NULL,
  "nombre"    character varying(255) NOT NULL,
  "apellido"  character varying(255) NOT NULL,
  CONSTRAINT "ck_usuario_id_auth" UNIQUE (id_auth),
  CONSTRAINT "pk_usuario" PRIMARY KEY (idusuario)
);

ALTER TABLE "public"."usuario"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."venta_descuento" (
  "idventa_descuento" integer                NOT NULL DEFAULT nextval('public.venta_descuento_idventa_descuento_seq'::regclass),
  "venta"             integer                NOT NULL,
  "motivo"            character varying(255) NOT NULL,
  "monto_descontado"  numeric(10,2)          NOT NULL,
  CONSTRAINT "pk_venta_descuento" PRIMARY KEY (idventa_descuento)
);

ALTER TABLE "public"."venta_descuento"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."venta_trabajo" (
  "venta"   integer NOT NULL,
  "trabajo" integer NOT NULL,
  CONSTRAINT "pk_venta_trabajo" PRIMARY KEY (trabajo)
);

ALTER TABLE "public"."venta_trabajo"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."venta" (
  "idventa"     integer                  NOT NULL DEFAULT nextval('public.venta_idventa_seq'::regclass),
  "fecha"       timestamp with time zone NOT NULL DEFAULT now(),
  "monto_total" numeric(10,2)            NOT NULL DEFAULT 0,
  "cliente"     integer                  NOT NULL,
  "esta_pagado" boolean                  NOT NULL DEFAULT false,
  "subtotal"    numeric(10,2)            NOT NULL DEFAULT 0,
  CONSTRAINT "pk_venta" PRIMARY KEY (idventa),
  "user_id"     uuid                     DEFAULT auth.uid()
);

ALTER TABLE "public"."venta"
  ENABLE ROW LEVEL SECURITY;

ALTER SEQUENCE "public"."actividad_idactividad_seq" OWNED BY "public"."actividad"."idactividad";

ALTER SEQUENCE "public"."cliente_idcliente_seq" OWNED BY "public"."cliente"."idcliente";

ALTER SEQUENCE "public"."configuracion_fiscal_idconfiguracion_fiscal_seq" OWNED BY "public"."configuracion_fiscal"."idconfiguracion_fiscal";

ALTER SEQUENCE "public"."configuracion_fiscal_activida_idconfiguracion_fiscal_activi_seq" OWNED BY "public"."configuracion_fiscal_actividad"."idconfiguracion_fiscal_actividad";

ALTER SEQUENCE "public"."configuracion_fiscal_punto_ve_idconfiguracion_fiscal_punto__seq" OWNED BY "public"."configuracion_fiscal_punto_venta"."idconfiguracion_fiscal_punto_venta";

ALTER SEQUENCE "public"."contiene_trabajo_idcontiene_trabajo_seq" OWNED BY "public"."contiene_trabajo"."idcontiene_trabajo";

ALTER SEQUENCE "public"."contiene_venta_idcontiene_venta_seq" OWNED BY "public"."contiene_venta"."idcontiene_venta";

ALTER SEQUENCE "public"."estado_idestado_seq" OWNED BY "public"."estado"."idestado";

ALTER SEQUENCE "public"."fabrica_idfabrica_seq" OWNED BY "public"."fabrica"."idfabrica";

ALTER SEQUENCE "public"."factura_idfactura_seq" OWNED BY "public"."factura"."idfactura";

ALTER SEQUENCE "public"."historial_estado_idhistorial_estado_seq" OWNED BY "public"."historial_estado"."idhistorial_estado";

ALTER SEQUENCE "public"."materia_prima_idmateria_prima_seq" OWNED BY "public"."materia_prima"."idmateria_prima";

ALTER SEQUENCE "public"."movimiento_mp_idmovimiento_mp_seq" OWNED BY "public"."movimiento_mp"."idmovimiento_mp";

ALTER SEQUENCE "public"."pago_parcial_idpago_parcial_seq" OWNED BY "public"."pago_parcial"."idpago_parcial";

ALTER SEQUENCE "public"."producto_base_idproducto_base_seq" OWNED BY "public"."producto_base"."idproducto_base";

ALTER SEQUENCE "public"."producto_variante_idproducto_variante_seq" OWNED BY "public"."producto_variante"."idproducto_variante";

ALTER SEQUENCE "public"."punto_venta_idpunto_venta_seq" OWNED BY "public"."punto_venta"."idpunto_venta";

ALTER SEQUENCE "public"."retazo_idretazo_seq" OWNED BY "public"."retazo"."idretazo";

ALTER SEQUENCE "public"."rol_idrol_seq" OWNED BY "public"."rol"."idrol";

ALTER SEQUENCE "public"."rol_usuario_idrol_usuario_seq" OWNED BY "public"."rol_usuario"."idrol_usuario";

ALTER SEQUENCE "public"."trabajo_idtrabajo_seq" OWNED BY "public"."trabajo"."idtrabajo";

ALTER SEQUENCE "public"."usuario_idusuario_seq" OWNED BY "public"."usuario"."idusuario";

ALTER SEQUENCE "public"."venta_idventa_seq" OWNED BY "public"."venta"."idventa";

ALTER SEQUENCE "public"."venta_descuento_idventa_descuento_seq" OWNED BY "public"."venta_descuento"."idventa_descuento";

CREATE DOMAIN "public"."estados" AS character varying(12) CONSTRAINT "estados_check"
  CHECK
    (((VALUE)::text = ANY ((ARRAY['RECIBIDO'::character varying, 'DISEÑADO'::character varying, 'HECHO'::character varying, 'NOTIFICADO'::character varying, 'FINALIZADO'::character
    varying])::text[])));

ALTER TABLE "public"."estado"
  ADD COLUMN "nombre" public.estados NOT NULL DEFAULT 'RECIBIDO'::character varying;

CREATE DOMAIN "public"."metodos_pago" AS character varying(15) CONSTRAINT "metodos_pago_check"
  CHECK (((VALUE)::text = ANY ((ARRAY['EFECTIVO'::character varying, 'TRANSFERENCIA'::character varying, 'QR'::character varying, 'TARJETA'::character varying])::text[])));

ALTER TABLE "public"."movimiento_mp"
  ADD COLUMN "metodo_pago" public.metodos_pago NOT NULL;

ALTER TABLE "public"."pago_parcial"
  ADD COLUMN "metodo_pago" public.metodos_pago NOT NULL DEFAULT 'EFECTIVO'::character varying;

ALTER TABLE "public"."venta"
  ADD COLUMN "metodo_pago" public.metodos_pago DEFAULT 'EFECTIVO'::character varying;

CREATE DOMAIN "public"."provincias" AS character varying(50) CONSTRAINT "provincias_check"
  CHECK
    (((VALUE)::text = ANY ((ARRAY['BUENOS AIRES'::character varying, 'CABA'::character varying, 'CATAMARCA'::character varying, 'CHACO'::character varying, 'CHUBUT'::character
    varying,
    'CORDOBA'::character varying,
    'CORRIENTES'::character varying,
    'ENTRE RIOS'::character varying,
    'FORMOSA'::character varying,
    'JUJUY'::character varying,
    'LA PAMPA'::character varying,
    'LA RIOJA'::character varying,
    'MENDOZA'::character varying,
    'MISIONES'::character varying,
    'NEUQUEN'::character varying,
    'RIO NEGRO'::character varying,
    'SALTA'::character varying,
    'SAN JUAN'::character varying,
    'SAN LUIS'::character varying,
    'SANTA CRUZ'::character varying,
    'SANTA FE'::character varying, 'SANTIAGO DEL ESTERO'::character varying, 'TIERRA DEL FUEGO'::character varying, 'TUCUMAN'::character varying])::text[])));

ALTER TABLE "public"."cliente"
  ADD COLUMN "provincia" public.provincias;

CREATE DOMAIN "public"."roles" AS character varying(15) CONSTRAINT "roles_check"
  CHECK (((VALUE)::text = ANY ((ARRAY['ADMINISTRADOR'::character varying, 'OPERARIO'::character varying])::text[])));

ALTER TABLE "public"."rol"
  ADD COLUMN "nombre" public.roles NOT NULL DEFAULT 'OPERARIO'::character varying;

CREATE DOMAIN "public"."tipos_documentos" AS character varying(5) CONSTRAINT "tipos_documentos_check"
  CHECK (((VALUE)::text = ANY ((ARRAY['DNI'::character varying, 'CUIL'::character varying, 'CUIT'::character varying])::text[])));

ALTER TABLE "public"."cliente"
  ADD COLUMN "tipo_documento" public.tipos_documentos;

ALTER TABLE "public"."movimiento_mp"
  ADD COLUMN "tipo_documento" public.tipos_documentos;

CREATE DOMAIN "public"."unidades_medida" AS character varying(6) CONSTRAINT "unidades_medida_check"
  CHECK (((VALUE)::text = ANY ((ARRAY['UNIDAD'::character varying, 'GRAMOS'::character varying, 'CM2'::character varying])::text[])));

ALTER TABLE "public"."materia_prima"
  ADD COLUMN "unidad_medida" public.unidades_medida NOT NULL DEFAULT 'UNIDAD'::character varying;

ALTER TABLE "public"."producto_variante"
  ADD COLUMN "unidad_medida" public.unidades_medida NOT NULL DEFAULT 'UNIDAD'::character varying;

CREATE OR REPLACE FUNCTION public._congelar_y_eliminar_variante (
  p_idproducto_variante integer
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
	v_sku_variante VARCHAR;
	v_color VARCHAR;
	v_tamano VARCHAR;
	v_descripcion_base TEXT;
	v_snapshot TEXT;
BEGIN
	SELECT pv.sku_variante, pv.color, pv.tamano, pb.descripcion
	INTO v_sku_variante, v_color, v_tamano, v_descripcion_base
	FROM producto_variante pv
	JOIN producto_base pb ON pb.idproducto_base = pv.producto_base
	WHERE pv.idproducto_variante = p_idproducto_variante;

	IF v_sku_variante IS NULL THEN
		RAISE EXCEPTION 'La variante % no existe', p_idproducto_variante;
	END IF;

	v_snapshot := '[PRODUCTO ELIMINADO] ' || v_descripcion_base
		|| ' (SKU: ' || v_sku_variante || ')'
		|| COALESCE(', Color: ' || v_color, '')
		|| COALESCE(', Tamaño: ' || v_tamano, '');

	-- La receta de fabricación no tiene valor histórico sin el producto
	DELETE FROM fabrica
	WHERE producto_variante = p_idproducto_variante;

	-- Congelar referencias históricas antes de romper la FK
	UPDATE contiene_trabajo
	SET producto_variante = NULL,
	    descripcion = COALESCE(descripcion, v_snapshot)
	WHERE producto_variante = p_idproducto_variante;

	UPDATE contiene_venta
	SET producto_variante = NULL,
	    descripcion = COALESCE(descripcion, v_snapshot)
	WHERE producto_variante = p_idproducto_variante;

	DELETE FROM producto_variante
	WHERE idproducto_variante = p_idproducto_variante;
END;
$function$;

CREATE OR REPLACE FUNCTION public.actualizar_costo_variante (
  p_id_variante integer
)
  RETURNS void
  LANGUAGE plpgsql
  AS $function$
BEGIN
    UPDATE producto_variante pv
    SET precio_costo = COALESCE((
        SELECT SUM(f.cantidad * mp.precio_unitario)
        FROM fabrica f
        JOIN materia_prima mp ON f.materia_prima = mp.idmateria_prima
        WHERE f.producto_variante = pv.idproducto_variante
    ), 0)
    WHERE idproducto_variante = p_id_variante;
END;
$function$;

CREATE OR REPLACE FUNCTION public.actualizar_estado_trabajo (
  p_id_trabajo   integer,
  p_nuevo_estado character varying
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
  v_id_estado INTEGER;
BEGIN
  SELECT idestado INTO v_id_estado FROM estado WHERE nombre = p_nuevo_estado;

  IF v_id_estado IS NULL THEN
    RAISE EXCEPTION 'Estado "%" no encontrado', p_nuevo_estado;
  END IF;
  
  INSERT INTO historial_estado (trabajo, estado)
  VALUES (p_id_trabajo, v_id_estado);
END;
$function$;

CREATE OR REPLACE FUNCTION public.actualizar_precios_masivos (
  ids_variantes integer[]
)
  RETURNS void
  LANGUAGE plpgsql
  AS $function$
BEGIN
    UPDATE producto_variante
    SET precio_venta = CEIL((precio_costo * (1 + (markup / 100))) / 100) * 100
    WHERE idproducto_variante = ANY(ids_variantes);
END;
$function$;

CREATE OR REPLACE FUNCTION public.actualizar_producto_completo (
  p_id_base      integer,
  p_sku_base     character varying,
  p_categoria    character varying,
  p_subcategoria character varying,
  p_descripcion  text,
  p_variantes    jsonb
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
  v_id_variante INTEGER;
  v_variante JSONB;
  v_receta JSONB;
  v_ids_mantener INTEGER[];
BEGIN
  -- 1. Actualizamos el producto base
  UPDATE producto_base
  SET sku_base = COALESCE(p_sku_base, sku_base),
      categoria = p_categoria,
      subcategoria = p_subcategoria,
      descripcion = p_descripcion
  WHERE idproducto_base = p_id_base;

  -- 1.1. Ids de variantes que el usuario decidió mantener (las que vienen con id en el JSON)
  SELECT COALESCE(array_agg((elem->>'id')::INTEGER), ARRAY[]::INTEGER[])
  INTO v_ids_mantener
  FROM jsonb_array_elements(p_variantes) AS elem
  WHERE elem->>'id' IS NOT NULL;

  -- 1.2. Congelamos el historial: los ítems de ventas/trabajos que usaban una variante
  -- eliminada quedan con descripción propia en vez de perder la referencia
  UPDATE contiene_trabajo ct
  SET producto_variante = NULL,
      descripcion = trim(concat_ws(' ', pb.descripcion, pv.color, pv.tamano))
  FROM producto_variante pv
  JOIN producto_base pb ON pb.idproducto_base = pv.producto_base
  WHERE ct.producto_variante = pv.idproducto_variante
    AND pv.producto_base = p_id_base
    AND NOT (pv.idproducto_variante = ANY(v_ids_mantener));

  UPDATE contiene_venta cv
  SET producto_variante = NULL,
      descripcion = trim(concat_ws(' ', pb.descripcion, pv.color, pv.tamano))
  FROM producto_variante pv
  JOIN producto_base pb ON pb.idproducto_base = pv.producto_base
  WHERE cv.producto_variante = pv.idproducto_variante
    AND pv.producto_base = p_id_base
    AND NOT (pv.idproducto_variante = ANY(v_ids_mantener));

  -- 1.3. Ahora que no queda nada referenciando a las variantes eliminadas, borramos
  -- primero su receta y después la variante en sí
  DELETE FROM fabrica
  WHERE producto_variante IN (
    SELECT idproducto_variante FROM producto_variante
    WHERE producto_base = p_id_base
      AND NOT (idproducto_variante = ANY(v_ids_mantener))
  );

  DELETE FROM producto_variante
  WHERE producto_base = p_id_base
    AND NOT (idproducto_variante = ANY(v_ids_mantener));

  -- 2. Recorremos las variantes del JSON
  FOR v_variante IN SELECT * FROM jsonb_array_elements(p_variantes)
  LOOP
    -- 2a. Evaluamos si la variante YA EXISTE (tiene ID) o es NUEVA
    IF (v_variante->>'id') IS NOT NULL THEN
      v_id_variante := (v_variante->>'id')::INTEGER;
      
      UPDATE producto_variante
      SET sku_variante = COALESCE(v_variante->>'sku', sku_variante),
          stock = (v_variante->>'stock')::INTEGER,
          precio_costo = (v_variante->>'costPrice')::NUMERIC,
          precio_venta = (v_variante->>'salePrice')::NUMERIC,
          color = v_variante->>'color',
          tamano = v_variante->>'size',
          unidad_medida = v_variante->>'measurementUnit'
      WHERE idproducto_variante = v_id_variante;
      
    ELSE
      -- Es una variante agregada durante la edición
      INSERT INTO producto_variante (
        sku_variante, stock, precio_costo, precio_venta, color, tamano, producto_base, unidad_medida
      ) VALUES (
        v_variante->>'sku',
        (v_variante->>'stock')::INTEGER,
        (v_variante->>'costPrice')::NUMERIC,
        (v_variante->>'salePrice')::NUMERIC,
        v_variante->>'color',
        v_variante->>'size',
        p_id_base,
        v_variante->>'measurementUnit'
      ) RETURNING idproducto_variante INTO v_id_variante;
    END IF;

    -- 3. Manejar la receta (La estrategia más limpia: Borrar y recrear)
    -- En vez de comparar qué materia prima cambió, borramos la receta vieja de esta variante
    DELETE FROM fabrica WHERE producto_variante = v_id_variante;

    -- Insertamos la nueva receta (si viene en el JSON)
    IF v_variante->'recipe' IS NOT NULL AND jsonb_array_length(v_variante->'recipe') > 0 THEN
      FOR v_receta IN SELECT * FROM jsonb_array_elements(v_variante->'recipe')
      LOOP
        INSERT INTO fabrica (producto_variante, materia_prima, cantidad)
        VALUES (
          v_id_variante,
          (v_receta->>'rawMaterialId')::INTEGER,
          (v_receta->>'quantity')::NUMERIC
        );
      END LOOP;
    END IF;

  END LOOP;
END;
$function$;

CREATE OR REPLACE FUNCTION public.actualizar_retazo (
  p_id            integer,
  p_materia_prima integer,
  p_alto          numeric,
  p_ancho         numeric,
  p_stock         numeric
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
  v_existing_id INTEGER;
BEGIN
  -- ¿Ya existe otro retazo (distinto al que editamos) con esa misma medida y material?
  SELECT idretazo INTO v_existing_id
  FROM retazo
  WHERE materia_prima = p_materia_prima
    AND alto = p_alto
    AND ancho = p_ancho
    AND idretazo != p_id;

  IF v_existing_id IS NOT NULL THEN
    -- Fusión: sumamos el stock editado al retazo existente, y eliminamos el que se estaba editando
    UPDATE retazo
    SET stock = stock + p_stock
    WHERE idretazo = v_existing_id;

    DELETE FROM retazo WHERE idretazo = p_id;
  ELSE
    -- Sin conflicto: actualización normal
    UPDATE retazo
    SET materia_prima = p_materia_prima,
        alto = p_alto,
        ancho = p_ancho,
        stock = p_stock
    WHERE idretazo = p_id;
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.actualizar_trabajo_completo (
  p_id_trabajo      integer,
  p_cliente         integer,
  p_fecha_limite    date,
  p_items           jsonb,
  p_pagos_parciales jsonb   DEFAULT '[]'::jsonb
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
  v_item JSONB;
  v_pago JSONB;
  v_id_pago INTEGER;
  v_ids_pagos_mantener INTEGER[];
BEGIN
  -- Actualizar datos de cabecera
  UPDATE trabajo
  SET cliente = p_cliente,
      fecha_limite = p_fecha_limite
  WHERE idtrabajo = p_id_trabajo;

  -- Reemplazo completo de ítems: borramos los actuales y reinsertamos
  DELETE FROM contiene_trabajo WHERE trabajo = p_id_trabajo;

  FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
  LOOP
    INSERT INTO contiene_trabajo (
      trabajo, producto_variante, descripcion, cantidad, precio_unitario, hecho
    ) VALUES (
      p_id_trabajo,
      (v_item->>'producto_variante')::INTEGER,
      v_item->>'descripcion',
      (v_item->>'cantidad')::NUMERIC,
      (v_item->>'precio_unitario')::NUMERIC,
      COALESCE((v_item->>'hecho')::BOOLEAN, false)
    );
  END LOOP;
  
  -- Manejo de señas
  SELECT COALESCE(array_agg((elem->>'id')::INTEGER), ARRAY[]::INTEGER[])
  INTO v_ids_pagos_mantener
  FROM jsonb_array_elements(p_pagos_parciales) AS elem
  WHERE elem->>'id' IS NOT NULL;

  DELETE FROM pago_parcial
  WHERE trabajo = p_id_trabajo AND NOT (idpago_parcial = ANY(v_ids_pagos_mantener));

  FOR v_pago IN SELECT * FROM jsonb_array_elements(p_pagos_parciales)
  LOOP
    IF (v_pago->>'id') IS NOT NULL THEN
      -- Actualizamos seña existente
      v_id_pago := (v_pago->>'id')::INTEGER;
      
      UPDATE pago_parcial
      SET monto = (v_pago->>'monto')::NUMERIC,
          metodo_pago = (v_pago->>'metodo_pago')::metodos_pago
      WHERE idpago_parcial = v_id_pago;
      
    ELSE
      -- Insertamos nueva seña agregada durante la edición
      INSERT INTO pago_parcial (trabajo, monto, metodo_pago)
      VALUES (
        p_id_trabajo,
        (v_pago->>'monto')::NUMERIC,
        (v_pago->>'metodo_pago')::metodos_pago
      );
    END IF;
  END LOOP;
END;
$function$;

CREATE OR REPLACE FUNCTION public.agregar_retazo (
  p_ancho         numeric,
  p_alto          numeric,
  p_stock         integer,
  p_materia_prima integer
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
BEGIN
  INSERT INTO retazo (ancho, alto, stock, materia_prima)
  VALUES (p_ancho, p_alto, p_stock, p_materia_prima)
  ON CONFLICT (ancho, alto, materia_prima)
  DO UPDATE SET stock = retazo.stock + p_stock;
END;
$function$;

CREATE OR REPLACE FUNCTION public.ajustar_stock_mp (
  p_id       integer,
  p_cantidad numeric
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
BEGIN
  UPDATE materia_prima SET stock = stock + p_cantidad WHERE idmateria_prima = p_id;
END;
$function$;

CREATE OR REPLACE FUNCTION public.ajustar_stock_producto (
  p_id_variante  integer,
  p_cantidad     numeric,
  p_descontar_mp boolean
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
  v_receta RECORD;
BEGIN
  -- Actualizamos el stock del producto
  UPDATE producto_variante 
  SET stock = stock + p_cantidad 
  WHERE idproducto_variante = p_id_variante;

  -- Si estamos sumando stock (fabricando) y el usuario dejó el check activado
  IF p_cantidad > 0 AND p_descontar_mp THEN
    -- Buscamos la receta en la tabla 'fabrica' y descontamos la materia prima
    FOR v_receta IN (SELECT materia_prima, cantidad FROM fabrica WHERE producto_variante = p_id_variante)
    LOOP
      UPDATE materia_prima 
      SET stock = stock - (v_receta.cantidad * p_cantidad) 
      WHERE idmateria_prima = v_receta.materia_prima;
    END LOOP;
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.ajustar_stock_retazo (
  p_id       integer,
  p_cantidad integer
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
BEGIN
  UPDATE retazo SET stock = stock + p_cantidad WHERE idretazo = p_id;
END;
$function$;

CREATE OR REPLACE FUNCTION public.calcular_totales_venta()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $function$
DECLARE
    v_id_venta INTEGER;
    v_subtotal NUMERIC(10,2);
    v_descuentos NUMERIC(10,2);
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_id_venta := OLD.venta;
    ELSE
        v_id_venta := NEW.venta;
    END IF;

    -- Sumar subtotal
    SELECT COALESCE(SUM(cantidad * precio_unitario), 0) INTO v_subtotal
    FROM contiene_venta WHERE venta = v_id_venta;

    -- Sumar descuentos
    SELECT COALESCE(SUM(monto_descontado), 0) INTO v_descuentos
    FROM venta_descuento WHERE venta = v_id_venta;

    -- Guardar totales en la venta
    UPDATE venta
    SET subtotal = v_subtotal, monto_total = v_subtotal - v_descuentos
    WHERE idventa = v_id_venta;

    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.crear_producto_completo (
  p_sku_base     character varying,
  p_categoria    character varying,
  p_subcategoria character varying,
  p_descripcion  text,
  p_variantes    jsonb
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
  v_id_base INTEGER;
  v_id_variante INTEGER;
  v_variante JSONB;
  v_receta JSONB;
BEGIN
  -- 1. Insertamos el producto base
  INSERT INTO producto_base (sku_base, categoria, subcategoria, descripcion)
  VALUES (p_sku_base, p_categoria, p_subcategoria, p_descripcion)
  RETURNING idproducto_base INTO v_id_base;

  -- 2. Recorremos las variantes
  FOR v_variante IN SELECT * FROM jsonb_array_elements(p_variantes)
  LOOP
    INSERT INTO producto_variante (
      sku_variante, 
      stock, 
      precio_costo, 
      precio_venta, 
      color, 
      tamano, 
      producto_base,
      unidad_medida
    ) VALUES (
      v_variante->>'sku',
      (v_variante->>'stock')::INTEGER,
      (v_variante->>'costPrice')::NUMERIC,
      (v_variante->>'salePrice')::NUMERIC,
      v_variante->>'color',
      v_variante->>'size',
      v_id_base,
      v_variante->>'measurementUnit'
    ) RETURNING idproducto_variante INTO v_id_variante;

    -- 3. Insertamos la receta de fabricación (Si existe)
    IF v_variante->'recipe' IS NOT NULL AND jsonb_array_length(v_variante->'recipe') > 0 THEN
      FOR v_receta IN SELECT * FROM jsonb_array_elements(v_variante->'recipe')
      LOOP
        INSERT INTO fabrica (producto_variante, materia_prima, cantidad)
        VALUES (
          v_id_variante,
          (v_receta->>'rawMaterialId')::INTEGER,
          (v_receta->>'quantity')::NUMERIC
        );
      END LOOP;
    END IF;

  END LOOP;
END;
$function$;

CREATE OR REPLACE FUNCTION public.crear_trabajo_completo (
  p_cliente         integer,
  p_fecha_limite    timestamp with time zone,
  p_items           jsonb,
  p_pagos_parciales jsonb                    DEFAULT '[]'::jsonb
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
  v_id_trabajo INTEGER;
  v_id_estado_recibido INTEGER;
  v_item JSONB;
  v_pago JSONB;
BEGIN
  -- 1. Obtener el ID del estado 'RECIBIDO'
  SELECT idestado INTO v_id_estado_recibido FROM estado WHERE nombre = 'RECIBIDO';

  IF v_id_estado_recibido IS NULL THEN
    RAISE EXCEPTION 'No se encontró el estado inicial "RECIBIDO" en la tabla estado';
  END IF;

  -- 2. Insertar el trabajo y obtener su ID
  INSERT INTO trabajo (cliente, fecha_limite)
  VALUES (p_cliente, p_fecha_limite)
  RETURNING idtrabajo INTO v_id_trabajo;

  -- 3. Insertar estado inicial en el historial
  INSERT INTO historial_estado (trabajo, estado)
  VALUES (v_id_trabajo, v_id_estado_recibido);

  -- 4. Insertar los ítems
  FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
  LOOP
    INSERT INTO contiene_trabajo (
      trabajo,
      producto_variante,
      cantidad,
      precio_unitario,
      descripcion
    ) VALUES (
      v_id_trabajo,
      (v_item->>'producto_variante')::INTEGER, -- Puede ser nulo si es genérico
      (v_item->>'cantidad')::INTEGER,
      (v_item->>'precio_unitario')::NUMERIC,
      v_item->>'descripcion'
    );
  END LOOP;

  -- 5. Insertar los pagos parciales
  IF jsonb_array_length(p_pagos_parciales) > 0 THEN
    FOR v_pago IN SELECT * FROM jsonb_array_elements(p_pagos_parciales)
    LOOP
      INSERT INTO pago_parcial (
        trabajo,
        monto,
        metodo_pago
      ) VALUES (
        v_id_trabajo,
        (v_pago->>'monto')::NUMERIC,
        (v_pago->>'metodo_pago')::metodo_pago
      );
    END LOOP;
  END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.crear_venta_completa (
  p_cliente       integer,
  p_metodo_pago   character varying,
  p_esta_pagado   boolean,
  p_id_trabajo    integer,
  p_items         jsonb,
  p_descuentos    jsonb             DEFAULT '[]'::jsonb,
  p_materia_prima integer           DEFAULT NULL::integer,
  p_consumo       numeric           DEFAULT NULL::numeric
)
  RETURNS integer
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
  v_id_venta INTEGER;
  v_item JSONB;
  v_desc JSONB;
  v_id_variante INTEGER;
  v_cantidad INTEGER;
BEGIN
  -- Insertar la Venta principal
  INSERT INTO venta (cliente, metodo_pago, esta_pagado, subtotal, monto_total)
  VALUES (p_cliente, p_metodo_pago::metodos_pago, p_esta_pagado, 0, 0)
  RETURNING idventa INTO v_id_venta;

  -- Vincular Trabajo (Si existe)
  IF p_id_trabajo IS NOT NULL THEN
    INSERT INTO venta_trabajo (venta, trabajo) 
    VALUES (v_id_venta, p_id_trabajo);
  END IF;

  -- Insertar items
  IF p_items IS NOT NULL THEN
    FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
    LOOP
      v_id_variante := (v_item->>'producto_variante')::INTEGER;
      v_cantidad := (v_item->>'cantidad')::INTEGER;

      INSERT INTO contiene_venta (
        venta, producto_variante, cantidad, precio_unitario, descripcion
      ) 
      VALUES (
        v_id_venta,
        v_id_variante,
        v_cantidad,
        (v_item->>'precio_unitario')::NUMERIC,
        v_item->>'descripcion'
      );

      -- Descontar stock del inventario si es venta de mostrador
      IF p_id_trabajo IS NULL AND v_id_variante IS NOT NULL THEN
        UPDATE producto_variante 
        SET stock = stock - v_cantidad
        WHERE idproducto_variante = v_id_variante;
      END IF;
    END LOOP;
  END IF;

  -- Insertar descuentos
  IF p_descuentos IS NOT NULL THEN
    FOR v_desc IN SELECT * FROM jsonb_array_elements(p_descuentos)
    LOOP
      INSERT INTO venta_descuento(venta, motivo, monto_descontado)
      VALUES(v_id_venta, v_desc->>'motivo', (v_desc->>'monto_descontado')::NUMERIC);
    END LOOP;
  END IF;

  -- Venta Rápida: Descuento de Materia Prima
  IF p_materia_prima IS NOT NULL AND p_consumo IS NOT NULL AND p_consumo > 0 THEN
    UPDATE materia_prima
    SET stock = stock - p_consumo
    WHERE idmateria_prima = p_materia_prima;
  END IF;

  RETURN v_id_venta;
END;
$function$;

CREATE OR REPLACE FUNCTION public.eliminar_producto_completo (
  p_idproducto_base integer
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
	v_idvariante INTEGER;
BEGIN
	IF NOT EXISTS (SELECT 1 FROM producto_base WHERE idproducto_base = p_idproducto_base) THEN
		RAISE EXCEPTION 'El producto base % no existe', p_idproducto_base;
	END IF;

	FOR v_idvariante IN
		SELECT idproducto_variante FROM producto_variante
		WHERE producto_base = p_idproducto_base
	LOOP
		PERFORM _congelar_y_eliminar_variante(v_idvariante);
	END LOOP;

	DELETE FROM producto_base
	WHERE idproducto_base = p_idproducto_base;
END;
$function$;

CREATE OR REPLACE FUNCTION public.eliminar_producto_variante (
  p_idproducto_variante integer
)
  RETURNS void
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
	v_producto_base INTEGER;
	v_variantes_restantes INTEGER;
BEGIN
	SELECT producto_base INTO v_producto_base
	FROM producto_variante
	WHERE idproducto_variante = p_idproducto_variante;

	IF v_producto_base IS NULL THEN
		RAISE EXCEPTION 'La variante % no existe', p_idproducto_variante;
	END IF;

	PERFORM _congelar_y_eliminar_variante(p_idproducto_variante);

	SELECT COUNT(*) INTO v_variantes_restantes
	FROM producto_variante
	WHERE producto_base = v_producto_base;

	IF v_variantes_restantes = 0 THEN
		DELETE FROM producto_base
		WHERE idproducto_base = v_producto_base;
	END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.es_administrador()
  RETURNS boolean
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM public.usuario u
    JOIN public.rol_usuario ru ON u.idusuario = ru.usuario
    JOIN public.rol r ON ru.rol = r.idrol
    WHERE u.id_auth = auth.uid() 
      AND r.nombre = 'ADMINISTRADOR'
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.generar_sku_base()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
  v_cat_abrev VARCHAR;
  v_subcat_abrev VARCHAR;
  v_correlativo INT;
  v_sku_candidato VARCHAR;
BEGIN
  IF NEW.sku_base IS NOT NULL AND TRIM(NEW.sku_base) <> '' THEN
    RETURN NEW; -- el usuario definió el SKU a mano
  END IF;

  v_cat_abrev := obtener_abreviatura('categoria', NEW.categoria);
  v_subcat_abrev := obtener_abreviatura('subcategoria', NEW.subcategoria);

  SELECT COUNT(*) + 1 INTO v_correlativo
  FROM producto_base
  WHERE categoria = NEW.categoria AND subcategoria = NEW.subcategoria;

  LOOP
    v_sku_candidato := 'PRO-' || v_cat_abrev || '-' || v_subcat_abrev || '-' || LPAD(v_correlativo::TEXT, 3, '0');
    EXIT WHEN NOT EXISTS (SELECT 1 FROM producto_base WHERE sku_base = v_sku_candidato);
    v_correlativo := v_correlativo + 1;
  END LOOP;

  NEW.sku_base := v_sku_candidato;
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.generar_sku_variante()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
  v_color_abrev VARCHAR;
  v_size_abrev VARCHAR;
  v_categoria VARCHAR;
  v_sku_base VARCHAR;
  v_correlativo INT;
  v_sku_candidato VARCHAR;
  v_prefijo VARCHAR;
BEGIN
  IF NEW.sku_variante IS NOT NULL AND TRIM(NEW.sku_variante) <> '' THEN
    RETURN NEW;
  END IF;

  IF (NEW.color IS NULL OR TRIM(NEW.color) = '') AND (NEW.tamano IS NULL OR TRIM(NEW.tamano) = '') THEN
    RAISE EXCEPTION 'El color y el tamaño no pueden ser nulos al mismo tiempo.';
  END IF;

  SELECT categoria, sku_base INTO v_categoria, v_sku_base
  FROM producto_base WHERE idproducto_base = NEW.producto_base;

  v_color_abrev := obtener_abreviatura('color', NEW.color, 3);
  v_size_abrev := obtener_abreviatura('tamano', NEW.tamano);

  IF v_color_abrev IS NOT NULL AND v_size_abrev IS NOT NULL THEN
    v_prefijo := v_color_abrev || '-' || v_size_abrev;
  ELSIF v_color_abrev IS NOT NULL THEN
    v_prefijo := v_color_abrev;
  ELSE
    v_prefijo := v_size_abrev;
  END IF;

  SELECT COUNT(*) + 1 INTO v_correlativo
  FROM producto_variante
  WHERE producto_base = NEW.producto_base;

  LOOP
    -- Formato final: COL-TAM-001 o COL-001
    v_sku_candidato := v_sku_base || '-' || v_prefijo || '-' || LPAD(v_correlativo::TEXT, 3, '0');
    
    -- Verificamos que este SKU no exista de forma global para evitar choques en la tabla
    EXIT WHEN NOT EXISTS (SELECT 1 FROM producto_variante WHERE sku_variante = v_sku_candidato);
    v_correlativo := v_correlativo + 1;
  END LOOP;

  NEW.sku_variante := v_sku_candidato;
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.generar_venta_por_trabajo_finalizado()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
  v_nombre_estado estados;
  v_id_cliente INTEGER;
  v_id_venta INTEGER;
BEGIN
  -- Obtener el nombre del estado que se acaba de insertar
  SELECT nombre INTO v_nombre_estado 
  FROM estado 
  WHERE idestado = NEW.estado;

  -- Solo actuamos si el nuevo estado es 'FINALIZADO'
  IF v_nombre_estado = 'FINALIZADO' THEN
    
    -- Control de seguridad: Evitar duplicados si el trabajo pasa a finalizado más de una vez
    IF EXISTS (SELECT 1 FROM venta_trabajo WHERE trabajo = NEW.trabajo) THEN
      RETURN NEW;
    END IF;

    -- Obtener el cliente asociado al trabajo
    SELECT cliente INTO v_id_cliente 
    FROM trabajo 
    WHERE idtrabajo = NEW.trabajo;

    -- A. Crear la Venta
    INSERT INTO venta (esta_pagado, metodo_pago, fecha, subtotal, monto_total, cliente)
    VALUES (false, NULL, NOW(), 0, 0, v_id_cliente)
    RETURNING idventa INTO v_id_venta;

    -- B. Vincular la venta con el trabajo en la tabla intermedia
    INSERT INTO venta_trabajo (venta, trabajo) 
    VALUES (v_id_venta, NEW.trabajo);

    -- C. Copiar el detalle de los productos/descripciones a la venta
    INSERT INTO contiene_venta (producto_variante, venta, cantidad, precio_unitario, descripcion)
    SELECT producto_variante, v_id_venta, cantidad, precio_unitario, descripcion
    FROM contiene_trabajo 
    WHERE trabajo = NEW.trabajo;

  END IF;

  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.handle_new_user()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'public'
  AS $function$DECLARE
  nuevo_id_usuario INT;
BEGIN
  INSERT INTO public.usuario (id_auth, nombre, apellido)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'nombre', 'Usuario'),
    COALESCE(NEW.raw_user_meta_data->>'apellido', 'Nuevo')
  )
  RETURNING idusuario INTO nuevo_id_usuario;

  INSERT INTO public.rol_usuario(usuario, rol) 
  VALUES(
    nuevo_id_usuario, 
    (SELECT idrol FROM rol WHERE nombre='ADMINISTRADOR'));

  RETURN NEW;
END;$function$;

CREATE OR REPLACE FUNCTION public.llamar_movimientos_mp()
  RETURNS void
  LANGUAGE plpgsql
  SECURITY DEFINER
  AS $function$
DECLARE
  v_token text;
BEGIN
  -- Secreto desencriptado en el Vault
  SELECT secret INTO v_token 
  FROM vault.decrypted_secrets 
  WHERE name = 'token_movimientos_mp';

  -- Petición HTTP inyectando el token
  PERFORM net.http_post(
      url := 'https://ihgndhbzmxtysugjyfbs.supabase.co/functions/v1/movimientos-mp',
      headers := jsonb_build_object('Authorization', 'Bearer ' || v_token),
      timeout_milliseconds := 1000
  );
END;
$function$;

CREATE OR REPLACE FUNCTION public.obtener_abreviatura (
  p_campo character varying,
  p_valor character varying,
  p_largo integer           DEFAULT 3
)
  RETURNS character varying
  LANGUAGE plpgsql
  SET search_path TO 'public'
  AS $function$
DECLARE
  v_valor_limpio VARCHAR;
BEGIN
  IF p_valor IS NULL OR TRIM(p_valor) = '' THEN
    RETURN NULL;
  END IF;

  v_valor_limpio := UPPER(TRIM(p_valor));

  IF p_campo = 'categoria' THEN
    -- Contemplamos con y sin tilde por si acaso viene sucio desde el front
    IF v_valor_limpio IN ('IMPRESIÓN 3D', 'IMPRESION 3D') THEN
      RETURN 'IMP';
    ELSIF v_valor_limpio IN ('CORTE LÁSER', 'CORTE LASER') THEN
      RETURN 'CLA';
    ELSIF v_valor_limpio IN ('COTILLÓN', 'COTILLON') THEN
      RETURN 'COT';
    END IF;
  END IF;

  -- FALLBACK
  RETURN UPPER(LEFT(REGEXP_REPLACE(extensions.unaccent(TRIM(p_valor)), '[^a-zA-Z0-9]', '', 'g'), p_largo));
END;
$function$;

CREATE OR REPLACE FUNCTION public.trg_fn_fabrica_costo()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $function$
BEGIN
    IF TG_OP = 'DELETE' THEN
        PERFORM actualizar_costo_variante(OLD.producto_variante);
        RETURN OLD;
    ELSE
        PERFORM actualizar_costo_variante(NEW.producto_variante);
        RETURN NEW;
    END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION public.trg_fn_mp_precio_costo()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $function$
BEGIN
    -- Solo ejecutamos si el precio realmente cambió
    IF NEW.precio_unitario IS DISTINCT FROM OLD.precio_unitario THEN
        -- Actualizar costo de las variantes vinculadas a esta materia prima
        UPDATE producto_variante pv
        SET precio_costo = COALESCE((
            SELECT SUM(f.cantidad * mp.precio_unitario)
            FROM fabrica f
            JOIN materia_prima mp ON f.materia_prima = mp.idmateria_prima
            WHERE f.producto_variante = pv.idproducto_variante
        ), 0)
        WHERE idproducto_variante IN (
            SELECT producto_variante FROM fabrica WHERE materia_prima = NEW.idmateria_prima
        );
    END IF;
    RETURN NEW;
END;
$function$;

ALTER TABLE "public"."configuracion_fiscal_actividad"
  ADD CONSTRAINT "fk_configuracion_fiscal_actividad_actividad" FOREIGN KEY (actividad) REFERENCES public.actividad(idactividad);

ALTER TABLE "public"."configuracion_fiscal_actividad"
  ADD CONSTRAINT "fk_configuracion_fiscal_actividad_configuracion_fiscal" FOREIGN KEY (configuracion_fiscal) REFERENCES public.configuracion_fiscal(idconfiguracion_fiscal);

ALTER TABLE "public"."configuracion_fiscal_punto_venta"
  ADD CONSTRAINT "fk_configuracion_fiscal_punto_venta_configuracion_fiscal" FOREIGN KEY (configuracion_fiscal) REFERENCES public.configuracion_fiscal(idconfiguracion_fiscal);

ALTER TABLE "public"."estado"
  ADD CONSTRAINT "ck_estado_nombre" UNIQUE (nombre);

ALTER TABLE "public"."historial_estado"
  ADD CONSTRAINT "fk_historial_estado_estado" FOREIGN KEY (estado) REFERENCES public.estado(idestado);

ALTER TABLE "public"."fabrica"
  ADD CONSTRAINT "fk_fabrica_materia_prima" FOREIGN KEY (materia_prima) REFERENCES public.materia_prima(idmateria_prima);

ALTER TABLE "public"."mp_venta"
  ADD CONSTRAINT "fk_mp_venta_movimiento_mp" FOREIGN KEY (movimiento_mp) REFERENCES public.movimiento_mp(idmovimiento_mp);

ALTER TABLE "public"."producto_variante"
  ADD CONSTRAINT "fk_producto_variante_producto_base" FOREIGN KEY (producto_base) REFERENCES public.producto_base(idproducto_base);

ALTER TABLE "public"."contiene_trabajo"
  ADD CONSTRAINT "fk_contiene_trabajo_producto_variante" FOREIGN KEY (producto_variante) REFERENCES public.producto_variante(idproducto_variante);

ALTER TABLE "public"."contiene_venta"
  ADD CONSTRAINT "fk_contiene_venta_producto_variante" FOREIGN KEY (producto_variante) REFERENCES public.producto_variante(idproducto_variante);

ALTER TABLE "public"."fabrica"
  ADD CONSTRAINT "fk_fabrica_producto_variante" FOREIGN KEY (producto_variante) REFERENCES public.producto_variante(idproducto_variante);

ALTER TABLE "public"."configuracion_fiscal_punto_venta"
  ADD CONSTRAINT "fk_configuracion_fiscal_punto_venta_punto_venta" FOREIGN KEY (punto_venta) REFERENCES public.punto_venta(idpunto_venta);

ALTER TABLE "public"."retazo"
  ADD CONSTRAINT "fk_retazo_materia_prima" FOREIGN KEY (materia_prima) REFERENCES public.materia_prima(idmateria_prima);

ALTER TABLE "public"."rol"
  ADD CONSTRAINT "ck_rol_nombre" UNIQUE (nombre);

ALTER TABLE "public"."rol_usuario"
  ADD CONSTRAINT "fk_rol_usuario_rol" FOREIGN KEY (rol) REFERENCES public.rol(idrol);

ALTER TABLE "public"."trabajo"
  ADD CONSTRAINT "fk_trabajo_cliente" FOREIGN KEY (cliente) REFERENCES public.cliente(idcliente);

ALTER TABLE "public"."contiene_trabajo"
  ADD CONSTRAINT "fk_contiene_trabajo_trabajo" FOREIGN KEY (trabajo) REFERENCES public.trabajo(idtrabajo);

ALTER TABLE "public"."historial_estado"
  ADD CONSTRAINT "fk_historial_estado_trabajo" FOREIGN KEY (trabajo) REFERENCES public.trabajo(idtrabajo);

ALTER TABLE "public"."pago_parcial"
  ADD CONSTRAINT "fk_pago_parcial_trabajo" FOREIGN KEY (trabajo) REFERENCES public.trabajo(idtrabajo);

ALTER TABLE "public"."rol_usuario"
  ADD CONSTRAINT "fk_rol_usuario_usuario" FOREIGN KEY (usuario) REFERENCES public.usuario(idusuario);

ALTER TABLE "public"."venta"
  ADD CONSTRAINT "ck_esta_pago_o_metodo_pago" CHECK (((metodo_pago IS NOT NULL) OR (esta_pagado IS FALSE)));

ALTER TABLE "public"."venta"
  ADD CONSTRAINT "fk_venta_cliente" FOREIGN KEY (cliente) REFERENCES public.cliente(idcliente);

ALTER TABLE "public"."contiene_venta"
  ADD CONSTRAINT "fk_contiene_venta_venta" FOREIGN KEY (venta) REFERENCES public.venta(idventa);

ALTER TABLE "public"."factura"
  ADD CONSTRAINT "fk_factura_venta" FOREIGN KEY (venta) REFERENCES public.venta(idventa);

ALTER TABLE "public"."mp_venta"
  ADD CONSTRAINT "fk_mp_venta_venta" FOREIGN KEY (venta) REFERENCES public.venta(idventa);

ALTER TABLE "public"."venta_descuento"
  ADD CONSTRAINT "fk_venta_venta_descuento" FOREIGN KEY (venta) REFERENCES public.venta(idventa);

ALTER TABLE "public"."venta_trabajo"
  ADD CONSTRAINT "fk_venta_trabajo_trabajo" FOREIGN KEY (trabajo) REFERENCES public.trabajo(idtrabajo);

ALTER TABLE "public"."venta_trabajo"
  ADD CONSTRAINT "fk_venta_trabajo_venta" FOREIGN KEY (venta) REFERENCES public.venta(idventa);

CREATE VIEW "public"."vista_previsualizacion_precios" AS  SELECT pv.idproducto_variante,
    pb.sku_base,
    pv.sku_variante,
    pb.descripcion,
    pv.precio_costo,
    pv.precio_venta AS precio_venta_actual,
    (ceil(((pv.precio_costo * ((1)::numeric + (pv.markup / (100)::numeric))) / (100)::numeric)) * (100)::numeric) AS precio_venta_sugerido,
        CASE
            WHEN ((ceil(((pv.precio_costo * ((1)::numeric + (pv.markup / (100)::numeric))) / (100)::numeric)) * (100)::numeric) <> pv.precio_venta) THEN true
            ELSE false
        END AS requiere_actualizacion
   FROM (public.producto_variante pv
     JOIN public.producto_base pb ON ((pv.producto_base = pb.idproducto_base)))
  WHERE (pv.precio_costo > (0)::numeric);

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

CREATE TRIGGER trg_actualizar_totales_por_item
  AFTER INSERT OR DELETE OR UPDATE ON public.contiene_venta
  FOR EACH ROW
  EXECUTE FUNCTION public.calcular_totales_venta();

CREATE TRIGGER trg_actualizar_costo_receta
  AFTER INSERT OR DELETE OR UPDATE OF cantidad, materia_prima ON public.fabrica
  FOR EACH ROW
  EXECUTE FUNCTION public.trg_fn_fabrica_costo();

CREATE TRIGGER trg_generar_venta_al_finalizar
  AFTER INSERT ON public.historial_estado
  FOR EACH ROW
  EXECUTE FUNCTION public.generar_venta_por_trabajo_finalizado();

CREATE TRIGGER trg_actualizar_costo_insumo
  AFTER UPDATE OF precio_unitario ON public.materia_prima
  FOR EACH ROW
  EXECUTE FUNCTION public.trg_fn_mp_precio_costo();

CREATE TRIGGER trg_generar_sku_base
  BEFORE INSERT ON public.producto_base
  FOR EACH ROW
  EXECUTE FUNCTION public.generar_sku_base();

CREATE TRIGGER trg_generar_sku_variante
  BEFORE INSERT ON public.producto_variante
  FOR EACH ROW
  EXECUTE FUNCTION public.generar_sku_variante();

CREATE TRIGGER trg_actualizar_totales_por_descuento
  AFTER INSERT OR DELETE OR UPDATE ON public.venta_descuento
  FOR EACH ROW
  EXECUTE FUNCTION public.calcular_totales_venta();

CREATE POLICY "read_estados" ON "public"."estado"
  FOR SELECT
  TO "authenticated"
  USING (true);

CREATE POLICY "read_roles" ON "public"."rol"
  FOR SELECT
  TO "authenticated"
  USING (true);

CREATE POLICY "user_isolation_rol_usuario" ON "public"."rol_usuario"
  FOR ALL
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.idusuario = rol_usuario.usuario) AND (u.id_auth = auth.uid())))))
  WITH CHECK ((EXISTS ( SELECT 1
   FROM public.usuario u
  WHERE ((u.idusuario = rol_usuario.usuario) AND (u.id_auth = auth.uid())))));

CREATE POLICY "user_isolation_usuario" ON "public"."usuario"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = id_auth))
  WITH CHECK ((auth.uid() = id_auth));

COMMENT ON EXTENSION "pg_cron" IS 'Job scheduler for PostgreSQL';

COMMENT ON EXTENSION "pg_net" IS 'Async HTTP';

COMMENT ON EXTENSION "unaccent" IS 'text search dictionary that removes accents';

GRANT USAGE ON TYPE "public"."estados" TO "postgres";

GRANT USAGE ON TYPE "public"."metodos_pago" TO "postgres";

GRANT USAGE ON TYPE "public"."provincias" TO "postgres";

GRANT USAGE ON TYPE "public"."roles" TO "postgres";

GRANT USAGE ON TYPE "public"."tipos_documentos" TO "postgres";

GRANT USAGE ON TYPE "public"."unidades_medida" TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."_congelar_y_eliminar_variante"(integer) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."actualizar_costo_variante"(integer) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."actualizar_estado_trabajo"(integer, character varying) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."actualizar_precios_masivos"(integer[]) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE
  ON FUNCTION "public"."actualizar_producto_completo"(integer, character varying, character varying, character varying, text, jsonb)
  TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."actualizar_retazo"(integer, integer, numeric, numeric, numeric) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."actualizar_trabajo_completo"(integer, integer, date, jsonb, jsonb) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."agregar_retazo"(numeric, numeric, integer, integer) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."ajustar_stock_mp"(integer, numeric) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."ajustar_stock_producto"(integer, numeric, boolean) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."ajustar_stock_retazo"(integer, integer) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."calcular_totales_venta"() TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE
  ON FUNCTION "public"."crear_producto_completo"(character varying, character varying, character varying, text, jsonb)
  TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."crear_trabajo_completo"(integer, timestamp WITH time zone, jsonb, jsonb) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE
  ON FUNCTION "public"."crear_venta_completa"(integer, character varying, boolean, integer, jsonb, jsonb, integer, numeric)
  TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."eliminar_producto_completo"(integer) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."eliminar_producto_variante"(integer) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."es_administrador"() TO PUBLIC, "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."generar_sku_base"() TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."generar_sku_variante"() TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."generar_venta_por_trabajo_finalizado"() TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."handle_new_user"() TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."llamar_movimientos_mp"() TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."obtener_abreviatura"(character varying, character varying, integer) TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."trg_fn_fabrica_costo"() TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT EXECUTE ON FUNCTION "public"."trg_fn_mp_precio_costo"() TO PUBLIC, "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."actividad_idactividad_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."cliente_idcliente_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."configuracion_fiscal_activida_idconfiguracion_fiscal_activi_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."configuracion_fiscal_idconfiguracion_fiscal_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."configuracion_fiscal_punto_ve_idconfiguracion_fiscal_punto__seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."contiene_trabajo_idcontiene_trabajo_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."contiene_venta_idcontiene_venta_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."estado_idestado_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."fabrica_idfabrica_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."factura_idfactura_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."historial_estado_idhistorial_estado_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."materia_prima_idmateria_prima_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."movimiento_mp_idmovimiento_mp_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."pago_parcial_idpago_parcial_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."producto_base_idproducto_base_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."producto_variante_idproducto_variante_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."punto_venta_idpunto_venta_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."retazo_idretazo_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."rol_idrol_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."rol_usuario_idrol_usuario_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."trabajo_idtrabajo_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."usuario_idusuario_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."venta_descuento_idventa_descuento_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."venta_idventa_seq" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."actividad" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."cliente" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."configuracion_fiscal" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE
  ON TABLE "public"."configuracion_fiscal_actividad"
  TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE
  ON TABLE "public"."configuracion_fiscal_punto_venta"
  TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."contiene_trabajo" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."contiene_venta" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."estado" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."fabrica" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."factura" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."historial_estado" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."materia_prima" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."movimiento_mp" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."mp_venta" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."pago_parcial" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."producto_base" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."producto_variante" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."punto_venta" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."retazo" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."rol" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."rol_usuario" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."trabajo" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."usuario" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."venta" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."venta_descuento" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."venta_trabajo" TO "anon", "authenticated", "postgres", "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE
  ON TABLE "public"."vista_previsualizacion_precios"
  TO "anon", "authenticated", "postgres", "service_role";

SELECT cron.schedule_in_database('movimientos-mp', '0 */2 * * *', 'SELECT public.llamar_movimientos_mp();', 'postgres', NULL, true);

ALTER TABLE "public"."actividad"
  ADD CONSTRAINT "actividad_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE POLICY "user_isolation_actividad" ON "public"."actividad"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = user_id))
  WITH CHECK ((auth.uid() = user_id));

ALTER TABLE "public"."cliente"
  ADD CONSTRAINT "cliente_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE INDEX idx_cliente_user_id ON public.cliente USING btree (user_id);

CREATE POLICY "user_isolation_cliente" ON "public"."cliente"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = user_id))
  WITH CHECK ((auth.uid() = user_id));

ALTER TABLE "public"."configuracion_fiscal"
  ADD CONSTRAINT "configuracion_fiscal_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE POLICY "user_isolation_configuracion_fiscal" ON "public"."configuracion_fiscal"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = user_id))
  WITH CHECK ((auth.uid() = user_id));

CREATE POLICY "user_isolation_config_actividad" ON "public"."configuracion_fiscal_actividad"
  FOR ALL
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.configuracion_fiscal cf
  WHERE ((cf.idconfiguracion_fiscal = configuracion_fiscal_actividad.configuracion_fiscal) AND (cf.user_id = auth.uid())))))
  WITH CHECK ((EXISTS ( SELECT 1
   FROM public.configuracion_fiscal cf
  WHERE ((cf.idconfiguracion_fiscal = configuracion_fiscal_actividad.configuracion_fiscal) AND (cf.user_id = auth.uid())))));

CREATE POLICY "user_isolation_config_pv" ON "public"."configuracion_fiscal_punto_venta"
  FOR ALL
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.configuracion_fiscal cf
  WHERE ((cf.idconfiguracion_fiscal = configuracion_fiscal_punto_venta.configuracion_fiscal) AND (cf.user_id = auth.uid())))))
  WITH CHECK ((EXISTS ( SELECT 1
   FROM public.configuracion_fiscal cf
  WHERE ((cf.idconfiguracion_fiscal = configuracion_fiscal_punto_venta.configuracion_fiscal) AND (cf.user_id = auth.uid())))));

ALTER TABLE "public"."factura"
  ADD CONSTRAINT "factura_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE POLICY "user_isolation_factura" ON "public"."factura"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = user_id))
  WITH CHECK ((auth.uid() = user_id));

ALTER TABLE "public"."materia_prima"
  ADD CONSTRAINT "materia_prima_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE INDEX idx_materia_prima_user_id ON public.materia_prima USING btree (user_id);

CREATE POLICY "user_isolation_materia_prima" ON "public"."materia_prima"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = user_id))
  WITH CHECK ((auth.uid() = user_id));

ALTER TABLE "public"."movimiento_mp"
  ADD CONSTRAINT "movimiento_mp_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE POLICY "user_isolation_movimiento_mp" ON "public"."movimiento_mp"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = user_id))
  WITH CHECK ((auth.uid() = user_id));

ALTER TABLE "public"."producto_base"
  ADD CONSTRAINT "producto_base_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE INDEX idx_producto_base_user_id ON public.producto_base USING btree (user_id);

CREATE POLICY "user_isolation_producto_base" ON "public"."producto_base"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = user_id))
  WITH CHECK ((auth.uid() = user_id));

ALTER TABLE "public"."producto_variante"
  ADD CONSTRAINT "producto_variante_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE INDEX idx_producto_variante_user_id ON public.producto_variante USING btree (user_id);

CREATE POLICY "user_isolation_fabrica" ON "public"."fabrica"
  FOR ALL
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.producto_variante pv
  WHERE ((pv.idproducto_variante = fabrica.producto_variante) AND (pv.user_id = auth.uid())))))
  WITH CHECK ((EXISTS ( SELECT 1
   FROM public.producto_variante pv
  WHERE ((pv.idproducto_variante = fabrica.producto_variante) AND (pv.user_id = auth.uid())))));

CREATE POLICY "user_isolation_producto_variante" ON "public"."producto_variante"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = user_id))
  WITH CHECK ((auth.uid() = user_id));

ALTER TABLE "public"."punto_venta"
  ADD CONSTRAINT "punto_venta_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE POLICY "user_isolation_punto_venta" ON "public"."punto_venta"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = user_id))
  WITH CHECK ((auth.uid() = user_id));

ALTER TABLE "public"."retazo"
  ADD CONSTRAINT "retazo_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE INDEX idx_retazo_user_id ON public.retazo USING btree (user_id);

CREATE POLICY "user_isolation_retazo" ON "public"."retazo"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = user_id))
  WITH CHECK ((auth.uid() = user_id));

ALTER TABLE "public"."trabajo"
  ADD CONSTRAINT "trabajo_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE INDEX idx_trabajo_user_id ON public.trabajo USING btree (user_id);

CREATE POLICY "user_isolation_contiene_trabajo" ON "public"."contiene_trabajo"
  FOR ALL
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.trabajo t
  WHERE ((t.idtrabajo = contiene_trabajo.trabajo) AND (t.user_id = auth.uid())))))
  WITH CHECK ((EXISTS ( SELECT 1
   FROM public.trabajo t
  WHERE ((t.idtrabajo = contiene_trabajo.trabajo) AND (t.user_id = auth.uid())))));

CREATE POLICY "user_isolation_historial_estado" ON "public"."historial_estado"
  FOR ALL
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.trabajo t
  WHERE ((t.idtrabajo = historial_estado.trabajo) AND (t.user_id = auth.uid())))))
  WITH CHECK ((EXISTS ( SELECT 1
   FROM public.trabajo t
  WHERE ((t.idtrabajo = historial_estado.trabajo) AND (t.user_id = auth.uid())))));

CREATE POLICY "user_isolation_pago_parcial" ON "public"."pago_parcial"
  FOR ALL
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.trabajo t
  WHERE ((t.idtrabajo = pago_parcial.trabajo) AND (t.user_id = auth.uid())))))
  WITH CHECK ((EXISTS ( SELECT 1
   FROM public.trabajo t
  WHERE ((t.idtrabajo = pago_parcial.trabajo) AND (t.user_id = auth.uid())))));

CREATE POLICY "user_isolation_trabajo" ON "public"."trabajo"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = user_id))
  WITH CHECK ((auth.uid() = user_id));

ALTER TABLE "public"."venta"
  ADD CONSTRAINT "venta_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

CREATE INDEX idx_venta_user_id ON public.venta USING btree (user_id);

CREATE POLICY "user_isolation_contiene_venta" ON "public"."contiene_venta"
  FOR ALL
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.venta v
  WHERE ((v.idventa = contiene_venta.venta) AND (v.user_id = auth.uid())))))
  WITH CHECK ((EXISTS ( SELECT 1
   FROM public.venta v
  WHERE ((v.idventa = contiene_venta.venta) AND (v.user_id = auth.uid())))));

CREATE POLICY "user_isolation_mp_venta" ON "public"."mp_venta"
  FOR ALL
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.venta v
  WHERE ((v.idventa = mp_venta.venta) AND (v.user_id = auth.uid())))))
  WITH CHECK ((EXISTS ( SELECT 1
   FROM public.venta v
  WHERE ((v.idventa = mp_venta.venta) AND (v.user_id = auth.uid())))));

CREATE POLICY "user_isolation_venta" ON "public"."venta"
  FOR ALL
  TO "authenticated"
  USING ((auth.uid() = user_id))
  WITH CHECK ((auth.uid() = user_id));

CREATE POLICY "user_isolation_venta_descuento" ON "public"."venta_descuento"
  FOR ALL
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.venta v
  WHERE ((v.idventa = venta_descuento.venta) AND (v.user_id = auth.uid())))))
  WITH CHECK ((EXISTS ( SELECT 1
   FROM public.venta v
  WHERE ((v.idventa = venta_descuento.venta) AND (v.user_id = auth.uid())))));

CREATE POLICY "user_isolation_venta_trabajo" ON "public"."venta_trabajo"
  FOR ALL
  TO "authenticated"
  USING ((EXISTS ( SELECT 1
   FROM public.venta v
  WHERE ((v.idventa = venta_trabajo.venta) AND (v.user_id = auth.uid())))))
  WITH CHECK ((EXISTS ( SELECT 1
   FROM public.venta v
  WHERE ((v.idventa = venta_trabajo.venta) AND (v.user_id = auth.uid())))));

