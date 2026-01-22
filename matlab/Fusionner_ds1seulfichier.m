% Fusion des données/

%listenames=dir('./*.mat')%% in order to have all files names saved  in "listenames"  (You shouldn't  be inside the forlder)

load('Vol5_1');
data5=data;

load('Vol5_2');
data6=data;

data_f.AD_NAVIGATION_label=data5.AD_NAVIGATION_label;
data_f.AD_NAVIGATION=vertcat(data5.AD_NAVIGATION,data6.AD_NAVIGATION);

data_f.PaquetAirData_label=data5.PaquetAirData_label;
data_f.PaquetAirData=vertcat(data5.PaquetAirData,data6.PaquetAirData);

data_f.PaquetWind_label=data5.PaquetWind_label;
data_f.PaquetWind=vertcat(data5.PaquetWind,data6.PaquetWind);

data_f.AirDataSensors_label=data5.AirDataSensors_label;
data_f.AirDataSensors=vertcat(data5.AirDataSensors,data6.AirDataSensors);

data_f.IMU_label=data5.IMU_label;
data_f.IMU=vertcat(data5.IMU,data6.IMU);

data_f.Pattern_label=data5.Pattern_label;
data_f.Pattern=vertcat(data5.Pattern,data6.Pattern);

data_f.MOTUSRAW_label=data5.MOTUSRAW_label;
data_f.MOTUSRAW=vertcat(data5.MOTUSRAW,data6.MOTUSRAW);

data_f.MOTUSORI_label=data5.MOTUSORI_label;
data_f.MOTUSORI=vertcat(data5.MOTUSORI,data6.MOTUSORI);

data_f.Pressures_label=data5.Pressures_label;
data_f.Pressures=vertcat(data5.Pressures,data6.Pressures);

data_f.TH_label=data5.TH_label;
data_f.TH=vertcat(data5.TH,data6.TH);

data_f.T2_label=data5.T2_label;
data_f.T2=vertcat(data5.T2,data6.T2);

Vol5_momenta=data_f;
save('Vol5_momenta')

% data_f.AD_NAVIGATION_label=data5.AD_NAVIGATION_label;
% data_f.AD_NAVIGATION=vertcat(data5.AD_NAVIGATION(1:35992),data6.AD_NAVIGATION(1:35985),data7.AD_NAVIGATION(1:35991),data8.AD_NAVIGATION(1:35994),data9.AD_NAVIGATION,data10.AD_NAVIGATION,data11.AD_NAVIGATION,data12.AD_NAVIGATION,data13.AD_NAVIGATION,data14.AD_NAVIGATION,data15.AD_NAVIGATION);
% 
% data_f.PaquetGNSS_label=data5.PaquetGNSS_label;
% data_f.PaquetGNSS=vertcat(data5.PaquetGNSS(1:35992),data6.PaquetGNSS(1:35985),data7.PaquetGNSS(1:35991),data8.PaquetGNSS(1:35994),data9.PaquetGNSS,data10.PaquetGNSS,data11.PaquetGNSS,data12.PaquetGNSS,data13.PaquetGNSS,data14.PaquetGNSS,data15.PaquetGNSS);
% 
% data_f.PaquetAirData_label=data5.PaquetAirData_label;
% data_f.PaquetAirData=vertcat(data5.PaquetAirData(1:35992),data6.PaquetAirData(1:35985),data7.PaquetAirData(1:35991),data8.PaquetAirData(1:35994),data9.PaquetAirData,data10.PaquetAirData,data11.PaquetAirData,data12.PaquetAirData,data13.PaquetAirData,data14.PaquetAirData,data15.PaquetAirData);
% 
% data_f.PaquetWind_label=data5.PaquetWind_label;
% data_f.PaquetWind=vertcat(data5.PaquetWind(1:35992),data6.PaquetWind(1:35985),data7.PaquetWind(1:35991),data8.PaquetWind(1:35994),data9.PaquetWind,data10.PaquetWind,data11.PaquetWind,data12.PaquetWind,data13.PaquetWind,data14.PaquetWind,data15.PaquetWind);
% 
% data_f.AirDataSensors_label=data5.AirDataSensors_label;
% data_f.AirDataSensors=vertcat(data5.AirDataSensors(1:35992),data6.AirDataSensors(1:35985),data7.AirDataSensors(1:35991),data8.AirDataSensors(1:35994),data9.AirDataSensors,data10.AirDataSensors,data11.AirDataSensors,data12.AirDataSensors,data13.AirDataSensors,data14.AirDataSensors,data15.AirDataSensors);
% 
% data_f.IMU_label=data5.IMU_label;
% data_f.IMU=vertcat(data5.IMU(1:35992),data6.IMU(1:35985),data7.IMU(1:35991),data8.IMU(1:35994),data9.IMU,data10.IMU,data11.IMU,data12.IMU,data13.IMU,data14.IMU,data15.IMU);
% 
% data_f.Pattern_label=data5.Pattern_label;
% data_f.Pattern=vertcat(data5.Pattern(1:35992),data6.Pattern(1:35985),data7.Pattern(1:35991),data8.Pattern(1:35994),data9.Pattern,data10.Pattern,data11.Pattern,data12.Pattern,data13.Pattern,data14.Pattern,data15.Pattern);
% 
% data_f.Pressures_label=data5.Pressures_label;
% data_f.Pressures=vertcat(data5.Pressures(1:35992),data6.Pressures(1:35985),data7.Pressures(1:35991),data8.Pressures(1:35994),data9.Pressures,data10.Pressures,data11.Pressures,data12.Pressures,data13.Pressures,data14.Pressures,data15.Pressures);
% 
% data_f.TH13_label=data5.TH13_label;
% data_f.TH13=vertcat(data5.TH13(1:35992),data6.TH13(1:35985),data7.TH13(1:35991),data8.TH13(1:35994),data9.TH13,data10.TH13,data11.TH13,data12.TH13,data13.TH13,data14.TH13,data15.TH13);
% 
% data_f.Pnav1_Label=data5.Pnav1_Label;
% data_f.Pnav1=vertcat(data5.Pnav1(1:35992),data6.Pnav1(1:35985),data7.Pnav1(1:35991),data8.Pnav1(1:35994),data9.Pnav1,data10.Pnav1,data11.Pnav1,data12.Pnav1,data13.Pnav1,data14.Pnav1,data15.Pnav1);
% 
% data_f.Pnav2_Label=data5.Pnav2_Label;
% data_f.Pnav2=vertcat(data5.Pnav2(1:35992),data6.Pnav2(1:35985),data7.Pnav2(1:35991),data8.Pnav2(1:35994),data9.Pnav2,data10.Pnav2,data11.Pnav2,data12.Pnav2,data13.Pnav2,data14.Pnav2,data15.Pnav2);
% 
% data_f.Pnav3_Label=data5.Pnav3_Label;
% data_f.Pnav3=vertcat(data5.Pnav3(1:35992),data6.Pnav3(1:35985),data7.Pnav3(1:35991),data8.Pnav3(1:35994),data9.Pnav3,data10.Pnav3,data11.Pnav3,data12.Pnav3,data13.Pnav3,data14.Pnav3,data15.Pnav3);
% 
% data_f.Pnav4_Label=data5.Pnav4_Label;
% data_f.Pnav4=vertcat(data5.Pnav4(1:35992),data6.Pnav4(1:35985),data7.Pnav4(1:35991),data8.Pnav4(1:35994),data9.Pnav4,data10.Pnav4,data11.Pnav4,data12.Pnav4,data13.Pnav4,data14.Pnav4,data15.Pnav4);
% 
% data_f.Pnav5_Label=data5.Pnav5_Label;
% data_f.Pnav5=vertcat(data5.Pnav5(1:35992),data6.Pnav5(1:35985),data7.Pnav5(1:35991),data8.Pnav5(1:35994),data9.Pnav5,data10.Pnav5,data11.Pnav5,data12.Pnav5,data13.Pnav5,data14.Pnav5,data15.Pnav5);
% 
% data_f.Pnav6_Label=data5.Pnav6_Label;
% data_f.Pnav6=vertcat(data5.Pnav6(1:35992),data6.Pnav6(1:35985),data7.Pnav6(1:35991),data8.Pnav6(1:35994),data9.Pnav6,data10.Pnav6,data11.Pnav6,data12.Pnav6,data13.Pnav6,data14.Pnav6,data15.Pnav6);
% 
% data_f.Pnav7_Label=data5.Pnav7_Label;
% data_f.Pnav7=vertcat(data5.Pnav7(1:35992),data6.Pnav7(1:35985),data7.Pnav7(1:35991),data8.Pnav7(1:35994),data9.Pnav7,data10.Pnav7,data11.Pnav7,data12.Pnav7,data13.Pnav7,data14.Pnav7,data15.Pnav7);

