DROP TABLE IF EXISTS proceso.maestro_cuotas PURGE;
CREATE TABLE proceso.maestro_cuotas
STORED AS PARQUET AS
WITH marca_repetidos AS
(
    SELECT
        *,
        row_number() OVER(PARTITION BY nit_enmascarado,num_oblig_enmascarado,fecha_corte ORDER BY pago_total) AS rn
    FROM proceso_enmascarado.prueba_op_maestra_cuotas_pagos_mes_hist_enmascarado_completa 
) 
SELECT
    *
FROM marca_repetidos 
WHERE rn = 1
;
COMPUTE STATS proceso.maestro_cuotas;