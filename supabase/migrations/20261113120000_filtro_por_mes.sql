-- Filtro por mes: la RPC de reportes recibe un rango [p_desde, p_hasta)
-- e índices por fecha para las consultas mensuales de ventas, gastos y movimientos MP.
-- Sin parámetros se comporta como antes (mes actual).

DROP FUNCTION IF EXISTS "public"."obtener_metricas_reportes"();

CREATE OR REPLACE FUNCTION "public"."obtener_metricas_reportes"(
  "p_desde" timestamp with time zone DEFAULT NULL,
  "p_hasta" timestamp with time zone DEFAULT NULL
) RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $_$
DECLARE
  resultado jsonb;
  v_inicio_mes timestamptz := COALESCE(p_desde, date_trunc('month', now()));
  v_fin_mes timestamptz := COALESCE(p_hasta, v_inicio_mes + interval '1 month');
BEGIN
  WITH metricas_generales AS (
    SELECT
      (SELECT COALESCE(SUM(monto_total), 0) FROM venta WHERE fecha >= v_inicio_mes AND fecha < v_fin_mes) AS total_invoiced,
      (SELECT COALESCE(SUM(monto_total), 0) FROM venta WHERE esta_pagado = false AND fecha >= v_inicio_mes AND fecha < v_fin_mes) AS pending_collection,
      (SELECT COUNT(*) FROM materia_prima WHERE stock <= stock_minimo) AS stock_alerts,
      -- Ganancia Neta Teórica (Facturado - Costo de Recetas)
      (
        (SELECT COALESCE(SUM(monto_total), 0) FROM venta WHERE fecha >= v_inicio_mes AND fecha < v_fin_mes) 
        - 
        (SELECT COALESCE(SUM(cv.cantidad * pv.precio_costo), 0)
         FROM venta v
         JOIN contiene_venta cv ON v.idventa = cv.venta
         JOIN producto_variante pv ON cv.producto_variante = pv.idproducto_variante
         WHERE v.fecha >= v_inicio_mes AND v.fecha < v_fin_mes)
      ) AS net_profit
  ),
  metricas_gastos AS (
    SELECT
      (SELECT COALESCE(SUM(monto), 0) FROM gasto WHERE fecha_emision >= v_inicio_mes AND fecha_emision < v_fin_mes) AS total_expenses,
      (SELECT COALESCE(SUM(monto), 0) FROM gasto WHERE estado_pago = 'PAGADO' AND fecha_emision >= v_inicio_mes AND fecha_emision < v_fin_mes) AS paid_expenses,
      (SELECT COALESCE(SUM(monto), 0) FROM gasto WHERE estado_pago = 'PENDIENTE' AND fecha_emision >= v_inicio_mes AND fecha_emision < v_fin_mes) AS pending_expenses
  ),
  balance_mensual AS (
    SELECT
      (SELECT COALESCE(SUM(monto_total), 0) FROM venta WHERE esta_pagado = true AND fecha >= v_inicio_mes AND fecha < v_fin_mes) AS monthly_collected
  ),
  
  -- Incluimos "PENDIENTE" en los métodos de pago
  ingresos_base AS (
    SELECT 
      COALESCE(metodo_pago, 'PENDIENTE') AS metodo_pago,
      count(*) AS cantidad,
      sum(monto_total) AS total
    FROM venta
    WHERE fecha >= v_inicio_mes AND fecha < v_fin_mes
    GROUP BY COALESCE(metodo_pago, 'PENDIENTE')
  ),
  ingresos_por_metodo AS (
    SELECT jsonb_agg(
      jsonb_build_object(
        'leading_text', metodo_pago,
        'center_text', cantidad::text,
        'trailing_text', '$' || total::text
      )
    ) AS data
    FROM ingresos_base
  ),

  descuentos_base AS (
    SELECT 
      motivo,
      count(*) AS cantidad,
      sum(monto_descontado) AS total
    FROM venta_descuento vd
    JOIN venta v ON v.idventa = vd.venta
    WHERE v.fecha >= v_inicio_mes AND v.fecha < v_fin_mes
    GROUP BY motivo
  ),
  descuentos_aplicados AS (
    SELECT jsonb_agg(
      jsonb_build_object(
        'leading_text', motivo,
        'center_text', cantidad::text,
        'trailing_text', '-$' || total::text
      )
    ) AS data
    FROM descuentos_base
  ),

  gastos_base AS (
    SELECT 
      cg.nombre AS categoria,
      count(*) AS cantidad,
      sum(g.monto) AS total
    FROM gasto g
    JOIN categoria_gasto cg ON g.categoria_gasto = cg.idcategoria_gasto
    WHERE g.fecha_emision >= v_inicio_mes AND g.fecha_emision < v_fin_mes
    GROUP BY cg.nombre
  ),
  gastos_registrados AS (
    SELECT jsonb_agg(
      jsonb_build_object(
        'leading_text', categoria,
        'center_text', cantidad::text || ' reg.',
        'trailing_text', '$' || total::text
      )
    ) AS data
    FROM gastos_base
  ),

  rentabilidad_base AS (
    SELECT 
      COALESCE(pb.categoria, 'Otros') AS category,
      SUM(cv.cantidad * cv.precio_unitario) AS total_sales,
      SUM(cv.cantidad * COALESCE(pv.precio_costo, 0)) AS supply_costs,
      SUM(cv.cantidad * cv.precio_unitario) - SUM(cv.cantidad * COALESCE(pv.precio_costo, 0)) AS net_profit
    FROM venta v
    JOIN contiene_venta cv ON v.idventa = cv.venta
    LEFT JOIN producto_variante pv ON cv.producto_variante = pv.idproducto_variante
    LEFT JOIN producto_base pb ON pv.producto_base = pb.idproducto_base
    WHERE v.fecha >= v_inicio_mes AND v.fecha < v_fin_mes
    GROUP BY COALESCE(pb.categoria, 'Otros')
  ),
  rentabilidad_calculada AS (
    SELECT 
      category,
      total_sales,
      supply_costs,
      net_profit,
      CASE WHEN total_sales > 0 THEN ROUND((net_profit / total_sales * 100)::numeric, 1) ELSE 0 END AS margin_percent,
      CASE WHEN SUM(net_profit) OVER() > 0 THEN ROUND((net_profit / SUM(net_profit) OVER() * 100)::numeric, 1) ELSE 0 END AS utility_distribution_percent
    FROM rentabilidad_base
  ),
  rentabilidad_agrupada AS (
    SELECT jsonb_agg(
      jsonb_build_object(
        'category', category,
        'total_sales', '$' || total_sales::text,
        'supply_costs', '$' || supply_costs::text,
        'net_profit', '$' || net_profit::text,
        'margin_percent', margin_percent,
        'utility_distribution_percent', utility_distribution_percent
      )
    ) AS data
    FROM rentabilidad_calculada
  )
  
  SELECT jsonb_build_object(
    'total_invoiced', mg.total_invoiced,
    'pending_collection', mg.pending_collection,
    'stock_alerts', mg.stock_alerts,
    'net_profit', mg.net_profit,
    'global_margin', CASE WHEN mg.total_invoiced > 0 THEN ROUND((mg.net_profit / mg.total_invoiced * 100)::numeric, 1) ELSE 0 END,
    
    'total_expenses', mgast.total_expenses,
    'pending_expenses', mgast.pending_expenses,
    
    -- Aplicamos Devengado: Facturado - Gastos Totales
    'monthly_collected', mg.total_invoiced, 
    'monthly_expenses', mgast.total_expenses,
    'monthly_final_amount', (mg.total_invoiced - mgast.total_expenses),
    
    'income_by_payment_method', COALESCE((SELECT data FROM ingresos_por_metodo), '[]'::jsonb),
    'applied_discounts', COALESCE((SELECT data FROM descuentos_aplicados), '[]'::jsonb),
    'registered_expenses', COALESCE((SELECT data FROM gastos_registrados), '[]'::jsonb),
    'profitability_by_category', COALESCE((SELECT data FROM rentabilidad_agrupada), '[]'::jsonb)
  ) INTO resultado
  FROM metricas_generales mg
  CROSS JOIN metricas_gastos mgast
  CROSS JOIN balance_mensual bm;

  RETURN resultado;
END;
$_$;


ALTER FUNCTION "public"."obtener_metricas_reportes"(timestamp with time zone, timestamp with time zone) OWNER TO "postgres";

GRANT ALL ON FUNCTION "public"."obtener_metricas_reportes"(timestamp with time zone, timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."obtener_metricas_reportes"(timestamp with time zone, timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."obtener_metricas_reportes"(timestamp with time zone, timestamp with time zone) TO "service_role";

CREATE INDEX IF NOT EXISTS "idx_venta_fecha" ON "public"."venta" USING "btree" ("fecha" DESC);
CREATE INDEX IF NOT EXISTS "idx_gasto_fecha_emision" ON "public"."gasto" USING "btree" ("fecha_emision" DESC);
CREATE INDEX IF NOT EXISTS "idx_movimiento_mp_fecha" ON "public"."movimiento_mp" USING "btree" ("fecha" DESC);
