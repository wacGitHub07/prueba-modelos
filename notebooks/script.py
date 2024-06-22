#%%
from pycaret.classification import *
import pandas as pd

# %%
data_model_norm = pd.read_csv("data_model_norm.csv")

#%%
s = setup(data_model_norm, target = "var_rpta_alt", n_jobs= -1, session_id=123, log_experiment=True, experiment_name="prueba_modelos")

# %%
best = compare_models(sort = 'f1',
                      fold = 5,
                      include = ['lr', 'dt', 'svm', 'rf', 'lightgbm'],
                      n_select= 3)
# %%
print(best)
# %%

#%%
plot_model(best[0], plot = 'feature')
# %%
