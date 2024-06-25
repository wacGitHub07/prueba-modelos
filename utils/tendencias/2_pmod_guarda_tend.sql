/*
    Alacenamiento de la tabla de tendencias en una zona de mínimo
    mediana permanencia
*/
DROP TABLE IF EXISTS {proccess_area_zone}.{pref}_tend_{base} PURGE;
CREATE TABLE {proccess_area_zone}.{pref}_tend_{base}
STORED AS PARQUET AS
SELECT DISTINCT
    *
FROM {proccess_zone}.{pref}_tend_tabla_base
;
COMPUTE STATS {proccess_area_zone}.{pref}_tend_{base};

DROP TABLE IF EXISTS {proccess_zone}.{pref}_tend_tabla_base PURGE;