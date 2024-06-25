#%%
import numpy as np
import pandas as pd
from sklearn.metrics import mean_squared_error
from pycaret.classification import *
import os

def test_inferencia_modelo(model, data , y_expected):
    """

    """
    data_prediccion = predict_model(model, data=data)
    
    # Comparar los valores de predicción con los valores esperados
    mse = mean_squared_error(data_prediccion["prediction_label"], y_expected)
    print(f"Error cuadrático medio (MSE) entre los valores esperados y los de predicción: {mse}")



path_models = os.path.abspath(os.getcwd())

vars_model = ['avg_sld_cap_final_1', 'avg_sld_cap_final_stddev_ult3',
              'avg_sld_cap_final_stddev_ult6', 'avg_nueva_altura_mora_1',
              'avg_nueva_altura_mora_stddev_ult3',
              'min_vlr_obligacion_stddev_ult3', 'avg_vlr_vencido_1',
              'valor_cuota_mes_1', 'valor_cuota_mes_stddev_ult3',
              'valor_cuota_mes_stddev_ult6', 'pago_total_1',
              'pago_total_avg_ult3', 'porc_pago_1', 'porc_pago_avg_ult3',
              'total_ing_1', 'total_ing_avg_ult3', 'total_ing_stddev_ult3',
              'tot_activos_1', 'tot_activos_stddev_ult3',
              'tot_activos_stddev_ult6', 'egresos_mes_1',
              'egresos_mes_stddev_ult3', 'tot_patrimonio_stddev_ult3',
              'tot_patrimonio_stddev_ult6', 'prob_propension_1',
              'prob_propension_stddev_ult3', 'prob_propension_stddev_ult6',
              'prob_propension_max_ult6', 'prob_alrt_temprana_1',
              'prob_alrt_temprana_stddev_ult3', 'prob_alrt_temprana_stddev_ult6',
              'prob_auto_cura_1', 'prob_auto_cura_stddev_ult3',
              'prob_auto_cura_stddev_ult6', 'marca_pago', 'ajustes_banco',
              'lote']

# load pipeline
model = load_model(path_models + '/notebooks/models/best_model_tuned')
data = pd.read_csv(path_models + '/utils/monitoring/inference_example.csv')
y_expected = data['var_rpta_alt']
data = data[vars_model]
data.head()


test_inferencia_modelo(model, data , y_expected)