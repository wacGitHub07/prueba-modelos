/*
    Tabla temporal con las variables de cruce
*/
DROP TABLE IF EXISTS {proccess_zone}.{pref}_tend_tabla_base PURGE;
CREATE TABLE {proccess_zone}.{pref}_tend_tabla_base
STORED AS PARQUET AS
SELECT
    {vars_agrupa}
FROM {table_vars}
;
COMPUTE STATS {proccess_zone}.{pref}_tend_tabla_base;
