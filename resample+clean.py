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

def resample_and_clean_data(input_h5_file, offset1=0, offset2=0, output_dir=None):
    input_filename = Path(input_h5_file).stem  # Gets the filename without extension
    output_filename = f"Resampled_{input_filename}.h5"
    with h5py.File(input_h5_file, 'r') as h5f:
        # Find datasets and their labels
        datasets = {}
        labels = {}
        
        for key in h5f.keys():
            # Get the data
            data = h5f[key][:]
            datasets[key] = data[offset1:len(data) - offset2]
            
            # Try to get column names for this specific dataset
            label_key = f'{key}_label' if f'{key}_label' in h5f.attrs else f'{key}_LABEL'
            if label_key in h5f.attrs:
                columns = h5f.attrs[label_key]
                if isinstance(columns[0], bytes):
                    columns = [col.decode('utf-8') if isinstance(col, bytes) else col for col in columns]
                labels[key] = columns
        
        # Resample AD_NAVIGATION 
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
        time_resampled = np.linspace(time_original[0], time_original[-1], len(datasets['AD_NAVIGATION']))

        resampled_ADnav_25to100 = np.zeros((len(time_resampled), ADnav_short.shape[1]))
        for col in range(ADnav_short.shape[1]):
            resampled_ADnav_25to100[:, col] = np.interp(time_resampled, time_original, ADnav_short[:, col])
        time_adnav_tes = time_resampled

        """# Interpolate roll angle using circular interpolation
        roll_angle = ADnav_short[:, 15]
        cos_roll = np.cos(np.radians(roll_angle))
        sin_roll = np.sin(np.radians(roll_angle))
        x_roll = np.interp(time_resampled, time_original, cos_roll)
        y_roll = np.interp(time_resampled, time_original, sin_roll)
        resampled_ADnav_25to100[:, 15] = np.degrees(np.arctan2(y_roll, x_roll))

        # Interpolate pitch angle using circular interpolation
        pitch_angle = ADnav_short[:, 16]
        cos_pitch = np.cos(np.radians(pitch_angle))
        sin_pitch = np.sin(np.radians(pitch_angle))
        x_pitch = np.interp(time_resampled, time_original, cos_pitch)
        y_pitch = np.interp(time_resampled, time_original, sin_pitch)
        resampled_ADnav_25to100[:, 16] = np.degrees(np.arctan2(y_pitch, x_pitch))"""
        
        # save it as an h5 file
        output_path = os.path.join(output_dir, output_filename)
        with h5py.File(output_path, 'w') as h5f_out:
            h5f_out.create_dataset('Resampled_ADnav_25hzto100', data=resampled_ADnav_25to100, compression="gzip", compression_opts=4)
            h5f_out.create_dataset('time_adnav_tes', data=time_adnav_tes, compression="gzip", compression_opts=4)
            
            # Store column labels as attributes
            h5f_out.attrs['Resampled_ADnav_25hzto100_label'] = np.array(labels['AD_NAVIGATION'], dtype='S')
            h5f_out.attrs['time_adnav_tes_label'] = np.array(['Time'], dtype='S')

        return 

resample_and_clean_data("C:\\Users\\Antonin\\Desktop\\Project Results\\MomentaVol5_clean_extracted.h5", offset1=0, offset2=0, output_dir="C:\\Users\\Antonin\\Desktop\\Project Results")


# Display settings for pandas
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth', None)

"""
for key in data:
    print(f"Dataset: {key}")
    print(f"Shape: {data[key].shape}")
    print("\nFirst 5 rows:")
    print(pd.DataFrame(data[key][:5], columns=labels[key]))
    print("\nLast 5 rows:")
    print(pd.DataFrame(data[key][-5:], columns=labels[key]))
    print("\n" + "="*80 + "\n")"""