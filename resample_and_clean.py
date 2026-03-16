"""
Utility functions for resampling and cleaning flight data after their extraction.
The goal is to get rid of NaN, infinite values, nulls, and to resample the data to a uniform time grid.
"""
import os
import numpy as np
import h5py
import time
from pathlib import Path

def checkpoint(name, checkpoints_dict):
    """Record a timing checkpoint"""
    current_time = time.time()
    if name in checkpoints_dict:
        elapsed = current_time - checkpoints_dict[name]
        print(f"  [OK] {name}: {elapsed:.2f}s")
    else:
        checkpoints_dict[name] = current_time
    return current_time

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

def resample_and_clean_data(input_h5_file, offset1=0, offset2=0, offsetP1=0, offsetP2=0, output_dir=None, progress_callback=None):
    # Initialize timing
    start_time = time.time()
    checkpoints = {}
    
    input_filename = Path(input_h5_file).stem  # Gets the filename without extension
    output_filename = f"Resampled_{input_filename}.h5"
    
    print(f"\n{'='*50}")
    print(f"Processing: {input_h5_file}")
    print(f"{'='*50}\n")
    
    print("[1/8] Loading HDF5 file and extracting datasets...")
    checkpoint_start = checkpoint("HDF5 load", checkpoints)
    
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
            elif key=='IMU':
                datasets[key]=data[offset1:len(data) - offset2]
            elif key=='MOTUSORI':
                datasets[key]=data[offset1:len(data) - offset2]
            elif key=='MOTUSRAW':
                datasets[key]=data[offsetP1:len(data) - offsetP2]
            
            # Try to get column names for this specific dataset
            label_key = f'{key}_label' if f'{key}_label' in h5f.attrs else f'{key}_LABEL'
            if label_key in h5f.attrs:
                columns = h5f.attrs[label_key]
                if isinstance(columns[0], bytes):
                    columns = [col.decode('utf-8') if isinstance(col, bytes) else col for col in columns]
                labels[key] = columns
    
    print(f"  [OK] HDF5 load: {time.time() - checkpoint_start:.2f}s")
        
    print("[2/8] Processing AD_NAVIGATION resampling (25Hz to 100Hz)...")
    checkpoint_start = checkpoint("AD_NAVIGATION resampling", checkpoints)
        
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
    Resampled_ADnav_25to100 = np.zeros((num_samples_adnav, ADnav_short.shape[1]), dtype=np.float64)
    for col in range(ADnav_short.shape[1]):
        Resampled_ADnav_25to100[:, col] = np.interp(time_adnav_tes, time_original, ADnav_short[:, col])
    
    Resampled_ADnav_25to100[:, :-2] = Resampled_ADnav_25to100[:, :-2].astype(np.float32)
    Resampled_ADnav_25to100[:, -1] = Resampled_ADnav_25to100[:, -1].astype(np.float32)

    print(f"  [OK] AD_NAVIGATION resampling: {time.time() - checkpoint_start:.2f}s")
    
    print("[3/8] Processing Pressures resampling (1000Hz to 100Hz)...")
    checkpoint_start = checkpoint("Pressures resampling", checkpoints)
        
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
    Resampled_Pressures=np.zeros((num_samples_p, Pressures_100hz.shape[1]), dtype=np.float32)
    for col in range(Pressures_100hz.shape[1]):
        Resampled_Pressures[:, col]=np.interp(time_p, time_original_p, Pressures_100hz[:, col])

    print(f"  [OK] Pressures resampling: {time.time() - checkpoint_start:.2f}s")
    
    print("[4/8] Processing Temperature data with outlier detection...")
    checkpoint_start = checkpoint("Temperature processing", checkpoints)
        
    # ============ Resample Temperature Data ============
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
    Resampled_TH=np.zeros((num_samples_TH, TH_100hz_clean.shape[1]), dtype=np.float32)
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
    Resampled_T2=np.zeros((num_samples_T2, T2_100hz_clean.shape[1]), dtype=np.float32)
    for col in range(T2_100hz_clean.shape[1]):
        Resampled_T2[:, col] = np.interp(time_T2, time_original_T2, T2_100hz_clean[:, col])
    
    print(f"  [OK] Temperature processing: {time.time() - checkpoint_start:.2f}s")
        
    print("[5/8] Processing IMU data with outlier detection and interpolation...")
    checkpoint_start = checkpoint("IMU processing", checkpoints)

    # ============ Resample IMU Data ===========
    IMU_100hz = np.zeros((len(datasets['IMU']), 16))
    for i in range(16):
        IMU_100hz[:, i] = datasets['IMU'][:, i]  
    
    # Remove duplicate timestamps (keep unique time values)
    IMU_100hz_unique=np.zeros((len(IMU_100hz), 16))
    IMU_100hz_unique[0,:]=IMU_100hz[0,:]
    k=1
    for i in range(1, len(IMU_100hz)):
        if IMU_100hz[i, -2] != IMU_100hz[i-1, -2]:  # If timestamp is different from previous
            IMU_100hz_unique[k,:]=IMU_100hz[i,:]
            k+=1
    IMU_100hz_unique=IMU_100hz_unique[:k, :]  # Keep only the filled rows

    num_samples_IMU=int(IMU_100hz_unique[-1, -1]-IMU_100hz_unique[0, -1])+1
    time_IMU=np.linspace(IMU_100hz_unique[0, -1], IMU_100hz_unique[-1, -1], num_samples_IMU)
    time_original_IMU=IMU_100hz_unique[:, -1]
    # Resample with interpolation
    Resampled_IMU=np.zeros((num_samples_IMU, IMU_100hz_unique.shape[1]), dtype=np.float64)
    for col in range(IMU_100hz_unique.shape[1]):
        Resampled_IMU[:, col] = np.interp(time_IMU, time_original_IMU, IMU_100hz_unique[:, col])
    
    Resampled_IMU[:, :-2] = Resampled_IMU[:, :-2].astype(np.float32)
    Resampled_IMU[:, -1] = Resampled_IMU[:, -1].astype(np.float32)
    
    print(f"  [OK] IMU processing: {time.time() - checkpoint_start:.2f}s")

    print("[6/8] Processing MOTUSORI data with outlier detection and interpolation...")
    checkpoint_start = checkpoint("MOTUSORI processing", checkpoints)

    # =========== Resample MOTUSORI Data ===========
    MOTUSORI_100hz = np.zeros((len(datasets['MOTUSORI']), 7))
    for i in range(7):
        MOTUSORI_100hz[:, i] = datasets['MOTUSORI'][:, i]
    # Remove duplicate timestamps (keep unique time values)
    MOTUSORI_100hz_unique=np.zeros((len(MOTUSORI_100hz), 7))
    MOTUSORI_100hz_unique[0,:]=MOTUSORI_100hz[0,:]
    k=1
    for i in range(1, len(MOTUSORI_100hz)):
        if MOTUSORI_100hz[i, -1] != MOTUSORI_100hz[i-1, -1]:  # If timestamp is different from previous
            MOTUSORI_100hz_unique[k,:]=MOTUSORI_100hz[i,:]
            k+=1
    MOTUSORI_100hz_unique=MOTUSORI_100hz_unique[:k, :]  # Keep only the filled rows

    # Remove outliers before resampling
    MOTUSORI_100hz_clean, MOTUSORI_outlier_mask = detect_and_fill_outliers(
        MOTUSORI_100hz_unique,
        column_idx=[1,2],  # All columns are numeric
        iqr_multiplier=2  # Adjust this: lower = more aggressive outlier detection
    )

    num_samples_MOTUSORI=int(MOTUSORI_100hz_clean[-1, -1]-MOTUSORI_100hz_clean[0, -1])+1
    time_MOTUSORI=np.linspace(MOTUSORI_100hz_clean[0, -1], MOTUSORI_100hz_clean[-1, -1], num_samples_MOTUSORI)
    time_original_MOTUSORI=MOTUSORI_100hz_clean[:, -1]
    # Resample with interpolation 
    Resampled_MOTUSORI=np.zeros((num_samples_MOTUSORI, MOTUSORI_100hz_clean.shape[1]), dtype=np.float64)
    for col in range(MOTUSORI_100hz_clean.shape[1]):
        Resampled_MOTUSORI[:, col] = np.interp(time_MOTUSORI, time_original_MOTUSORI, MOTUSORI_100hz_clean[:, col])
    
    # Optimize dtypes: convert all columns to float32 except column -2 
    Resampled_MOTUSORI[:, :-2] = Resampled_MOTUSORI[:, :-2].astype(np.float32)
    Resampled_MOTUSORI[:, -1] = Resampled_MOTUSORI[:, -1].astype(np.float32)

    print(f"  [OK] MOTUSORI processing: {time.time() - checkpoint_start:.2f}s")

    print("[7/8] Processing MOTUSRAW data with outlier detection and interpolation...")
    checkpoint_start = checkpoint("MOTUSRAW processing", checkpoints)
    # =========== Resample MOTUSRAW Data ===========
    """
    Most of MOTUSRAW's data are recorded at 1000Hz, but some of them are recorded at 100Hz. 
    We will split the data into two groups, data at 1000Hz that we'll keep at 1000Hz and data at 100Hz that we'll resample to 1000Hz. 
    Data recorded at 1000Hz are "Xaccl", "Yaccl", "Zaccl", "Xgyro", "Ygyro", "Zgyro", "QuadSum".
    Data recorded at 100Hz are "Time", "Xmagn", "Ymagn", "Zmagn", "Compteur100hz".
    "Barometer" (index 11), "TemperaturePressure" (index 12) are empty columns that we will ignore. "TemperatureIMU" (index 10) contains very dirty data that we will also ignore. "TSmilli" (index 14) is recorded at 16.67Hz and is not useful for our analysis, so we will ignore it as well. "Secondes" (index 13) is recorded at 1Hz and is not useful for our analysis, so we will ignore it as well.
    """
    MOTUSRAW_labels = [label for i, label in enumerate(labels['MOTUSRAW']) if i not in [10, 11, 12, 13, 14]]  # Crate label copy excluding index 10, 11, 12, 13, 14

    # Split groups 1000Hz / 100Hz
    MOTUSRAW_1000hz = np.zeros((len(datasets['MOTUSRAW']), 8))
    MOTUSRAW_100hz = np.zeros((len(datasets['MOTUSRAW'])//10, 5))
    for i in range(len(datasets['MOTUSRAW'])):
        MOTUSRAW_1000hz[i, :] = datasets['MOTUSRAW'][i, [1, 2, 3, 4, 5, 6, -2, -1]]  # Xaccl, Yaccl, Zaccl, Xgyro, Ygyro, Zgyro, QuadSum, Compteur100hz (duplicate used for interp)
    for i in range(len(datasets['MOTUSRAW'])//10):
        MOTUSRAW_100hz[i, :] = datasets['MOTUSRAW'][i*10, [0, 7, 8, 9, -1]]  # Time, Xmagn, Ymagn, Zmagn, Compteur100hz
            
    time_original_MOTUSRAW_100Hz=MOTUSRAW_100hz[:, -1]
    time_original_MOTUSRAW_1000hz=MOTUSRAW_1000hz[:, -1]
    
    # Create uniform time grid
    t_start_p, t_end_p=time_original_MOTUSRAW_100Hz[0], time_original_MOTUSRAW_100Hz[-1]
    duration_ms_p=t_end_p-t_start_p+1
    num_samples_p=int(duration_ms_p) 
    time_p = np.linspace(t_start_p, t_end_p, num_samples_p*10)

    # Remove outliers of the 1000Hz group before resampling
    MOTUSRAW_1000hz_clean, MOTUSRAW_1000hz_outlier_mask = detect_and_fill_outliers(
        MOTUSRAW_1000hz,
        column_idx=[0,1,2,3,4,5,6,7],
        iqr_multiplier=3  # Adjust this: lower = more aggressive outlier detection
    )

    # Linear interpolation for each column of the 1000Hz group at 1000Hz timestamps
    Resampled_MOTUSRAW_1000hz=np.zeros((num_samples_p*10, MOTUSRAW_1000hz_clean.shape[1]))
    for col in range(MOTUSRAW_1000hz_clean.shape[1]):
        Resampled_MOTUSRAW_1000hz[:, col]=np.interp(time_p, time_original_MOTUSRAW_1000hz, MOTUSRAW_1000hz_clean[:, col])

    # Remove outliers before resampling
    MOTUSRAW_100hz_clean, MOTUSRAW_100hz_outlier_mask = detect_and_fill_outliers(
        MOTUSRAW_100hz,
        column_idx=[0, 1, 2, 3, 4],
        iqr_multiplier=3.0  # Adjust threshold as needed
    )
    
    # Linear interpolation for each column of the 100Hz group at 1000Hz timestamps
    Resampled_MOTUSRAW_100hzto1000hz=np.zeros((num_samples_p*10, MOTUSRAW_100hz_clean.shape[1]))
    for col in range(MOTUSRAW_100hz_clean.shape[1]):
        Resampled_MOTUSRAW_100hzto1000hz[:, col]=np.interp(time_p, time_original_MOTUSRAW_100Hz, MOTUSRAW_100hz_clean[:, col])

    # Combine the cleaned 1000Hz data with the resampled 100Hz data (after aligning them on the same time grid)
    Resampled_MOTUSRAW=np.zeros((num_samples_p*10, MOTUSRAW_1000hz_clean.shape[1]+MOTUSRAW_100hz_clean.shape[1]-1), dtype=np.float32)  # -1 because Compteur100hz is duplicated
    Resampled_MOTUSRAW[:, 0]=Resampled_MOTUSRAW_100hzto1000hz[:, 0]  
    Resampled_MOTUSRAW[:, 1:7]=Resampled_MOTUSRAW_1000hz[:, :6]
    Resampled_MOTUSRAW[:, 7:-2]=Resampled_MOTUSRAW_100hzto1000hz[:, 1:-1]
    Resampled_MOTUSRAW[:, -2]=Resampled_MOTUSRAW_1000hz[:, -2]
    Resampled_MOTUSRAW[:, -1]=Resampled_MOTUSRAW_100hzto1000hz[:, -1]

    print(f"  [OK] MOTUSRAW processing: {time.time() - checkpoint_start:.2f}s")

    print("[8/8] Saving resampled data to HDF5 file...")
    checkpoint_start = checkpoint("HDF5 save", checkpoints)
        
    # ============ Save to HDF5 ============
    output_path = os.path.join(output_dir, output_filename)
    with h5py.File(output_path, 'w') as h5f_out:
        # Save ADnav
        h5f_out.create_dataset('Resampled_ADnav_25hzto100', data=Resampled_ADnav_25to100, compression="gzip", compression_opts=4)
        h5f_out.attrs['Resampled_ADnav_25hzto100_label'] = np.array(labels['AD_NAVIGATION'], dtype='S')

        # Save Pressures
        Resampled_Pressures_label = ['Baro1 HCEM STAT', 'Baro2 HCEM STAT', 'Pressure1HCE2 Sonde 5T', 'Pressure2HCE3 Sonde 5T', 'Pressure3HCE4 Pitot', 'Pressure4HCE5 Pitot', 'Pressure5HCE10 HAUT-BAS', 'Pressure6HCE10 HAUT-BAS', 'Pressure7HCE10 GAUCHE-DROITE', 'Pressure8HCE10 GAUCHE-DROITE', 'LDE1 HAUT-BAS BRUT', 'LDE2 GAUCHE-DROITE BRUT', 'LDE1 HAUT-BAS', 'LDE2 GAUCHE-DROITE', '100Hz Time']
        h5f_out.create_dataset('Resampled_Pressures', data=Resampled_Pressures, compression="gzip", compression_opts=4)
        h5f_out.attrs['Resampled_Pressures_label'] = np.array(Resampled_Pressures_label, dtype='S')
        #Save TH data
        Resampled_TH_label = ['Temp1', 'Hum1', 'Time']
        h5f_out.create_dataset('Resampled_TH', data=Resampled_TH, compression="gzip", compression_opts=4)
        h5f_out.attrs['Resampled_TH_label'] = np.array(Resampled_TH_label, dtype='S')
        # Save T2 data
        Resampled_T2_label = ['Temp2', 'Time']
        h5f_out.create_dataset('Resampled_T2', data=Resampled_T2, compression="gzip", compression_opts=4)
        h5f_out.attrs['Resampled_T2_label'] = np.array(Resampled_T2_label, dtype='S')

        # Save IMU data
        h5f_out.create_dataset('Resampled_IMU', data=Resampled_IMU, compression="gzip", compression_opts=4)
        h5f_out.attrs['Resampled_IMU_label'] = np.array(labels['IMU'], dtype='S')

        # Save MOTUSORI data with mixed precision (float32 for most, float64 for column -2)
        h5f_out.create_dataset('Resampled_MOTUSORI', data=Resampled_MOTUSORI, compression="gzip", compression_opts=4)
        h5f_out.attrs['Resampled_MOTUSORI_label'] = np.array(labels['MOTUSORI'], dtype='S')

        # Save MOTUSRAW data
        h5f_out.create_dataset('Resampled_MOTUSRAW', data=Resampled_MOTUSRAW, compression="gzip", compression_opts=4)
        h5f_out.attrs['Resampled_MOTUSRAW_label'] = np.array(MOTUSRAW_labels, dtype='S')
    
    print(f"  [OK] HDF5 save: {time.time() - checkpoint_start:.2f}s")
    
    total_time = time.time() - start_time
    print(f"\n{'='*50}")
    print(f"Processing completed successfully!")
    print(f"Output file: {output_path}")
    print(f"Total processing time: {total_time:.2f}s")
    print(f"{'='*50}\n")

    return output_path

