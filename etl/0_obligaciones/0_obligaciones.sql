/*
    Tabla temporal con las principales variables de cruce
    Incluyendo la muestra fuera de tiempo para calcular las variables de toda la muestra
*/
DROP TABLE IF EXISTS {proccess_zone}.pmod_obligaciones PURGE;
CREATE TABLE {proccess_zone}.pmod_obligaciones
PARTITIONED BY (fecha_var_rpta_alt)
STORED AS PARQUET AS
SELECT
    nit_enmascarado,
    num_oblig_enmascarado,
    num_oblig_orig_enmascarado,
    fecha_var_rpta_alt
FROM proceso_enmascarado.prueba_op_base_pivot_var_rpta_alt_enmascarado_trtest
UNION
SELECT
    nit_enmascarado,
    num_oblig_enmascarado,
    num_oblig_orig_enmascarado,
    fecha_var_rpta_alt
FROM proceso_enmascarado.prueba_op_base_pivot_var_rpta_alt_enmascarado_oot
;
COMPUTE STATS {proccess_zone}.pmod_obligaciones;
