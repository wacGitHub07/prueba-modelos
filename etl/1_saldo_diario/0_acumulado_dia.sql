DROP TABLE IF EXISTS proceso.pmod_saldo_diario_add_dia PURGE;
CREATE TABLE proceso.pmod_saldo_diario_add_dia
STORED AS PARQUET AS
SELECT
    nit_enmascarado,
    num_oblig_enmascarado,
    year*100 + month as fecha_corte,
    
    AVG(sld_cap_final) AS avg_sld_cap_final,
    MAX(sld_cap_final) AS max_dia_sld_cap_final,
    MIN(sld_cap_final) AS min_sld_cap_final,

    AVG(nueva_altura_mora) AS avg_nueva_altura_mora,
    MAX(nueva_altura_mora) AS max_nueva_altura_mora,
    MIN(nueva_altura_mora) AS min_nueva_altura_mora,
    
    AVG(vlr_obligacion) AS avg_vlr_obligacion,
    MAX(vlr_obligacion) AS max_vlr_obligacion,
    MIN(vlr_obligacion) AS min_vlr_obligacion,
    
    AVG(vlr_vencido) AS avg_vlr_vencido,
    MAX(vlr_vencido) AS max_vlr_vencido,
    MIN(vlr_vencido) AS min_vlr_vencido

FROM proceso_enmascarado.prueba_op_saldos_diarios_cob_enmascarado_completa
GROUP BY nit_enmascarado,
         num_oblig_enmascarado,
         fecha_corte
;
COMPUTE STATS proceso.pmod_saldo_diario_add_dia;