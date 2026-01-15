import numpy as np

# fonction permettant d'ouvrir un fichier binaire écrit en hexadécimal, de l'enregistrer dans un tableau 2d et d'afficher le contenu d'une ligne ou d'une colonne en sachant qu'une ligne fait 1024 octets
def extract_data(file_path, offset1, offset2):
    # ouverture du fichier binaire en mode lecture
    with open(file_path, 'rb') as file:
        data = file.read()
    # conversion du contenu en une liste 
    list_data = list(data)
    line_count = len(list_data) // 1024 - (offset1 + offset2)
    matrix = np.zeros((line_count, 1024), dtype=np.uint8)
    # remplissage de la matrice
    for i in range(line_count):
        matrix[i] = list_data[(i+offset1)*1024:(i+1+offset1)*1024]


    
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


    # retoure la colonne 1011 de la matrice
    return matrix


print (extract_data('MomentaVol5_small.bin', 0, 0))




