import os
from azure.devops.connection import Connection
from msrest.authentication import BasicAuthentication
from azure.devops.v7_1.git.models import GitVersionDescriptor
import time
import pickle
import joblib
import numpy as np
import subprocess
import shutil
import os
import base64

def txt_to_obj(txt):
    """_summary_

    Args:
        txt (_type_): Función para convertir un txt en un objeto

    Returns:
        obj: objeto deserializado
    """
    base64_bytes = txt.encode('ascii')
    message_bytes = base64.b64decode(base64_bytes)
    obj = pickle.loads(message_bytes)
    return obj

data = None # Datos de predicción
personal_access_token = 'azure_token' # Token de acceso del ejecutor
organization_url = 'https://dev.azure.com/GrupoBancolombia/' # Organización en Azure DevOps
project_name = 'Vicepresidencia de Innovación y Transformación Digital' # Proyecto en Azure DevOps

# Autenticación api
credentials = BasicAuthentication('', personal_access_token)
connection = Connection(base_url=organization_url, creds=credentials)

# Obtener cliente de Git
git_client = connection.clients.get_git_client()

repositories = git_client.get_repositories(project_name)

# Busqueda de repositorio
for repo in repositories:
    if repo.name == 'repo_name': # Nombre del repositorio a monitorear
        print(repo.name)
        print(repo.id)
        print(repo.default_branch)
        print(repo.web_url)
        break
    
repository_id = repo.id
branch_name = repo.default_branch

# Se debe serializar el modelo como un txt
file_path = 'model.txt'

# Obtener información del archivo
file_content = git_client.get_item(
    repository_id,
    path=file_path,
    project=project_name,
    version_descriptor=GitVersionDescriptor(version=branch_name),
    latest_processed_change = True,
    include_content=True
)
file_content.as_dict()

model = txt_to_obj(file_content.content)

# Hacer predicciones con el modelo cargado
y_pred = model.predict(data)

print(f'Predicciones: {y_pred}')

update_date = file_content.latest_processed_change.author.date
commit_id = file_content.latest_processed_change.commit_id

current_date = update_date
current_commit = commit_id
current_model = txt_to_obj(file_content.content)

# Ciclo de monitoreo de cambioa en el modelo
while True:
    file_content = git_client.get_item(
    repository_id,
    path=file_path,
    project=project_name,
    version_descriptor=GitVersionDescriptor(version=branch_name),
    latest_processed_change = True,
    include_content=True
    )
    
    print("Escuchando...")
    print(current_date)
    update_date = file_content.latest_processed_change.author.date
    commit_id = file_content.latest_processed_change.commit_id
    
    if update_date > current_date and commit_id != current_commit:
        print("#### NEW MODEL ####")
        current_date = update_date
        current_commit = commit_id
        current_model = txt_to_obj(file_content.content)
    else:
        print("No hay cambios en el modelo.")
    
    X_test = np.array([[5.1, 3.5, 1.4, 0.2],
                   [6.2, 3.4, 5.4, 2.3]])
        # Hacer predicciones con el modelo cargado
    y_pred = current_model.predict(X_test)
    print(f'Predicciones: {y_pred}')
    
    time.sleep(5)