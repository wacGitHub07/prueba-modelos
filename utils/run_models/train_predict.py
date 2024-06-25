import pandas as pd
from pycaret.classification import *

def train_model(data, target, models = ['lr', 'dt', 'svm', 'rf', 'xgboost', 'lightgbm']):
    """Función para entrenamiento de modelos por medio de pycaret

    Args:
        data (_type_): dataset de entrenamiento
        target (_type_): variable objetivo
        models (list, optional): lista con los algoritmos a ejecutar. Defaults to ['lr', 'dt', 'svm', 'rf', 'xgboost', 'lightgbm'].

    Returns:
        Any: resultado de la comparación de modelos
    """
    s = setup(data, 
              target = target, 
              n_jobs= -1,
              session_id=123)
    best = compare_models(sort = 'f1', fold = 5, include = models, n_select= 3)
    return best
    