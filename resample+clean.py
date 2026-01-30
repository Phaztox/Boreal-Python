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
def detect_and_fill_outliers(data, column_idx=0, iqr_multiplier=1.5):
    """
    Detect outliers using IQR (Interquartile Range) method and fill them using linear interpolation.
    Values below Q1 - iqr_multiplier*IQR or above Q3 + iqr_multiplier*IQR are considered outliers.
    
    Parameters:
    -----------
    data : numpy array
        The data array with shape (n_samples, n_columns)
    column_idx : int or list of int
        The column index(es) to check for outliers. Can be a single int or a list of ints.
    iqr_multiplier : float
        Multiplier for IQR (default=1.5, use 3.0 for more conservative detection)
    
    Returns:
    --------
    cleaned_data : numpy array
        Data with outliers replaced by interpolated values
    outlier_masks : dict
        Dictionary mapping column indices to their boolean outlier masks
    """
    cleaned_data = data.copy()
    
    # Handle single column or multiple columns
    if isinstance(column_idx, int):
        column_indices = [column_idx]
    else:
        column_indices = list(column_idx)
    
    outlier_masks = {}
    
    for col_idx in column_indices:
        column_data = data[:, col_idx]

        # Calculate quartiles and IQR
        Q1 = np.percentile(column_data, 25)
        Q3 = np.percentile(column_data, 75)
        IQR = Q3 - Q1
        
        # Define outlier bounds
        lower_bound = Q1 - iqr_multiplier * IQR
        upper_bound = Q3 + iqr_multiplier * IQR
        
        # Identify outliers
        outlier_mask = (column_data < lower_bound) | (column_data > upper_bound)
        n_outliers = np.sum(outlier_mask)
        
        if n_outliers > 0:
            valid_indices = np.where(~outlier_mask)[0]
            valid_values = column_data[valid_indices]
            outlier_indices = np.where(outlier_mask)[0]
            interpolated_values = np.interp(outlier_indices, valid_indices, valid_values)
            
            cleaned_data[outlier_indices, col_idx] = interpolated_values
        
        outlier_masks[col_idx] = outlier_mask
    
    return cleaned_data, outlier_masks

