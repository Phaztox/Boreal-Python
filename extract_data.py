import numpy as np
from scipy.io import savemat
import struct
from scipy.io import loadmat
import h5py
import pandas as pd
import os
import time
import warnings
from pathlib import Path

# Suppress warnings about invalid values in casting/arithmetic operations
# These occur naturally when byte patterns don't represent valid floats, but the script handles it
warnings.filterwarnings('ignore', category=RuntimeWarning, message='.*invalid value.*')
warnings.filterwarnings('ignore', category=RuntimeWarning, message='.*overflow.*')

def checkpoint(name, checkpoints_dict):
    """Record a timing checkpoint"""
    current_time = time.time()
    if name in checkpoints_dict:
        elapsed = current_time - checkpoints_dict[name]
        print(f"  [OK] {name}: {elapsed:.2f}s")
    else:
        checkpoints_dict[name] = current_time
        print(f"  [*] {name}...")
    return current_time

def load_binary_data(file_path, offset1, offset2):
    """Load binary file and return matrix and line count"""
    data = np.memmap(file_path, dtype=np.uint8, mode='r')
    total_lines = data.size // 1024
    # remove lines where the first two colomns are not 00 
    # valid_lines = [i for i in range(total_lines) if data[i*1024] == 0 and data[i*1024+1] == 0]
    line_count = total_lines - (offset1 + offset2)
    if line_count <= 0:
        raise ValueError("Offsets too large for file size")
    start = offset1 * 1024
    end = start + line_count * 1024
    matrix = data[start:end].reshape((line_count, 1024))
    # remove lines filed with FF (255)
    matrix = matrix[~np.all(matrix == 255, axis=1)]
    line_count = matrix.shape[0]
    return matrix, line_count


