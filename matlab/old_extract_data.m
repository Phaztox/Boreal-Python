function Result = extract_data(Q,offset,offset2)
%%% 
% Input:
%Q: (1024,N) données issues du lien série ou SD
%Offset: indice de colonne où on souaite extraire les données
%Offset2:indice de colonne où on termine l'extraction
%Output: Structure matlab contenant toutes les données de pression
%température humidité Orientation etc..

%=============== Selection affichage des  donnees

N=size(Q,2)-(offset2+offset)+1;
Result.AD_NAVIGATION_label={'Time','SystStatus','FilterStatus','Unixtime','MicroSecondes',...
    'Latitude(Rad)','Longitude(Rad)','Height','VitesseNord','VitesseEast','VitesseDown',...
    'Acceleration_X','Acceleration_Y','Acceleration_Z','G','Roll','Pitch','Heading',...
    'AngularVelocity_X','AngularVelocity_Y','AngularVelocity_Z',...
    'LatitudeStandardDeviation','LongitudeStandardDeviation','HeightStandardDeviation','Secondes','TSmilli','Compteur100hz'};
Result.AD_NAVIGATION = zeros(N,27);
%==================================================================%
%  PaquetGNSS_label={'Time','Unixtime','Microseconds','Latitude(Rad)','Longitude(Rad)','Height',...
%    'VitesseNord','VitesseEast','VitesseDown', 'LatitudeStandardDeviation','LongitudeStandardDeviation','HeightStandardDeviation',...
%    'Reserved','Reserved','Reserved','Reserved','SystStatus','Secondes','TSmilli'};
% PaquetGNSS = zeros(floor(length_data/taille_fichier), 19);
%==================================================================%
Result.PaquetAirData_label={'Time','BaroRetard(s)','AirSpeedRetard(s)','BaroAltitude(m)','AirSpeed(m/s)',...
    'BaroStandardDeviation(m)','AirSpeedStandardDeviation(m/s)','StatusAirData','Secondes','TSmilli','Compteur100hz'};
%  PaquetAirData=   zeros(floor(length_data/taille_fichier), 10);
Result.PaquetAirData=   zeros(N,11);
Result.PaquetWind=   zeros(N,7);
%==================================================================%
Result.PaquetWind_label={'Time','WindVelocityNorth(m/s)','WindVelocityEast(m/s)',...
    'WindVelocityStandardDeviation(m/s)','Secondes','TSmilli','Compteur100hz'};
%  PaquetWind=   zeros(floor(length_data/taille_fichier), 6);
%==================================================================%
Result.AirDataSensors_label={'Time','AbsolutePressure(Pa)','DifferentialPressure(Pa)',...
    'FlagsRawStatus','Temperature(c)','Secondes','TSmilli','Compteur100hz'};
%  AirDataSensors=   zeros(floor(length_data/taille_fichier), 7);
Result.AirDataSensors=  zeros(N,8);
%==================================================================%
% if bitand(whatload, 8)
Result.IMU_label = {'Time','Xaccl', 'Yaccl', 'Zaccl','Xgyro', 'Ygyro', 'Zgyro', 'Xmagn', 'Ymagn', 'Zmagn', 'TemperatureIMU','Barometer','TemperaturePressure','Secondes','TSmilli','QuadSum','Compteur100hz'};
%    IMU = zeros(floor(length_data/512*10), 12);     %  Il y a 10 valeures par lignes %
Result.IMU =  zeros(N,13);     %  Il y a 10 valeures par lignes
%  IMU = zeros(floor(length_data/taille_fichier), 15);
%i_IMU = 1;
% 2/AA/234 3/BB/235 4/CC/256 5/DD/257 6/EE/266 7/AA/267 8/C0/493 9/01/494
% 10/C5/497 11/12/498 12/C1/503 13/00/504
Result.Pattern_label = {'Time','AA','BB',...
    'CC','DD','EE','AA',...
    '22','22','33','33','44','44','55','55','66',...
    '66','77','77','88','88','99','99','AA','AA',...
    'C0','01','C5','12','C1','00','BB','BB',...
    'AC','C2','AC','C3','AC','C4','AC','C5','AC','C6',...
    'AC','C7','AC','C8','AC','C9','AC','CA','AB','CD',...
    };
%  Pattern= zeros(floor(length_data/taille_fichier), 53);
Result.Pattern=zeros(N,53);% end
%==================================================================%
Result.MOTUSRAW_label = {'Time','Xaccl', 'Yaccl', 'Zaccl','Xgyro', 'Ygyro', 'Zgyro', 'Xmagn', 'Ymagn', 'Zmagn', 'TemperatureIMU','Barometer','TemperaturePressure','Secondes','TSmilli','QuadSum','Compteur100hz'};
%    IMU = zeros(floor(length_data/512*10), 12);     %  Il y a 10 valeures par lignes
%  MOTUSRAW = zeros(floor(length_data/taille_fichier)*10, 15);
Result.MOTUSRAW = zeros(10*N,17);

Result.MOTUSORI_label = {'Time','Roll', 'Pitch', 'Heading','Secondes','TSmilli','Compteur100hz'};
%    IMU = zeros(floor(length_data/512*10), 12);     %  Il y a 10 valeures par lignes
%  MOTUSORI = zeros(floor(length_data/taille_fichier), 6);
Result.MOTUSORI = zeros(N,7);
%==================================================================%
% Modif MIRIAD PressionBaro1, PressionBaro2, PressionPitot         %
%==================================================================%
% if bitand(whatload, 4)
Result.Pressures_label = {'Time','Data1Baro ADU ABS', 'Data2Baro ADU diff', 'Data3HCE1','Data4HCE4',....
    'Data5HCE5', 'Data6HCE6', 'Data7HCE101', 'Data8HCE102', 'Data9HCE103','Data10HCE104','Baro1 HCEM STAT', 'Baro2 HCEM STAT' ...
    'Pressure1HCE2 Sonde 5T', 'Pressure2HCE3 Sonde 5T','Pressure3HCE4 Pitot', 'Pressure4HCE5 Pitot','Pressure5HCE10 HAUT-BAS',...
    'Pressure6HCE10 HAUT-BAS', 'Pressure7HCE10 GAUCHE-DROITE','Pressure8HCE10 GAUCHE-DROITE','LDE1 HAUT-BAS BRUT','LDE2 GAUCHE-DROITE BRUT','LDE1 HAUT-BAS','LDE2 GAUCHE-DROITE','Secondes','TSmilli','Compteur100hz'};
%      Pressures = zeros(floor(length_data/taille_fichier)*10, 23);   % DonnÃ©es a 1000Hz
Result.Pressures = zeros(N*10,28);   % DonnÃ©es a 1000Hz
% end

%==================================================================%
% Modif MIRIAD PressionBaro1, PressionBaro2, PressionPitot         %
%==================================================================%
Result.TH_label = {'Time','digi1','digi2','digi3','digi4', 'Temp1', 'Hum1', 'Temp2', 'Hum2','Secondes','TSmilli','Compteur100hz'};
%     TH = zeros(floor(length_data/512), 11); % Donnees a 2.5 Hz
Result.TH = zeros(N,12); % Donnees a 2.5 Hz
%     i_TH = 1;
Result.T2_label = {'Time','digi1', 'Temp2','Secondes','Tsmilli','Compteur100hz'};
%     T2 = zeros(floor(length_data/512), 5);  % Donnees a 10 Hz
Result.T2 = zeros(N,6);  % Donnees a 10 Hz
%     i_T2 = 1;

%===============================% Initialisation des variables temporaires
Pressures0_temp=zeros(N,10);
Pressures1_temp=zeros(N,10);
Pressures2_temp=zeros(N,10);
Pressures3_temp=zeros(N,10);
Pressures4_temp=zeros(N,10);
Pressures5_temp=zeros(N,10);
Pressures6_temp=zeros(N,10);
Pressures7_temp=zeros(N,10);
Pressures8_temp=zeros(N,10);
Pressures9_temp=zeros(N,10);

Result0_temp=zeros(N,10);
Result1_temp=zeros(N,10);
Result2_temp=zeros(N,10);
Result3_temp=zeros(N,10);
Result4_temp=zeros(N,10);
Result5_temp=zeros(N,10);
Result6_temp=zeros(N,10);
Result7_temp=zeros(N,10);
Result8_temp=zeros(N,10);
Result9_temp=zeros(N,10);

Pressures_tempLDE1=zeros(N,10);
PressurestempLDE2=zeros(N,10);
Result_tempLDE1=zeros(N,10);
Result_tempLDE2=zeros(N,10);

