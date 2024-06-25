/*
    Cruce de la base de obligaciones replicada con el módulo de saldos diarios
*/
DROP TABLE IF EXISTS {proccess_zone}.pmod_saldo_diario_obligacion PURGE;
CREATE TABLE {proccess_zone}.pmod_saldo_diario_obligacion
STORED AS PARQUET AS
SELECT
    t1.*,
    
    t2.nit_enmascarado AS nit_enmascarado_sd,
    t2.num_oblig_enmascarado AS num_oblig_enmascarado_sd,
    t2.fecha_corte,
    t2.avg_sld_cap_final,
    t2.max_dia_sld_cap_final,
    t2.min_sld_cap_final,
    t2.avg_nueva_altura_mora,
    t2.max_nueva_altura_mora,
    t2.min_nueva_altura_mora,
    t2.avg_vlr_obligacion,
    t2.max_vlr_obligacion,
    t2.min_vlr_obligacion,
    t2.avg_vlr_vencido,
    t2.max_vlr_vencido,
    t2.min_vlr_vencido
FROM {proccess_zone}.pmod_obligaciones_cruce t1
LEFT JOIN {proccess_zone}.pmod_saldo_diario_add_dia t2
       ON t1.nit_enmascarado = t2.nit_enmascarado
      AND t1.num_oblig_enmascarado = t2.num_oblig_enmascarado
      AND t1.f_cruce = t2.fecha_corte
;
COMPUTE STATS {proccess_zone}.pmod_saldo_diario_obligacion; 
