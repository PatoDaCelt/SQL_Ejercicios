import pandas as pd
import numpy as np

# Cargar el dataset
file_name = '/home/pato/Documentos/Data-Analysis/SQL_Ejercicios/Spotify/Spotify_data.csv'
df = pd.read_csv(file_name)

# 2. Generar IDs aleatorios de 4 dígitos (entre 1000 y 9999)
# np.random.randint(min, max) genera números enteros en el rango
df['user_id'] = np.random.randint(1000, 10000, size=len(df))

# 4. Guardar el resultado en un nuevo archivo CSV
output_file = 'Spotify_data2.csv'
df.to_csv(output_file, index=False)

print(f"¡Éxito! Archivo guardado como: {output_file}")
print(df.head())