RAW0_temp=zeros(N,10);
RAW1_temp=zeros(N,10);
RAW2_temp=zeros(N,10);
RAW3_temp=zeros(N,10);
RAW4_temp=zeros(N,10);
RAW5_temp=zeros(N,10);
RAW6_temp=zeros(N,10);
RAW7_temp=zeros(N,10);
RAW8_temp=zeros(N,10);
RAW9_temp=zeros(N,10);
RAW10_temp=zeros(N,10);
RAW11_temp=zeros(N,10);
% stockage des données a traiter
q=Q(:,offset:size(Q,2)-offset2);
q=q.';
%% TRAITEMENT DONNES IMU SPATIAL
a=[q(:,1) q(:,2)];
b=a(:,2)*256+a(:,1);
Result.AD_NAVIGATION(:,2)=b;    % SystStatus
a=[q(:,3) q(:,4)];
b=a(:,2)*256+a(:,1);
Result.AD_NAVIGATION(:,3)=b;    % FilterStatus
a=[q(:,5) q(:,6) q(:,7) q(:,8)];
b=a(:,1)+a(:,2)*2^8+a(:,3)*2^16+a(:,4)*2^24;
Result.AD_NAVIGATION(:,4)=b;    % Unixtime
a=[q(:,9) q(:,10) q(:,11) q(:,12)];
b=a(1)+a(2)*2^8+a(3)*2^16+a(4)*2^24;
Result.AD_NAVIGATION(:,5)=b;    % MicroSecondes
a=[q(:,13) q(:,14) q(:,15) q(:,16) q(:,17) q(:,18) q(:,19) q(:,20)];
b=dec2double(a);
Result.AD_NAVIGATION(:,6)=b;   % Latitude(Rad)
a=[q(:,21) q(:,22) q(:,23) q(:,24) q(:,25) q(:,26) q(:,27) q(:,28)];
b=dec2double(a);
Result.AD_NAVIGATION(:,7)=b;   % Longitude(Rad)
a=[q(:,29) q(:,30) q(:,31) q(:,32) q(:,33) q(:,34) q(:,35) q(:,36)];
b=dec2double(a);
Result.AD_NAVIGATION(:,8)=b;   % Height
a=[q(:,37) q(:,38) q(:,39) q(:,40)];
b=dec2single(a);
Result.AD_NAVIGATION(:,9)=b;   % VitesseNord
a=[q(:,41) q(:,42) q(:,43) q(:,44)];
b=dec2single(a);
Result.AD_NAVIGATION(:,10)=b ; % VitesseEast
a=[q(:,45) q(:,46) q(:,47) q(:,48)];
b=dec2single(a);
Result.AD_NAVIGATION(:,11)=b;  % VitesseDown
a=[q(:,49) q(:,50) q(:,51) q(:,52)];
b=dec2single(a);
Result.AD_NAVIGATION(:,12)=b;  % Acceleration_X
a=[q(:,53) q(:,54) q(:,55) q(:,56)];
b=dec2single(a);
Result.AD_NAVIGATION(:,13)=b;  % Acceleration_Y
a=[q(:,57) q(:,58) q(:,59) q(:,60)];
b=dec2single(a);
Result.AD_NAVIGATION(:,14)=b;  % Acceleration_Z
a=[q(:,61) q(:,62) q(:,63) q(:,64)];
b=dec2single(a);
Result.AD_NAVIGATION(:,15)=b;  % G
a=[q(:,65) q(:,66) q(:,67) q(:,68)];
b=dec2single(a);
Result.AD_NAVIGATION(:,16)=b*180/pi;  % Roll
a=[q(:,69) q(:,70) q(:,71) q(:,72)];
b=dec2single(a);
Result.AD_NAVIGATION(:,17)=b*180/pi;  % Pitch
a=[q(:,73) q(:,74) q(:,75) q(:,76)];
b=dec2single(a);
Result.AD_NAVIGATION(:,18)=b*180/pi;  % Heading
a=[q(:,77) q(:,78) q(:,79) q(:,80)];
b=dec2single(a);
Result.AD_NAVIGATION(:,19)=b;  % AngularVelocity_X
a=[q(:,81) q(:,82) q(:,83) q(:,84)];
b=dec2single(a);
Result.AD_NAVIGATION(:,20)=b;  % AngularVelocity_Y
a=[q(:,85) q(:,86) q(:,87) q(:,88)];
b=dec2single(a);
Result.AD_NAVIGATION(:,21)=b;  % AngularVelocity_Z
a=[q(:,89) q(:,90) q(:,91) q(:,92)];
b=dec2single(a);
Result.AD_NAVIGATION(:,22)=b;  % LatitudeStandardDeviation
a=[q(:,93) q(:,94) q(:,95) q(:,96)];
b=dec2single(a);
Result.AD_NAVIGATION(:,23)=b;  % LongitudeStandardDeviation
a=[q(:,97) q(:,98) q(:,99) q(:,100)];
b=dec2single(a);
Result.AD_NAVIGATION(:,24)=b;  % HeightStandardDeviation
%
a=[q(:,101) q(:,102) q(:,103) q(:,104)];
b=dec2single(a);
Result.IMU(:,2)=b; % Xaccl
a=[q(:,105) q(:,106) q(:,107) q(:,108)];
b=dec2single(a);
Result.IMU(:,3)=b; % Yaccl
a=[q(:,109) q(:,110) q(:,111) q(:,112)];
b=dec2single(a);
Result.IMU(:,4)=b;  % Zaccl
a=[q(:,113) q(:,114) q(:,115) q(:,116)];
b=dec2single(a);
Result.IMU(:,5)=b;  % Xgyro
a=[q(:,117) q(:,118) q(:,119) q(:,120)];
b=dec2single(a);
Result.IMU(:,6)=b;  % Ygyro
a=[q(:,121) q(:,122) q(:,123) q(:,124)];
b=dec2single(a);
Result.IMU(:,7)=b;  % Zgyro
a=[q(:,125) q(:,126) q(:,127) q(:,128)];
b=dec2single(a);
Result.IMU(:,8)=b;  % Xmagn
a=[q(:,129) q(:,130) q(:,131) q(:,132)];
b=dec2single(a);
Result.IMU(:,9)=b;  % Ymagn
a=[q(:,133) q(:,134) q(:,135) q(:,136)];
b=dec2single(a);
IMU(:,10)=b; % Zmagn
a=[q(:,137) q(:,138) q(:,139) q(:,140)];
b=dec2single(a);
Result.IMU(:,11)=b; % IMUTemperatureIMU
a=[q(:,141) q(:,142) q(:,143) q(:,144)];
b=dec2single(a);
Result.IMU(:,12)=b; % Barometer
a=[q(:,145) q(:,146) q(:,147) q(:,148)];
b=dec2single(a);
Result.IMU(:,13)=b; % TemperaturePressure



Result.IMU(:,16) =((IMU(:,2)).^2 +(IMU(:,3)).^2 +(IMU(:,4)).^2).^0.5;
%

a=[q(:,149) q(:,150) q(:,151) q(:,152)];
b=dec2single(a);
Result.PaquetAirData(:,2)=b;  % Barometrique Altitude delay(s)
a=[q(:,153) q(:,154) q(:,155) q(:,156)];
b=dec2single(a);
Result.PaquetAirData(:,3)=b;  % Air Speed Delay(s)
a=[q(:,157) q(:,158) q(:,159) q(:,160)];
b=dec2single(a);
Result.PaquetAirData(:,4)=b; % bar altitude (m)
a=[q(:,169) q(:,170) q(:,171) q(:,172)];
b=dec2single(a);
Result.PaquetAirData(:,5)=b;%% air speed (m/s)
%                                     PaquetAirData_temp=[PaquetAirData_temp;repmat(PaquetAirData(end,:),10,1)];
a=[q(:,165) q(:,166) q(:,167) q(:,168)];
b=dec2single(a);
Result.PaquetAirData(:,6)=b;  % Barometrique Standard deviation
a=[q(:,169) q(:,170) q(:,171) q(:,172)];
b=dec2single(a);
Result.PaquetAirData(:,7)=b;  % Air Speed Standard deviation
a=q(:,173);
b=a;
Result.PaquetAirData(:,8)=b;    % Status

a=[q(:,174) q(:,175) q(:,176) q(:,177)];
b=dec2single(a);
Result.PaquetWind(:,2)=b;  % WindVelocityNorth(m/s)
a=[q(:,178) q(:,179) q(:,180) q(:,181)];
b=dec2single(a);
Result.PaquetWind(:,3)=b;  % WindVelocityEast(m/s)
%                                     PaquetWind_temp=[PaquetWind_temp;repmat(PaquetWind(end,:),10,1)];
a=[q(:,182) q(:,183) q(:,184) q(:,185)];
b=dec2single(a);
Result.PaquetWind(:,4)=b;  % WindVelocityStandardDeviation(m/s)
a=[q(:,186) q(:,187) q(:,188) q(:,189)];
b=dec2single(a);
Result.AirDataSensors(:,2)=b; % Absolute pressure(Pa)
a=[q(:,190) q(:,191) q(:,192) q(:,193)];
b=dec2single(a);
Result.AirDataSensors(:,3)=b;  % Differential pressue (Pa)
%                                     Result.AirDataSensors_temp=[AirDataSensors_temp;repmat(AirDataSensors(end,:),10,1)];
a=q(:,194);
b=a;
Result.AirDataSensors(:,4)=b;    % Status
a=[q(:,195) q(:,196) q(:,197) q(:,198)];
b=dec2single(a);
Result.AirDataSensors(:,5)=b;  % add
%
a=q(:,235);
b=a;
Result.Pattern(:,2)=b; % AA
a=q(:,236);
b=a;
Result.Pattern(:,3)=b; % BB
%% PRESSION STATIQUE 1&2
a=q(:,237);
b=q(:,238);
pression_brute0=a.*256+b; % Pression Baro1 HCEMO611
a=q(:,239);
b=q(:,240);
pression_brute1=a.*256+b; % Pression Baro1 HCEMO611

val =( 24575 - 2730)/( 1100 - 600);%
Result_0 = (pression_brute0 - 2730)/val + 600;
Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM diff pressure 1
a=q(:,241);
b=q(:,242);
pression_brute2=a.*256+b;
a=q(:,243);
b=q(:,244);
pression_brute3=a.*256+b;
a=q(:,245);
b=q(:,246);
pression_brute4=a.*256+b;
a=q(:,247);
b=q(:,248);
pression_brute5=a.*256+b;

val =( 24575 - 2730)/( 50);  % +/- 50 mb
Result_2 = (pression_brute2 - 2730)./val + (-0);  % diff pressure HCEM
Result_3 = (pression_brute3 - 2730)./val + (-0);
Result_4 = (pression_brute4 - 2730)./val + (-0);
Result_5 = (pression_brute5 - 2730)./val + (-0);
%% DIFF PRESSURE HCE10 1
a=q(:,249);
b=q(:,250);
pression_brute6 =uint82int16(a,b);

a=q(:,251);
b=q(:,252);
pression_brute7 = uint82int16(a,b);

a=q(:,253);
b=q(:,254);
pression_brute8 = uint82int16(a,b);

a=q(:,255);
b=q(:,256);
pression_brute9 = uint82int16(a,b);
val =( 24575 - 2730)/( 20);  % +/- 50 mb
Result_6=(pression_brute6- 2730)./val + (-10)  ; % mb
Result_7=(pression_brute7- 2730)./val + (-10)  ; % mb
Result_8=(pression_brute8- 2730)./val + (-10)  ; % mb
Result_9=(pression_brute9- 2730)./val + (-10)  ; % mb

%% DIFF PRESSURE LDE 1
a=q(:,200);
b=q(:,201);
pression_bruteLDE1_1 =uint82int16(a,b);

a=q(:,202);
b=q(:,203);
pression_bruteLDE2_1 = uint82int16(a,b);
Result_LDE1_1=pression_bruteLDE1_1 /6000 ; % mb
Result_LDE2_1=pression_bruteLDE2_1 /6000 ; % mb
%% DIFF PRESSURE LDE 2

a=q(:,205);
b=q(:,206);
pression_bruteLDE1_2 =uint82int16(a,b);

