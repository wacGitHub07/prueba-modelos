/******************************************************************/
/*Autores:        Walter Arboleda Castañeda - warboled                                             
  Fecha creación: 09/11/2019                                                                                                                             
  Descripción:    Calculo de tendencias para los modulos fic              
  
  Input:          - tabla a calcular {TABLA}
  
  Output:         - {proccess_zone}.{pref}_tendencias                                                                                                       

  Actualización:                                                  */                                                                                                                                 
/******************************************************************/

/* Se calculan 12 variables para verificar en cual
   de los 12 meses esta presente la variable, de lo contrario
   se imputa */
DROP TABLE IF EXISTS {proccess_zone}.{pref}_tendencias_00 PURGE;
CREATE TABLE {proccess_zone}.{pref}_tendencias_00
STORED AS PARQUET AS
SELECT 
      {vars_agrupa}
    , IF(d_meses = 1, IF({variable} IS NULL, 0, {variable}),  0) AS v1
    , IF(d_meses = 2, IF({variable} IS NULL, 0, {variable}),  0) AS v2
    , IF(d_meses = 3, IF({variable} IS NULL, 0, {variable}),  0) AS v3
    , IF(d_meses = 4, IF({variable} IS NULL, 0, {variable}),  0) AS v4
    , IF(d_meses = 5, IF({variable} IS NULL, 0, {variable}),  0) AS v5
    , IF(d_meses = 6, IF({variable} IS NULL, 0, {variable}),  0) AS v6
FROM {table_vars}
;
COMPUTE STATS {proccess_zone}.{pref}_tendencias_00;

/* Se calcula el maximo valor para las 12 variables */
DROP TABLE IF EXISTS {proccess_zone}.{pref}_tendencias_01 PURGE;
CREATE TABLE {proccess_zone}.{pref}_tendencias_01
STORED AS PARQUET AS
SELECT 
      {vars_agrupa}
    , MAX(v1) AS v1
    , MAX(v2) AS v2
    , MAX(v3) AS v3
    , MAX(v4) AS v4
    , MAX(v5) AS v5
    , MAX(v6) AS v6
FROM {proccess_zone}.{pref}_tendencias_00
GROUP BY {vars_agrupa}
;
COMPUTE STATS {proccess_zone}.{pref}_tendencias_01;


/* Se sumas las variables categoricas para determinar la cantidad
   de veces en que esta presente la variable */
DROP TABLE IF EXISTS {proccess_zone}.{pref}_tendencias_02 PURGE;
CREATE TABLE {proccess_zone}.{pref}_tendencias_02
STORED AS PARQUET AS 
SELECT
    *
    -- Suma de las cantidades anulando las nulas en los últimos 6 meses
    , (v6 + v5 + v4 + v3 + v2 + v1) AS sum_ult6 
    -- Suma de las cantidades anulando las nulas en los últimos 3 meses
    , (v3 + v2 + v1) AS sum_ult3
FROM {proccess_zone}.{pref}_tendencias_01
;
COMPUTE STATS {proccess_zone}.{pref}_tendencias_02;

/* Se calculan los promedios */ 
DROP TABLE IF EXISTS {proccess_zone}.{pref}_tendencias_03 PURGE;
CREATE TABLE {proccess_zone}.{pref}_tendencias_03
STORED AS PARQUET AS 
SELECT
      *
    , sum_ult6/6 as avg_ult6
    , sum_ult3/3 as avg_ult3
FROM {proccess_zone}.{pref}_tendencias_02
;
COMPUTE STATS {proccess_zone}.{pref}_tendencias_03;

/* Se suman los totales */
DROP TABLE IF EXISTS {proccess_zone}.{pref}_tendencias_04 PURGE;
CREATE TABLE {proccess_zone}.{pref}_tendencias_04
STORED AS PARQUET AS 
SELECT
      *
    -- Suma para desviacion estandar ultimos 6 meses
    , ((v6-avg_ult6)*(v6-avg_ult6) + 
       (v5-avg_ult6)*(v5-avg_ult6) + 
       (v4-avg_ult6)*(v4-avg_ult6) + 
       (v3-avg_ult6)*(v3-avg_ult6) + 
       (v2-avg_ult6)*(v2-avg_ult6) + 
       (v1-avg_ult6)*(v1-avg_ult6)) AS sum2_ult6
    -- Suma para desviacion estandar ultimos 3 meses
    , ((v3-avg_ult3)*(v3-avg_ult3) + 
       (v2-avg_ult3)*(v2-avg_ult3) + 
       (v1-avg_ult3)*(v1-avg_ult3)) AS sum2_ult3
FROM {proccess_zone}.{pref}_tendencias_03
;
COMPUTE STATS {proccess_zone}.{pref}_tendencias_04;

/* Se calculan desviaciones
   Se calculan valores maximos
   Se consolidan las variables calculadas */
DROP TABLE IF EXISTS {proccess_zone}.{pref}_tendencias PURGE;
CREATE TABLE {proccess_zone}.{pref}_tendencias
STORED AS PARQUET AS 
SELECT
    {vars_agrupa}
    , v1 AS {variable}_1
    , avg_ult3 AS {variable}_avg_ult3
    , avg_ult6 AS {variable}_avg_ult6
    , SQRT(sum2_ult3/3) as {variable}_stddev_ult3
    , SQRT(sum2_ult6/6) as {variable}_stddev_ult6
    , GREATEST(v1,v2,v3,v4,v5,v6) AS {variable}_max_ult6
    , GREATEST(v1,v2,v3) AS {variable}_max_ult3
FROM {proccess_zone}.{pref}_tendencias_04;

COMPUTE STATS {proccess_zone}.{pref}_tendencias;

DROP TABLE IF EXISTS {proccess_zone}.{pref}_tend_tabla_base_ PURGE;
CREATE TABLE {proccess_zone}.{pref}_tend_tabla_base_
STORED AS PARQUET AS
SELECT
      t1.*
    , t2.{variable}_1
    , t2.{variable}_avg_ult3
    , t2.{variable}_avg_ult6
    , t2.{variable}_stddev_ult3
    , t2.{variable}_stddev_ult6
    , t2.{variable}_max_ult6
    , t2.{variable}_max_ult3
FROM {proccess_zone}.{pref}_tend_tabla_base t1
LEFT JOIN {proccess_zone}.{pref}_tendencias t2
       ON {join}
;
COMPUTE STATS {proccess_zone}.{pref}_tend_tabla_base_;

DROP TABLE {proccess_zone}.{pref}_tend_tabla_base PURGE;
ALTER TABLE {proccess_zone}.{pref}_tend_tabla_base_ RENAME TO {proccess_zone}.{pref}_tend_tabla_base;
INVALIDATE METADATA {proccess_zone}.{pref}_tend_tabla_base;

/* Se eliminan las tablas temporales */
DROP TABLE {proccess_zone}.{pref}_tendencias_00 PURGE;
DROP TABLE {proccess_zone}.{pref}_tendencias_01 PURGE;
DROP TABLE {proccess_zone}.{pref}_tendencias_02 PURGE;
DROP TABLE {proccess_zone}.{pref}_tendencias_03 PURGE;
DROP TABLE {proccess_zone}.{pref}_tendencias_04 PURGE;