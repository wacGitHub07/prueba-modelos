DROP TABLE IF EXISTS {proccess_zone}.pmod_base_cruce PURGE;
CREATE TABLE {proccess_zone}.pmod_base_cruce
STORED AS PARQUET AS
WITH obligaciones AS (
      SELECT
            nit_enmascarado,
            num_oblig_enmascarado,
            num_oblig_orig_enmascarado,
            fecha_var_rpta_alt,
            var_rpta_alt
      FROM proceso_enmascarado.prueba_op_base_pivot_var_rpta_alt_enmascarado_trtest
      UNION
      SELECT
            nit_enmascarado,
            num_oblig_enmascarado,
            num_oblig_orig_enmascarado,
            fecha_var_rpta_alt,
            NULL AS var_rpta_alt
      FROM proceso_enmascarado.prueba_op_base_pivot_var_rpta_alt_enmascarado_oot
)
SELECT 
    t1.*,
    t2.marca_pago,
    t2.ajustes_banco,
    t3.lote
FROM obligaciones t1
LEFT JOIN {proccess_zone}.pmod_maestro_cuotas_obligaciones t2
       ON t1.nit_enmascarado = t2.nit_enmascarado
      AND t1.num_oblig_orig_enmascarado = t2.num_oblig_orig_enmascarado
      AND t1.num_oblig_enmascarado = t2.num_oblig_enmascarado
      AND t1.fecha_var_rpta_alt = t2.fecha_var_rpta_alt
LEFT JOIN {proccess_zone}.pmod_pd_obligaciones t3
       ON t1.nit_enmascarado = t3.nit_enmascarado
      AND t1.num_oblig_orig_enmascarado = t3.num_oblig_orig_enmascarado
      AND t1.num_oblig_enmascarado = t3.num_oblig_enmascarado
      AND t1.fecha_var_rpta_alt = t3.fecha_var_rpta_alt
WHERE t2.d_meses = 1
  AND t3.d_meses = 1
;

COMPUTE STATS {proccess_zone}.pmod_base_cruce;