a=q(:,207);
b=q(:,208);
pression_bruteLDE2_2 = uint82int16(a,b);
Result_LDE1_2=pression_bruteLDE1_2 /6000 ; % mb
Result_LDE2_2=pression_bruteLDE2_2 /6000 ; % mb
%% DIFF PRESSURE LDE 3
a=q(:,210);
b=q(:,211);
pression_bruteLDE1_3 =uint82int16(a,b);

a=q(:,212);
b=q(:,213);
pression_bruteLDE2_3 = uint82int16(a,b);
Result_LDE1_3=pression_bruteLDE1_3 /6000 ; % mb
Result_LDE2_3=pression_bruteLDE2_3 /6000 ; % mb
%% DIFF PRESSURE LDE 4
a=q(:,215);
b=q(:,216);
pression_bruteLDE1_4 =uint82int16(a,b);

a=q(:,217);
b=q(:,218);
pression_bruteLDE2_4 = uint82int16(a,b);
Result_LDE1_4=pression_bruteLDE1_4 /6000 ; % mb
Result_LDE2_4=pression_bruteLDE2_4 /6000 ; % mb
%% DIFF PRESSURE LDE 5
a=q(:,220);
b=q(:,221);
pression_bruteLDE1_5 =uint82int16(a,b);

a=q(:,222);
b=q(:,223);
pression_bruteLDE2_5 = uint82int16(a,b);
Result_LDE1_5=pression_bruteLDE1_5 /6000 ; % mb
Result_LDE2_5=pression_bruteLDE2_5 /6000 ; % mb
%% DIFF PRESSURE LDE 6
a=q(:,225);
b=q(:,226);
pression_bruteLDE1_6 =uint82int16(a,b);

a=q(:,227);
b=q(:,228);
pression_bruteLDE2_6 = uint82int16(a,b);
Result_LDE1_6=pression_bruteLDE1_6 /6000 ; % mb
Result_LDE2_6=pression_bruteLDE2_6 /6000 ; % mb
%% DIFF PRESSURE LDE 7
a=q(:,230);
b=q(:,231);
pression_bruteLDE1_7 =uint82int16(a,b);

a=q(:,232);
b=q(:,233);
pression_bruteLDE2_7 = uint82int16(a,b);
Result_LDE1_7=pression_bruteLDE1_7 /6000 ; % mb
Result_LDE2_7=pression_bruteLDE2_7 /6000 ; % mb
%% DIFF PRESSURE LDE 8
a=q(:,471);
b=q(:,472);
pression_bruteLDE1_8 =uint82int16(a,b);

a=q(:,473);
b=q(:,474);
pression_bruteLDE2_8 = uint82int16(a,b);
Result_LDE1_8=pression_bruteLDE1_8 /6000 ; % mb
Result_LDE2_8=pression_bruteLDE2_8 /6000 ; % mb
%% DIFF PRESSURE LDE 9
a=q(:,476);
b=q(:,477);

pression_bruteLDE1_9 =uint82int16(a,b);

a=q(:,478);
b=q(:,479);
pression_bruteLDE2_9 = uint82int16(a,b);
Result_LDE1_9=pression_bruteLDE1_9 /6000 ; % mb
Result_LDE2_9=pression_bruteLDE2_9 /6000 ; % mb
%% DIFF PRESSURE LDE 10
a=q(:,481);
b=q(:,482);
pression_bruteLDE1_10 =uint82int16(a,b);

a=q(:,483);
b=q(:,484);
pression_bruteLDE2_10 = uint82int16(a,b);
Result_LDE1_10=pression_bruteLDE1_10 /6000 ; % mb
Result_LDE2_10=pression_bruteLDE2_10 /6000 ; % mb


%% STOCKAGE PRESSION 1
Pressures0_temp(:,1)=pression_brute0;
Pressures1_temp(:,1)=pression_brute1;
Pressures2_temp(:,1)=pression_brute2;
Pressures3_temp(:,1)=pression_brute3;
Pressures4_temp(:,1)=pression_brute4;
Pressures5_temp(:,1)=pression_brute5;
Pressures6_temp(:,1)=pression_brute6;
Pressures7_temp(:,1)=pression_brute7;
Pressures8_temp(:,1)=pression_brute8;
Pressures9_temp(:,1)=pression_brute9;

Result0_temp(:,1)=Result_0;
Result1_temp(:,1)=Result_1;
Result2_temp(:,1)=Result_2;
Result3_temp(:,1)=Result_3;
Result4_temp(:,1)=Result_4;
Result5_temp(:,1)=Result_5;
Result6_temp(:,1)=Result_6;
Result7_temp(:,1)=Result_7;
Result8_temp(:,1)=Result_8;
Result9_temp(:,1)=Result_9;

Result.Pattern(:,4)=q(:,257); % AA

Result.Pattern(:,5)=q(:,258); % BB
%% SHT 85
a=q(:,259);
b=q(:,260);
digi1=a.*256 +b;    % data_temp_sht75_1
a=q(:,261);
b=q(:,262);
digi2=a.*256 +b;
%
T1 = -45 + 175.*digi1./(2^16-1);
H1 =100.*digi2./(2^16-1);
Result.TH(:,2)=digi1;
Result.TH(:,3)=digi2;

Result.TH(:,6)=T1;
Result.TH(:,7)=H1;

a=q(:,263);
b=q(:,264);
digi1=a.*256 +b;    % data_temp_sht75_2
a=q(:,265);
b=q(:,266);
digi2=a.*256 +b;

T1 = -45 + 175.*digi1./(2^16-1);
H1 =100.*digi2./(2^16-1);
Result.TH(:,4)=digi1;
Result.TH(:,5)=digi2;

Result.TH(:,8)=T1;
Result.TH(:,9)=H1;


Result.Pattern(:,6)=q(:,267);
Result.Pattern(:,7)=q(:,268);
%
%
%% PT100
a=dec2bin(q(:,269),8);
b=dec2bin(q(:,270),8);
a2=[a b];
a2=a2-'0';

a3=sum(a2(:,2:9).*2.^repmat((7:-1:0),size(a2,1),1),2);
a4=[zeros(size(a2,1),1) a2(:,10:end)];
b3=sum(a4.*2.^repmat((7:-1:0),size(a2,1),1),2);
digi1=a3*128 +b3;    % data_temp_max31865
T2x= digi1./32 - 256;
Result.T2(:,2)=digi1;
Result.T2(:,3)=T2x;
%% Pression statique 2

Result.Pattern(:,8)=q(:,272);

Result.Pattern(:,9)=q(:,273);

a=q(:,274);
b=q(:,275);
pression_brute0=a.*256+b; % Pression Baro1 HCEMO611
a=q(:,276);
b=q(:,277);
pression_brute1=a.*256+b; % Pression Baro1 HCEMO611

val =( 24575 - 2730)/( 1100 - 600);
Result_0 = (pression_brute0 - 2730)/val + 600;
Result_1 = (pression_brute1 - 2730)/val + 600;
%% HDE 2
a=q(:,278);
b=q(:,279);
pression_brute2=a.*256+b;
a=q(:,280);
b=q(:,281);
pression_brute3=a.*256+b;
a=q(:,282);
b=q(:,283);
pression_brute4=a.*256+b;
a=q(:,284);
b=q(:,285);
pression_brute5=a*256+b;

