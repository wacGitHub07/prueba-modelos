import pandas as pd
from pycaret.classification import *

def train_model(data, target, models = ['lr', 'dt', 'svm', 'rf', 'xgboost', 'lightgbm']):
    s = setup(data, 
              target = target, 
              n_jobs= -1,
            #   remove_multicollinearity = True, 
            #   multicollinearity_threshold = 0.8,
            #   remove_outliers = True,
              session_id=123)
    best = compare_models(sort = 'f1', fold = 5, include = models, n_select= 3)
    return best

def calification_model(model, data_calification, vars_model, scaler = None):

    data_calification_ = data_calification[vars_model]
    
    if scaler:
        data_calif_norm = data_calification_
        data_calif_norm = scaler.transform(data_calification_.values)
        data_calif_norm = pd.DataFrame(data_calif_norm, columns=vars_model)
    else:
        data_calif_norm = data_calification_
    

    predictios = predict_model(model, data=data_calif_norm, raw_score=True)
    
    data_calification["var_rpta_alt"] = predictios["prediction_label"].values
    data_calification["prediction_score_1"] = predictios["prediction_score_1"].values
    return data_calification
    