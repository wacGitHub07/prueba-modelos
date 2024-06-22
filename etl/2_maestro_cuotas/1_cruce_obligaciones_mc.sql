DROP TABLE IF EXISTS {proccess_zone}.pmod_maestro_cuotas_obligaciones PURGE;
CREATE TABLE {proccess_zone}.pmod_maestro_cuotas_obligaciones
STORED AS PARQUET AS
SELECT 
    t1.*,
    
    t2.nit_enmascarado AS nit_enmascarado_mcd,
    t2.fecha_corte,
    t2.valor_cuota_mes,
    t2.pago_total,
    t2.porc_pago
FROM {proccess_zone}.pmod_obligaciones_cruce t1
LEFT JOIN {proccess_zone}.maestro_cuotas t2
       ON t1.nit_enmascarado = t2.nit_enmascarado
      AND t1.num_oblig_enmascarado = t2.num_oblig_enmascarado
      AND t1.f_cruce = CAST(t2.fecha_corte/100 AS INT)
;
COMPUTE STATS {proccess_zone}.pmod_maestro_cuotas_obligaciones;