import pandas as pd
import numpy as np


# Función para eliminar variables altamente correlacionadas
def remove_highly_correlated_features(df, threshold=0.9):
    # Calcular la matriz de correlación
    corr_matrix = df.corr().abs()
    
    # Seleccionar el triángulo superior de la matriz de correlación
    upper = corr_matrix.where(np.triu(np.ones(corr_matrix.shape), k=1).astype(bool))
    
    # Encontrar las columnas con una correlación superior al umbral
    to_drop = [column for column in upper.columns if any(upper[column] > threshold)]
    
    # Eliminar las columnas altamente correlacionadas
    df_cleaned = df.drop(columns=to_drop)
    
    print("Variables eliminadas:", to_drop)
    return df_cleaned, to_drop