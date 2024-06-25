/*
    Queries pivote para la replica de registros n meses
*/
drop table if exists {proccess_zone}.{pref}_fechas_anio purge
;
create table {proccess_zone}.{pref}_fechas_anio 
stored as parquet as
select 2023 as anio
union all
select 2024 as anio
;
compute stats {proccess_zone}.{pref}_fechas_anio;

drop table if exists {proccess_zone}.{pref}_fechas_mes purge
;
create table {proccess_zone}.{pref}_fechas_mes 
stored as parquet as
select 1 as mes
union all
select 2 as mes
union all
select 3 as mes
union all
select 4 as mes
union all
select 5 as mes
union all
select 6 as mes
union all
select 7 as mes
union all
select 8 as mes
union all
select 9 as mes
union all
select 10 as mes
union all
select 11 as mes
union all
select 12 as mes;

compute stats {proccess_zone}.{pref}_fechas_mes;s