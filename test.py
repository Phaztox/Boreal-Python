import h5py
import pandas as pd

with h5py.File('resultats_test/data.h5', 'r') as f:
    # Afficher les données avec pandas
    df = pd.DataFrame(f['AD_NAVIGATION'][:], columns=f['AD_NAVIGATION'].attrs['columns'])
    print(df.head(10))  # Afficher les 10 premières lignes
    df = pd.DataFrame(f['Pressures'][:], columns=f['Pressures'].attrs['columns'])
    print(df.tail(10))  # Afficher les 10 dernières lignes