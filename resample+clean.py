"""
Utility functions for resampling and cleaning flight data after their extraction.
The goal is to get rid of NaN, infinite values, nulls, and to resample the data to a uniform time grid.
"""
# the file reference for this one is 'Resample_ADnav.m' from the MATLAB codebase.

import os
import pandas as pd
import numpy as np
import h5py
from pathlib import Path
from scipy.signal import resample, resample_poly
import matplotlib.pyplot as plt

def resample_and_clean_data(input_h5_file, offsetAD1=0, offsetAD2=0, offsetP1=0, offsetP2=0, output_dir=None):
    input_filename = Path(input_h5_file).stem  # Gets the filename without extension
    output_filename = f"Resampled_{input_filename}.h5"
    with h5py.File(input_h5_file, 'r') as h5f:
        # Find datasets and their labels
        datasets = {}
        labels = {}
        
        for key in h5f.keys():
            # Get the data
            data = h5f[key][:]
            if key=='AD_NAVIGATION':
                datasets[key] = data[offsetAD1:len(data) - offsetAD2]
            elif key=='Pressures':
                datasets[key]=data[offsetP1:len(data) - offsetP2]
            
            # Try to get column names for this specific dataset
            label_key = f'{key}_label' if f'{key}_label' in h5f.attrs else f'{key}_LABEL'
            if label_key in h5f.attrs:
                columns = h5f.attrs[label_key]
                if isinstance(columns[0], bytes):
                    columns = [col.decode('utf-8') if isinstance(col, bytes) else col for col in columns]
                labels[key] = columns
        
        # ============ Resample AD_NAVIGATION (25Hz to 100Hz) ============
        # First, remove duplicate timestamps (keep unique time values)
        ADnav_short=np.zeros((len(datasets['AD_NAVIGATION']), 27))
        ADnav_short[0,:]=datasets['AD_NAVIGATION'][0,:]
        k=1
        for i in range(1,len(datasets['AD_NAVIGATION'])):
            if datasets['AD_NAVIGATION'][i, 25] == ADnav_short[k-1, 25]:
                continue
            else:
                ADnav_short[k,:]=datasets['AD_NAVIGATION'][i,:]
                k+=1
        # Remove rows that are exclusively filled with 0s
        ADnav_short=ADnav_short[~np.all(ADnav_short==0, axis=1)]

        time_original =ADnav_short[:, 26]  # 100Hz column
        
        # Create uniform time grid at 100Hz (10ms intervals)
        t_start, t_end = time_original[0], time_original[-1]
        duration_ms = t_end-t_start+1
        num_samples_adnav = int(duration_ms) 
        time_adnav_tes = np.linspace(t_start, t_end, num_samples_adnav)
        
        # Linear interpolation for each column
        resampled_ADnav_25to100 = np.zeros((num_samples_adnav, ADnav_short.shape[1]))
        for col in range(ADnav_short.shape[1]):
            resampled_ADnav_25to100[:, col] = np.interp(time_adnav_tes, time_original, ADnav_short[:, col])

        # ============ Resample Pressures (1000Hz -> 100Hz) ============
        Pressures_1000hz = datasets['Pressures'][:,11:26]
        Pressures_100hz =np.zeros((len(Pressures_1000hz)//10, 15))
        for i in range(len(Pressures_1000hz)//10):
            Pressures_100hz[i, :] =np.mean(Pressures_1000hz[i*10:(i+1)*10,:], axis=0)
        Pressures_100hz[:, 14]=datasets['Pressures'][:-9:10, 27]  # 100hz column
        
        time_original_p=Pressures_100hz[:, 14]
        
        # Create uniform time grid
        t_start_p, t_end_p=time_original_p[0], time_original_p[-1]
        duration_ms_p=t_end_p-t_start_p
        num_samples_p=int(duration_ms_p) 
        time_p = np.linspace(t_start_p, t_end_p, num_samples_p)
        
        # Linear interpolation for each column
        Resampled_Pressures=np.zeros((num_samples_p, Pressures_100hz.shape[1]))
        for col in range(Pressures_100hz.shape[1]):
            Resampled_Pressures[:, col]=np.interp(time_p, time_original_p, Pressures_100hz[:, col])
        
        # ============ Save to HDF5 ============
        output_path = os.path.join(output_dir, output_filename)
        with h5py.File(output_path, 'w') as h5f_out:
            # Save ADnav
            h5f_out.create_dataset('Resampled_ADnav_25hzto100', data=resampled_ADnav_25to100, compression="gzip", compression_opts=4)
            h5f_out.create_dataset('time_adnav_tes', data=time_adnav_tes, compression="gzip", compression_opts=4)
            h5f_out.attrs['Resampled_ADnav_25hzto100_label'] = np.array(labels['AD_NAVIGATION'], dtype='S')
            h5f_out.attrs['time_adnav_tes_label'] = np.array(['Time'], dtype='S')
            # also save the ADnav_short for reference
            h5f_out.create_dataset('ADnav_short', data=ADnav_short, compression="gzip", compression_opts=4)
            h5f_out.attrs['ADnav_short_label'] = np.array(labels['AD_NAVIGATION'], dtype='S')

            # Save Pressures
            Resampled_Pressures_label = ['Baro1 HCEM STAT', 'Baro2 HCEM STAT', 'Pressure1HCE2 Sonde 5T', 'Pressure2HCE3 Sonde 5T', 'Pressure3HCE4 Pitot', 'Pressure4HCE5 Pitot', 'Pressure5HCE10 HAUT-BAS', 'Pressure6HCE10 HAUT-BAS', 'Pressure7HCE10 GAUCHE-DROITE', 'Pressure8HCE10 GAUCHE-DROITE', 'LDE1 HAUT-BAS BRUT', 'LDE2 GAUCHE-DROITE BRUT', 'LDE1 HAUT-BAS', 'LDE2 GAUCHE-DROITE', '100Hz Time']
            h5f_out.create_dataset('Resampled_Pressures', data=Resampled_Pressures, compression="gzip", compression_opts=4)
            h5f_out.create_dataset('time_pressures', data=time_p, compression="gzip", compression_opts=4)
            h5f_out.attrs['Resampled_Pressures_label'] = np.array(Resampled_Pressures_label, dtype='S')
            h5f_out.attrs['time_pressures_label'] = np.array(['Time'], dtype='S')
            # also save the original Pressures_100hz for reference
            h5f_out.create_dataset('Pressures_100hz', data=Pressures_100hz, compression="gzip", compression_opts=4)
            h5f_out.attrs['Pressures_100hz_label'] = np.array(Resampled_Pressures_label, dtype='S')

        return Pressures_100hz, Resampled_Pressures, resampled_ADnav_25to100

a, b, c = resample_and_clean_data("C:\\Users\\Antonin\\Desktop\\Project Results\\MomentaVol5_clean_extracted.h5", offsetAD1=0, offsetAD2=0, offsetP1=0, offsetP2=0, output_dir="C:\\Users\\Antonin\\Desktop\\Project Results")


with h5py.File("C:\\Users\\Antonin\\Desktop\\Project Results\\MomentaVol5_clean_extracted.h5", 'r') as h5f_test:
    colonne_time=-1
    start_time=h5f_test['AD_NAVIGATION'][0,colonne_time]
    end_time=h5f_test['AD_NAVIGATION'][-1,colonne_time]
    print(f"La taille est: {len(h5f_test['AD_NAVIGATION'][:,colonne_time])}")
    print(f"Première valeur de la colonne time: {round(start_time)}"+f"\nDernière valeur de la colonne time: {round(end_time)}"+f"\nDifférence: {round((end_time-start_time)/1)}")
    print(f"Nombre de valeurs manquantes: {round((end_time-start_time)/1)-len(h5f_test['AD_NAVIGATION'][:,colonne_time])}")
    val_missing=[]
    ad_nav_times = h5f_test['AD_NAVIGATION'][:, colonne_time]
    for i in range(len(ad_nav_times) - 1):
        if ad_nav_times[i+1] - ad_nav_times[i] != 1:
            val_missing.append(i)
    print(f"Indices des valeurs manquantes: {val_missing}")
    print(f"Nombre de valeurs manquantes détectées: {len(val_missing)}")


# simple plot for Pressure_100hz and Resampled_Pressures on the same plot
plt.figure(figsize=(12, 6))
plt.plot(a[:, 2], label='Pressure1 5T', linewidth=0.5, color='blue')
plt.plot(b[:, 2], label='Resampled Pressure1 5T', linewidth=0.5, color='orange')
plt.title('Pressure1 5T - 100hz')
plt.xlabel("Time")
plt.ylabel("Pressure")
plt.legend()

# simple plot for resampled_ADnav_25to100 roll and Pitch columns
plt.figure(figsize=(12, 6))
plt.plot(c[:, 15], label='Roll', linewidth=0.5, color='green')
plt.plot(c[:, 16], label='Pitch', linewidth=0.5, color='red')
plt.title('Resampled ADnav 25Hz to 100Hz - Roll and Pitch Columns')
plt.xlabel("Time")
plt.ylabel("Value")
plt.legend()

# simple plot for the path of the flight using resampled_ADnav_25to100 Latitude and Longitude columns
plt.figure(figsize=(12, 6))
plt.plot(c[:, 5], c[:, 6], label='Flight Path', linewidth=0.5, color='purple')
plt.title('Flight Path using Latitude and Longitude')
plt.xlabel("Longitude")
plt.ylabel("Latitude")
plt.legend()

plt.show()