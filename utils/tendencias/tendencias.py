
from helper.helper import Helper

def tendencias(helper, vars_tend: list, path: str, params_tend: dict)-> None:

    # Crear la tabla base que acumula las tendencias
    helper.ejecutar_archivo(path + '/0_pmod_tabla_base.sql', params=params_tend)
    
    # Ejecutar ciclo de calculo de tendencias
    for var in vars_tend:
        print("Calculando Tendencias: ", var)
        params_tend['variable'] = var
        helper.ejecutar_archivo(path + '/1_pmod_tendencias.sql', params=params_tend)
        
        
    # Almacenar tendencias
    helper.ejecutar_archivo(path + '/2_pmod_guarda_tend.sql', params=params_tend)