def extract_flight_data(bin_file_path, offset1=1, offset2=0, output_dir='resultats_test'):
    """
    Extract flight data from binary file and save to HDF5 format.
    
    Args:
        bin_file_path (str): Path to the binary file
        offset1 (int): Number of lines to skip at the beginning (default: 1)
        offset2 (int): Number of lines to skip at the end (default: 0)
        output_dir (str): Output directory for the HDF5 file (default: 'resultats_test')
    
    Returns:
        str: Path to the output HDF5 file
    """
    # Initialize timing
    start_time = time.time()
    checkpoints = {}
    
    # Get input filename without extension for output naming
    input_filename = Path(bin_file_path).stem  # Gets the filename without extension
    output_filename = f"{input_filename}_extracted.h5"
    
    print(f"\n{'='*50}")
    print(f"Processing: {bin_file_path}")
    print(f"{'='*50}\n")
    
    print("[1/6] Loading binary file...")
    checkpoint_start = checkpoint("Binary load", checkpoints)
    
    matrix, line_count = load_binary_data(bin_file_path, offset1, offset2)
    
    print(f"  [OK] Binary load: {time.time() - checkpoint_start:.2f}s")
    
    # creation des tables et de celles de 'label'
    AD_NAVIGATION_LABEL = ['Time','SystStatus','FilterStatus','Unixtime','MicroSecondes','Latitude(Rad)',
                        'Longitude(Rad)','Height','VitesseNord','VitesseEast','VitesseDown',
                        'Acceleration_X','Acceleration_Y','Acceleration_Z','G','Roll','Pitch','Heading',
                        'AngularVelocity_X','AngularVelocity_Y','AngularVelocity_Z','LatitudeStandardDeviation',
                        'LongitudeStandardDeviation','HeightStandardDeviation','Secondes','TSmilli','Compteur100hz']
    AD_NAVIGATION = np.zeros((line_count, len(AD_NAVIGATION_LABEL)))

    PaquetAirData_label=['Time','BaroRetard(s)','AirSpeedRetard(s)','BaroAltitude(m)','AirSpeed(m/s)',
                            'BaroStandardDeviation(m)','AirSpeedStandardDeviation(m/s)','StatusAirData','Secondes','TSmilli','Compteur100hz']
    PaquetAirData = np.zeros((line_count,len(PaquetAirData_label)))
    PaquetWind_label=['Time','WindVelocityNorth(m/s)','WindVelocityEast(m/s)',
                        'WindVelocityStandardDeviation(m/s)','Secondes','TSmilli','Compteur100hz']
    PaquetWind = np.zeros((line_count,len(PaquetWind_label)))

    AirDataSensors_label=['Time','AbsolutePressure(Pa)','DifferentialPressure(Pa)',
                            'FlagsRawStatus','Temperature(c)','Secondes','TSmilli','Compteur100hz']
    AirDataSensors = np.zeros((line_count,len(AirDataSensors_label)))

    IMU_label = ['Time','Xaccl', 'Yaccl', 'Zaccl','Xgyro', 'Ygyro', 'Zgyro', 'Xmagn', 'Ymagn', 
                    'Zmagn', 'TemperatureIMU','Barometer','TemperaturePressure','Secondes','TSmilli','Compteur100hz']
    IMU = np.zeros((line_count,len(IMU_label)))

    Pattern_label = ['Time','AA','BB', 'CC','DD','EE','AA','22','22','33','33','44','44','55','55','66',
                        '66','77','77','88','88','99','99','AA','AA','C0','01','C5','12','C1','00','BB','BB',
                        'AC','C2','AC','C3','AC','C4','AC','C5','AC','C6','AC','C7','AC','C8','AC','C9','AC','CA','AB','CD',]
    Pattern = np.zeros((line_count, len(Pattern_label)))

    MOTUSRAW_label = ['Time','Xaccl', 'Yaccl', 'Zaccl','Xgyro', 'Ygyro', 'Zgyro', 'Xmagn', 'Ymagn', 'Zmagn',
                        'TemperatureIMU','Barometer','TemperaturePressure','Secondes','TSmilli','QuadSum','Compteur100hz']
    MOTUSRAW = np.zeros((10*line_count,len(MOTUSRAW_label)))

    MOTUSORI_label = ['Time','Roll', 'Pitch', 'Heading','Secondes','TSmilli','Compteur100hz']
    MOTUSORI = np.zeros((line_count,len(MOTUSORI_label)))

    Pressures_label = ['Time','Data1Baro ADU ABS', 'Data2Baro ADU diff', 'Data3HCE1','Data4HCE4',
                        'Data5HCE5', 'Data6HCE6', 'Data7HCE101', 'Data8HCE102', 'Data9HCE103','Data10HCE104',
                        'Baro1 HCEM STAT', 'Baro2 HCEM STAT', 'Pressure1HCE2 Sonde 5T', 'Pressure2HCE3 Sonde 5T',
                        'Pressure3HCE4 Pitot', 'Pressure4HCE5 Pitot','Pressure5HCE10 HAUT-BAS','Pressure6HCE10 HAUT-BAS',
                        'Pressure7HCE10 GAUCHE-DROITE','Pressure8HCE10 GAUCHE-DROITE','LDE1 HAUT-BAS BRUT',
                        'LDE2 GAUCHE-DROITE BRUT','LDE1 HAUT-BAS','LDE2 GAUCHE-DROITE','Secondes','TSmilli','Compteur100hz']
    Pressures = np.zeros((line_count*10,len(Pressures_label)))

    TH_label = ['Time','digi1','digi2','digi3','digi4', 'Temp1', 'Hum1', 'Temp2', 'Hum2','Secondes','TSmilli','Compteur100hz']
    TH = np.zeros((line_count,len(TH_label)))

    T2_label = ['Time','digi1', 'Temp2','Secondes','Tsmilli','Compteur100hz']
    T2 = np.zeros((line_count,len(T2_label)))

    # initialisation des variables temporaires 
    Pressures0_temp = np.zeros((line_count,10))
    Pressures1_temp = np.zeros((line_count,10))
    Pressures2_temp = np.zeros((line_count,10))
    Pressures3_temp = np.zeros((line_count, 10))
    Pressures4_temp = np.zeros((line_count, 10))
    Pressures5_temp = np.zeros((line_count, 10))
    Pressures6_temp = np.zeros((line_count, 10))
    Pressures7_temp = np.zeros((line_count, 10))
    Pressures8_temp = np.zeros((line_count, 10))
    Pressures9_temp = np.zeros((line_count, 10))

    Result0_temp = np.zeros((line_count, 10))
    Result1_temp = np.zeros((line_count, 10))
    Result2_temp = np.zeros((line_count, 10))
    Result3_temp = np.zeros((line_count, 10))
    Result4_temp = np.zeros((line_count, 10))
    Result5_temp = np.zeros((line_count, 10))
    Result6_temp = np.zeros((line_count, 10))
    Result7_temp = np.zeros((line_count, 10))
    Result8_temp = np.zeros((line_count, 10))
    Result9_temp = np.zeros((line_count, 10))

    Pressures_tempLDE1 = np.zeros((line_count, 10))
    Pressures_tempLDE2 = np.zeros((line_count, 10))
    Result_tempLDE1 = np.zeros((line_count, 10))
    Result_tempLDE2 = np.zeros((line_count, 10))

    RAW0_temp = np.zeros((line_count, 10))
    RAW1_temp = np.zeros((line_count, 10))
    RAW2_temp = np.zeros((line_count, 10))
    RAW3_temp = np.zeros((line_count, 10))
    RAW4_temp = np.zeros((line_count, 10))
    RAW5_temp = np.zeros((line_count, 10))
    RAW6_temp = np.zeros((line_count, 10))
    RAW7_temp = np.zeros((line_count, 10))
    RAW8_temp = np.zeros((line_count, 10))
    RAW9_temp = np.zeros((line_count, 10))
    RAW10_temp = np.zeros((line_count, 10))
    RAW11_temp = np.zeros((line_count, 10))
    
    # Verification du positionnement des paquets
    for row in matrix:
        if row[510] == 187 and row[511] == 187 and row[1010] == 171 and row[1011] == 205 and row[293] == 51 and row[294] == 51 and row[493] == 192 and row[494] == 1:
            pass
        # Permutation des block inversés
        elif row[1022] == 187 and row[1023] == 187 and row[498] == 171 and row[499] == 205:  # detection des paquets inverses
            temp = row[0:511]  # Valeures Motus   # variable Tempo pour echanger de place les paquets de 512
            row[0:511] = row[512:1023]
            row[512:1023] = temp

    print("[2/6] Processing AD_NAVIGATION, IMU, and counters...")
    checkpoint_start = checkpoint("AD_NAVIGATION, IMU, counters", checkpoints)
    
    def extract_uint64_forward(*cols):
        result = np.zeros(matrix.shape[0])
        sorted_cols = sorted(cols)
        shifts = [0, 8, 16, 24, 32, 40, 48, 56]
        for i, col in enumerate(sorted_cols):
            dtype = np.uint32 if i < 4 else np.uint64
            result += matrix[:, col].astype(dtype) * (2 ** shifts[i])
        return result

    def extract_uint64_reverse(*cols):
        result = np.zeros(matrix.shape[0])
        sorted_cols = sorted(cols, reverse=True)
        shifts = [0, 8, 16, 24, 32, 40, 48, 56]
        for i, col in enumerate(sorted_cols):
            dtype = np.uint32 if i < 4 else np.uint64
            result += matrix[:, col].astype(dtype) * (2 ** shifts[i])
        return result

    def uin82int16(a, b):
        """return the convertion from two uint 8 into their equivalent in int16"""
        col_a = matrix[:, a].astype(np.uint16)
        col_b = matrix[:, b].astype(np.uint16)
        combined = (col_a << 8) | col_b
        signed = combined.astype(np.int16)
        return signed

    def dec2double(*cols):
        """Vectorized conversion from 8 uint8 to float64"""
        if len(cols) != 8:
            raise ValueError("Exactly 8 columns are required to form a double")
        sorted_cols = sorted(cols)
        byte_array = np.column_stack([matrix[:, col] for col in sorted_cols]).astype(np.uint8)
        return np.frombuffer(byte_array.tobytes(), dtype=np.float64)

    def dec2single(*cols):
        """Vectorized conversion from 4 uint8 to float32"""
        if len(cols) != 4:
            raise ValueError("Exactly 4 columns are required to form a single")
        sorted_cols = sorted(cols)
        n_rows = matrix.shape[0]
        byte_array = np.empty((n_rows, 4), dtype=np.uint8)
        for i, col in enumerate(sorted_cols):
            byte_array[:, i] = matrix[:, col]
        return np.frombuffer(byte_array.tobytes(), dtype=np.float32)

    # Compteurs
    compteur1s = extract_uint64_forward(495, 496)  # Compteur 1s
    compteur1sv2 = compteur1s.repeat(10).T  # version 10 Hz
    compteurSD = extract_uint64_reverse(499, 500, 501, 502)  # compteur SD
    compteurSDv2 = compteurSD.repeat(10).T  # version 10 Hz
    compteur100Hz = extract_uint64_reverse(505, 506, 507, 508)  # Compteur 100Hz
    compteur100Hzv2 = compteur100Hz.repeat(10).T  # version 10 Hz

    # Traitement donnees IMU Spatial
    # AD_NAVIGATION
    AD_NAVIGATION[:,0] = compteurSD
    AD_NAVIGATION[:,1] = extract_uint64_forward(0, 1)  # Sys Status
    AD_NAVIGATION[:,2] = extract_uint64_forward(2, 3)  # Filter Status
    AD_NAVIGATION[:,3] = extract_uint64_forward(4, 5, 6, 7)  # Unix Time
    AD_NAVIGATION[:,4] = extract_uint64_forward(8, 9, 10, 11)  # Micro Secondes
    AD_NAVIGATION[:,5] = dec2double(12, 13, 14, 15, 16, 17, 18, 19)  # Latitude (Rad)
    AD_NAVIGATION[:,6] = dec2double(20, 21, 22, 23, 24, 25, 26, 27)  # Longitude (Rad)
    AD_NAVIGATION[:,7] = dec2double(28, 29, 30, 31, 32, 33, 34, 35)  # Height
    AD_NAVIGATION[:,8] = dec2single(36, 37, 38, 39)  # Vitesse Nord
    AD_NAVIGATION[:,9] = dec2single(40, 41, 42, 43)  # Vitesse East
    AD_NAVIGATION[:,10] = dec2single(44, 45, 46, 47)  # Vitesse Down
    AD_NAVIGATION[:,11] = dec2single(48, 49, 50, 51)  # Acceleration X
    AD_NAVIGATION[:,12] = dec2single(52, 53, 54, 55)  # Acceleration Y
    AD_NAVIGATION[:,13] = dec2single(56, 57, 58, 59)  # Acceleration Z
    AD_NAVIGATION[:,14] = dec2single(60, 61, 62, 63)  # G
    AD_NAVIGATION[:,15] = dec2single(64, 65, 66, 67)*180/np.pi  # Roll
    AD_NAVIGATION[:,16] = dec2single(68, 69, 70, 71)*180/np.pi  # Pitch
    AD_NAVIGATION[:,17] = dec2single(72, 73, 74, 75)*180/np.pi  # Heading
    AD_NAVIGATION[:,18] = dec2single(76, 77, 78, 79)  # Angular Velocity X
    AD_NAVIGATION[:,19] = dec2single(80, 81, 82, 83)  # Angular Velocity Y
    AD_NAVIGATION[:,20] = dec2single(84, 85, 86, 87)  # Angular Velocity Z
    AD_NAVIGATION[:,21] = dec2single(88, 89, 90, 91)  # Latitude Standard Deviation
    AD_NAVIGATION[:,22] = dec2single(92, 93, 94, 95)  # Longitude Standard Deviation
    AD_NAVIGATION[:,23] = dec2single(96, 97, 98, 99)  # Height Standard Deviation
    AD_NAVIGATION[:,24] = compteur1s  # Secondes
    AD_NAVIGATION[:,25] = (AD_NAVIGATION[:,3]*1e6+AD_NAVIGATION[:,4])/1e3  # TSmilli
    AD_NAVIGATION[:,26] = compteur100Hz  # Compteur 100hz

    print(f"  [OK] AD_NAVIGATION, IMU, counters: {time.time() - checkpoint_start:.2f}s")

    print("[3/6] Processing Air Data, Wind, and Pressures...")
    checkpoint_start = checkpoint("Air Data, Wind, Pressures", checkpoints)
    Tsmilli = (AD_NAVIGATION[:,3]*1e6+AD_NAVIGATION[:,4])/1e3

    # Calculate once, reuse everywhere - keep as 1D for IMU, create V2 for 10Hz data
    TsmilliV2 = np.repeat(Tsmilli, 10)
    IMU[:,0] = compteurSD
    IMU[:,1] = dec2single(100, 101, 102, 103)  # Xaccl
    IMU[:,2] = dec2single(104, 105, 106, 107)  # Yaccl
    IMU[:,3] = dec2single(108, 109, 110, 111)  # Zaccl
    IMU[:,4] = dec2single(112, 113, 114, 115)  # Xgyro
    IMU[:,5] = dec2single(116, 117, 118, 119)  # Ygyro
    IMU[:,6] = dec2single(120, 121, 122, 123)  # Zgyro
    IMU[:,7] = dec2single(124, 125, 126, 127)  # Xmagn
    IMU[:,8] = dec2single(128, 129, 130, 131)  # Ymagn
    IMU[:,9] = dec2single(132, 133, 134, 135)  # Zmagn
    IMU[:,10] = dec2single(136, 137, 138, 139) # Temperature IMU
    IMU[:,11] = dec2single(140, 141, 142, 143) # Barometer
    IMU[:,12] = dec2single(144, 145, 146, 147) # Temperature Pressure
    IMU[:,13] = compteur1s  # Compteur 1s
    IMU[:,14] = Tsmilli
    IMU[:,15] = compteur100Hz

    # Paquet Air Data
    PaquetAirData[:,0] = compteurSD 
    PaquetAirData[:,1] = dec2single(148, 149, 150, 151)  # Barometric Altitude delay (s)
    PaquetAirData[:,2] = dec2single(152, 153, 154, 155)  # Air Speed delay (s)
    PaquetAirData[:,3] = dec2single(156, 157, 158, 159)  # Bar Altitude (m)
    PaquetAirData[:,4] = dec2single(168, 169, 170, 171)  # Air Speed (m/s)
    PaquetAirData[:,5] = dec2single(164, 165, 166, 167)  # Barometric  Standard Deviation
    PaquetAirData[:,6] = dec2single(168, 169, 170, 171)  # Air Speed Standard Deviation
    PaquetAirData[:,7] = matrix[:,172] # Status
    PaquetAirData[:,8] = compteur1s
    PaquetAirData[:,-2] = Tsmilli  # TSmilli
    PaquetAirData[:,-1] = compteur100Hz  # Compteur 100hz

    # MOTUS RAW
    MOTUSRAW[:,0]=compteurSDv2
    MOTUSRAW[:,13]=compteur1sv2
    MOTUSRAW[:,-3]=TsmilliV2
    MOTUSRAW[:,-1]=compteur100Hzv2

    # MOTUS ORI
    MOTUSORI[:,0]=compteurSD
    MOTUSORI[:,4]=compteur1s
    MOTUSORI[:,-2]=Tsmilli
    MOTUSORI[:,-1]=compteur100Hz

    # TH
    TH[:,0]=compteurSD
    TH[:,9]=compteur1s
    TH[:,-2]=Tsmilli
    TH[:,-1]=compteur100Hz

    # T2
    T2[:,0]=compteurSD
    T2[:,3]=compteur1s
    T2[:,-2]=Tsmilli
    T2[:,-1]=compteur100Hz

    # Air Data Sensors
    AirDataSensors[:,0]=compteurSD
    AirDataSensors[:,1]=dec2single(185, 186, 187, 188) # Absolute Pressure (Pa)
    AirDataSensors[:,2]=dec2single(189, 190, 191, 192) # Differential Pressure (Pa)
    AirDataSensors[:,3]=matrix[:,193] # Status
    AirDataSensors[:,4]=dec2single(194, 195, 196, 197) # Temperature (°C)
    AirDataSensors[:,5]=compteur1s
    AirDataSensors[:,-2]=Tsmilli
    AirDataSensors[:,-1]=compteur100Hz

    # Pressures
    Pressures[:,0]=compteurSDv2
    Pressures[:,25]=compteur1sv2
    Pressures[:,-2]=TsmilliV2
    Pressures[:,-1]=compteur100Hzv2

    # Paquet Wind
    PaquetWind[:,0]=compteurSD
    PaquetWind[:,1]=dec2single(173, 174, 175, 176) # Wind Velocity North (m/s)
    PaquetWind[:,2]=dec2single(177, 178, 179, 180) # Wind Velocity East (m/s)
    PaquetWind[:,3]=dec2single(181, 182, 183, 184) # Wind Velocity Standard Deviation (m/s)
    PaquetWind[:,4]=compteur1s
    PaquetWind[:,-2]=Tsmilli
    PaquetWind[:,-1]=compteur100Hz

    print(f"  [OK] Air Data, Wind, Pressures: {time.time() - checkpoint_start:.2f}s")

    print("[4/6] Processing Pattern and Temperature/Humidity...")
    checkpoint_start = checkpoint("Pattern and SHT/PT100", checkpoints)
    Pattern[:,1]=matrix[:,234] # AA
    Pattern[:,2]=matrix[:,235] # BB
    Pattern[:,3]=matrix[:,256] # CC
    Pattern[:,4]=matrix[:,257] # DD
    Pattern[:,5]=matrix[:,266] # EE
    Pattern[:,6]=matrix[:,267] # AA
    Pattern[:,7]=matrix[:,271] # 22
    Pattern[:,8]=matrix[:,272] # 22
    Pattern[:,9]=matrix[:,293] # 33
    Pattern[:,10]=matrix[:,294] # 33
    Pattern[:,11]=matrix[:,315] # 44
    Pattern[:,12]=matrix[:,316] # 44    
    Pattern[:,13]=matrix[:,337] # 55
    Pattern[:,14]=matrix[:,338] # 55
    Pattern[:,15]=matrix[:,359] # 66
    Pattern[:,16]=matrix[:,360] # 66
    Pattern[:,17]=matrix[:,381] # 77
    Pattern[:,18]=matrix[:,382] # 77
    Pattern[:,19]=matrix[:,403] # 88
    Pattern[:,20]=matrix[:,404] # 88
    Pattern[:,21]=matrix[:,425] # 99
    Pattern[:,22]=matrix[:,426] # 99
    Pattern[:,23]=matrix[:,447] # AA
    Pattern[:,24]=matrix[:,448] # AA
    Pattern[:,25]=matrix[:,493] # C0
    Pattern[:,26]=matrix[:,494] # 01
    Pattern[:,27]=matrix[:,497] # C5
    Pattern[:,28]=matrix[:,498] # 12
    Pattern[:,29]=matrix[:,503] # C1
    Pattern[:,30]=matrix[:,504] # 00
    Pattern[:,31]=matrix[:,510] # BB
    Pattern[:,32]=matrix[:,511] # BB
    Pattern[:,33]=matrix[:,560] # AC
    Pattern[:,34]=matrix[:,561] # C2
    Pattern[:,35]=matrix[:,610] # AC
    Pattern[:,36]=matrix[:,611] # C3
    Pattern[:,37]=matrix[:,660] # AC
    Pattern[:,38]=matrix[:,661] # C4
    Pattern[:,39]=matrix[:,710] # AC
    Pattern[:,40]=matrix[:,711] # C5
    Pattern[:,41]=matrix[:,760] # AC
    Pattern[:,42]=matrix[:,761] # C6
    Pattern[:,43]=matrix[:,810] # AC
    Pattern[:,44]=matrix[:,811] # C7
    Pattern[:,45]=matrix[:,860] # AC
    Pattern[:,46]=matrix[:,861] # C8
    Pattern[:,47]=matrix[:,910] # AC
    Pattern[:,48]=matrix[:,911] # C9
    Pattern[:,49]=matrix[:,960] # AC
    Pattern[:,50]=matrix[:,961] # CA
    Pattern[:,51]=matrix[:,1010] # AB
    Pattern[:,52]=matrix[:,1011] # CD

    def processpressureLDE (start: int, n: int) -> None:
        """
        Function made to process LDE's pressure group
        Args:
            start (int): Index of the column we start from for LDE pressure data processing.
            n (int): The number corresponding to the group of pression LDE (1-10)
        Returns:
            None but will fill up the temporary variables
        """
        Pressures_tempLDE1[:,n-1]=uin82int16(start, start+1)
        Pressures_tempLDE2[:,n-1]=uin82int16(start+2, start+3)
        Result_tempLDE1[:,n-1]=Pressures_tempLDE1[:,n-1]/6000
        Result_tempLDE2[:,n-1]=Pressures_tempLDE2[:,n-1]/6000
        return

    processpressureLDE(199,1)
    processpressureLDE(204,2)
    processpressureLDE(209,3)
    processpressureLDE(214,4)
    processpressureLDE(219,5)
    processpressureLDE(224,6)
    processpressureLDE(229,7)
    processpressureLDE(470,8)
    processpressureLDE(475,9)
    processpressureLDE(480,10)

    # Remplir Pressures avec les données LDE
    Pressures[:,21]=Pressures_tempLDE1.flatten()
    Pressures[:,22]=Pressures_tempLDE2.flatten()
    Pressures[:,23]=Result_tempLDE1.flatten()
    Pressures[:,24]=Result_tempLDE2.flatten()

    # SHT 85 
    SHT1_temp=extract_uint64_reverse(258, 259)
    SHT1_hum=extract_uint64_reverse(260, 261)
    TH[:,1]=SHT1_temp
    TH[:,2]=SHT1_hum
    T1_SHT=-45+175*SHT1_temp/(2**16-1)
    H1_SHT=100*SHT1_hum/(2**16-1)
    TH[:,5]=T1_SHT
    TH[:,6]=H1_SHT

    SHT2_temp=extract_uint64_reverse(262, 263)
    SHT2_hum=extract_uint64_reverse(264, 265)
    TH[:,3]=SHT2_temp
    TH[:,4]=SHT2_hum
    T2_SHT=-45+175*SHT2_temp/(2**16-1) 
    H2_SHT=100*SHT2_hum/(2**16-1)
    TH[:,7]=T2_SHT
    TH[:,8]=H2_SHT

    # PT100 
    col_h = matrix[:, 268].astype(np.uint16)
    col_l = matrix[:, 269].astype(np.uint16)
    combined = (col_h << 8) | col_l
    a3 = (combined >> 7) & 0xFF  # Upper 8 bits
    b3 = combined & 0x7F  # Lower 7 bits

    T2_raw = a3 * 128 + b3
    T2_temp = T2_raw / 32.0 - 256.0
    T2[:, 1] = T2_raw
    T2[:, 2] = T2_temp

    print(f"  [OK] Pattern and SHT/PT100: {time.time() - checkpoint_start:.2f}s")

    print("[5/6] Processing MOTUS RAW and ORI...")
    checkpoint_start = checkpoint("MOTUS RAW and ORI", checkpoints)

    # Pressure conversion constants
    val0=(24575-2730)/(1100-600)
    val1=(24575-2730)/50
    val2=(24575-2730)/20

    def processpressure(start: int, n: int) -> None:
        """
        Process pressure data starting from a given index, including static pressure, HCEM and HCE10
        Args:
            start (int): Index of the column we start from for pressure data processing.
            n (int): The number corresponding to the group of pression trio (1-10)
        Returns:
            None but will fill up the temporary variables
        """
        pressure_temps = {
            'Pressures0_temp': Pressures0_temp,
            'Pressures1_temp': Pressures1_temp,
            'Pressures2_temp': Pressures2_temp,
            'Pressures3_temp': Pressures3_temp,
            'Pressures4_temp': Pressures4_temp,
            'Pressures5_temp': Pressures5_temp,
            'Pressures6_temp': Pressures6_temp,
            'Pressures7_temp': Pressures7_temp,
            'Pressures8_temp': Pressures8_temp,
            'Pressures9_temp': Pressures9_temp,
        }
        result_temps = {
            'Result0_temp': Result0_temp,
            'Result1_temp': Result1_temp,
            'Result2_temp': Result2_temp,
            'Result3_temp': Result3_temp,
            'Result4_temp': Result4_temp,
            'Result5_temp': Result5_temp,
            'Result6_temp': Result6_temp,
            'Result7_temp': Result7_temp,
            'Result8_temp': Result8_temp,
            'Result9_temp': Result9_temp,
        }
        for i in range(10):
            var_name=f'Pressures{i}_temp'
            res_name=f'Result{i}_temp'
            if i < 2 :
                pressure_temps[var_name][:, n-1]=extract_uint64_reverse(start+i*2, start+i*2+1)
                result_temps[res_name][:, n-1]=(pressure_temps[var_name][:, n-1]-2730)/val0+600
            elif i < 6 :
                pressure_temps[var_name][:, n-1]=extract_uint64_reverse(start+i*2, start+i*2+1)
                result_temps[res_name][:, n-1]=(pressure_temps[var_name][:, n-1]-2730)/val1
            else :
                pressure_temps[var_name][:, n-1]=uin82int16(start+i*2, start+i*2+1)
                result_temps[res_name][:, n-1]=(pressure_temps[var_name][:, n-1]-2730)/val2-10
        return

    processpressure(236, 1)
    processpressure(273, 2)
    processpressure(295, 3)
    processpressure(317, 4)
    processpressure(339, 5)
    processpressure(361, 6)
    processpressure(383, 7)
    processpressure(405, 8)
    processpressure(427, 9)
    processpressure(449, 10)

    # Remplir Pressures avec les données de pression Statique, HCEM et HCE10
    pressure_temps_dict = {
        'Pressures0_temp': Pressures0_temp,
        'Pressures1_temp': Pressures1_temp,
        'Pressures2_temp': Pressures2_temp,
        'Pressures3_temp': Pressures3_temp,
        'Pressures4_temp': Pressures4_temp,
        'Pressures5_temp': Pressures5_temp,
        'Pressures6_temp': Pressures6_temp,
        'Pressures7_temp': Pressures7_temp,
        'Pressures8_temp': Pressures8_temp,
        'Pressures9_temp': Pressures9_temp,
    }
    result_temps_dict = {
        'Result0_temp': Result0_temp,
        'Result1_temp': Result1_temp,
        'Result2_temp': Result2_temp,
        'Result3_temp': Result3_temp,
        'Result4_temp': Result4_temp,
        'Result5_temp': Result5_temp,
        'Result6_temp': Result6_temp,
        'Result7_temp': Result7_temp,
        'Result8_temp': Result8_temp,
        'Result9_temp': Result9_temp,
    }
    for i in range(10):
        n1=f'Pressures{i}_temp'
        n2=f'Result{i}_temp'
        Pressures[:,i+1]=pressure_temps_dict[n1].flatten()
        Pressures[:,i+11]=result_temps_dict[n2].flatten()


    # MOTUS DATA
    def processMOTUSRAW(start: int, n: int) -> None:
        """
        Process MOTUS RAW data starting from a given index
        Args:
            start (int): Index of the column we start from for MOTUS RAW data processing.
            n (int): The number corresponding to the group of MOTUS RAW (1-12)
        Returns:
            None but will fill up the temporary variables
        """
        raw_temps = {
            'RAW0_temp': RAW0_temp,
            'RAW1_temp': RAW1_temp,
            'RAW2_temp': RAW2_temp,
            'RAW3_temp': RAW3_temp,
            'RAW4_temp': RAW4_temp,
            'RAW5_temp': RAW5_temp,
            'RAW6_temp': RAW6_temp,
            'RAW7_temp': RAW7_temp,
            'RAW8_temp': RAW8_temp,
            'RAW9_temp': RAW9_temp,
            'RAW10_temp': RAW10_temp,
            'RAW11_temp': RAW11_temp,
        }
        for i in range(12):
            var_name=f'RAW{i}_temp'
            raw_temps[var_name][:, n-1]=dec2single(start+i*4, start+i*4+1, start+i*4+2, start+i*4+3)
        return

    processMOTUSRAW(512,1)
    processMOTUSRAW(562,2)
    processMOTUSRAW(612,3)
    processMOTUSRAW(662,4) 
    processMOTUSRAW(712,5)
    processMOTUSRAW(762,6)
    processMOTUSRAW(812,7)
    processMOTUSRAW(862,8)
    processMOTUSRAW(912,9)
    processMOTUSRAW(962,10)
    
    for i in range(12):
        MOTUSRAW[:, i+1] = eval(f'RAW{i}_temp').flatten()

    # Replace NaN and Inf values with 0 before calculating QuadSum
    MOTUSRAW[:, 1] = np.where(np.isfinite(MOTUSRAW[:, 1]), MOTUSRAW[:, 1], 0)
    MOTUSRAW[:, 2] = np.where(np.isfinite(MOTUSRAW[:, 2]), MOTUSRAW[:, 2], 0)
    MOTUSRAW[:, 3] = np.where(np.isfinite(MOTUSRAW[:, 3]), MOTUSRAW[:, 3], 0)

    MOTUSRAW[:,-2]=np.sqrt(MOTUSRAW[:,1]**2+MOTUSRAW[:,2]**2+MOTUSRAW[:,3]**2)

    # MOTUS ORI
    MOTUSORI[:,1]=dec2single(1012, 1013, 1014, 1015)*180/np.pi  # Roll
    MOTUSORI[:,2]=dec2single(1016, 1017, 1018, 1019)*180/np.pi  # Pitch
    MOTUSORI[:,3]=dec2single(1020, 1021, 1022, 1023)*180/np.pi  # Heading

    print(f"  [OK] MOTUS RAW and ORI: {time.time() - checkpoint_start:.2f}s")
    
    print("[6/6] Saving data to HDF5 file...")
    checkpoint_start = checkpoint("HDF5 save", checkpoints)
    os.makedirs(output_dir, exist_ok=True)

    # Save to HDF5 file
    output_path = os.path.join(output_dir, output_filename)
    with h5py.File(output_path, 'w') as hf:
        # Create a group for organized data storage
        hf.create_dataset('AD_NAVIGATION', data=AD_NAVIGATION, compression='gzip', compression_opts=4)
        hf.create_dataset('IMU', data=IMU, compression='gzip', compression_opts=4)
        hf.create_dataset('PaquetAirData', data=PaquetAirData, compression='gzip', compression_opts=4)
        hf.create_dataset('T2', data=T2, compression='gzip', compression_opts=4)
        hf.create_dataset('TH', data=TH, compression='gzip', compression_opts=4)
        hf.create_dataset('Pressures', data=Pressures, compression='gzip', compression_opts=4)
        hf.create_dataset('MOTUSRAW', data=MOTUSRAW, compression='gzip', compression_opts=4)
        hf.create_dataset('MOTUSORI', data=MOTUSORI, compression='gzip', compression_opts=4)
        hf.create_dataset('PaquetWind', data=PaquetWind, compression='gzip', compression_opts=4)
        hf.create_dataset('AirDataSensors', data=AirDataSensors, compression='gzip', compression_opts=4)
        
        # Store column labels as attributes for easy reference
        hf.attrs['AD_NAVIGATION_LABEL'] = AD_NAVIGATION_LABEL
        hf.attrs['IMU_label'] = IMU_label
        hf.attrs['PaquetAirData_label'] = PaquetAirData_label
        hf.attrs['T2_label'] = T2_label
        hf.attrs['TH_label'] = TH_label
        hf.attrs['Pressures_label'] = Pressures_label
        hf.attrs['MOTUSRAW_label'] = MOTUSRAW_label
        hf.attrs['MOTUSORI_label'] = MOTUSORI_label
        hf.attrs['PaquetWind_label'] = PaquetWind_label
        hf.attrs['AirDataSensors_label'] = AirDataSensors_label

    print(f"  [OK] HDF5 file saved ({output_path}): {time.time() - checkpoint_start:.2f}s")

    # End timer and display execution time
    end_time = time.time()
    elapsed_time = end_time - start_time
    minutes = int(elapsed_time // 60)
    seconds = elapsed_time % 60
    print(f"\n{'='*50}")
    print(f"Data extraction completed!")
    print(f"Total time: {minutes}m {seconds:.2f}s ({elapsed_time:.2f}s)")
    print(f"Output saved to: {output_path}")
    print(f"{'='*50}\n")
    
    return output_path







