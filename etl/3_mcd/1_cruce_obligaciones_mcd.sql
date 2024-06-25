/*
    Cruce de la base de obligaciones replicada con el módulo de maestro de clientes
*/
DROP TABLE IF EXISTS {proccess_zone}.pmod_mcd_obligaciones PURGE;
CREATE TABLE {proccess_zone}.pmod_mcd_obligaciones
STORED AS PARQUET AS
SELECT 
    t1.*,
    
    t2.nit_enmascarado AS nit_enmascarado_mc,
    t2.fecha_corte,
    t2.total_ing,
    t2.tot_activos,
    t2.egresos_mes,
    t2.tot_patrimonio
FROM {proccess_zone}.pmod_obligaciones_cruce t1
LEFT JOIN {proccess_zone}.pmod_mcd t2
       ON t1.nit_enmascarado = t2.nit_enmascarado
      AND t1.f_cruce = t2.fecha_corte
;
COMPUTE STATS {proccess_zone}.pmod_mcd_obligaciones;