def resample_and_clean_data(input_h5_file, offset1=0, offset2=0, offsetP1=0, offsetP2=0, output_dir=None):
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
                datasets[key] = data[offset1:len(data) - offset2]
            elif key=='Pressures':
                datasets[key]=data[offsetP1:len(data) - offsetP2]
            elif key=='TH':
                datasets[key]=data[offset1:len(data) - offset2]
            elif key=='T2':
                datasets[key]=data[offset1:len(data) - offset2]
            
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
        Resampled_ADnav_25to100 = np.zeros((num_samples_adnav, ADnav_short.shape[1]))
        for col in range(ADnav_short.shape[1]):
            Resampled_ADnav_25to100[:, col] = np.interp(time_adnav_tes, time_original, ADnav_short[:, col])

        # ============ Resample Pressures (1000Hz -> 100Hz) ============
        Pressures_1000hz = datasets['Pressures'][:,11:26]
        Pressures_100hz =np.zeros((len(Pressures_1000hz)//10, 15))
        for i in range(len(Pressures_1000hz)//10):
            Pressures_100hz[i, :] =np.mean(Pressures_1000hz[i*10:(i+1)*10,:], axis=0)
        Pressures_100hz[:, 14]=datasets['Pressures'][:-9:10, 27]  # 100hz column
        
        time_original_p=Pressures_100hz[:, 14]
        
        # Create uniform time grid
        t_start_p, t_end_p=time_original_p[0], time_original_p[-1]
        duration_ms_p=t_end_p-t_start_p+1
        num_samples_p=int(duration_ms_p) 
        time_p = np.linspace(t_start_p, t_end_p, num_samples_p)
        
        # Linear interpolation for each column
        Resampled_Pressures=np.zeros((num_samples_p, Pressures_100hz.shape[1]))
        for col in range(Pressures_100hz.shape[1]):
            Resampled_Pressures[:, col]=np.interp(time_p, time_original_p, Pressures_100hz[:, col])

        # ============ Resample Temparature Data ============
        # Resample TH
        TH_100hz=np.zeros((len(datasets['TH']), 3))
        for i in range(len(datasets['TH'])):
            TH_100hz[i, 0]=datasets['TH'][i, 5] 
            TH_100hz[i, 1]=datasets['TH'][i, 6] 
            TH_100hz[i, -1]=datasets['TH'][i, -1] 
        
        # Detect and fill outliers before resampling
        TH_100hz_clean, TH_outlier_mask = detect_and_fill_outliers(
            TH_100hz, 
            column_idx=[0, 1], 
            iqr_multiplier=1.0  # Adjust this: lower = more aggressive outlier detection
        )

        num_samples_TH=int(TH_100hz_clean[-1, -1]-TH_100hz_clean[0, -1])+1
        time_TH=np.linspace(TH_100hz_clean[0, -1], TH_100hz_clean[-1, -1], num_samples_TH)
        time_original_TH=TH_100hz_clean[:, -1]
        Resampled_TH=np.zeros((num_samples_TH, TH_100hz_clean.shape[1]))
        for col in range(TH_100hz_clean.shape[1]):
            Resampled_TH[:, col] = np.interp(time_TH, time_original_TH, TH_100hz_clean[:, col])

        # Resample T2
        T2_100hz=np.zeros((len(datasets['T2']), 2))
        for i in range(len(datasets['T2'])):
            T2_100hz[i, 0]=datasets['T2'][i, 2]  
            T2_100hz[i, -1]=datasets['T2'][i, -1] 
        
        # Detect and fill outliers before resampling
        T2_100hz_clean, T2_outlier_mask = detect_and_fill_outliers(
            T2_100hz, 
            column_idx=[0], 
            iqr_multiplier=1  # Adjust this: lower = more aggressive outlier detection
        )
        
        num_samples_T2=int(T2_100hz_clean[-1, -1]-T2_100hz_clean[0, -1])+1
        time_T2=np.linspace(T2_100hz_clean[0, -1], T2_100hz_clean[-1, -1], num_samples_T2)
        time_original_T2=T2_100hz_clean[:, -1]
        # Resample with interpolation
        Resampled_T2=np.zeros((num_samples_T2, T2_100hz_clean.shape[1]))
        for col in range(T2_100hz_clean.shape[1]):
            Resampled_T2[:, col] = np.interp(time_T2, time_original_T2, T2_100hz_clean[:, col])
        
        # ============ Save to HDF5 ============
        output_path = os.path.join(output_dir, output_filename)
        with h5py.File(output_path, 'w') as h5f_out:
            # Save ADnav
            h5f_out.create_dataset('Resampled_ADnav_25hzto100', data=Resampled_ADnav_25to100, compression="gzip", compression_opts=4)
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

            #Save TH data
            Resampled_TH_label = ['Temp1', 'Hum1', 'Time']
            h5f_out.create_dataset('Resampled_TH', data=Resampled_TH, compression="gzip", compression_opts=4)
            h5f_out.attrs['Resampled_TH_label'] = np.array(Resampled_TH_label, dtype='S')
            # Save T2 data
            Resampled_T2_label = ['Temp2', 'Time']
            h5f_out.create_dataset('Resampled_T2', data=Resampled_T2, compression="gzip", compression_opts=4)
            h5f_out.attrs['Resampled_T2_label'] = np.array(Resampled_T2_label, dtype='S')

        return Resampled_ADnav_25to100, Pressures_100hz, Resampled_Pressures, Resampled_TH, Resampled_T2

Resampled_ADnav_25to100, Pressures_100hz, Resampled_Pressures, Resampled_TH, Resampled_T2 = resample_and_clean_data("C:\\Users\\Antonin\\Desktop\\Project Results\\MomentaVol5_clean_extracted.h5", offset1=0, offset2=0, offsetP1=0, offsetP2=0, output_dir="Project Results")


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
plt.plot(Pressures_100hz[:, 2], label='Pressure1 5T', linewidth=0.5, color='blue')
plt.plot(Resampled_Pressures[:, 2], label='Resampled Pressure1 5T', linewidth=0.5, color='orange')
plt.title('Pressure1 5T - 100hz')
plt.xlabel("Time")
plt.ylabel("Pressure")
plt.legend()

# simple plot for resampled_ADnav_25to100 roll and Pitch columns
plt.figure(figsize=(12, 6))
plt.plot(Resampled_ADnav_25to100[:, 15], label='Roll', linewidth=0.5, color='green')
plt.plot(Resampled_ADnav_25to100[:, 16], label='Pitch', linewidth=0.5, color='red')
plt.title('Resampled ADnav 25Hz to 100Hz - Roll and Pitch Columns')
plt.xlabel("Time")
plt.ylabel("Value")
plt.legend()

# simple plot for the path of the flight using resampled_ADnav_25to100 Latitude and Longitude columns
plt.figure(figsize=(12, 6))
plt.plot(Resampled_ADnav_25to100[:, 5], Resampled_ADnav_25to100[:, 6], label='Flight Path', linewidth=0.5, color='purple')
plt.title('Flight Path using Latitude and Longitude')
plt.xlabel("Longitude")
plt.ylabel("Latitude")
plt.legend()

# simple plot for TH and T2 resampled data
plt.figure(figsize=(12, 6))
plt.plot(Resampled_TH[:, 0], label='Resampled TH Temp1', linewidth=0.5, color='brown')
plt.plot(Resampled_T2[:, 0], label='Resampled T2 Temp2', linewidth=0.5, color='orange')
plt.title('Resampled TH and T2 Temperature Data')
plt.xlabel("Time")
plt.ylabel("Temperature")
plt.legend()

# 3D plot for the 'Heading' label off the AD_NAVIGATION database (column 17).
# Since it's a heading consisting of angles from 0 to 360 degrees, we can plot it in a cylinder manner, the circle being the angle and the height being time.
from mpl_toolkits.mplot3d import Axes3D
fig = plt.figure(figsize=(12, 8))
ax = fig.add_subplot(111, projection='3d')
ax.set_title('3D Plot of Heading over Time')
ax.set_xlabel('Time')
ax.set_ylabel('Heading (degrees)')
ax.set_zlabel('Radius')

time_axis = np.arange(Resampled_ADnav_25to100.shape[0])
heading_angles = Resampled_ADnav_25to100[:, 17]  # Heading column
heading_angles = np.where(heading_angles == 360, 0, heading_angles)  # Replace 360 with 0

radius = 1  # Fixed radius for the cylinder
x = time_axis
y = radius * np.cos(np.radians(heading_angles))
z = radius * np.sin(np.radians(heading_angles))

ax.plot(x, y, z, label='Heading', linewidth=0.3)
ax.set_box_aspect([3, 1, 1])  # Stretch time axis
ax.legend()


plt.show()