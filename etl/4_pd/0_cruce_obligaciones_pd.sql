DROP TABLE IF EXISTS {proccess_zone}.pmod_pd_obligaciones PURGE;
CREATE TABLE {proccess_zone}.pmod_pd_obligaciones
STORED AS PARQUET AS
SELECT 
    t1.*,
    
    t2.nit_enmascarado AS nit_enmascarado_mc,
    t2.fecha_corte,
    t2.prob_propension,
    t2.prob_alrt_temprana,
    t2.prob_auto_cura,
    t2.lote
FROM {proccess_zone}.pmod_obligaciones_cruce t1
LEFT JOIN proceso_enmascarado.prueba_op_probabilidad_oblig_base_hist_enmascarado_completa t2
       ON t1.nit_enmascarado = t2.nit_enmascarado
      AND t1.num_oblig_enmascarado = t2.num_oblig_enmascarado
      AND t1.f_cruce = t2.fecha_corte
;
COMPUTE STATS {proccess_zone}.pmod_pd_obligaciones;