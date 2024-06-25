/*
    Selección de las variables de interés del maestro de clientes
    Eliminacion de datos repetidos por total_ing
*/
DROP TABLE IF EXISTS {proccess_zone}.pmod_mcd PURGE;
CREATE TABLE {proccess_zone}.pmod_mcd
STORED AS PARQUET AS
WITH filtro_mcd AS(
    SELECT
        nit_enmascarado,
        total_ing,
        tot_activos,
        egresos_mes,
        tot_patrimonio,
        year,
        month,
        ingestion_day,
        year*100 + month AS fecha_corte,
        ROW_NUMBER() OVER(PARTITION BY nit_enmascarado, year, month ORDER BY total_ing DESC) AS rn
    FROM proceso_cap_analit_y_gob_de_inf.prueba_op_master_customer_data_enmascarado_completa
)
SELECT
    *
FROM filtro_mcd
WHERE rn = 1
;
COMPUTE STATS {proccess_zone}.pmod_mcd;