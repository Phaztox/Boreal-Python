import numpy as np
import struct

# fonction permettant d'ouvrir un fichier binaire écrit en hexadécimal, de l'enregistrer dans un tableau 2d et d'afficher le contenu d'une ligne ou d'une colonne en sachant qu'une ligne fait 1024 octets
def extract_data(file_path, offset1, offset2):
    global matrix, line_count
    data = np.memmap(file_path, dtype=np.uint8, mode='r')
    total_lines = data.size // 1024
    line_count = total_lines - (offset1 + offset2)
    if line_count <= 0:
        raise ValueError("Offsets too large for file size")
    start = offset1 * 1024
    end = start + line_count * 1024
    matrix = data[start:end].reshape((line_count, 1024))
    return matrix

extract_data('MomentaVol5_clean.bin', 1, 0)
    
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
                'Zmagn', 'TemperatureIMU','Barometer','TemperaturePressure','Secondes','TSmilli','QuadSum','Compteur100hz']
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
PressurestempLDE2 = np.zeros((line_count, 10))
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



# Traitement donnees IMU Spatial
"""
AD_NAVIGATION[:,1] = matrix[:,1].astype(np.uint16)*(2**8)+matrix[:,0].astype(np.uint16) # Sys Status
AD_NAVIGATION[:,2] = matrix[:,3].astype(np.uint16)*(2**8)+matrix[:,2].astype(np.uint16) # Filter Status
AD_NAVIGATION[:,3] = matrix[:,7].astype(np.uint32)*(2**24)+matrix[:,6].astype(np.uint32)*(2**16)+matrix[:,5].astype(np.uint32)*(2**8)+matrix[:,4].astype(np.uint32) # Unix Time
AD_NAVIGATION[:,4] = matrix[:,11].astype(np.uint32)*(2**24)+matrix[:,10].astype(np.uint32)*(2**16)+matrix[:,9].astype(np.uint32)*(2**8)+matrix[:,8].astype(np.uint32) # Micro Secondes
AD_NAVIGATION[:,5] = matrix[:,19].astype(np.uint64)*(2**56)+matrix[:,18].astype(np.uint64)*(2**48)+matrix[:,17].astype(np.uint64)*(2**40)+matrix[:,16].astype(np.uint64)*(2**32)+matrix[:,15].astype(np.uint32)*(2**24)+matrix[:,14].astype(np.uint32)*(2**16)+matrix[:,13].astype(np.uint32)*(2**8)+matrix[:,12].astype(np.uint32) # Latitude (Rad)
"""

def extract_uint64(*cols):
    result = np.zeros(matrix.shape[0])
    sorted_cols = sorted(cols)
    shifts = [0, 8, 16, 24, 32, 40, 48, 56]
    for i, col in enumerate(sorted_cols):
        dtype = np.uint32 if i < 4 else np.uint64
        result += matrix[:, col].astype(dtype) * (2 ** shifts[i])
    return result

def dec2double(*cols):
    """look for the specified argument in the matrix and return it to double (float64)"""
    if len(cols) != 8:
        raise ValueError("Exactly 8 columns are required to form a double")
    sorted_cols = sorted(cols)
    byte_array = np.zeros((matrix.shape[0], 8), dtype=np.uint8)
    for i, col in enumerate(sorted_cols):
        byte_array[:, i] = matrix[:, col]
    return np.array([struct.unpack('<d', byte_array[i].tobytes())[0] for i in range(byte_array.shape[0])])

def dec2single(*cols):
    """look for the specified argument in the matrix and return it to single (float32)"""
    if len(cols) != 4:
        raise ValueError("Exactly 4 columns are required to form a single")
    sorted_cols = sorted(cols)
    byte_array = np.zeros((matrix.shape[0], 4), dtype=np.uint8)
    for i, col in enumerate(sorted_cols):
        byte_array[:, i] = matrix[:, col]
    return np.array([struct.unpack('<f', byte_array[i].tobytes())[0] for i in range(byte_array.shape[0])])

AD_NAVIGATION[:,1] = extract_uint64(0, 1)  # Sys Status
AD_NAVIGATION[:,2] = extract_uint64(2, 3)  # Filter Status
AD_NAVIGATION[:,3] = extract_uint64(4, 5, 6, 7)  # Unix Time
AD_NAVIGATION[:,4] = extract_uint64(8, 9, 10, 11)  # Micro Secondes
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

print(AD_NAVIGATION[-1:]) # Affichage des 5 dernières lignes de la table AD_NAVIGATION