% 									val=( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb
val=( 24575 - 2730)/( 50);  % +/- 50 mb

Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
Result_3 = (pression_brute3 - 2730)/val + (-0);
Result_4 = (pression_brute4 - 2730)/val + (-0);
Result_5 = (pression_brute5 - 2730)/val + (-0);
%% DIFF PRESSURE HCE10 2
a=q(:,286);
b=q(:,287);

pression_brute6 = uint82int16(a,b);

a=q(:,288);
b=q(:,289);
pression_brute7 =uint82int16(a,b);

a=q(:,290);
b=q(:,291);
pression_brute8 = uint82int16(a,b);

a=q(:,292);
b=q(:,293);
pression_brute9 = uint82int16(a,b);
val =( 24575 - 2730)/( 20);
Result_6=(pression_brute6- 2730)./val + (-10)  ; % mb
Result_7=(pression_brute7- 2730)./val + (-10)  ; % mb
Result_8=(pression_brute8- 2730)./val + (-10)  ; % mb
Result_9=(pression_brute9- 2730)./val + (-10)  ; % mb

%% stockage 2
Pressures0_temp(:,2)=pression_brute0;
Pressures1_temp(:,2)=pression_brute1;
Pressures2_temp(:,2)=pression_brute2;
Pressures3_temp(:,2)=pression_brute3;
Pressures4_temp(:,2)=pression_brute4;
Pressures5_temp(:,2)=pression_brute5;
Pressures6_temp(:,2)=pression_brute6;
Pressures7_temp(:,2)=pression_brute7;
Pressures8_temp(:,2)=pression_brute8;
Pressures9_temp(:,2)=pression_brute9;

Result0_temp(:,2)=Result_0;
Result1_temp(:,2)=Result_1;
Result2_temp(:,2)=Result_2;
Result3_temp(:,2)=Result_3;
Result4_temp(:,2)=Result_4;
Result5_temp(:,2)=Result_5;
Result6_temp(:,2)=Result_6;
Result7_temp(:,2)=Result_7;
Result8_temp(:,2)=Result_8;
Result9_temp(:,2)=Result_9;


%% pression statique 3
a=q(:,294);
Result.Pattern(:,10)=a;
a=q(:,295);
Result.Pattern(:,11)=a ;

a=q(:,296);
b=q(:,297);
pression_brute0=a.*256+b;
a=q(:,298);
b=q(:,299);
pression_brute1=a.*256+b;

val=( 24575 - 2730)/( 1100 - 600);
Result_0 = (pression_brute0 - 2730)/val + 600;
Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 3
a=q(:,300);
b=q(:,301);
pression_brute2=a.*256+b;
a=q(:,302);
b=q(:,303);
pression_brute3=a.*256+b;
a=q(:,304);
b=q(:,305);
pression_brute4=a.*256+b;
a=q(:,306);
b=q(:,307);
pression_brute5=a.*256+b;

val=( 24575 - 2730)/( 50);  % +/- 50 mb
Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
Result_3 = (pression_brute3 - 2730)/val + (-0);
Result_4 = (pression_brute4 - 2730)/val + (-0);
Result_5 = (pression_brute5 - 2730)/val + (-0);
%% DIFF PRESSURE HCE10 3
a=q(:,308);
b=q(:,309);

pression_brute6 = uint82int16(a,b);
a=q(:,310);
b=q(:,311);
pression_brute7 = uint82int16(a,b);
a=q(:,312);
b=q(:,313);
pression_brute8 =  uint82int16(a,b);
a=q(:,314);
b=q(:,315);
pression_brute9 = uint82int16(a,b);
val =( 24575 - 2730)/( 20);
Result_6=(pression_brute6- 2730)./val + (-10)  ; % mb
Result_7=(pression_brute7- 2730)./val + (-10)  ; % mb
Result_8=(pression_brute8- 2730)./val + (-10)  ; % mb
Result_9=(pression_brute9- 2730)./val + (-10)  ; % mb


%% Stockage 3
Pressures0_temp(:,3)=pression_brute0;
Pressures1_temp(:,3)=pression_brute1;
Pressures2_temp(:,3)=pression_brute2;
Pressures3_temp(:,3)=pression_brute3;
Pressures4_temp(:,3)=pression_brute4;
Pressures5_temp(:,3)=pression_brute5;
Pressures6_temp(:,3)=pression_brute6;
Pressures7_temp(:,3)=pression_brute7;
Pressures8_temp(:,3)=pression_brute8;
Pressures9_temp(:,3)=pression_brute9;

Result0_temp(:,3)=Result_0;
Result1_temp(:,3)=Result_1;
Result2_temp(:,3)=Result_2;
Result3_temp(:,3)=Result_3;
Result4_temp(:,3)=Result_4;
Result5_temp(:,3)=Result_5;
Result6_temp(:,3)=Result_6;
Result7_temp(:,3)=Result_7;
Result8_temp(:,3)=Result_8;
Result9_temp(:,3)=Result_9;


Result.Pattern(:,12)=q(:,316);
Result.Pattern(:,13)=q(:,317);
%% Pression statique 4
a=q(:,318);
b=q(:,319);
pression_brute0=a.*256+b; % Pression Baro1 HCEMO611
a=q(:,320);
b=q(:,321);
pression_brute1=a.*256+b; % Pression Baro1 HCEMO611

val=( 24575 - 2730)/( 1100 - 600);
Result_0 = (pression_brute0 - 2730)/val + 600;
Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM4
a=q(:,322);
b=q(:,323);
pression_brute2=a*256+b;
a=q(:,324);
b=q(:,325);
pression_brute3=a*256+b;
a=q(:,326);
b=q(:,327);
pression_brute4=a*256+b;
a=q(:,328);
b=q(:,329);
pression_brute5=a.*256+b;

val=( 24575 - 2730)/( 50);  % +/- 50 mb
Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
Result_3 = (pression_brute3 - 2730)/val + (-0);
Result_4 = (pression_brute4 - 2730)/val + (-0);
Result_5 = (pression_brute5 - 2730)/val + (-0);
%% DIFF PRESSURE HCE10 4
a=q(:,330);
b=q(:,331);
pression_brute6 = uint82int16(a,b);

a=q(:,332);
b=q(:,333);
pression_brute7 =uint82int16(a,b);
a=q(:,334);
b=q(:,335);
pression_brute8 = uint82int16(a,b);
a=q(:,336);
b=q(:,337);
pression_brute9 = uint82int16(a,b);
val =( 24575 - 2730)/( 20);
Result_6=(pression_brute6- 2730)./val + (-10)  ; % mb
Result_7=(pression_brute7- 2730)./val + (-10)  ; % mb
Result_8=(pression_brute8- 2730)./val + (-10)  ; % mb
Result_9=(pression_brute9- 2730)./val + (-10)  ; % mb



%% Stockage 4

Pressures0_temp(:,4)=pression_brute0;
Pressures1_temp(:,4)=pression_brute1;
Pressures2_temp(:,4)=pression_brute2;
Pressures3_temp(:,4)=pression_brute3;
Pressures4_temp(:,4)=pression_brute4;
Pressures5_temp(:,4)=pression_brute5;
Pressures6_temp(:,4)=pression_brute6;
Pressures7_temp(:,4)=pression_brute7;
Pressures8_temp(:,4)=pression_brute8;
Pressures9_temp(:,4)=pression_brute9;

Result0_temp(:,4)=Result_0;
Result1_temp(:,4)=Result_1;
Result2_temp(:,4)=Result_2;
Result3_temp(:,4)=Result_3;
Result4_temp(:,4)=Result_4;
Result5_temp(:,4)=Result_5;
Result6_temp(:,4)=Result_6;
Result7_temp(:,4)=Result_7;
Result8_temp(:,4)=Result_8;
Result9_temp(:,4)=Result_9;

Result.Pattern(:,14)=q(:,338);
Result.Pattern(:,15)=q(:,339);
%% Pression statique 5
a=q(:,340);
b=q(:,341);
pression_brute0=a.*256+b; % Pression Baro1 HCEMO611
a=q(:,342);
b=q(:,343);
pression_brute1=a.*256+b; % Pression Baro1 HCEMO611

val=( 24575 - 2730)/( 1100 - 600);
Result_0 = (pression_brute0 - 2730)/val + 600;
Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 5
a=q(:,344);
b=q(:,345);

pression_brute2=a.*256+b;
a=q(:,346);
b=q(:,347);
pression_brute3=a.*256+b;
a=q(:,348);
b=q(:,349);
pression_brute4=a.*256+b;
a=q(:,350);
b=q(:,351);
pression_brute5=a.*256+b;

val=( 24575 - 2730)/( 50);  % +/- 50 mb
Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
Result_3 = (pression_brute3 - 2730)/val + (-0);
Result_4 = (pression_brute4 - 2730)/val + (-0);
Result_5 = (pression_brute5 - 2730)/val + (-0);
%% DIFF PRESSURE HCE10 5
a=q(:,352);
b=q(:,353);

pression_brute6 = uint82int16(a,b);
a=q(:,354);
b=q(:,355);

pression_brute7 = uint82int16(a,b);
a=q(:,356);
b=q(:,357);

pression_brute8 = uint82int16(a,b);
a=q(:,358);
b=q(:,359);

pression_brute9 = uint82int16(a,b);

val =( 24575 - 2730)/( 20);
Result_6=(pression_brute6- 2730)./val + (-10)  ; % mb
Result_7=(pression_brute7- 2730)./val + (-10)  ; % mb
Result_8=(pression_brute8- 2730)./val + (-10)  ; % mb
Result_9=(pression_brute9- 2730)./val + (-10)  ; % mb


%% Stockage

Pressures0_temp(:,5)=pression_brute0;
Pressures1_temp(:,5)=pression_brute1;
Pressures2_temp(:,5)=pression_brute2;
Pressures3_temp(:,5)=pression_brute3;
Pressures4_temp(:,5)=pression_brute4;
Pressures5_temp(:,5)=pression_brute5;
Pressures6_temp(:,5)=pression_brute6;
Pressures7_temp(:,5)=pression_brute7;
Pressures8_temp(:,5)=pression_brute8;
Pressures9_temp(:,5)=pression_brute9;

Result0_temp(:,5)=Result_0;
Result1_temp(:,5)=Result_1;
Result2_temp(:,5)=Result_2;
Result3_temp(:,5)=Result_3;
Result4_temp(:,5)=Result_4;
Result5_temp(:,5)=Result_5;
Result6_temp(:,5)=Result_6;
Result7_temp(:,5)=Result_7;
Result8_temp(:,5)=Result_8;
Result9_temp(:,5)=Result_9;

Result.Pattern(:,16)=q(:,360);
Result.Pattern(:,17)=q(:,361);
%% Pression statique 6
a=q(:,362);
b=q(:,363);
pression_brute0=a.*256+b; % Pression Baro1 HCEMO611
a=q(:,364);
b=q(:,365);
pression_brute1=a.*256+b; % Pression Baro1 HCEMO611

val=( 24575 - 2730)/( 1100 - 600);
Result_0 = (pression_brute0 - 2730)/val + 600;
Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 6
a=q(:,366);
b=q(:,367);
pression_brute2=a.*256+b;
a=q(:,368);
b=q(:,369);
pression_brute3=a.*256+b;
a=q(:,370);
b=q(:,371);
pression_brute4=a.*256+b;
a=q(:,372);
b=q(:,373);
pression_brute5=a.*256+b;

val=( 24575 - 2730)/( 50);  % +/- 50 mb
Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
Result_3 = (pression_brute3 - 2730)/val + (-0);
Result_4 = (pression_brute4 - 2730)/val + (-0);
Result_5 = (pression_brute5 - 2730)/val + (-0);

%% DIFF PRESSURE HCE10 6
a=q(:,374);
b=q(:,375);

pression_brute6 =uint82int16(a,b);
a=q(:,376);
b=q(:,377);

pression_brute7 = uint82int16(a,b);
a=q(:,378);
b=q(:,379);

pression_brute8 =uint82int16(a,b);
a=q(:,380);
b=q(:,381);

pression_brute9 = uint82int16(a,b);
val =( 24575 - 2730)/( 20);
Result_6=(pression_brute6- 2730)./val + (-10)  ; % mb
Result_7=(pression_brute7- 2730)./val + (-10)  ; % mb
Result_8=(pression_brute8- 2730)./val + (-10)  ; % mb
Result_9=(pression_brute9- 2730)./val + (-10)  ; % mb


%% Stockage 6

Pressures0_temp(:,6)=pression_brute0;
Pressures1_temp(:,6)=pression_brute1;
Pressures2_temp(:,6)=pression_brute2;
Pressures3_temp(:,6)=pression_brute3;
Pressures4_temp(:,6)=pression_brute4;
Pressures5_temp(:,6)=pression_brute5;
Pressures6_temp(:,6)=pression_brute6;
Pressures7_temp(:,6)=pression_brute7;
Pressures8_temp(:,6)=pression_brute8;
Pressures9_temp(:,6)=pression_brute9;

Result0_temp(:,6)=Result_0;
Result1_temp(:,6)=Result_1;
Result2_temp(:,6)=Result_2;
Result3_temp(:,6)=Result_3;
Result4_temp(:,6)=Result_4;
Result5_temp(:,6)=Result_5;
Result6_temp(:,6)=Result_6;
Result7_temp(:,6)=Result_7;
Result8_temp(:,6)=Result_8;
Result9_temp(:,6)=Result_9;

Result.Pattern(:,18)=q(:,382);

Result.Pattern(:,19)=q(:,383);
%% pression statique 7
a=q(:,384);
b=q(:,385);
pression_brute0=a.*256+b; % Pression Baro1 HCEMO611
a=q(:,386);
b=q(:,387);
pression_brute1=a.*256+b; % Pression Baro1 HCEMO611

val=( 24575 - 2730)/( 1100 - 600);
Result_0 = (pression_brute0 - 2730)/val + 600;
Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 7
a=q(:,388);
b=q(:,389);
pression_brute2=a.*256+b;
a=q(:,390);
b=q(:,391);
pression_brute3=a.*256+b;
a=q(:,392);
b=q(:,393);
pression_brute4=a.*256+b;
a=q(:,394);
b=q(:,395);
pression_brute5=a*256+b;

val=( 24575 - 2730)/( 50);  % +/- 50 mb
Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
Result_3 = (pression_brute3 - 2730)/val + (-0);
Result_4 = (pression_brute4 - 2730)/val + (-0);
Result_5 = (pression_brute5 - 2730)/val + (-0);
%% DIFF PRESSURE HCE10 7
a=q(:,396);
b=q(:,397);

pression_brute6 =uint82int16(a,b);
a=q(:,398);
b=q(:,399);

pression_brute7 = uint82int16(a,b);
a=q(:,400);
b=q(:,401);

pression_brute8 = uint82int16(a,b);
a=q(:,402);
b=q(:,403);

pression_brute9 = uint82int16(a,b);
val =( 24575 - 2730)/( 20);
Result_6=(pression_brute6- 2730)./val + (-10)  ; % mb
Result_7=(pression_brute7- 2730)./val + (-10)  ; % mb
Result_8=(pression_brute8- 2730)./val + (-10)  ; % mb
Result_9=(pression_brute9- 2730)./val + (-10)  ; % mb



%% Stockage 7
Pressures0_temp(:,7)=pression_brute0;
Pressures1_temp(:,7)=pression_brute1;
Pressures2_temp(:,7)=pression_brute2;
Pressures3_temp(:,7)=pression_brute3;
Pressures4_temp(:,7)=pression_brute4;
Pressures5_temp(:,7)=pression_brute5;
Pressures6_temp(:,7)=pression_brute6;
Pressures7_temp(:,7)=pression_brute7;
Pressures8_temp(:,7)=pression_brute8;
Pressures9_temp(:,7)=pression_brute9;

Result0_temp(:,7)=Result_0;
Result1_temp(:,7)=Result_1;
Result2_temp(:,7)=Result_2;
Result3_temp(:,7)=Result_3;
Result4_temp(:,7)=Result_4;
Result5_temp(:,7)=Result_5;
Result6_temp(:,7)=Result_6;
Result7_temp(:,7)=Result_7;
Result8_temp(:,7)=Result_8;
Result9_temp(:,7)=Result_9;
%

Result.Pattern(:,20)=q(:,404);
Result.Pattern(:,21)=q(:,405);
%% Pression statique 8
a=q(:,406);
b=q(:,407);
pression_brute0=a*256+b; % Pression Baro1 HCEMO611
a=q(:,408);
b=q(:,409);
pression_brute1=a*256+b; % Pression Baro1 HCEMO611

val=( 24575 - 2730)/( 1100 - 600);
Result_0 = (pression_brute0 - 2730)/val + 600;
Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 8
a=q(:,410);
b=q(:,411);
pression_brute2=a*256+b;
a=q(:,412);
b=q(:,413);
pression_brute3=a*256+b;
a=q(:,414);
b=q(:,415);
pression_brute4=a*256+b;
a=q(:,416);
b=q(:,417);
pression_brute5=a*256+b;

val=( 24575 - 2730)/( 50);  % +/- 50 mb
Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
Result_3 = (pression_brute3 - 2730)/val + (-0);
Result_4 = (pression_brute4 - 2730)/val + (-0);
Result_5 = (pression_brute5 - 2730)/val + (-0);

%% DIFF PRESSURE HCE10 8
a=q(:,418);
b=q(:,419);

pression_brute6 =uint82int16(a,b);
a=q(:,420);
b=q(:,421);

pression_brute7 = uint82int16(a,b);
a=q(:,422);
b=q(:,423);

pression_brute8 = uint82int16(a,b);
a=q(:,424);
b=q(:,425);

pression_brute9 = uint82int16(a,b);
val =( 24575 - 2730)/( 20);
Result_6=(pression_brute6- 2730)./val + (-10)  ; % mb
Result_7=(pression_brute7- 2730)./val + (-10)  ; % mb
Result_8=(pression_brute8- 2730)./val + (-10)  ; % mb
Result_9=(pression_brute9- 2730)./val + (-10)  ; % mb



%% Stockage 	8
Pressures0_temp(:,8)=pression_brute0;
Pressures1_temp(:,8)=pression_brute1;
Pressures2_temp(:,8)=pression_brute2;
Pressures3_temp(:,8)=pression_brute3;
Pressures4_temp(:,8)=pression_brute4;
Pressures5_temp(:,8)=pression_brute5;
Pressures6_temp(:,8)=pression_brute6;
Pressures7_temp(:,8)=pression_brute7;
Pressures8_temp(:,8)=pression_brute8;
Pressures9_temp(:,8)=pression_brute9;

Result0_temp(:,8)=Result_0;
Result1_temp(:,8)=Result_1;
Result2_temp(:,8)=Result_2;
Result3_temp(:,8)=Result_3;
Result4_temp(:,8)=Result_4;
Result5_temp(:,8)=Result_5;
Result6_temp(:,8)=Result_6;
Result7_temp(:,8)=Result_7;
Result8_temp(:,8)=Result_8;
Result9_temp(:,8)=Result_9;

Result.Pattern(:,22)=q(:,426);
Result.Pattern(:,23)=q(:,427);
%% Pression statique 9
a=q(:,428);
b=q(:,429);
pression_brute0=a.*256+b; % Pression Baro1 HCEMO611
a=q(:,430);
b=q(:,431);
pression_brute1=a*256+b; % Pression Baro1 HCEMO611

val=( 24575 - 2730)/( 1100 - 600);
Result_0 = (pression_brute0 - 2730)/val + 600;
Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 9
a=q(:,432);
b=q(:,433);
pression_brute2=a*256+b;
a=q(:,434);
b=q(:,435);
pression_brute3=a*256+b;
a=q(:,436);
b=q(:,437);
pression_brute4=a*256+b;
a=q(:,438);
b=q(:,439);
pression_brute5=a*256+b;

val=( 24575 - 2730)/( 50);  % +/- 50 mb
Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
Result_3 = (pression_brute3 - 2730)/val + (-0);
Result_4 = (pression_brute4 - 2730)/val + (-0);
Result_5 = (pression_brute5 - 2730)/val + (-0);
%% DIFF PRESSURE HCE10 9
a=q(:,440);
b=q(:,441);

pression_brute6 = uint82int16(a,b);
a=q(:,442);
b=q(:,443);

pression_brute7 = uint82int16(a,b);
a=q(:,444);
b=q(:,445);

pression_brute8 = uint82int16(a,b);
a=q(:,446);
b=q(:,447);

pression_brute9 = uint82int16(a,b);
val =( 24575 - 2730)/( 20);
Result_6=(pression_brute6- 2730)./val + (-10)  ; % mb
Result_7=(pression_brute7- 2730)./val + (-10)  ; % mb
Result_8=(pression_brute8- 2730)./val + (-10)  ; % mb
Result_9=(pression_brute9- 2730)./val + (-10)  ; % mb


%% Stockage 9


Pressures0_temp(:,9)=pression_brute0;
Pressures1_temp(:,9)=pression_brute1;
Pressures2_temp(:,9)=pression_brute2;
Pressures3_temp(:,9)=pression_brute3;
Pressures4_temp(:,9)=pression_brute4;
Pressures5_temp(:,9)=pression_brute5;
Pressures6_temp(:,9)=pression_brute6;
Pressures7_temp(:,9)=pression_brute7;
Pressures8_temp(:,9)=pression_brute8;
Pressures9_temp(:,9)=pression_brute9;

Result0_temp(:,9)=Result_0;
Result1_temp(:,9)=Result_1;
Result2_temp(:,9)=Result_2;
Result3_temp(:,9)=Result_3;
Result4_temp(:,9)=Result_4;
Result5_temp(:,9)=Result_5;
Result6_temp(:,9)=Result_6;
Result7_temp(:,9)=Result_7;
Result8_temp(:,9)=Result_8;
Result9_temp(:,9)=Result_9;

Result.Pattern(:,24)=q(:,448);

Result.Pattern(:,25)=q(:,449);
%% Pression statique 10
a=q(:,450);
b=q(:,451);
pression_brute0=a.*256+b; % Pression Baro1 HCEMO611
a=q(:,452);
b=q(:,453);
pression_brute1=a.*256+b; % Pression Baro1 HCEMO611

val=( 24575 - 2730)/( 1100 - 600);
Result_0 = (pression_brute0 - 2730)/val + 600;
Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 10
a=q(:,454);
b=q(:,455);
pression_brute2=a.*256+b;
a=q(:,456);
b=q(:,457);
pression_brute3=a.*256+b;
a=q(:,458);
b=q(:,459);
pression_brute4=a.*256+b;
a=q(:,460);
b=q(:,461);
pression_brute5=a.*256+b;

val=( 24575 - 2730)/( 50);  % +/- 50 mb
Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
Result_3 = (pression_brute3 - 2730)/val + (-0);
Result_4 = (pression_brute4 - 2730)/val + (-0);
Result_5 = (pression_brute5 - 2730)/val + (-0);
%% DIFF PRESSURE HCE10 10
a=q(:,462);
b=q(:,463);

pression_brute6 = uint82int16(a,b);
a=q(:,464);
b=q(:,465);

pression_brute7 = uint82int16(a,b);
a=q(:,466);
b=q(:,467);

pression_brute8 = uint82int16(a,b);
a=q(:,468);
b=q(:,469);

pression_brute9 = uint82int16(a,b);
val =( 24575 - 2730)/( 20);
Result_6=(pression_brute6- 2730)./val + (-10)  ; % mb
Result_7=(pression_brute7- 2730)./val + (-10)  ; % mb
Result_8=(pression_brute8- 2730)./val + (-10)  ; % mb
Result_9=(pression_brute9- 2730)./val + (-10)  ; % mb


%% Stockage 10

Pressures0_temp(:,10)=pression_brute0;
Pressures1_temp(:,10)=pression_brute1;
Pressures2_temp(:,10)=pression_brute2;
Pressures3_temp(:,10)=pression_brute3;
Pressures4_temp(:,10)=pression_brute4;
Pressures5_temp(:,10)=pression_brute5;
Pressures6_temp(:,10)=pression_brute6;
Pressures7_temp(:,10)=pression_brute7;
Pressures8_temp(:,10)=pression_brute8;
Pressures9_temp(:,10)=pression_brute9;

Result0_temp(:,10)=Result_0;
Result1_temp(:,10)=Result_1;
Result2_temp(:,10)=Result_2;
Result3_temp(:,10)=Result_3;
Result4_temp(:,10)=Result_4;
Result5_temp(:,10)=Result_5;
Result6_temp(:,10)=Result_6;
Result7_temp(:,10)=Result_7;
Result8_temp(:,10)=Result_8;
Result9_temp(:,10)=Result_9;
Pressures0_temp=Pressures0_temp.';
Pressures1_temp=Pressures1_temp.';
Pressures2_temp=Pressures2_temp.';
Pressures3_temp=Pressures3_temp.';
Pressures4_temp=Pressures4_temp.';
Pressures5_temp=Pressures5_temp.';
Pressures6_temp=Pressures6_temp.';
Pressures7_temp=Pressures7_temp.';
Pressures8_temp=Pressures8_temp.';
Pressures9_temp=Pressures9_temp.';

Result0_temp=Result0_temp.';
Result1_temp=Result1_temp.';
Result2_temp=Result2_temp.';
Result3_temp=Result3_temp.';
Result4_temp=Result4_temp.';
Result5_temp=Result5_temp.';
Result6_temp=Result6_temp.';
Result7_temp=Result7_temp.';
Result8_temp=Result8_temp.';
Result9_temp=Result9_temp.';


Pressures_tempLDE1(:,1)=pression_bruteLDE1_1;
Pressures_tempLDE1(:,2)=pression_bruteLDE1_2;
Pressures_tempLDE1(:,3)=pression_bruteLDE1_3;
Pressures_tempLDE1(:,4)=pression_bruteLDE1_4;
Pressures_tempLDE1(:,5)=pression_bruteLDE1_5;
Pressures_tempLDE1(:,6)=pression_bruteLDE1_6;
Pressures_tempLDE1(:,7)=pression_bruteLDE1_7;
Pressures_tempLDE1(:,8)=pression_bruteLDE1_8;
Pressures_tempLDE1(:,9)=pression_bruteLDE1_9;
Pressures_tempLDE1(:,10)=pression_bruteLDE1_10;

Result_tempLDE1(:,1)=Result_LDE1_1;
Result_tempLDE1(:,2)=Result_LDE1_2;
Result_tempLDE1(:,3)=Result_LDE1_3;
Result_tempLDE1(:,4)=Result_LDE1_4;
Result_tempLDE1(:,5)=Result_LDE1_5;
Result_tempLDE1(:,6)=Result_LDE1_6;
Result_tempLDE1(:,7)=Result_LDE1_7;
Result_tempLDE1(:,8)=Result_LDE1_8;
Result_tempLDE1(:,9)=Result_LDE1_9;
Result_tempLDE1(:,10)=Result_LDE1_10;

Pressures_tempLDE1=Pressures_tempLDE1.';
Result_tempLDE1=Result_tempLDE1.';



PressurestempLDE2(:,1)=pression_bruteLDE2_1;
PressurestempLDE2(:,2)=pression_bruteLDE2_2;
PressurestempLDE2(:,3)=pression_bruteLDE2_3;
PressurestempLDE2(:,4)=pression_bruteLDE2_4;
PressurestempLDE2(:,5)=pression_bruteLDE2_5;
PressurestempLDE2(:,6)=pression_bruteLDE2_6;
PressurestempLDE2(:,7)=pression_bruteLDE2_7;
PressurestempLDE2(:,8)=pression_bruteLDE2_8;
PressurestempLDE2(:,9)=pression_bruteLDE2_9;
PressurestempLDE2(:,10)=pression_bruteLDE2_10;

Result_tempLDE2(:,1)=Result_LDE2_1;
Result_tempLDE2(:,2)=Result_LDE2_2;
Result_tempLDE2(:,3)=Result_LDE2_3;
Result_tempLDE2(:,4)=Result_LDE2_4;
Result_tempLDE2(:,5)=Result_LDE2_5;
Result_tempLDE2(:,6)=Result_LDE2_6;
Result_tempLDE2(:,7)=Result_LDE2_7;
Result_tempLDE2(:,8)=Result_LDE2_8;
Result_tempLDE2(:,9)=Result_LDE2_9;
Result_tempLDE2(:,10)=Result_LDE2_10;

PressurestempLDE2=PressurestempLDE2.';
Result_tempLDE2=Result_tempLDE2.';
%
Result.Pressures(:,2)=Pressures0_temp(:); % Baro
Result.Pressures(:,3)=Pressures1_temp(:); % Baro
Result.Pressures(:,4)=Pressures2_temp(:); % Diff 1 HCE
Result.Pressures(:,5)=Pressures3_temp(:); % Diff 2
Result.Pressures(:,6)=Pressures4_temp(:); % Diff 3
Result.Pressures(:,7)=Pressures5_temp(:); % Diff 4
Result.Pressures(:,8)=Pressures6_temp(:); % Diff 5 LDE
Result.Pressures(:,9)=Pressures7_temp(:); % Diff 6
Result.Pressures(:,10)=Pressures8_temp(:); % Diff 7
Result.Pressures(:,11)=Pressures9_temp(:);  % Diff 8

Result.Pressures(:,12)=Result0_temp(:);  % Baro
Result.Pressures(:,13)=Result1_temp(:);  % Baro
Result.Pressures(:,14)=Result2_temp(:);  % Diff 1 HCE
Result.Pressures(:,15)=Result3_temp(:);  % Diff 2
Result.Pressures(:,16)=Result4_temp(:);  % Diff 3
Result.Pressures(:,17)=Result5_temp(:);  % Diff 4
Result.Pressures(:,18)=Result6_temp(:);  % Diff 5 LDE
Result.Pressures(:,19)=Result7_temp(:);  % Diff 6
Result.Pressures(:,20)=Result8_temp(:);  % Diff 7
Result.Pressures(:,21)=Result9_temp(:);  % Diff 8


Result.Pressures(:,22)=Pressures_tempLDE1(:);  % LDE brut 1
Result.Pressures(:,23)=PressurestempLDE2(:);  % LDE brut 2
Result.Pressures(:,24)=Result_tempLDE1(:);  % LDE 1
Result.Pressures(:,25)=Result_tempLDE2(:);  % LDE 2

Result.Pattern(:,26)=q(:,494);
Result.Pattern(:,27)=q(:,495);
%% DATA MOTUS

a=[q(:,496) q(:,497)];
Compteur=a(:,1)+a(:,2).*2^8;
Compteur2=repmat(Compteur,1,10);
Compteur2=Compteur2.';
Result.AD_NAVIGATION(:,25)=Compteur;
Result.IMU(:,14)=Compteur;
Result.MOTUSRAW(:,14)=Compteur2(:);
Result.MOTUSORI(:,5)=Compteur;
Result.TH(:,10)= Compteur;
Result.T2(:,4)= Compteur;
Result.PaquetAirData(:,9)= Compteur;
Result.AirDataSensors(:,6)= Compteur;
Result.Pressures(:,26)= Compteur2(:);
Result.PaquetWind (:,5)= Compteur;

Result.Pattern(:,28)=q(:,498);

Result.Pattern(:,29)=q(:,499);

a=[q(:,500) q(:,501) q(:,502) q(:,503)];
Compteur=a(:,4)+a(:,3).*2^8+a(:,2).*2^16+a(:,1).*2^24;

Result.AD_NAVIGATION(:,1)=Compteur;
Result.IMU(:,1)=Compteur;

Compteur2=repmat(Compteur,1,10);
Compteur2=Compteur2.';
Result.MOTUSRAW(:,1)=Compteur2(:);
Result.MOTUSORI(:,1)=Compteur;
Result.TH(:,1)= Compteur;
Result.T2(:,1)= Compteur;
Result.PaquetAirData(:,1)= Compteur;
Result.AirDataSensors(:,1)= Compteur;
Result.Pressures(:,1)= Compteur2(:);
Result.PaquetWind (:,1)= Compteur;


Result.Pattern(:,30)=q(:,504);
Result.Pattern(:,31)=q(:,505);

Result.AD_NAVIGATION(:,26) = ((Result.AD_NAVIGATION(:,4)*1e6)+ Result.AD_NAVIGATION(:,5))./1e3;
Result.IMU(:,15)=((Result.AD_NAVIGATION(:,4)*1e6)+ Result.AD_NAVIGATION(:,5))./1e3;

Result_adnav=repmat(((Result.AD_NAVIGATION(:,4)*1e6)+ Result.AD_NAVIGATION(:,5))./1e3,1,10)+repmat(0:10:90,N,1);
Result_adnav=Result_adnav.';

Result.MOTUSRAW(:,15)=Result_adnav(:);
Result.MOTUSORI(:,6)=((Result.AD_NAVIGATION(:,4)*1e6)+ Result.AD_NAVIGATION(:,5))/1e3;
Result.TH(:,11)= ((Result.AD_NAVIGATION(:,4)*1e6)+ Result.AD_NAVIGATION(:,5))/1e3;
Result.T2(:,5)= ((Result.AD_NAVIGATION(:,4)*1e6)+ Result.AD_NAVIGATION(:,5))/1e3;
Result.Pressures(:,27)=Result_adnav(:);

Result.PaquetAirData(:,10)=((Result.AD_NAVIGATION(:,4)*1e6)+ Result.AD_NAVIGATION(:,5))/1e3;
Result.PaquetWind (:,6)=((Result.AD_NAVIGATION(:,4)*1e6)+ Result.AD_NAVIGATION(:,5))/1e3;
Result.AirDataSensors(:,7)=((Result.AD_NAVIGATION(:,4)*1e6)+ Result.AD_NAVIGATION(:,5))/1e3;


Result.Pattern(:,32)=q(:,511);

Result.Pattern(:,33)=q(:,512);

a=[q(:,513) q(:,514) q(:,515) q(:,516)];
b=dec2single(a);

RAW0_temp(:,1)=b; % Xaccl
a=[q(:,517) q(:,518) q(:,519) q(:,520)];
b=dec2single(a);
RAW1_temp(:,1)=b; % Yaccl
a=[q(:,521) q(:,522) q(:,523) q(:,524)];
b=dec2single(a);
RAW2_temp(:,1)=b;  % Zaccl
a=[q(:,525) q(:,526) q(:,527) q(:,528)];
b=dec2single(a);
RAW3_temp(:,1)=b;  % Xgyro
a=[q(:,529) q(:,530) q(:,531) q(:,532)];
b=dec2single(a);
RAW4_temp(:,1)=b; % Ygyro
a=[q(:,533) q(:,534) q(:,535) q(:,536)];
b=dec2single(a);
RAW5_temp(:,1)=b;  % Zgyro
a=[q(:,537) q(:,538) q(:,539) q(:,540)];
b=dec2single(a);
RAW6_temp(:,1)=b;  % Xmagn
a=[q(:,541) q(:,542) q(:,543) q(:,544)];
b=dec2single(a);
RAW7_temp(:,1)=b;  % Ymagn
a=[q(:,545) q(:,546) q(:,547) q(:,548)];
b=dec2single(a);
RAW8_temp(:,1)=b; % Zmagn
a=[q(:,549) q(:,550) q(:,551) q(:,552)];
b=dec2single(a);
RAW9_temp(:,1)=b; % IMUTemperatureIMU
a=[q(:,553) q(:,554) q(:,555) q(:,556)];
b=dec2single(a);
RAW10_temp(:,1)=b;  % Barometer
a=[q(:,557) q(:,558) q(:,559) q(:,560)];
b=dec2single(a);
RAW11_temp(:,1)=b;  % TemperaturePressure


Result.Pattern(:,34)=q(:,561);
Result.Pattern(:,35)=q(:,562);

a=[q(:,563) q(:,564) q(:,565) q(:,566)];
b=dec2single(a);
RAW0_temp(:,2)=b; % Xaccl
a=[q(:,567) q(:,568) q(:,569) q(:,570)];
b=dec2single(a);
RAW1_temp(:,2)=b; % Yaccl
a=[q(:,571) q(:,572) q(:,573) q(:,574)];
b=dec2single(a);
RAW2_temp(:,2)=b;
a=[q(:,575) q(:,576) q(:,577) q(:,578)];
b=dec2single(a);
RAW3_temp(:,2)=b;
a=[q(:,579) q(:,580) q(:,581) q(:,582)];
b=dec2single(a);
RAW4_temp(:,2)=b;
a=[q(:,583) q(:,584) q(:,585) q(:,586)];
b=dec2single(a);
RAW5_temp(:,2)=b;
a=[q(:,587) q(:,588) q(:,589) q(:,590)];
b=dec2single(a);
RAW6_temp(:,2)=b;
a=[q(:,591) q(:,592) q(:,593) q(:,594)];
b=dec2single(a);
RAW7_temp(:,2)=b;
a=[q(:,595) q(:,596) q(:,597) q(:,598)];
b=dec2single(a);
RAW8_temp(:,2)=b;
a=[q(:,599) q(:,600) q(:,601) q(:,602)];
b=dec2single(a);
RAW9_temp(:,2)=b;
a=[q(:,603) q(:,604) q(:,605) q(:,606)];
b=dec2single(a);
RAW10_temp(:,2)=b;
a=[q(:,607) q(:,608) q(:,609) q(:,610)];
b=dec2single(a);
RAW11_temp(:,2)=b;  % TemperaturePressure


Result.Pattern(:,36)=q(:,611);
Result.Pattern(:,37)=q(:,612);

a=[q(:,613) q(:,614) q(:,615) q(:,616)];
b=dec2single(a);
RAW0_temp(:,3)=b; % Xaccl
a=[q(:,617) q(:,618) q(:,619) q(:,620)];
b=dec2single(a);
RAW1_temp(:,3)=b;
a=[q(:,621) q(:,622) q(:,623) q(:,624)];
b=dec2single(a);
RAW2_temp(:,3)=b;
a=[q(:,625) q(:,626) q(:,627) q(:,628)];
b=dec2single(a);
RAW3_temp(:,3)=b;
a=[q(:,629) q(:,630) q(:,631) q(:,632)];
b=dec2single(a);
RAW4_temp(:,3)=b;
a=[q(:,633) q(:,634) q(:,635) q(:,636)];
b=dec2single(a);
RAW5_temp(:,3)=b;
a=[q(:,637) q(:,638) q(:,639) q(:,640)];
b=dec2single(a);
RAW6_temp(:,3)=b;
a=[q(:,641) q(:,642) q(:,643) q(:,644)];
b=dec2single(a);
RAW7_temp(:,3)=b;
a=[q(:,645) q(:,646) q(:,647) q(:,648)];
b=dec2single(a);
RAW8_temp(:,3)=b;
a=[q(:,649) q(:,650) q(:,651) q(:,652)];
b=dec2single(a);
RAW9_temp(:,3)=b;  % IMUTemperatureIMU
a=[q(:,653) q(:,654) q(:,655) q(:,656)];
b=dec2single(a);
RAW10_temp(:,3)=b;  % Barometer
a=[q(:,657) q(:,658) q(:,659) q(:,660)];
b=dec2single(a);
RAW11_temp(:,3)=b; % TemperaturePressure


Result.Pattern(:,38)=q(:,661);
Result.Pattern(:,39)=q(:,662);

a=[q(:,663) q(:,664) q(:,665) q(:,666)];
b=dec2single(a);
RAW0_temp(:,4)=b; % Xaccl
a=[q(:,667) q(:,668) q(:,669) q(:,670)];
b=dec2single(a);
RAW1_temp(:,4)=b; % Yaccl
a=[q(:,671) q(:,672) q(:,673) q(:,674)];
b=dec2single(a);
RAW2_temp(:,4)=b;  % Zaccl
a=[q(:,675) q(:,676) q(:,677) q(:,678)];
b=dec2single(a);
RAW3_temp(:,4)=b;   % Xgyro
a=[q(:,679) q(:,680) q(:,681) q(:,682)];
b=dec2single(a);
RAW4_temp(:,4)=b;   % Ygyro
a=[q(:,683) q(:,684) q(:,685) q(:,686)];
b=dec2single(a);
RAW5_temp(:,4)=b;   % Zgyro
a=[q(:,687) q(:,688) q(:,689) q(:,690)];
b=dec2single(a);
RAW6_temp(:,4)=b;   % Xmagn
a=[q(:,691) q(:,692) q(:,693) q(:,694)];
b=dec2single(a);
RAW7_temp(:,4)=b;   % Ymagn
a=[q(:,695) q(:,696) q(:,697) q(:,698)];
b=dec2single(a);
RAW8_temp(:,4)=b;  % Zmagn
a=[q(:,699) q(:,700) q(:,701) q(:,702)];
b=dec2single(a);
RAW9_temp(:,4)=b;  % IMUTemperatureIMU
a=[q(:,703) q(:,704) q(:,705) q(:,706)];
b=dec2single(a);
RAW10_temp(:,4)=b;  % Barometer
a=[q(:,707) q(:,708) q(:,709) q(:,710)];
b=dec2single(a);
RAW11_temp(:,4)=b;  % TemperaturePressure


Result.Pattern(:,40)=q(:,711);
Result.Pattern(:,41)=q(:,712);

a=[q(:,713) q(:,714) q(:,715) q(:,716)];
b=dec2single(a);
RAW0_temp(:,5)=b; % Xaccl
a=[q(:,717) q(:,718) q(:,719) q(:,720)];
b=dec2single(a);
RAW1_temp(:,5)=b; % Yaccl
a=[q(:,721) q(:,722) q(:,723) q(:,724)];
b=dec2single(a);
RAW2_temp(:,5)=b;  % Zaccl
a=[q(:,725) q(:,726) q(:,727) q(:,728)];
b=dec2single(a);
RAW3_temp(:,5)=b;
a=[q(:,729) q(:,730) q(:,731) q(:,732)];
b=dec2single(a);
RAW4_temp(:,5)=b;
a=[q(:,733) q(:,734) q(:,735) q(:,736)];
b=dec2single(a);
RAW5_temp(:,5)=b;
a=[q(:,737) q(:,738) q(:,739) q(:,740)];
b=dec2single(a);
RAW6_temp(:,5)=b;
a=[q(:,741) q(:,742) q(:,743) q(:,744)];
b=dec2single(a);
RAW7_temp(:,5)=b;
a=[q(:,745) q(:,746) q(:,747) q(:,748)];
b=dec2single(a);
RAW8_temp(:,5)=b;
a=[q(:,749) q(:,750) q(:,751) q(:,752)];
b=dec2single(a);
RAW9_temp(:,5)=b;
a=[q(:,753) q(:,754) q(:,755) q(:,756)];
b=dec2single(a);
RAW10_temp(:,5)=b;
a=[q(:,757) q(:,758) q(:,759) q(:,760)];
b=dec2single(a);
RAW11_temp(:,5)=b; % TemperaturePressure
%

Result.Pattern(:,42)=q(:,761);
Result.Pattern(:,43)=q(:,762);

a=[q(:,763) q(:,764) q(:,765) q(:,766)];
b=dec2single(a);
RAW0_temp(:,6)=b; % Xaccl
a=[q(:,767) q(:,768) q(:,769) q(:,770)];
b=dec2single(a);
RAW1_temp(:,6)=b; % Yaccl
a=[q(:,771) q(:,772) q(:,773) q(:,774)];
b=dec2single(a);
RAW2_temp(:,6)=b;
a=[q(:,775) q(:,776) q(:,777) q(:,778)];
b=dec2single(a);
RAW3_temp(:,6)=b;
a=[q(:,779) q(:,780) q(:,781) q(:,782)];
b=dec2single(a);
RAW4_temp(:,6)=b;
a=[q(:,783) q(:,784) q(:,785) q(:,786)];
b=dec2single(a);
RAW5_temp(:,6)=b;
a=[q(:,787) q(:,788) q(:,789) q(:,790)];
b=dec2single(a);
RAW6_temp(:,6)=b;
a=[q(:,791) q(:,792) q(:,793) q(:,794)];
b=dec2single(a);
RAW7_temp(:,6)=b;
a=[q(:,795) q(:,796) q(:,797) q(:,798)];
b=dec2single(a);
RAW8_temp(:,6)=b;
a=[q(:,799) q(:,800) q(:,801) q(:,802)];
b=dec2single(a);
RAW9_temp(:,6)=b;
a=[q(:,803) q(:,804) q(:,805) q(:,806)];
b=dec2single(a);
RAW10_temp(:,6)=b;
a=[q(:,807) q(:,808) q(:,809) q(:,810)];
b=dec2single(a);
RAW11_temp(:,6)=b;


Result.Pattern(:,44)=q(:,811);
Result.Pattern(:,45)=q(:,812);

a=[q(:,813) q(:,814) q(:,815) q(:,816)];
b=dec2single(a);
RAW0_temp(:,7)=b;
a=[q(:,817) q(:,818) q(:,819) q(:,820)];
b=dec2single(a);
RAW1_temp(:,7)=b;
a=[q(:,821) q(:,822) q(:,823) q(:,824)];
b=dec2single(a);
RAW2_temp(:,7)=b;
a=[q(:,825) q(:,826) q(:,827) q(:,828)];
b=dec2single(a);
RAW3_temp(:,7)=b;
a=[q(:,829) q(:,830) q(:,831) q(:,832)];
b=dec2single(a);
RAW4_temp(:,7)=b;
a=[q(:,833) q(:,834) q(:,835) q(:,836)];
b=dec2single(a);
RAW5_temp(:,7)=b;
a=[q(:,837) q(:,838) q(:,839) q(:,840)];
b=dec2single(a);
RAW6_temp(:,7)=b;
a=[q(:,841) q(:,842) q(:,843) q(:,844)];
b=dec2single(a);
RAW7_temp(:,7)=b;
a=[q(:,845) q(:,846) q(:,847) q(:,848)];
b=dec2single(a);
RAW8_temp(:,7)=b;
a=[q(:,849) q(:,850) q(:,851) q(:,852)];
b=dec2single(a);
RAW9_temp(:,7)=b; % IMUTemperatureIMU
a=[q(:,853) q(:,854) q(:,855) q(:,856)];
b=dec2single(a);
RAW10_temp(:,7)=b; % Barometer
a=[q(:,857) q(:,858) q(:,859) q(:,860)];
b=dec2single(a);
RAW11_temp(:,7)=b; % TemperaturePressure


Result.Pattern(:,46)=q(:,861);
Result.Pattern(:,47)=q(:,862);

a=[q(:,863) q(:,864) q(:,865) q(:,866)];
b=dec2single(a);
RAW0_temp(:,8)=b; % Xaccl
a=[q(:,867) q(:,868) q(:,869) q(:,870)];
b=dec2single(a);
RAW1_temp(:,8)=b; % Yaccl
a=[q(:,871) q(:,872) q(:,873) q(:,874)];
b=dec2single(a);
RAW2_temp(:,8)=b;
a=[q(:,875) q(:,876) q(:,877) q(:,878)];
b=dec2single(a);
RAW3_temp(:,8)=b;
a=[q(:,879) q(:,880) q(:,881) q(:,882)];
b=dec2single(a);
RAW4_temp(:,8)=b;
a=[q(:,883) q(:,884) q(:,885) q(:,886)];
b=dec2single(a);
RAW5_temp(:,8)=b;
a=[q(:,887) q(:,888) q(:,889) q(:,890)];
b=dec2single(a);
RAW6_temp(:,8)=b;
a=[q(:,891) q(:,892) q(:,893) q(:,894)];
b=dec2single(a);
RAW7_temp(:,8)=b;
a=[q(:,895) q(:,896) q(:,897) q(:,898)];
b=dec2single(a);
RAW8_temp(:,8)=b;
a=[q(:,899) q(:,900) q(:,901) q(:,902)];
b=dec2single(a);
RAW9_temp(:,8)=b;
a=[q(:,903) q(:,904) q(:,905) q(:,906)];
b=dec2single(a);
RAW10_temp(:,8)=b;
a=[q(:,907) q(:,908) q(:,909) q(:,910)];
b=dec2single(a);
RAW11_temp(:,8)=b;

Result.Pattern(:,48)=q(:,911);
Result.Pattern(:,49)=q(:,912);

a=[q(:,913) q(:,914) q(:,915) q(:,916)];
b=dec2single(a);
RAW0_temp(:,9)=b;
a=[q(:,917) q(:,918) q(:,919) q(:,920)];
b=dec2single(a);
RAW1_temp(:,9)=b;
a=[q(:,921) q(:,922) q(:,923) q(:,924)];
b=dec2single(a);
RAW2_temp(:,9)=b;
a=[q(:,925) q(:,926) q(:,927) q(:,928)];
b=dec2single(a);
RAW3_temp(:,9)=b;
a=[q(:,929) q(:,930) q(:,931) q(:,932)];
b=dec2single(a);
RAW4_temp(:,9)=b;
a=[q(:,933) q(:,934) q(:,935) q(:,936)];
b=dec2single(a);
RAW5_temp(:,9)=b;
a=[q(:,937) q(:,938) q(:,939) q(:,940)];
b=dec2single(a);
RAW6_temp(:,9)=b;
a=[q(:,941) q(:,942) q(:,943) q(:,944)];
b=dec2single(a);
RAW7_temp(:,9)=b;
a=[q(:,945) q(:,946) q(:,947) q(:,948)];
b=dec2single(a);
RAW8_temp(:,9)=b;
a=[q(:,949) q(:,950) q(:,951) q(:,952)];
b=dec2single(a);
RAW9_temp(:,9)=b;
a=[q(:,953) q(:,954) q(:,955) q(:,956)];
b=dec2single(a);
RAW10_temp(:,9)=b;
a=[q(:,957) q(:,958) q(:,959) q(:,960)];
b=dec2single(a);
RAW11_temp(:,9)=b;
%

Result.Pattern(:,50)=q(:,961);
Result.Pattern(:,51)=q(:,962);

a=[q(:,963) q(:,964) q(:,965) q(:,966)];
b=dec2single(a);
RAW0_temp(:,10)=b; % Xaccl
a=[q(:,667) q(:,968) q(:,969) q(:,970)];
b=dec2single(a);
RAW1_temp(:,10)=b; % Yaccl
a=[q(:,971) q(:,972) q(:,973) q(:,974)];
b=dec2single(a);
RAW2_temp(:,10)=b;  % Zaccl
a=[q(:,975) q(:,976) q(:,977) q(:,978)];
b=dec2single(a);
RAW3_temp(:,10)=b;  % Xgyro
a=[q(:,979) q(:,980) q(:,981) q(:,982)];
b=dec2single(a);
RAW4_temp(:,10)=b;  % Ygyro
a=[q(:,983) q(:,984) q(:,985) q(:,986)];
b=dec2single(a);
RAW5_temp(:,10)=b;  % Zgyro
a=[q(:,987) q(:,988) q(:,989) q(:,990)];
b=dec2single(a);
RAW6_temp(:,10)=b;  % Xmagn
a=[q(:,991) q(:,992) q(:,993) q(:,994)];
b=dec2single(a);
RAW7_temp(:,10)=b;  % Ymagn
a=[q(:,995) q(:,996) q(:,997) q(:,998)];
b=dec2single(a);
RAW8_temp(:,10)=b; % Zmagn
a=[q(:,999) q(:,1000) q(:,1001) q(:,1002)];
b=dec2single(a);
RAW9_temp(:,10)=b; % IMUTemperatureIMU
a=[q(:,1003) q(:,1004) q(:,1005) q(:,1006)];
b=dec2single(a);
RAW10_temp(:,10)=b; % Barometer
a=[q(:,1007) q(:,1008) q(:,1009) q(:,1010)];
b=dec2single(a);
RAW11_temp(:,10)=b; % TemperaturePressure

RAW0_temp=RAW0_temp.';
RAW1_temp=RAW1_temp.';
RAW1_temp=RAW1_temp.';
RAW2_temp=RAW2_temp.';
RAW3_temp=RAW3_temp.';
RAW4_temp=RAW4_temp.';
RAW5_temp=RAW5_temp.';
RAW6_temp=RAW6_temp.';
RAW7_temp=RAW7_temp.';
RAW8_temp=RAW8_temp.';
RAW9_temp=RAW9_temp.';
RAW10_temp=RAW10_temp.';
RAW11_temp=RAW11_temp.';

Result.MOTUSRAW(:,2)=RAW0_temp(:);
Result.MOTUSRAW(:,3)=RAW1_temp(:);
Result.MOTUSRAW(:,4)=RAW2_temp(:);
Result.MOTUSRAW(:,5)=RAW3_temp(:);
Result.MOTUSRAW(:,6)=RAW4_temp(:);
Result.MOTUSRAW(:,7)=RAW5_temp(:);
Result.MOTUSRAW(:,8)=RAW6_temp(:);
Result.MOTUSRAW(:,9)=RAW7_temp(:);
Result.MOTUSRAW(:,10)=RAW8_temp(:);
Result.MOTUSRAW(:,11)=RAW9_temp(:);
Result.MOTUSRAW(:,12)=RAW10_temp(:);
Result.MOTUSRAW(:,13)=RAW11_temp(:);


Result.MOTUSRAW(:,16) =((Result.MOTUSRAW(:,2)).^2 +(Result.MOTUSRAW(:,3)).^2 +(Result.MOTUSRAW(:,4)).^2).^0.5;


Result.Pattern(:,52)=q(:,1011);
Result.Pattern(:,53)=q(:,1012);
%
a=[q(:,1013) q(:,1014) q(:,1015) q(:,1016)];
b=dec2single(a);
Result.MOTUSORI(:,2)=b*180/pi;  % Roll
a=[q(:,1017) q(:,1018) q(:,1019) q(:,1020)];
b=dec2single(a);
Result.MOTUSORI(:,3)=b*180/pi;  % Pitch
a=[q(:,1021) q(:,1022) q(:,1023) q(:,1024)];
b=dec2single(a);
Result.MOTUSORI(:,4)=b*180/pi;  % Heading
%% compteur 100hz
a=[q(:,506) q(:,507) q(:,508) q(:,509)];

Compteur=a(:,1)*2^24+a(:,2).*2^16+a(:,3)*2^8+a(:,4);
Result.AD_NAVIGATION(:,end)=Compteur;
Result.PaquetAirData(:,end)=Compteur;
Result.PaquetWind(:,end)=Compteur;
Result.AirDataSensors(:,end)=Compteur;
Result.IMU(:,end)=Compteur;

Result.MOTUSORI(:,end)=Compteur;
Result.TH(:,end)=Compteur;
Result.T2(:,end)=Compteur;

Compteur2=repmat(Compteur,1,10);
Compteur2=Compteur2.';
Result.MOTUSRAW(:,end)=Compteur2(:);
Result.Pressures(:,end)=Compteur2(:);






end




