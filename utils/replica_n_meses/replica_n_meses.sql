-- Selecciona fechas de interés
DROP TABLE IF EXISTS {proccess_zone}.{pref}_fechas_12 PURGE;
CREATE TABLE {proccess_zone}.{pref}_fechas_12 
STORED AS PARQUET AS
SELECT     
      anio
    , mes
    , ( {anio} * 12 + {mes} ) - ( anio * 12 + mes ) AS d_meses
FROM {proccess_zone}.{pref}_fechas_anio
CROSS JOIN {proccess_zone}.{pref}_fechas_mes
     WHERE anio*100+mes <= {anio} * 100 + {mes} 
       and anio*100+mes > if (  {mes}  =  1, ( ( {anio} - 2 ) * 100 ) + 12, ( ( {anio} - 1 ) * 100 ) + {mes} - 1 )  
;

COMPUTE STATS {proccess_zone}.{pref}_fechas_12;

-- Selecciona clientes de interés
DROP TABLE IF EXISTS {proccess_zone}.{pref}_replica_12_1 PURGE;
CREATE TABLE {proccess_zone}.{pref}_replica_12_1 
STORED AS PARQUET AS
SELECT 
    *  
FROM {proccess_zone}.{base}
WHERE {fecha_corte} = {f_analisis}
;

COMPUTE STATS {proccess_zone}.{pref}_replica_12_1;

-- Se obtienen los doce meses anteriores para cada cliente
DROP TABLE IF EXISTS {proccess_zone}.{pref}_replica_12_{f_analisis} PURGE
;
CREATE TABLE {proccess_zone}.{pref}_replica_12_{f_analisis} 
STORED AS PARQUET AS
SELECT     
    {vars_base},
    t2.anio*100 + t2.mes as f_cruce,
    t2.d_meses,
    {fecha_corte}
FROM  {proccess_zone}.{pref}_replica_12_1 t1
CROSS JOIN {proccess_zone}.{pref}_fechas_12 t2
;

COMPUTE STATS {proccess_zone}.{pref}_replica_12_{f_analisis};