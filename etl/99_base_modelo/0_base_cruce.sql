DROP TABLE IF EXISTS {proccess_zone}.pmod_base_cruce PURGE;
CREATE TABLE {proccess_zone}.pmod_base_cruce
STORED AS PARQUET AS
SELECT DISTINCT
    t1.nit_enmascarado,
    t1.num_oblig_enmascarado,
    t1.num_oblig_orig_enmascarado,
    t1.fecha_var_rpta_alt,

    t2.avg_dia_sld_cap_final AS sd_avg_dia_sld_cap_final,
    t2.max_dia_sld_cap_final AS sd_max_dia_sld_cap_final,
    t2.min_sld_cap_final AS sd_min_sld_cap_final,
    t2.stddevpop_dia_sld_cap_final AS sd_stddevpop_dia_sld_cap_final,
    t2.max_dia_nueva_altura_mora AS sd_max_dia_nueva_altura_mora,
    t2.min_dia_nueva_altura_mora AS sd_min_dia_nueva_altura_mora,
    t2.avg_dia_vlr_obligacion AS sd_avg_dia_vlr_obligacion,
    t2.max_dia_vlr_obligacion AS sd_max_dia_vlr_obligacion,
    t2.min_dia_vlr_obligacion AS sd_min_dia_vlr_obligacion,
    t2.stddevpop_dia_vlr_obligacion AS sd_stddevpop_dia_vlr_obligacion,
    t2.avg_dia_vlr_vencido AS sd_avg_dia_vlr_vencido,
    t2.max_dia_vlr_vencido AS sd_max_dia_vlr_vencido,
    t2.min_dia_vlr_vencido AS sd_min_dia_vlr_vencido,
    t2.stddevpop_dia_vlr_vencido AS sd_stddevpop_dia_vlr_vencido,

    t3.valor_cuota_mes AS mc_valor_cuota_mes,
    t3.pago_total AS mc_pago_total,
    t3.porc_pago AS mc_porc_pago,

    t4.total_ing AS mcd_total_ing,
    t4.tot_activos AS mcd_tot_activos,
    t4.egresos_mes AS mcd_egresos_mes,
    t4.tot_patrimonio AS mcd_tot_patrimonio,

    t5.var_rpta_alt

FROM {proccess_zone}.pmod_obligaciones_cruce t1 
LEFT JOIN {proccess_zone}.pmod_saldo_diario_obligacion t2
       ON t1.nit_enmascarado = t2.nit_enmascarado
      AND t1.num_oblig_enmascarado = t2.num_oblig_enmascarado
      AND t1.f_cruce = t2.fecha_corte
LEFT JOIN {proccess_zone}.pmod_maestro_cuotas_obligaciones t3
       ON t1.nit_enmascarado = t3.nit_enmascarado
      AND t1.num_oblig_enmascarado = t3.num_oblig_enmascarado
      AND t1.f_cruce = t3.fecha_corte
LEFT JOIN {proccess_zone}.pmod_mcd_obligaciones t4
       ON t1.nit_enmascarado = t4.nit_enmascarado
      AND t1.f_cruce = t4.fecha_corte
LEFT JOIN proceso_enmascarado.prueba_op_base_pivot_var_rpta_alt_enmascarado_trtest t5
       ON t1.nit_enmascarado = t5.nit_enmascarado
      AND t1.num_oblig_orig_enmascarado = t5.num_oblig_orig_enmascarado
      AND t1.num_oblig_enmascarado = t5.num_oblig_enmascarado
      AND t1.fecha_var_rpta_alt = t5.fecha_var_rpta_alt
;

COMPUTE STATS {proccess_zone}.pmod_base_cruce;