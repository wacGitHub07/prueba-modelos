DROP TABLE IF EXISTS {proccess_zone}.pmod_obligaciones_cruce PURGE;
CREATE TABLE {proccess_zone}.pmod_obligaciones_cruce
STORED AS PARQUET AS
SELECT
    *
FROM {proccess_area_zone}.pmod_replica_12
WHERE d_meses = 1
;
COMPUTE STATS {proccess_zone}.pmod_obligaciones;