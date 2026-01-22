"""
Utility functions for resampling and cleaning flight data after their extraction.
The goal is to get rid of NaN, infinite values, nulls, and to resample the data to a uniform time grid.
"""
# the file reference for this one is 'Resample_ADnav.m' from the MATLAB codebase.

import pandas as pd
import numpy as np
import h5py 

def resample_and_clean_data(input_h5_file, offset1=0, offset2=0):
    with h5py.File(input_h5_file, 'r') as h5f:
        # Find datasets and their labels
        datasets = {}
        all_columns = {}
        
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
                all_columns[key] = columns
        
        return datasets, all_columns 


data, labels = resample_and_clean_data("C:\\Users\\Antonin\\Desktop\\Project Results\\MomentaVol5_clean_extracted.h5", offset1=0, offset2=0)

# Display settings for pandas
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth', None)

for key in data:
    print(f"Dataset: {key}")
    print(f"Shape: {data[key].shape}")
    print("\nFirst 5 rows:")
    print(pd.DataFrame(data[key][:5], columns=labels[key]))
    print("\nLast 5 rows:")
    print(pd.DataFrame(data[key][-5:], columns=labels[key]))
    print("\n" + "="*80 + "\n")