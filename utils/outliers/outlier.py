import pandas as pd

def outlier(data: pd.DataFrame) -> pd.DataFrame:
    """Calculo de outliers por método de IQR  y eliminación de los mismos.

    Args:
        data (pd.DataFrame): dataset

    Returns:
        pd.DataFrame: dataset sin outliers
    """
    # 1. Calcular el IQR
    Q1 = data.quantile(0.25)
    Q3 = data.quantile(0.75)
    IQR = Q3 - Q1

    # 2. Determinar límites para outliers
    limite_inferior = Q1 - 1.5 * IQR
    limite_superior = Q3 + 1.5 * IQR

    # 3. Identificar los outliers
    es_outlier = ((data < limite_inferior) | (data > limite_superior))
    outliers = data[es_outlier]
    num_outliers = es_outlier.sum()

    # Mostrar los outliers
    print("Valores atípicos encontrados:")
    print(outliers.stack())  # Usamos stack para una mejor visualización

    # Contar y mostrar la cantidad de outliers por columna
    print("\nCantidad de valores atípicos por columna:")
    print(num_outliers)

    # 4. Eliminar los outliers
    data_limpio = data[~es_outlier.any(axis=1)]

    # Mostrar la cantidad de filas eliminadas
    print(f"\nFilas eliminadas: {len(data) - len(data_limpio)}")
    
    return data_limpio