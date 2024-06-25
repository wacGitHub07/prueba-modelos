/*
    Selección de la muestra de cruce para el cálculo de las tendencias
    Se seleccionan de 1 a 6 meses dada la historia proporcionada
*/
DROP TABLE IF EXISTS {proccess_zone}.pmod_obligaciones_cruce PURGE;
CREATE TABLE {proccess_zone}.pmod_obligaciones_cruce
STORED AS PARQUET AS
SELECT
    *
FROM {proccess_area_zone}.pmod_replica_12
WHERE d_meses BETWEEN 1 AND 6
;
COMPUTE STATS {proccess_zone}.pmod_obligaciones_cruce;