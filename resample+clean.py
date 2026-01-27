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
from scipy.interpolate import interp1d
from scipy.signal import resample
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
            if key == 'AD_NAVIGATION':
                datasets[key] = data[offsetAD1:len(data) - offsetAD2]
            elif key == 'Pressures':
                datasets[key] = data[offsetP1:len(data) - offsetP2]
            
            # Try to get column names for this specific dataset
            label_key = f'{key}_label' if f'{key}_label' in h5f.attrs else f'{key}_LABEL'
            if label_key in h5f.attrs:
                columns = h5f.attrs[label_key]
                if isinstance(columns[0], bytes):
                    columns = [col.decode('utf-8') if isinstance(col, bytes) else col for col in columns]
                labels[key] = columns
        
        # Interpolate for AD_NAVIGATION 
        ADnav_short = np.zeros((len(datasets['AD_NAVIGATION']),27))
        k=0
        for i in range(len(datasets['AD_NAVIGATION'])-1):
            if datasets['AD_NAVIGATION'][i,25]==datasets['AD_NAVIGATION'][i+1,25]:
                ADnav_short[k,:]=datasets['AD_NAVIGATION'][i,:]
            else :
                ADnav_short[k+1,:]=datasets['AD_NAVIGATION'][i+1,:] 
                k+=1
        # Remove rows that are exclusively filled with 0s
        ADnav_short = ADnav_short[~np.all(ADnav_short == 0, axis=1)]

        # Interpolation process - interpolate back to original data length
        # This fills in values where there were duplicates due to sensor refresh rate
        time_original = ADnav_short[:, 25]
        
        # Create uniform time grid with same length as original AD_NAVIGATION
        adjust=0
        for i in datasets['AD_NAVIGATION'][-12:, 25]:
            if i==ADnav_short[-1,25]:
                adjust+=1
        time_resampled = np.linspace(time_original[0], time_original[-1], len(datasets['AD_NAVIGATION'])-7)

        resampled_ADnav_25to100 = np.zeros((len(time_resampled), ADnav_short.shape[1]))
        for col in range(ADnav_short.shape[1]):
            resampled_ADnav_25to100[:, col] = np.interp(time_resampled, time_original, ADnav_short[:, col])
        time_adnav_tes = time_resampled

        # Interpolate for Pressures
        Pressures_1000hz = datasets['Pressures'][:,11:26]
        Pressures_100hz = np.zeros((len(Pressures_1000hz)//10, 15))
        for i in range(len(Pressures_1000hz)//10):
            Pressures_100hz[i,:] = np.mean(Pressures_1000hz[i*10:(i+1)*10,:], axis=0)
        Pressures_100hz[:,14] = datasets['Pressures'][:-9:10, 26]  # TSmilli column
        
        # Use scipy.signal.resample - applies anti-aliasing filter like MATLAB
        # Resample to uniform grid based on timestamps
        time_original_p = Pressures_100hz[:, 14]
        
        # Calculate target number of samples for uniform 100Hz (10ms intervals)
        t_start, t_end = time_original_p[0], time_original_p[-1]
        duration_ms = t_end - t_start
        num_samples = int(duration_ms / 10)  # 10ms interval = 100Hz
        
        # scipy.signal.resample: resamples to num_samples with anti-aliasing filter
        Resampled_Pressures, time_p = resample(Pressures_100hz, num_samples, t=time_original_p)
        
        # save it as an h5 file
        output_path = os.path.join(output_dir, output_filename)
        with h5py.File(output_path, 'w') as h5f_out:
            h5f_out.create_dataset('Resampled_ADnav_25hzto100', data=resampled_ADnav_25to100, compression="gzip", compression_opts=4)
            h5f_out.create_dataset('time_adnav_tes', data=time_adnav_tes, compression="gzip", compression_opts=4)
            
            # Store column labels as attributes
            h5f_out.attrs['Resampled_ADnav_25hzto100_label'] = np.array(labels['AD_NAVIGATION'], dtype='S')
            h5f_out.attrs['time_adnav_tes_label'] = np.array(['Time'], dtype='S')

            # also save the ADnav_short for reference
            h5f_out.create_dataset('ADnav_short', data=ADnav_short, compression="gzip", compression_opts=4)
            h5f_out.attrs['ADnav_short_label'] = np.array(labels['AD_NAVIGATION'], dtype='S')

            # Save Pressures
            Resampled_Pressures_label=['Baro1 HCEM STAT','Baro2 HCEM STAT','Pressure1HCE2 Sonde 5T','Pressure2HCE3 Sonde 5T','Pressure3HCE4 Pitot','Pressure4HCE5 Pitot','Pressure5HCE10 HAUT-BAS','Pressure6HCE10 HAUT-BAS','Pressure7HCE10 GAUCHE-DROITE','Pressure8HCE10 GAUCHE-DROITE','LDE1 HAUT-BAS BRUT','LDE2 GAUCHE-DROITE BRUT','LDE1 HAUT-BAS','LDE2 GAUCHE-DROITE','TSmilli']   
            h5f_out.create_dataset('Resampled_Pressures', data=Resampled_Pressures, compression="gzip", compression_opts=4)
            h5f_out.create_dataset('time_pressures', data=time_p, compression="gzip", compression_opts=4)
            h5f_out.attrs['Resampled_Pressures_label'] = np.array(Resampled_Pressures_label, dtype='S')
            h5f_out.attrs['time_pressures_label'] = np.array(['Time'], dtype='S')
            h5f_out.create_dataset('Pressures_100hz', data=Pressures_100hz, compression="gzip", compression_opts=4)
            h5f_out.attrs['Pressures_100hz_label'] = np.array(Resampled_Pressures_label, dtype='S')

        return Pressures_100hz, Resampled_Pressures

a, b = resample_and_clean_data("C:\\Users\\Antonin\\Desktop\\Project Results\\MomentaVol5_clean_extracted.h5", offsetAD1=0, offsetAD2=670927,offsetP1=90, offsetP2=6709243, output_dir="C:\\Users\\Antonin\\Desktop\\Project Results")

# simple plot for Pressure_100hz and Resampled_Pressures on the same plot, using thin lines
plt.figure(figsize=(12, 6))
plt.plot(a[:, 3], label='Pressure1 5T - 100hz (original)', linewidth=0.5, color='blue')
plt.plot(b[:, 3], label='Resampled Pressure1 5T (filtered)', linewidth=0.5, color='orange')
plt.title('Pressure1 5T - 100hz')
plt.xlabel("Time")
plt.ylabel("Pressure")
plt.legend()
plt.show()