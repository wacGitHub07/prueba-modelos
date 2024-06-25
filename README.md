
## Prueba Analítica: Modelo Opciones de Pago

### Descripción

Este repositorio contiene la solucion propuesta a la prueba de selección del área de modelos analíticos.

**Componentes de la solución**:

- **documentacion_entregable**: contiene el documento que detalla la solución asi como el archivo .csv con la base calificada fuera de tiempo

- **etl**: Queries para el proceso de variables

- **notebooks**:
  -  0_etl_executions: Ejecuciones de queries
  - 1_proccess_data: Procesamiento de los datos
  - 2_modeling: Modelo y ejecución de experimento

- **utils**: Funciones desarrolladas
  - cd: scripts para despliegues continuos
  - correlacion: scipts para calculo y selección de variables por correlación
  - monitoring: scripts ejemplos para el calculo de métricas y monitoreo de la solución
  - outliers: script para el cálculo y eliminación de valores atípicos
  - replica_n_meses: replica de registros n meses atrás
  - run_models: script para la ejecución de entrenamiento de modelos en pycaret
  - tendencias: script para el calculo de variables regresivas