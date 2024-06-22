import math
from helper.helper import Helper
import os

def replica(helper: Helper, f_ini: int, f_fin: int, params_sql: dict) -> None:
    """_summary_

    Args:
        helper (Helper): _description_
        f_ini (int): _description_
        f_fin (int): _description_
    """
    f_analisis_ = []
    anios = []
    f_ini = ( ( math.floor( f_ini / 100 ) - 1 ) * 100 ) + ( f_ini % 100 )
    
    print("Fechas del intervalo: ",f_ini, f_fin)

    while f_ini <= f_fin:
        f_analisis_.append(int(f_ini))
        anios.append(math.floor(int(f_ini) / 100))
        if str(int(f_ini)).endswith('12'):
            f_ini = int(f_ini) + 89
        else:
            f_ini = int(f_ini) + 1

    params = {
        'proccess_zone' : params_sql['proccess_zone'],
        'proccess_area_zone' : params_sql['proccess_area_zone'],
        'base' : params_sql['base'],
        'fecha_corte' : params_sql['fecha_corte'],
        'pref': params_sql['pref'],
        'vars_base' : params_sql['vars_base'],
        'anios' : ",".join("({})".format(i) for i in set(anios))
    }
    
    path = params_sql['path']
    helper.ejecutar_archivo(path + '/replica_fechas.sql', params)

    q1 = ''
    q2 = ''
    i  = 1    
    params_loc = params
    pref = params['pref']
    fecha_corte = params['fecha_corte']
    
    for f_analisis in f_analisis_ :
        f_an = str(f_analisis)
        params_loc['f_analisis'] = f_analisis
        params_loc['anio'] = str(f_analisis)[:4]
        params_loc['mes'] = str(f_analisis)[-2:]
        
        helper.ejecutar_archivo(path + '/replica_n_meses.sql', params_loc )
                
        if i == 1 :
            q1 += 'select * from ' + params['proccess_zone']  + f'.{pref}_replica_12_' + str(int(f_an))
        else :
            q1 += ' union all select * from ' + params['proccess_zone']  + f'.{pref}_replica_12_' + str(int(f_an))
                
        q2 += ' drop table if exists ' + params['proccess_zone']  + f'.{pref}_replica_12_' + str(int(f_an)) + ' purge;'
        i += 1

    q_drop = 'drop table if exists ' + params['proccess_area_zone'] + f'.{pref}_replica_12 purge;'
    helper.ejecutar_consulta(q_drop)
    q_create = 'create table ' + params['proccess_area_zone'] + f'.{pref}_replica_12 partitioned by ({fecha_corte}) stored as parquet as '+ q1 + ';'
    helper.ejecutar_consulta(q_create)
    q_stats = 'compute stats ' + params['proccess_area_zone'] + f'.{pref}_replica_12'
    helper.ejecutar_consulta(q_stats)
        
    #Query que elimina las tablas temporales de este procesoqq
    q_qs = q2.split(";")
    for qr in q_qs:
        if(qr != ''):
            helper.ejecutar_consulta(qr)