import pandas as pd
from pycaret.classification import *

def train_model(data, target, models = ['lr', 'dt', 'svm', 'rf', 'xgboost', 'lightgbm']):
    s = setup(data, 
              target = target, 
              n_jobs= -1,
            #   remove_multicollinearity = True, 
            #   multicollinearity_threshold = 0.8,
              remove_outliers = True,
              session_id=123)
    best = compare_models(sort = 'f1', fold = 5, include = models, n_select= 3)
    return best

def calification_model(model, data_calification, vars_model, scaler = None):

    data_calification_ = data_calification[vars_model]
    
    if scaler:
        data_calif_norm = data_calification_
        data_calif_norm = scaler.transform(data_calification_.drop(columns=["pd_prob_propension","pd_prob_alrt_temprana","pd_prob_auto_cura", 'var_rpta_alt']))
        data_calif_norm = pd.DataFrame(data_calif_norm, columns=data_calification_.columns[:-4])
        data_calif_norm["pd_prob_propension"] = data_calification_["pd_prob_propension"].values
        data_calif_norm["pd_prob_alrt_temprana"] = data_calification_["pd_prob_alrt_temprana"].values
        data_calif_norm["pd_prob_auto_cura"] = data_calification_["pd_prob_auto_cura"].values
    else:
        data_calif_norm = data_calification_
    

    predictios = predict_model(model, data=data_calif_norm, raw_score=True)
    
    data_calification["var_rpta_alt"] = predictios["prediction_label"].values
    data_calification["prediction_score_1"] = predictios["prediction_score_1"].values
    return data_calification
    