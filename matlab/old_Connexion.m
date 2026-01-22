function Retour = Connexion( handles )
%CONNEXION Summary of this function goes here
%   Detailed explanation goes here
% handles tranfers parameter values between InterfaceGUI and Connexion

%=============== Selection affichage des  donnees
Voie1_HCEM_DIFF=get(handles.radiobutton1,'Value');
Voie2_LDE_DIFF=get(handles.radiobutton2,'Value');
Voie3_HCEM_STAT=get(handles.radiobutton3,'Value');
Voie4_PRESSION_ABS_ADU=get(handles.radiobutton40,'Value');
Voie5_PRESSION_DIFF_ADU=get(handles.radiobutton41,'Value');

Voie6_Air_speed=get(handles.radiobutton6,'Value');
Voie7_altitude=get(handles.radiobutton7,'Value');

Voie8_wind_velN=get(handles.radiobutton34,'Value');
Voie9_wind_velE=get(handles.radiobutton4,'Value');


Voie11_ROLL_spa=get(handles.radiobutton19,'Value');
Voie12_PITCH_spa=get(handles.radiobutton17,'Value');
Voie13_HEAD_spa=get(handles.radiobutton18,'Value');
Voie14_G=get(handles.radiobutton45,'Value');
Voie11_ROLL_mot=get(handles.radiobutton42,'Value');
Voie12_PITCH_mot=get(handles.radiobutton43,'Value');
Voie13_HEAD_mot=get(handles.radiobutton44,'Value');

Voie14_Temp_SHT1=get(handles.radiobutton36,'Value');
Voie15_Hum_SHT1=get(handles.radiobutton37,'Value');
Voie17_Temp_SHT2=get(handles.radiobutton38,'Value');
Voie18_Hum_SHT2=get(handles.radiobutton39,'Value');
Voie19_PT100=get(handles.radiobutton46,'Value');

Pas_dAffichage=get(handles.radiobutton15,'Value');
Affichage_zoom=get(handles.radiobutton14,'Value');

% Voie9_Spare=get(handles.radiobutton16,'Value');
% Voie14_Spare=get(handles.radiobutton35,'Value');



Range=get(handles.slider1,'Value')
Range_haut=get(handles.slider2,'Value')*100;
Range_bas=get(handles.slider3,'Value')*100


message_affichage='----------------------';
message5='';


BDRATE = 115200;

%============== Initialisation ==============%


AD_NAVIGATION_label={'Time','SystStatus','FilterStatus','Unixtime','MicroSecondes',...
    'Latitude(Rad)','Longitude(Rad)','Height','VitesseNord','VitesseEast','VitesseDown',...
    'Acceleration_X','Acceleration_Y','Acceleration_Z','G','Roll','Pitch','Heading',...
    'AngularVelocity_X','AngularVelocity_Y','AngularVelocity_Z',...
    'LatitudeStandardDeviation','LongitudeStandardDeviation','HeightStandardDeviation','Secondes','TSmilli'};
% AD_NAVIGATION = zeros(floor(length_data/taille_fichier), 26);
AD_NAVIGATION = 0;
%==================================================================% 
%  PaquetGNSS_label={'Time','Unixtime','Microseconds','Latitude(Rad)','Longitude(Rad)','Height',...
%    'VitesseNord','VitesseEast','VitesseDown', 'LatitudeStandardDeviation','LongitudeStandardDeviation','HeightStandardDeviation',...
%    'Reserved','Reserved','Reserved','Reserved','SystStatus','Secondes','TSmilli'};
% PaquetGNSS = zeros(floor(length_data/taille_fichier), 19);
%==================================================================%  
PaquetAirData_label={'Time','BaroRetard(s)','AirSpeedRetard(s)','BaroAltitude(m)','AirSpeed(m/s)',...
    'BaroStandardDeviation(m)','AirSpeedStandardDeviation(m/s)','StatusAirData','Secondes','TSmilli'};
%  PaquetAirData=   zeros(floor(length_data/taille_fichier), 10);
 PaquetAirData=   0;
 PaquetWind=   0;
%==================================================================%
 PaquetWind_label={'Time','WindVelocityNorth(m/s)','WindVelocityEast(m/s)',...
     'WindVelocityStandardDeviation(m/s)','Secondes','TSmilli'};
%  PaquetWind=   zeros(floor(length_data/taille_fichier), 6);
%==================================================================%
 AirDataSensors_label={'Time','AbsolutePressure(Pa)','DifferentialPressure(Pa)',...
     'FlagsRawStatus','Temperature(c)','Secondes','TSmilli'};
%  AirDataSensors=   zeros(floor(length_data/taille_fichier), 7);
 AirDataSensors=  0;
%==================================================================%
% if bitand(whatload, 8)
IMU_label = {'Time','Xaccl', 'Yaccl', 'Zaccl','Xgyro', 'Ygyro', 'Zgyro', 'Xmagn', 'Ymagn', 'Zmagn', 'TemperatureIMU','Barometer','TemperaturePressure','Secondes','TSmilli','QuadSum'};
%    IMU = zeros(floor(length_data/512*10), 12);     %  Il y a 10 valeures par lignes %    
IMU = zeros(1,16);     %  Il y a 10 valeures par lignes 
%  IMU = zeros(floor(length_data/taille_fichier), 15);
 %i_IMU = 1;
 % 2/AA/234 3/BB/235 4/CC/256 5/DD/257 6/EE/266 7/AA/267 8/C0/493 9/01/494
 % 10/C5/497 11/12/498 12/C1/503 13/00/504
Pattern_label = {'Time','AA','BB',...
                'CC','DD','EE','AA',...
                '22','22','33','33','44','44','55','55','66',...
                '66','77','77','88','88','99','99','AA','AA',...
                'C0','01','C5','12','C1','00','BB','BB',...
                'AC','C2','AC','C3','AC','C4','AC','C5','AC','C6',...
                'AC','C7','AC','C8','AC','C9','AC','CA','AB','CD',...
                };
%  Pattern= zeros(floor(length_data/taille_fichier), 53);
 Pattern= 0;
% end
%==================================================================%
MOTUSRAW_label = {'Time','Xaccl', 'Yaccl', 'Zaccl','Xgyro', 'Ygyro', 'Zgyro', 'Xmagn', 'Ymagn', 'Zmagn', 'TemperatureIMU','Barometer','TemperaturePressure','Secondes','TSmilli','QuadSum'};
%    IMU = zeros(floor(length_data/512*10), 12);     %  Il y a 10 valeures par lignes 
%  MOTUSRAW = zeros(floor(length_data/taille_fichier)*10, 15);
 MOTUSRAW = zeros(1,16);

MOTUSORI_label = {'Time','Roll', 'Pitch', 'Heading','Secondes','TSmilli'};
%    IMU = zeros(floor(length_data/512*10), 12);     %  Il y a 10 valeures par lignes 
%  MOTUSORI = zeros(floor(length_data/taille_fichier), 6);
 MOTUSORI = 0;
%==================================================================%
% Modif MIRIAD PressionBaro1, PressionBaro2, PressionPitot         %
%==================================================================%
% if bitand(whatload, 4)
    Pressures_label = {'Time','Data1Baro', 'Data2Baro', 'Data3HCE1','Data4HCE4',....
        'Data5HCE5', 'Data6HCE6', 'Data7LDE1', 'Data8LDE2', 'Data9LDE3','Data10LDE4','Baro1', 'Baro2' ...
        'Pressure1HCE1', 'Pressure2HCE2','Pressure3HCE3', 'Pressure4HCE4','Pressure5LDE1',...
        'Pressure6LDE2', 'Pressure7LDE3','Pressure8LDE4','Secondes','TSmilli'};
%      Pressures = zeros(floor(length_data/taille_fichier)*10, 23);   % Données a 1000Hz
     Pressures = 0;   % Données a 1000Hz
% end

%==================================================================%
% Modif MIRIAD PressionBaro1, PressionBaro2, PressionPitot         %
%==================================================================%
    TH_label = {'Time','digi1','digi2','digi3','digi4', 'Temp1', 'Hum1', 'Temp2', 'Hum2','Secondes','TSmilli'};
%     TH = zeros(floor(length_data/512), 11); % Donnees a 2.5 Hz
    TH = 0; % Donnees a 2.5 Hz
%     i_TH = 1;
    T2_label = {'Time','digi1', 'Temp2','Secondes','Tsmilli'};
%     T2 = zeros(floor(length_data/512), 5);  % Donnees a 10 Hz 
    T2 = 0;  % Donnees a 10 Hz 
%     i_T2 = 1;

% 
% first_char = 0;
% suite_MACC_X=0;
% suite_MACC_Y=0;
% suite_MACC_Z=0;
% suite_MGAUSS_X=0;
% suite_MGAUSS_Y=0;
% suite_MGAUSS_Z=0;
% suite_SACC_X=0;
% suite_SACC_Y=0;
% suite_SACC_Z=0;
% suite_SGAUSS_X=0;
% suite_SGAUSS_Y=0;
% suite_SGAUSS_Z=0;
j=1;
u=0;
%===============================%
suite_q=zeros(1,1024)';%64)';%32)';
boucle=0;
boucle10=0;
%================ Affichage 2D
AFF2D_Temp_Altitude=get(handles.radiobutton14,'Value');  % Affichage Zoom
AFF2D_Hum_Altitude=get(handles.radiobutton15,'Value');

if message5==''
    pouet='coucou';
end

%================ Sauvegarde Donnees
Sauvegarde_Donnees=get(handles.radiobutton13,'Value');
Nom_Fichier=get(handles.edit1,'String');
message5='';

%================ Port Communication
Val2_Com=cellstr(get(handles.listbox1,'String'));
Val_Com=get(handles.listbox1,'value');
PortCom=Val2_Com{Val_Com};
% whos Val2_Com;
% whos Val_Com;
% whos PortCom;
message5='';

%================ Communication ===================%
Test_Connexion=get(handles.pushbutton1,'Value');
Ouvrir_Connexion=get(handles.pushbutton2,'Value');
Fermer_Connexion=get(handles.pushbutton3,'Value');

if Test_Connexion
    v=instrfind
    whos v;
end
%============= Fermer Connexion ===================%
if Fermer_Connexion
    v=instrfind;
    fclose(v);
    %     message5 = 'Liaison ferm�e% \n';
    timeoutVal = 6; % Number of seconds to wait for data before killing the program
    timeout = 0.1;
    DataLenght= 1024;%32;
    s=serial(PortCom,'Baudrate',BDRATE);
    set(s, 'InputBufferSize', 1024);
    fclose(s)
    message5 = sprintf('Liaison Ferm�e% \n');
end


%============= Ouvrir Connexion ===============%
if Ouvrir_Connexion %& (Fermer_Connexion ~= 'false')
    s=serial(PortCom,'Baudrate',BDRATE)
    set(s, 'InputBufferSize', 1024);
    status_connection =' ';
    try
        fopen(s)
    catch ME1
        status_connection = ME1.identifier;
    end
    
    if status_connection == 'MATLAB:serial:fopen:opfailed'
        message5 = sprintf('MATLAB:serial:fopen:opfailed \n');
    else
        set(s,'Timeout',10);   %  modif de 1 a 10
        
        message0 = ' ';
        message1 = sprintf('%sLe numero du port est: #%d\n',message0,Val_Com);
        message5 = sprintf('Liaison ouverte  \n');
        if AFF2D_Temp_Altitude
            message2 = sprintf('Affichage Temp/Altitude \n ');
        else
            message2 = sprintf('Pas affichage Temp/Altitude \n ');
        end
        if AFF2D_Hum_Altitude
            message3 = sprintf('Affichage Hum/Altitude \n ');
        else
            message3 = sprintf('Pas affichage Temp/Altitude \n ');
        end
        if Sauvegarde_Donnees
            message4 = sprintf('Sauvegarde donnees en cours \n ');
        else
            message4 = sprintf('Pas de sauvegarde donnees en cours \n ');
        end
        message = sprintf('%s %s %s %s %s',message1,message2,message3,message4,message5);
        set(handles.text2,'string',message);
        timeoutVal = 6; % Number of seconds to wait for data before killing the program
        timeout = 0;
        fclose(s);
        DataLenght= 1024;  %15 %32;%
        
        
        Pouet=Nom_Fichier{1};
        NomFichier=sprintf('%s.mat',Pouet);
        boucle2=0;
        %
        % Nombre_graph= Num_Voie1_SN1_W+Num_Voie2_SN1_Aux+Num_Voie3_SN1_PPB_Oz+Num_Voie4_SN3_Aux+Num_Voie5_SN3_PPB_NOx+Num_Voie6_SN2_W+Num_Voie7_SN2_Aux+Num_Voie8_SN2_PPB_CO...
        %     +Num_Voie9_Spare+Num_Voie10_TempD+Num_Voie11_Spare+Num_Voie12_TempV
        % Nombre_profils = Num_AFF2D_Temp_Altitude +Num_AFF2D_Hum_Altitude;
        
        s=serial(PortCom,'Baudrate',BDRATE);
        set(s, 'InputBufferSize', 1024);
        fopen(s)
        AirDataSensors_temp=[];
        PaquetWind_temp=[];
        PaquetAirData_temp=[];
        MOTUSORI_temp=[];
        AD_NAVIGATION_temp=[];
        TH_temp=[];
        T2_temp=[];
        
       Q=[];
        if Fermer_Connexion
            first_char = 0;
        else
            
            while (timeout < timeoutVal) && Ouvrir_Connexion  %&& (Fermer_Connexion ~= 'false')
                
                if (s.BytesAvailable > DataLenght-1)
                    timeout = 0;
                    %s.BytesAvailable
                    if (s.TransferStatus == 'idle')
                        %pause(1);
                        
                        %=============== Selection affichage des  donnees

                        Voie1_HCEM_DIFF=get(handles.radiobutton1,'Value');                        
                        Voie2_LDE_DIFF=get(handles.radiobutton2,'Value');                        
                        Voie3_HCEM_STAT=get(handles.radiobutton3,'Value');                        
                        Voie4_PRESSION_ABS_ADU=get(handles.radiobutton40,'Value');                        
                        Voie5_PRESSION_DIFF_ADU=get(handles.radiobutton41,'Value');                      
                        liste_P=[double(Voie1_HCEM_DIFF) double(Voie2_LDE_DIFF) double(Voie5_PRESSION_DIFF_ADU) double(Voie3_HCEM_STAT) double(Voie4_PRESSION_ABS_ADU)  ];
                        
                        Voie6_Air_speed=get(handles.radiobutton6,'Value');                        
                        Voie7_altitude=get(handles.radiobutton7,'Value'); 
                        liste_AS=[double(Voie6_Air_speed) double(Voie7_altitude)];
                        
                        Voie8_wind_velN=get(handles.radiobutton34,'Value');                        
                        Voie9_wind_velE=get(handles.radiobutton4,'Value');                                               
                        liste_WP=[double(Voie8_wind_velN) double(Voie9_wind_velE)];                       
                       
                        
                        Voie11_ROLL_spa=get(handles.radiobutton19,'Value');                        
                        Voie12_PITCH_spa=get(handles.radiobutton17,'Value');                        
                        Voie13_HEAD_spa=get(handles.radiobutton18,'Value');                       
                        Voie14_G=get(handles.radiobutton45,'Value');                        
                        Voie15_ROLL_mot=get(handles.radiobutton42,'Value');                    
                        Voie16_PITCH_mot=get(handles.radiobutton43,'Value');                        
                        Voie17_HEAD_mot=get(handles.radiobutton44,'Value');                  
                        
                        liste_SS=[double(Voie11_ROLL_spa) double(Voie12_PITCH_spa) double(Voie13_HEAD_spa) double(Voie14_G) double(Voie15_ROLL_mot) double(Voie16_PITCH_mot) double(Voie17_HEAD_mot)];
                        
                        Voie18_Temp_SHT1=get(handles.radiobutton36,'Value');                          
                        Voie19_Hum_SHT1=get(handles.radiobutton37,'Value');                        
                        Voie20_Temp_SHT2=get(handles.radiobutton38,'Value');                        
                        Voie21_Hum_SHT2=get(handles.radiobutton39,'Value');                        
                        Voie22_PT100=get(handles.radiobutton46,'Value');
                        
                        liste_TH=[double(Voie18_Temp_SHT1) double(Voie20_Temp_SHT2) double(Voie22_PT100) double(Voie19_Hum_SHT1)  double(Voie21_Hum_SHT2) ];
                        
                        Pas_dAffichage=get(handles.radiobutton15,'Value');
                        Num_Pas_dAffichage=double(Pas_dAffichage);
                        Affichage_zoom=get(handles.radiobutton14,'Value');
%                         Voie9_Spare=get(handles.radiobutton16,'Value');
%                         Voie14_Spare=get(handles.radiobutton35,'Value');


                        Range=fix(get(handles.slider1,'Value'));
                        Range_haut=fix(get(handles.slider2,'Value')*100);
                        Range_bas=fix(get(handles.slider3,'Value')*100);
                        %=============== Selection affichage des  donnees
                        Num_AFF2D_Temp_Altitude=(double(AFF2D_Temp_Altitude));
                        Num_AFF2D_Hum_Altitude=(double(AFF2D_Hum_Altitude));
                        
                        Nombre_graph_P= sum(liste_P(:));                               % figure 1
                        Nombre_graph_AS = sum(liste_AS(:));       % figure 2
                        Nombre_graph_WP =sum(liste_WP(:));                             % figure 3
                        Nombre_graph_SS = sum(liste_SS(:));                        % figure 4
                        Nombre_graph_TH= sum(liste_TH(:));  
                       
                        
                        
                        Pouet=Nom_Fichier{1};
                        NomFichier=sprintf('%s.mat',Pouet);
                        
                        % Nombre_graph= Num_Voie1_SN1_W+Num_Voie2_SN1_Aux+Num_Voie3_SN1_PPB_Oz+Num_Voie4_SN3_Aux+Num_Voie5_SN3_PPB_NOx+Num_Voie6_SN2_W+Num_Voie7_SN2_Aux+Num_Voie8_SN2_PPB_CO...
                        %     +Num_Voie9_Spare+Num_Voie10_TempD+Num_Voie11_Spare+Num_Voie12_TempV
                        % Nombre_profils = Num_AFF2D_Temp_Altitude +Num_AFF2D_Hum_Altitude;
                        
                                                                                     % figure 5
 
                        
                        % figure 4
                        Nombre_de_lignes = Num_AFF2D_Temp_Altitude+1;
                        q=zeros(1024,1);
                        q = fread(s, s.BytesAvailable, 'char');
                        length(q);
                        
                        if length(q)==DataLenght%128 %32
                            if q(235)==170 && q(236)==187 && q(448)==170 && q(449)==170% %On check que toute la trame est correcte%
                                    Q=[Q q];
% 									a=[q(1) q(2)];
% 									AD_NAVIGATION(j,2)=typecast(uint8(a),'uint16');    % SystStatus         
% 									a=[q(3) q(4)];
% 									AD_NAVIGATION(j,3)=typecast(uint8(a),'uint16');    % FilterStatus   
% 									a=[q(5) q(6) q(7) q(8)];
% 									AD_NAVIGATION(j,4)=typecast(uint8(a),'uint32');    % Unixtime      
% 									a=[q(9) q(10) q(11) q(12)];
% 									AD_NAVIGATION(j,5)=typecast(uint8(a),'uint32');    % MicroSecondes  
% 									a=[q(13) q(14) q(15) q(16) q(17) q(18) q(19) q(20)];
% 									AD_NAVIGATION(j,6)=typecast(uint8(a),'double');   % Latitude(Rad)  
% 									a=[q(21) q(22) q(23) q(24) q(25) q(26) q(27) q(28)];
% 									AD_NAVIGATION(j,7)=typecast(uint8(a),'double');   % Longitude(Rad) 
% 									a=[q(29) q(30) q(31) q(32) q(33) q(34) q(35) q(36)];
% 									AD_NAVIGATION(j,8)=typecast(uint8(a),'double');   % Height         
% 									a=[q(37) q(38) q(39) q(40)];
% 									AD_NAVIGATION(j,9)=typecast(uint8(a),'single');   % VitesseNord    
% 									a=[q(41) q(42) q(43) q(44)];
% 									AD_NAVIGATION(j,10)=typecast(uint8(a),'single');  % VitesseEast    
% 									a=[q(45) q(46) q(47) q(48)];
% 									AD_NAVIGATION(j,11)=typecast(uint8(a),'single');  % VitesseDown    
% 									a=[q(49) q(50) q(51) q(52)];
% 									AD_NAVIGATION(j,12)=typecast(uint8(a),'single');  % Acceleration_X 
% 									a=[q(53) q(54) q(55) q(56)];
% 									AD_NAVIGATION(j,13)=typecast(uint8(a),'single');  % Acceleration_Y 
% 									a=[q(57) q(58) q(59) q(60)];
% 									AD_NAVIGATION(j,14)=typecast(uint8(a),'single');  % Acceleration_Z 
									a=[q(61) q(62) q(63) q(64)];
									AD_NAVIGATION(j,15)=typecast(uint8(a),'single');  % G     
									a=[q(65) q(66) q(67) q(68)];
									AD_NAVIGATION(j,16)=typecast(uint8(a),'single')*180/pi;  % Roll  
									a=[q(69) q(70) q(71) q(72)];
									AD_NAVIGATION(j,17)=typecast(uint8(a),'single')*180/pi;  % Pitch  
									a=[q(73) q(74) q(75) q(76)];
									AD_NAVIGATION(j,18)=typecast(uint8(a),'single')*180/pi;  % Heading   
% 									a=[q(77) q(78) q(79) q(80)];
% 									AD_NAVIGATION(j,19)=typecast(uint8(a),'single');  % AngularVelocity_X   
% 									a=[q(81) q(82) q(83) q(84)];
% 									AD_NAVIGATION(j,20)=typecast(uint8(a),'single');  % AngularVelocity_Y   
% 									a=[q(85) q(86) q(87) q(88)];
% 									AD_NAVIGATION(j,21)=typecast(uint8(a),'single');  % AngularVelocity_Z   
% 									a=[q(89) q(90) q(91) q(92)];
% 									AD_NAVIGATION(j,22)=typecast(uint8(a),'single');  % LatitudeStandardDeviation   
% 									a=[q(93) q(94) q(95) q(96)];
% 									AD_NAVIGATION(j,23)=typecast(uint8(a),'single');  % LongitudeStandardDeviation  
% 									a=[q(97) q(98) q(99) q(100)];
% 									AD_NAVIGATION(j,24)=typecast(uint8(a),'single');  % HeightStandardDeviation     
                                    AD_NAVIGATION_temp=[AD_NAVIGATION_temp;repmat( AD_NAVIGATION(end,:),10,1)];   
									a=[q(101) q(102) q(103) q(104)];
									IMU(j,2)=typecast(uint8(a),'single'); % Xaccl   
									a=[q(105) q(106) q(107) q(108)];
									IMU(j,3)=typecast(uint8(a),'single'); % Yaccl   
									a=[q(109) q(110) q(111) q(112)];
									IMU(j,4)=typecast(uint8(a),'single');  % Zaccl   
									a=[q(113) q(114) q(115) q(116)];
									IMU(j,5)=typecast(uint8(a),'single');  % Xgyro   
									a=[q(117) q(118) q(119) q(120)];
									IMU(j,6)=typecast(uint8(a),'single');  % Ygyro   
									a=[q(121) q(122) q(123) q(124)];
									IMU(j,7)=typecast(uint8(a),'single');  % Zgyro   
									a=[q(125) q(126) q(127) q(128)];
									IMU(j,8)=typecast(uint8(a),'single');  % Xmagn   
									a=[q(129) q(130) q(131) q(132)];
									IMU(j,9)=typecast(uint8(a),'single');  % Ymagn   
									a=[q(133) q(134) q(135) q(136)];
									IMU(j,10)=typecast(uint8(a),'single'); % Zmagn   
									a=[q(137) q(138) q(139) q(140)];
									IMU(j,11)=typecast(uint8(a),'single'); % IMUTemperatureIMU  
									a=[q(141) q(142) q(143) q(144)];
									IMU(j,12)=typecast(uint8(a),'single'); % Barometer          
									a=[q(145) q(146) q(147) q(148)];
									IMU(j,13)=typecast(uint8(a),'single'); % TemperaturePressure
                                    
                                    
                                    
                                    IMU(j,16) =((IMU(j,2)).^2 +(IMU(j,3)).^2 +(IMU(j,4)).^2).^0.5;
% 									

% 									a=[q(149) q(150) q(151) q(152)];
% 									PaquetAirData(j,2)=typecast(uint8(a),'single');  % Barometrique Altitude delay(s)   
% 									a=[q(153) q(154) q(155) q(156)];
% 									PaquetAirData(j,3)=typecast(uint8(a),'single');  % Air Speed Delay(s)           
 									a=[q(157) q(158) q(159) q(160)];
 									PaquetAirData(j,4)=typecast(uint8(a),'single'); % bar altitude (m)
									a=[q(169) q(170) q(171) q(172)];
									PaquetAirData(j,7)=typecast(uint8(a),'single');%% air speed (m/s)
                                    PaquetAirData_temp=[PaquetAirData_temp;repmat(PaquetAirData(end,:),10,1)];
% 									a=[q(165) q(166) q(167) q(168)];
% 									PaquetAirData(j,6)=typecast(uint8(a),'single');  % Barometrique Standard deviation    
% 									a=[q(169) q(170) q(171) q(172)];
% 									PaquetAirData(j,7)=typecast(uint8(a),'single');  % Air Speed Standard deviation   
% 									a=[q(173)];
% 									PaquetAirData(j,8)=typecast(uint8(a),'uint8');    % Status                                     

									a=[q(174) q(175) q(176) q(177)];
									PaquetWind(j,2)=typecast(uint8(a),'single');  % WindVelocityNorth(m/s)
									a=[q(178) q(179) q(180) q(181)];
									PaquetWind(j,3)=typecast(uint8(a),'single');  % WindVelocityEast(m/s)                              
                                    PaquetWind_temp=[PaquetWind_temp;repmat(PaquetWind(end,:),10,1)];
% 									a=[q(182) q(183) q(184) q(185)];
% 									PaquetWind(j,4)=typecast(uint8(a),'single');  % WindVelocityStandardDeviation(m/s)        
                                    a=[q(186) q(187) q(188) q(189)];
									AirDataSensors(j,2)=typecast(uint8(a),'single'); % Absolute pressure(Pa) 
									a=[q(190) q(191) q(192) q(193)];
									AirDataSensors(j,3)=typecast(uint8(a),'single');  % Differential pressue (Pa) 
                                    AirDataSensors_temp=[AirDataSensors_temp;repmat(AirDataSensors(end,:),10,1)];
% 									a=[q(194)];
% 									AirDataSensors(j,4)=typecast(uint8(a),'uint8');    % Status 
% 									a=[q(195) q(196) q(197) q(198)];
% 									AirDataSensors(j,5)=typecast(uint8(a),'single');  % add 
%         
% 									a=[q(235)];
% 									Pattern(j,2)=typecast(uint8(a),'uint8'); % AA     
% 									a=[q(236)];
% 									Pattern(j,3)=typecast(uint8(a),'uint8'); % BB      
%% PRESSION STATIQUE 1&2
									a=[q(237)];
									b=[q(238)];
									pression_brute0=a*256+b; % Pression Baro1 HCEMO611
									a=[q(239)];
									b=[q(240)];
									pression_brute1=a*256+b; % Pression Baro1 HCEMO611
        
									val =( 24575 - 2730)/( 1100 - 600);%
									Result_0 = (pression_brute0 - 2730)/val + 600;
									Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM diff pressure 1                      
									a=[q(241)];
									b=[q(242)];
									pression_brute2=a*256+b;     
									a=[q(243)];
									b=[q(244)];   
									pression_brute3=a*256+b;
									a=[q(245)];
									b=[q(246)];
									pression_brute4=a*256+b; 
									a=[q(247)];
									b=[q(248)];       
									pression_brute5=a*256+b;   

									val =( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb									
									Result_2 = (pression_brute2 - 2730)/val + (-0);  % diff pressure HCEM
									Result_3 = (pression_brute3 - 2730)/val + (-0);  
									Result_4 = (pression_brute4 - 2730)/val + (-0);  
									Result_5 = (pression_brute5 - 2730)/val + (-0);  
%% DIFF PRESSURE LDE 1
									a=[q(249)];
									b=[q(250)];       																								
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute6 = double((typecast(uint8(a),'int16')));  
									a=[q(251)];
									b=[q(252)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute7 = double((typecast(uint8(a),'int16'))); 
									a=[q(253)];
									b=[q(254)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute8 = double((typecast(uint8(a),'int16'))); 
									a=[q(255)];
									b=[q(256)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute9 = double((typecast(uint8(a),'int16'))); 
% 																		
									Result_6=pression_brute6 /6000 ; % mb
									Result_7=pression_brute7 /6000 ; % mb
									Result_8=pression_brute8 /6000 ; % mb
									Result_9=pression_brute9 /6000 ; % mb
									
%% STOCKAGE PRESSION 1									
									Pressures(u*10+1,2)=pression_brute0; % Baro
									Pressures(u*10+1,3)=pression_brute1; % Baro
									Pressures(u*10+1,4)=pression_brute2; % Diff 1 HCE
									Pressures(u*10+1,5)=pression_brute3; % Diff 2
									Pressures(u*10+1,6)=pression_brute4; % Diff 3
									Pressures(u*10+1,7)=pression_brute5; % Diff 4 
									Pressures(u*10+1,8)=pression_brute6; % Diff 5 LDE
									Pressures(u*10+1,9)=pression_brute7; % Diff 6
									Pressures(u*10+1,10)=pression_brute8; % Diff 7
									Pressures(u*10+1,11)=pression_brute9;  % Diff 8      
% 											
									Pressures(u*10+1,12)=Result_0;  % Baro
									Pressures(u*10+1,13)=Result_1;  % Baro
									Pressures(u*10+1,14)=Result_2;  % Diff 1 HCE
									Pressures(u*10+1,15)=Result_3;  % Diff 2
									Pressures(u*10+1,16)=Result_4;  % Diff 3
									Pressures(u*10+1,17)=Result_5;  % Diff 4     
									Pressures(u*10+1,18)=Result_6;  % Diff 5 LDE
									Pressures(u*10+1,19)=Result_7;  % Diff 6
									Pressures(u*10+1,20)=Result_8;  % Diff 7
									Pressures(u*10+1,21)=Result_9;  % Diff 8
% 									
% 									
% 									a=[q(257)];
% 									Pattern(j,4)=typecast(uint8(a),'uint8'); % AA      
% 									a=[q(258)];
% 									Pattern(j,5)=typecast(uint8(a),'uint8'); % BB      
%% SHT 85 									
									a=[q(259)];
									b=[q(260)];
									digi1=a*256 +b;    % data_temp_sht75_1     
									a=[q(261)];
									b=[q(262)];
									digi2=a*256 +b;       
% 
									T1 = -45 + 175*digi1/(2^16-1);
 									H1 =100*digi2/(2^16-1);
									TH(j,2)=digi1;
									TH(j,3)=digi2; 
									
									TH(j,6)=T1;
									TH(j,7)=H1;

									a=[q(263)];
									b=[q(264)];
									digi1=a*256 +b;    % data_temp_sht75_2    
									a=[q(265)];
									b=[q(266)];
									digi2=a*256 +b;       

                                    T1 = -45 + 175*digi1/(2^16-1);
 									H1 =100*digi2/(2^16-1);
									TH(j,4)=digi1;
									TH(j,5)=digi2; 
									
									TH(j,8)=T1;
									TH(j,9)=H1;
                                    TH_temp=[TH_temp;repmat(TH(end,:),10,1)];
% 									a=[q(267)];
% 									Pattern(j,6)=typecast(uint8(a),'uint8');       
% 									a=[q(268)];
% 									Pattern(j,7)=typecast(uint8(a),'uint8');       
% 
% 									
%% PT100                            
									q(269)
                                    q(270)
                                    a=dec2bin(q(269),8);
									b=dec2bin(q(270),8);
                                    a2=[a b];
                                    a3=bin2dec(a2(2:9));
                                    b3=bin2dec(['0' a2(10:end)]);
%                                     digi1=typecast(uint8(a),'uint8')*256 +typecast(uint8(b),'uint8')
									digi1=a3*128 +b3;    % data_temp_max31865    
									T2x= digi1/32 - 256;
									T2(j,2)=digi1;
									T2(j,3)=T2x;
                                    T2_temp=[T2_temp;repmat(T2(end,:),10,1)];
%% Pression statique 2 
									a=[q(272)];
									Pattern(j,8)=a;       
									a=[q(273)];
									Pattern(j,9)=a;       
																		
									a=[q(274)];
									b=[q(275)];
									pression_brute0=a*256+b; % Pression Baro1 HCEMO611
									a=[q(276)];
									b=[q(277)];
									pression_brute1=a*256+b; % Pression Baro1 HCEMO611
        
									val =( 24575 - 2730)/( 1100 - 600);
									Result_0 = (pression_brute0 - 2730)/val + 600;
									Result_1 = (pression_brute1 - 2730)/val + 600;
%% HDE 2                      
									a=[q(278)];
									b=[q(279)];
									pression_brute2=a*256+b;     
									a=[q(280)];
									b=[q(281)];   
									pression_brute3=a*256+b;
									a=[q(282)];
									b=[q(283)];
									pression_brute4=a*256+b; 
									a=[q(284)];
									b=[q(285)];       
									pression_brute5=a*256+b;    

									val=( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb									
									Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
									Result_3 = (pression_brute3 - 2730)/val + (-0);  
									Result_4 = (pression_brute4 - 2730)/val + (-0);  
									Result_5 = (pression_brute5 - 2730)/val + (-0);  
%% LDE 2 
									a=[q(286)];
									b=[q(287)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute6 = double((typecast(uint8(a),'int16')));
									
									a=[q(288)];
									b=[q(289)];  
                                    q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute7 =double((typecast(uint8(a),'int16')));
									a=[q(290)];
									b=[q(291)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute8 = double((typecast(uint8(a),'int16')));
									a=[q(292)];
									b=[q(293)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute9 = double((typecast(uint8(a),'int16')));
																		
									Result_6=pression_brute6 /6000 ; % mb
									Result_7=pression_brute7 /6000 ; % mb
									Result_8=pression_brute8 /6000 ; % mb
									Result_9=pression_brute9 /6000 ; % mb
%% stockage 2 									
									
									Pressures(u*10+2,2)=pression_brute0; % Baro
									Pressures(u*10+2,3)=pression_brute1; % Baro
									Pressures(u*10+2,4)=pression_brute2; % Diff 1 HCE
									Pressures(u*10+2,5)=pression_brute3; % Diff 2
									Pressures(u*10+2,6)=pression_brute4; % Diff 3
									Pressures(u*10+2,7)=pression_brute5; % Diff 4 
									Pressures(u*10+2,8)=pression_brute6; % Diff 5 LDE
									Pressures(u*10+2,9)=pression_brute7; % Diff 6
									Pressures(u*10+2,10)=pression_brute8; % Diff 7
									Pressures(u*10+2,11)=pression_brute9;  % Diff 8      
											
									Pressures(u*10+2,12)=Result_0;  % Baro
									Pressures(u*10+2,13)=Result_1;  % Baro
									Pressures(u*10+2,14)=Result_2;  % Diff 1 HCE
									Pressures(u*10+2,15)=Result_3;  % Diff 2
									Pressures(u*10+2,16)=Result_4;  % Diff 3
									Pressures(u*10+2,17)=Result_5;  % Diff 4     
									Pressures(u*10+2,18)=Result_6;  % Diff 5 LDE
									Pressures(u*10+2,19)=Result_7;  % Diff 6
									Pressures(u*10+2,20)=Result_8;  % Diff 7
									Pressures(u*10+2,21)=Result_9;  % Diff 8
									
%% pression statique 3
									a=[q(294)];
									Pattern(j,10)=a;     
									a=[q(295)];
									Pattern(j,11)=a ;    
																		
									a=[q(296)];
									b=[q(297)];
									pression_brute0=a*256+b;
									a=[q(298)];
									b=[q(299)];
									pression_brute1=a*256+b;
        
									val=( 24575 - 2730)/( 1100 - 600);
									Result_0 = (pression_brute0 - 2730)/val + 600;
									Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 3                      
									a=[q(300)];
									b=[q(301)];
									pression_brute2=a*256+b;
									a=[q(302)];
									b=[q(303)];   
									pression_brute3=a*256+b;
									a=[q(304)];
									b=[q(305)];
									pression_brute4=a*256+b;
									a=[q(306)];
									b=[q(307)];       
									pression_brute5=a*256+b; 

									val=( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb									
									Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
									Result_3 = (pression_brute3 - 2730)/val + (-0);  
									Result_4 = (pression_brute4 - 2730)/val + (-0);  
									Result_5 = (pression_brute5 - 2730)/val + (-0);  
%% LDE 3
									a=[q(308)];
									b=[q(309)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute6 = double((typecast(uint8(a),'int16'))); 
									a=[q(310)];
									b=[q(311)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									
									pression_brute7 = double((typecast(uint8(a),'int16'))); 
									a=[q(312)];
									b=[q(313)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute8 =  double((typecast(uint8(a),'int16'))); 
									a=[q(314)];
									b=[q(315)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute9 = double((typecast(uint8(a),'int16'))); 
																		
									Result_6=pression_brute6 /6000 ; % mb
									Result_7=pression_brute7 /6000 ; % mb
									Result_8=pression_brute8 /6000 ; % mb
									Result_9=pression_brute9 /6000 ; % mb
%% Stockage 3 									
									
									Pressures(u*10+3,2)=pression_brute0; % Baro
									Pressures(u*10+3,3)=pression_brute1; % Baro
									Pressures(u*10+3,4)=pression_brute2; % Diff 1 HCE
									Pressures(u*10+3,5)=pression_brute3; % Diff 2
									Pressures(u*10+3,6)=pression_brute4; % Diff 3
									Pressures(u*10+3,7)=pression_brute5; % Diff 4 
									Pressures(u*10+3,8)=pression_brute6; % Diff 5 LDE
									Pressures(u*10+3,9)=pression_brute7; % Diff 6
									Pressures(u*10+3,10)=pression_brute8; % Diff 7
									Pressures(u*10+3,11)=pression_brute9;  % Diff 8      
											
									Pressures(u*10+3,12)=Result_0;  % Baro
									Pressures(u*10+3,13)=Result_1;  % Baro
									Pressures(u*10+3,14)=Result_2;  % Diff 1 HCE
									Pressures(u*10+3,15)=Result_3;  % Diff 2
									Pressures(u*10+3,16)=Result_4;  % Diff 3
									Pressures(u*10+3,17)=Result_5;  % Diff 4     
									Pressures(u*10+3,18)=Result_6;  % Diff 5 LDE
									Pressures(u*10+3,19)=Result_7;  % Diff 6
									Pressures(u*10+3,20)=Result_8;  % Diff 7
									Pressures(u*10+3,21)=Result_9;  % Diff 8
% 									
% 
% 									a=[q(316)];
% 									Pattern(j,12)=typecast(uint8(a),'uint8');       
% 									a=[q(317)];
% 									Pattern(j,13)=typecast(uint8(a),'uint8');       
%% Pression statique 4 																		
									a=[q(318)];
									b=[q(319)];
									pression_brute0=a*256+b; % Pression Baro1 HCEMO611
									a=[q(320)];
									b=[q(321)];
									pression_brute1=a*256+b; % Pression Baro1 HCEMO611
        
									val=( 24575 - 2730)/( 1100 - 600);
									Result_0 = (pression_brute0 - 2730)/val + 600;
									Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM4                     
									a=[q(322)];
									b=[q(323)];
									pression_brute2=a*256+b;     
									a=[q(324)];
									b=[q(325)];   
									pression_brute3=a*256+b;
									a=[q(326)];
									b=[q(327)];
									pression_brute4=a*256+b;
									a=[q(328)];
									b=[q(329)];       
									pression_brute5=a*256+b;

									val=( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb									
									Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
									Result_3 = (pression_brute3 - 2730)/val + (-0);  
									Result_4 = (pression_brute4 - 2730)/val + (-0);  
									Result_5 = (pression_brute5 - 2730)/val + (-0);  
%% LDE4 
									a=[q(330)];
									b=[q(331)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute6 = double((typecast(uint8(a),'int16'))); 
									
									a=[q(332)];
									b=[q(333)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute7 =double((typecast(uint8(a),'int16'))); 
									a=[q(334)];
									b=[q(335)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute8 = double((typecast(uint8(a),'int16'))); 
									a=[q(336)];
									b=[q(337)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute9 = double((typecast(uint8(a),'int16'))); 
																		
									Result_6=pression_brute6 /6000 ; % mb
									Result_7=pression_brute7 /6000 ; % mb
									Result_8=pression_brute8 /6000 ; % mb
									Result_9=pression_brute9 /6000 ; % mb
									
%% Stockage 4 									
									Pressures(u*10+4,2)=pression_brute0; % Baro
									Pressures(u*10+4,3)=pression_brute1; % Baro
									Pressures(u*10+4,4)=pression_brute2; % Diff 1 HCE
									Pressures(u*10+4,5)=pression_brute3; % Diff 2
									Pressures(u*10+4,6)=pression_brute4; % Diff 3
									Pressures(u*10+4,7)=pression_brute5; % Diff 4 
									Pressures(u*10+4,8)=pression_brute6; % Diff 5 LDE
									Pressures(u*10+4,9)=pression_brute7; % Diff 6
									Pressures(u*10+4,10)=pression_brute8; % Diff 7
									Pressures(u*10+4,11)=pression_brute9;  % Diff 8      
											
									Pressures(u*10+4,12)=Result_0;  % Baro
									Pressures(u*10+4,13)=Result_1;  % Baro
									Pressures(u*10+4,14)=Result_2;  % Diff 1 HCE
									Pressures(u*10+4,15)=Result_3;  % Diff 2
									Pressures(u*10+4,16)=Result_4;  % Diff 3
									Pressures(u*10+4,17)=Result_5;  % Diff 4     
									Pressures(u*10+4,18)=Result_6;  % Diff 5 LDE
									Pressures(u*10+4,19)=Result_7;  % Diff 6
									Pressures(u*10+4,20)=Result_8;  % Diff 7
									Pressures(u*10+4,21)=Result_9;  % Diff 8
									

% 									a=[q(338)];
% 									Pattern(j,14)=typecast(uint8(a),'uint8');       
% 									a=[q(339)];
% 									Pattern(j,15)=typecast(uint8(a),'uint8');       
%% Pression statique 5 																		
									a=[q(340)];
									b=[q(341)];
									pression_brute0=a*256+b; % Pression Baro1 HCEMO611
									a=[q(342)];
									b=[q(343)];
									pression_brute1=a*256+b; % Pression Baro1 HCEMO611
        
									val=( 24575 - 2730)/( 1100 - 600);
									Result_0 = (pression_brute0 - 2730)/val + 600;
									Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 5                      
									a=[q(344)];
									b=[q(345)];
                                    
									pression_brute2=a*256+b;
									a=[q(346)];
									b=[q(347)];   
									pression_brute3=a*256+b;
									a=[q(348)];
									b=[q(349)];
									pression_brute4=a*256+b;
									a=[q(350)];
									b=[q(351)];       
									pression_brute5=a*256+b;

									val=( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb									
									Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
									Result_3 = (pression_brute3 - 2730)/val + (-0);  
									Result_4 = (pression_brute4 - 2730)/val + (-0);  
									Result_5 = (pression_brute5 - 2730)/val + (-0);  
%% LDE5 
									a=[q(352)];
									b=[q(353)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute6 = double((typecast(uint8(a),'int16'))); 
									a=[q(354)];
									b=[q(355)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute7 = double((typecast(uint8(a),'int16'))); 
									a=[q(356)];
									b=[q(357)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute8 = double((typecast(uint8(a),'int16'))); 
									a=[q(358)];
									b=[q(359)];       															
									a=[q(356)];
									b=[q(357)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute9 = double((typecast(uint8(a),'int16'))); 
																		
									Result_6=pression_brute6 /6000 ; % mb
									Result_7=pression_brute7 /6000 ; % mb
									Result_8=pression_brute8 /6000 ; % mb
									Result_9=pression_brute9 /6000 ; % mb
%% Stockage 									
									
									Pressures(u*10+5,2)=pression_brute0; % Baro
									Pressures(u*10+5,3)=pression_brute1; % Baro
									Pressures(u*10+5,4)=pression_brute2; % Diff 1 HCE
									Pressures(u*10+5,5)=pression_brute3; % Diff 2
									Pressures(u*10+5,6)=pression_brute4; % Diff 3
									Pressures(u*10+5,7)=pression_brute5; % Diff 4 
									Pressures(u*10+5,8)=pression_brute6; % Diff 5 LDE
									Pressures(u*10+5,9)=pression_brute7; % Diff 6
									Pressures(u*10+5,10)=pression_brute8; % Diff 7
									Pressures(u*10+5,11)=pression_brute9;  % Diff 8      
											
									Pressures(u*10+5,12)=Result_0;  % Baro
									Pressures(u*10+5,13)=Result_1;  % Baro
									Pressures(u*10+5,14)=Result_2;  % Diff 1 HCE
									Pressures(u*10+5,15)=Result_3;  % Diff 2
									Pressures(u*10+5,16)=Result_4;  % Diff 3
									Pressures(u*10+5,17)=Result_5;  % Diff 4     
									Pressures(u*10+5,18)=Result_6;  % Diff 5 LDE
									Pressures(u*10+5,19)=Result_7;  % Diff 6
									Pressures(u*10+5,20)=Result_8;  % Diff 7
									Pressures(u*10+5,21)=Result_9;  % Diff 8
% 									
% 
% 									a=[q(360)];
% 									Pattern(j,16)=typecast(uint8(a),'uint8');       
% 									a=[q(361)];
% 									Pattern(j,17)=typecast(uint8(a),'uint8');       
%% Pression statique 6																		
									a=[q(362)];
									b=[q(363)];
									pression_brute0=a*256+b; % Pression Baro1 HCEMO611
									a=[q(364)];
									b=[q(365)];
									pression_brute1=a*256+b; % Pression Baro1 HCEMO611
        
									val=( 24575 - 2730)/( 1100 - 600);
									Result_0 = (pression_brute0 - 2730)/val + 600;
									Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 6                      
									a=[q(366)];
									b=[q(367)];
									pression_brute2=a*256+b;    
									a=[q(368)];
									b=[q(369)];   
									pression_brute3=a*256+b;
									a=[q(370)];
									b=[q(371)];
									pression_brute4=a*256+b;
									a=[q(372)];
									b=[q(373)];       
									pression_brute5=a*256+b;   

									val=( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb									
									Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
									Result_3 = (pression_brute3 - 2730)/val + (-0);  
									Result_4 = (pression_brute4 - 2730)/val + (-0);  
									Result_5 = (pression_brute5 - 2730)/val + (-0);  

%% LDE 6
                                    a=[q(374)];
									b=[q(375)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute6 =double((typecast(uint8(a),'int16'))); 
									a=[q(376)];
									b=[q(377)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute7 = double((typecast(uint8(a),'int16'))); 
									a=[q(378)];
									b=[q(379)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute8 =double((typecast(uint8(a),'int16'))); 
									a=[q(380)];
									b=[q(381)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute9 = double((typecast(uint8(a),'int16'))); 
																		
									Result_6=pression_brute6 /6000 ; % mb
									Result_7=pression_brute7 /6000 ; % mb
									Result_8=pression_brute8 /6000 ; % mb
									Result_9=pression_brute9 /6000 ; % mb
									
%% Stockage 6 									
									Pressures(u*10+6,2)=pression_brute0; % Baro
									Pressures(u*10+6,3)=pression_brute1; % Baro
									Pressures(u*10+6,4)=pression_brute2; % Diff 1 HCE
									Pressures(u*10+6,5)=pression_brute3; % Diff 2
									Pressures(u*10+6,6)=pression_brute4; % Diff 3
									Pressures(u*10+6,7)=pression_brute5; % Diff 4 
									Pressures(u*10+6,8)=pression_brute6; % Diff 5 LDE
									Pressures(u*10+6,9)=pression_brute7; % Diff 6
									Pressures(u*10+6,10)=pression_brute8; % Diff 7
									Pressures(u*10+6,11)=pression_brute9;  % Diff 8      
											
									Pressures(u*10+6,12)=Result_0;  % Baro
									Pressures(u*10+6,13)=Result_1;  % Baro
									Pressures(u*10+6,14)=Result_2;  % Diff 1 HCE
									Pressures(u*10+6,15)=Result_3;  % Diff 2
									Pressures(u*10+6,16)=Result_4;  % Diff 3
									Pressures(u*10+6,17)=Result_5;  % Diff 4     
									Pressures(u*10+6,18)=Result_6;  % Diff 5 LDE
									Pressures(u*10+6,19)=Result_7;  % Diff 6
									Pressures(u*10+6,20)=Result_8;  % Diff 7
									Pressures(u*10+6,21)=Result_9;  % Diff 8
% 									
% 
% 									a=[q(382)];
% 									Pattern(j,18)=typecast(uint8(a),'uint8');       
% 									a=[q(383)];
% 									Pattern(j,19)=typecast(uint8(a),'uint8');       
%% pression statique 7 																		
									a=[q(384)];
									b=[q(385)];
									pression_brute0=a*256+b; % Pression Baro1 HCEMO611
									a=[q(386)];
									b=[q(387)];
									pression_brute1=a*256+b; % Pression Baro1 HCEMO611
        
									val=( 24575 - 2730)/( 1100 - 600);
									Result_0 = (pression_brute0 - 2730)/val + 600;
									Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 7                      
									a=[q(388)];
									b=[q(389)];
									pression_brute2=a*256+b;     
									a=[q(390)];
									b=[q(391)];   
									pression_brute3=a*256+b;
									a=[q(392)];
									b=[q(393)];
									pression_brute4=a*256+b; 
									a=[q(394)];
									b=[q(395)];       
									pression_brute5=a*256+b;   

									val=( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb									
									Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
									Result_3 = (pression_brute3 - 2730)/val + (-0);  
									Result_4 = (pression_brute4 - 2730)/val + (-0);  
									Result_5 = (pression_brute5 - 2730)/val + (-0);  
%% LDE 7
									a=[q(396)];
									b=[q(397)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute6 =double((typecast(uint8(a),'int16'))); 
									a=[q(398)];
									b=[q(399)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute7 = double((typecast(uint8(a),'int16'))); 
									a=[q(400)];
									b=[q(401)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute8 = double((typecast(uint8(a),'int16'))); 
									a=[q(402)];
									b=[q(403)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute9 = double((typecast(uint8(a),'int16'))); 
																		
									Result_6=pression_brute6 /6000 ; % mb
									Result_7=pression_brute7 /6000 ; % mb
									Result_8=pression_brute8 /6000 ; % mb
									Result_9=pression_brute9 /6000 ; % mb
									
%% Stockage 7 									
									Pressures(u*10+7,2)=pression_brute0; % Baro
									Pressures(u*10+7,3)=pression_brute1; % Baro
									Pressures(u*10+7,4)=pression_brute2; % Diff 1 HCE
									Pressures(u*10+7,5)=pression_brute3; % Diff 2
									Pressures(u*10+7,6)=pression_brute4; % Diff 3
									Pressures(u*10+7,7)=pression_brute5; % Diff 4 
									Pressures(u*10+7,8)=pression_brute6; % Diff 5 LDE
									Pressures(u*10+7,9)=pression_brute7; % Diff 6
									Pressures(u*10+7,10)=pression_brute8; % Diff 7
									Pressures(u*10+7,11)=pression_brute9;  % Diff 8      
											
									Pressures(u*10+7,12)=Result_0;  % Baro
									Pressures(u*10+7,13)=Result_1;  % Baro
									Pressures(u*10+7,14)=Result_2;  % Diff 1 HCE
									Pressures(u*10+7,15)=Result_3;  % Diff 2
									Pressures(u*10+7,16)=Result_4;  % Diff 3
									Pressures(u*10+7,17)=Result_5;  % Diff 4     
									Pressures(u*10+7,18)=Result_6;  % Diff 5 LDE
									Pressures(u*10+7,19)=Result_7;  % Diff 6
									Pressures(u*10+7,20)=Result_8;  % Diff 7
									Pressures(u*10+7,21)=Result_9;  % Diff 8
									
% 
% 									a=[q(404)];
% 									Pattern(j,20)=typecast(uint8(a),'uint8');       
% 									a=[q(405)];
% 									Pattern(j,21)=typecast(uint8(a),'uint8');       
%% Pression statique 8																		
									a=[q(406)];
									b=[q(407)];
									pression_brute0=a*256+b; % Pression Baro1 HCEMO611
									a=[q(408)];
									b=[q(409)];
									pression_brute1=a*256+b; % Pression Baro1 HCEMO611
        
									val=( 24575 - 2730)/( 1100 - 600);
									Result_0 = (pression_brute0 - 2730)/val + 600;
									Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 8                      
									a=[q(410)];
									b=[q(411)];
									pression_brute2=a*256+b;     
									a=[q(412)];
									b=[q(413)];   
									pression_brute3=a*256+b;
									a=[q(414)];
									b=[q(415)];
									pression_brute4=a*256+b;
									a=[q(416)];
									b=[q(417)];       
									pression_brute5=a*256+b;   

									val=( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb									
									Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
									Result_3 = (pression_brute3 - 2730)/val + (-0);  
									Result_4 = (pression_brute4 - 2730)/val + (-0);  
									Result_5 = (pression_brute5 - 2730)/val + (-0);  

%% LDE 8
									a=[q(418)];
									b=[q(419)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute6 =double((typecast(uint8(a),'int16'))); 
									a=[q(420)];
									b=[q(421)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute7 = double((typecast(uint8(a),'int16'))); 
									a=[q(422)];
									b=[q(423)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute8 = double((typecast(uint8(a),'int16'))); 
									a=[q(424)];
									b=[q(425)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute9 = double((typecast(uint8(a),'int16'))); 
																		
									Result_6=pression_brute6 /6000 ; % mb
									Result_7=pression_brute7 /6000 ; % mb
									Result_8=pression_brute8 /6000 ; % mb
									Result_9=pression_brute9 /6000 ; % mb
									
%% Stockage 	8								
									Pressures(u*10+8,2)=pression_brute0; % Baro
									Pressures(u*10+8,3)=pression_brute1; % Baro
									Pressures(u*10+8,4)=pression_brute2; % Diff 1 HCE
									Pressures(u*10+8,5)=pression_brute3; % Diff 2
									Pressures(u*10+8,6)=pression_brute4; % Diff 3
									Pressures(u*10+8,7)=pression_brute5; % Diff 4 
									Pressures(u*10+8,8)=pression_brute6; % Diff 5 LDE
									Pressures(u*10+8,9)=pression_brute7; % Diff 6
									Pressures(u*10+8,10)=pression_brute8; % Diff 7
									Pressures(u*10+8,11)=pression_brute9;  % Diff 8      
											
									Pressures(u*10+8,12)=Result_0;  % Baro
									Pressures(u*10+8,13)=Result_1;  % Baro
									Pressures(u*10+8,14)=Result_2;  % Diff 1 HCE
									Pressures(u*10+8,15)=Result_3;  % Diff 2
									Pressures(u*10+8,16)=Result_4;  % Diff 3
									Pressures(u*10+8,17)=Result_5;  % Diff 4     
									Pressures(u*10+8,18)=Result_6;  % Diff 5 LDE
									Pressures(u*10+8,19)=Result_7;  % Diff 6
									Pressures(u*10+8,20)=Result_8;  % Diff 7
									Pressures(u*10+8,21)=Result_9;  % Diff 8
									
% 
% 									a=[q(426)];
% 									Pattern(j,22)=typecast(uint8(a),'uint8');       
% 									a=[q(427)];
% 									Pattern(j,23)=typecast(uint8(a),'uint8');       
%% Pression statique 9																		
									a=[q(428)];
									b=[q(429)];
									pression_brute0=a*256+b; % Pression Baro1 HCEMO611
									a=[q(430)];
									b=[q(431)];
									pression_brute1=a*256+b; % Pression Baro1 HCEMO611
        
									val=( 24575 - 2730)/( 1100 - 600);
									Result_0 = (pression_brute0 - 2730)/val + 600;
									Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 9                     
									a=[q(432)];
									b=[q(433)];
									pression_brute2=a*256+b;    
									a=[q(434)];
									b=[q(435)];   
									pression_brute3=a*256+b;
									a=[q(436)];
									b=[q(437)];
									pression_brute4=a*256+b;
									a=[q(438)];
									b=[q(439)];       
									pression_brute5=a*256+b;    

									val=( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb									
									Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
									Result_3 = (pression_brute3 - 2730)/val + (-0);  
									Result_4 = (pression_brute4 - 2730)/val + (-0);  
									Result_5 = (pression_brute5 - 2730)/val + (-0);  
%% LDE 9
									a=[q(440)];
									b=[q(441)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute6 = double((typecast(uint8(a),'int16'))); 
									a=[q(442)];
									b=[q(443)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute7 = double((typecast(uint8(a),'int16'))); 
									a=[q(444)];
									b=[q(445)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute8 = double((typecast(uint8(a),'int16'))); 
									a=[q(446)];
									b=[q(447)];       															
									q1=typecast(uint8(a),'uint8');
									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute9 = double((typecast(uint8(a),'int16'))); 
																		
									Result_6=pression_brute6 /6000 ; % mb
									Result_7=pression_brute7 /6000 ; % mb
									Result_8=pression_brute8 /6000 ; % mb
									Result_9=pression_brute9 /6000 ; % mb
%% Stockage 9 									
									
									Pressures(u*10+9,2)=pression_brute0; % Baro
									Pressures(u*10+9,3)=pression_brute1; % Baro
									Pressures(u*10+9,4)=pression_brute2; % Diff 1 HCE
									Pressures(u*10+9,5)=pression_brute3; % Diff 2
									Pressures(u*10+9,6)=pression_brute4; % Diff 3
									Pressures(u*10+9,7)=pression_brute5; % Diff 4 
									Pressures(u*10+9,8)=pression_brute6; % Diff 5 LDE
									Pressures(u*10+9,9)=pression_brute7; % Diff 6
									Pressures(u*10+9,10)=pression_brute8; % Diff 7
									Pressures(u*10+9,11)=pression_brute9;  % Diff 8      
											
									Pressures(u*10+9,12)=Result_0;  % Baro
									Pressures(u*10+9,13)=Result_1;  % Baro
									Pressures(u*10+9,14)=Result_2;  % Diff 1 HCE
									Pressures(u*10+9,15)=Result_3;  % Diff 2
									Pressures(u*10+9,16)=Result_4;  % Diff 3
									Pressures(u*10+9,17)=Result_5;  % Diff 4     
									Pressures(u*10+9,18)=Result_6;  % Diff 5 LDE
									Pressures(u*10+9,19)=Result_7;  % Diff 6
									Pressures(u*10+9,20)=Result_8;  % Diff 7
									Pressures(u*10+9,21)=Result_9;  % Diff 8
									
% 
% 									a=[q(448)];
% 									Pattern(j,24)=typecast(uint8(a),'uint8');       
% 									a=[q(449)];
% 									Pattern(j,25)=typecast(uint8(a),'uint8');       
%% Pression statique 10																		
									a=[q(450)];
									b=[q(451)];
									pression_brute0=a*256+b; % Pression Baro1 HCEMO611
									a=[q(452)];
									b=[q(453)];
									pression_brute1=a*256+b; % Pression Baro1 HCEMO611
        
									val=( 24575 - 2730)/( 1100 - 600);
									Result_0 = (pression_brute0 - 2730)/val + 600;
									Result_1 = (pression_brute1 - 2730)/val + 600;
%% HCEM 10                     
									a=[q(454)];
									b=[q(455)];
									pression_brute2=a*256+b;     
									a=[q(456)];
									b=[q(457)];   
									pression_brute3=a*256+b;
									a=[q(458)];
									b=[q(459)];
									pression_brute4=a*256+b;
									a=[q(460)];
									b=[q(461)];       
									pression_brute5=a*256+b;    

									val=( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb									
									Result_2 = (pression_brute2 - 2730)/val + (-0);  % Pitot %
									Result_3 = (pression_brute3 - 2730)/val + (-0);  
									Result_4 = (pression_brute4 - 2730)/val + (-0);  
									Result_5 = (pression_brute5 - 2730)/val + (-0);  
%% LDE10 
									a=[q(462)];
									b=[q(463)];       															
									q1=typecast(uint8(a),'uint8');
 									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute6 = double((typecast(uint8(a),'int16'))); 
									a=[q(464)];
									b=[q(465)];       															
									q1=typecast(uint8(a),'uint8');
 									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute7 = double((typecast(uint8(a),'int16'))); 
									a=[q(466)];
									b=[q(467)];       															
									q1=typecast(uint8(a),'uint8');
 									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute8 = double((typecast(uint8(a),'int16'))); 
									a=[q(468)];
									b=[q(469)];       															
									q1=typecast(uint8(a),'uint8');
 									q2=typecast(uint8(b),'uint8');
									a=[q2,q1];
									pression_brute9 = double((typecast(uint8(a),'int16'))); 
																		
									Result_6=pression_brute6 /6000 ; % mb
									Result_7=pression_brute7 /6000 ; % mb
									Result_8=pression_brute8 /6000 ; % mb
									Result_9=pression_brute9 /6000 ; % mb
%% Stockage 10 									
									
									Pressures(u*10+10,2)=pression_brute0; % Baro
									Pressures(u*10+10,3)=pression_brute1; % Baro
									Pressures(u*10+10,4)=pression_brute2; % Diff 1 HCE
									Pressures(u*10+10,5)=pression_brute3; % Diff 2
									Pressures(u*10+10,6)=pression_brute4; % Diff 3
									Pressures(u*10+10,7)=pression_brute5; % Diff 4 
									Pressures(u*10+10,8)=pression_brute6; % Diff 5 LDE
									Pressures(u*10+10,9)=pression_brute7; % Diff 6
									Pressures(u*10+10,10)=pression_brute8; % Diff 7
									Pressures(u*10+10,11)=pression_brute9;  % Diff 8      
											
									Pressures(u*10+10,12)=Result_0;  % Baro
									Pressures(u*10+10,13)=Result_1;  % Baro
									Pressures(u*10+10,14)=Result_2;  % Diff 1 HCE
									Pressures(u*10+10,15)=Result_3;  % Diff 2
									Pressures(u*10+10,16)=Result_4;  % Diff 3
									Pressures(u*10+10,17)=Result_5;  % Diff 4     
									Pressures(u*10+10,18)=Result_6;  % Diff 5 LDE
									Pressures(u*10+10,19)=Result_7;  % Diff 6
									Pressures(u*10+10,20)=Result_8;  % Diff 7
									Pressures(u*10+10,21)=Result_9;  % Diff 8
									
% 									a=[q(494)];
% 									Pattern(j,26)=typecast(uint8(a),'uint8');       
% 									a=[q(495)];
% 									Pattern(j,27)=typecast(uint8(a),'uint8');   
%% DATA MOTUS 									
% 									a=[q(496)];
% 									b=[q(497)];
% 									Compteur=typecast(uint8(a),'uint8')*256+typecast(uint8(b),'uint8');     
%  
% 									AD_NAVIGATION(j,25)=Compteur;
% 									IMU(j,14)=Compteur;
% 									MOTUSRAW((u*10+1),14)=Compteur;
% 									MOTUSRAW((u*10+2),14)=Compteur;
% 									MOTUSRAW((u*10+3),14)=Compteur;
% 									MOTUSRAW((u*10+4),14)=Compteur;
% 									MOTUSRAW((u*10+5),14)=Compteur;
% 									MOTUSRAW((u*10+6),14)=Compteur;
% 									MOTUSRAW((u*10+7),14)=Compteur;
% 									MOTUSRAW((u*10+8),14)=Compteur;
% 									MOTUSRAW((u*10+9),14)=Compteur;
% 									MOTUSRAW((u*10+10),14)=Compteur;
% 									MOTUSORI((u+1),5)=Compteur;
% 									TH(j,10)= Compteur;
% 									T2(j,4)= Compteur;
% 									PaquetAirData(j,9)= Compteur;      
% 									AirDataSensors(j,6)= Compteur;    
% 									Pressures(j,22)= Compteur;
% 									PaquetWind (j,5)= Compteur;
%       
% 									a=[q(498)];
% 									Pattern(j,28)=typecast(uint8(a),'uint8');       
% 									a=[q(499)];
% 									Pattern(j,29)=typecast(uint8(a),'uint8');   
% 	  
% 									a=[q(500)];
% 									b=[q(501)];
% 									c=[q(502)];
% 									d=[q(503)];       
% 									Compteur=(typecast(uint8(a),'uint8')*16777216+typecast(uint8(b),'uint8')*65536+typecast(uint8(c),'uint8')*256+typecast(uint8(c),'uint8'));
% 									
% 									AD_NAVIGATION(j,1)=Compteur;
% 									IMU(j,1)=Compteur;
% 									MOTUSRAW((u*10+1),1)=Compteur;
% 									MOTUSRAW((u*10+2),1)=Compteur;
% 									MOTUSRAW((u*10+3),1)=Compteur;
% 									MOTUSRAW((u*10+4),1)=Compteur;
% 									MOTUSRAW((u*10+5),1)=Compteur;
% 									MOTUSRAW((u*10+6),1)=Compteur;
% 									MOTUSRAW((u*10+7),1)=Compteur;
% 									MOTUSRAW((u*10+8),1)=Compteur;
% 									MOTUSRAW((u*10+9),1)=Compteur;
% 									MOTUSRAW((u*10+10),1)=Compteur;
% 									MOTUSORI((u+1),1)=Compteur;
% 									TH(j,1)= Compteur;
% 									T2(j,1)= Compteur;
% 									PaquetAirData(j,1)= Compteur;
% 									AirDataSensors(j,1)= Compteur;         
% 									Pressures(j,1)= Compteur;
% 									Pressures(j+1,1)= Compteur;
% 									Pressures(j+2,1)= Compteur;
% 									Pressures(j+3,1)= Compteur;
% 									Pressures(j+4,1)= Compteur;
% 									Pressures(j+5,1)= Compteur;
% 									Pressures(j+6,1)= Compteur;
% 									Pressures(j+7,1)= Compteur;
% 									Pressures(j+8,1)= Compteur;
% 									Pressures(j+9,1)= Compteur;
% 									PaquetWind (j,1)= Compteur;
%    
% 									a=[q(504)];
% 									Pattern(j,30)=typecast(uint8(a),'uint8');       
% 									a=[q(505)];
% 									Pattern(j,31)=typecast(uint8(a),'uint8');   
% 
% 									AD_NAVIGATION(j,26) = ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3;
% 									IMU(j,15)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3;
% 									MOTUSRAW((u*10+1),15)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3; 
% 									MOTUSRAW((u*10+2),15)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 10;%e3; 
% 									MOTUSRAW((u*10+3),15)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 20;%e3; 
% 									MOTUSRAW((u*10+4),15)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 30;%e3; 
% 									MOTUSRAW((u*10+5),15)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 40;%e3; 
% 									MOTUSRAW((u*10+6),15)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 50;%e3; 
% 									MOTUSRAW((u*10+7),15)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 60;%e3; 
% 									MOTUSRAW((u*10+8),15)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 70;%e3; 
% 									MOTUSRAW((u*10+9),15)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 80;%e3; 
% 									MOTUSRAW((u*10+10),15)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 90;%e3; 
% 									MOTUSORI(j,6)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3;
% 									TH(j,11)= ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3;
% 									T2(j,5)= ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3;
% 									Pressures(u*10+1,23)= ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 ;
% 									Pressures(u*10+2,23)= ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 10;%e3;
% 									Pressures(u*10+3,23)= ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 20;%e3;
% 									Pressures(u*10+4,23)= ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 30;%e3;
% 									Pressures(u*10+5,23)= ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 40;%e3;
% 									Pressures(u*10+6,23)= ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 50;%e3;
% 									Pressures(u*10+7,23)= ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 60;%e3;
% 									Pressures(u*10+8,23)= ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 70;%e3;
% 									Pressures(u*10+9,23)= ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 80;%e3;
% 									Pressures(u*10+10,23)= ((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3 + 90;%e3;
% 									PaquetAirData(j,10)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3;
% 									PaquetWind (j,6)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3;
% 									AirDataSensors(j,7)=((AD_NAVIGATION(j,4)*1e6)+ AD_NAVIGATION(j,5))/1e3;
% 									
% 									a=[q(511)];
% 									Pattern(j,32)=typecast(uint8(a),'uint8');       
% 									a=[q(512)];
% 									Pattern(j,33)=typecast(uint8(a),'uint8');   

									a=[q(513) q(514) q(515) q(516)];
									MOTUSRAW(u*10+1,2)=typecast(uint8(a),'single'); % Xaccl   
									a=[q(517) q(518) q(519) q(520)];
									MOTUSRAW(u*10+1,3)=typecast(uint8(a),'single'); % Yaccl   
									a=[q(521) q(522) q(523) q(524)];
									MOTUSRAW(u*10+1,4)=typecast(uint8(a),'single');  % Zaccl   
									a=[q(525) q(526) q(527) q(528)];
									MOTUSRAW(u*10+1,5)=typecast(uint8(a),'single');  % Xgyro   
									a=[q(529) q(530) q(531) q(532)];
									MOTUSRAW(u*10+1,6)=typecast(uint8(a),'single');  % Ygyro   
									a=[q(533) q(534) q(535) q(536)];
									MOTUSRAW(u*10+1,7)=typecast(uint8(a),'single');  % Zgyro   
									a=[q(537) q(538) q(539) q(540)];
									MOTUSRAW(u*10+1,8)=typecast(uint8(a),'single');  % Xmagn   
									a=[q(541) q(542) q(543) q(544)];
									MOTUSRAW(u*10+1,9)=typecast(uint8(a),'single');  % Ymagn   
									a=[q(545) q(546) q(547) q(548)];
									MOTUSRAW(u*10+1,10)=typecast(uint8(a),'single'); % Zmagn   
									a=[q(549) q(550) q(551) q(552)];
									MOTUSRAW(u*10+1,11)=typecast(uint8(a),'single'); % IMUTemperatureIMU  
									a=[q(553) q(554) q(555) q(556)];
									MOTUSRAW(u*10+1,12)=typecast(uint8(a),'single'); % Barometer          
									a=[q(557) q(558) q(559) q(560)];
									MOTUSRAW(u*10+1,13)=typecast(uint8(a),'single'); % TemperaturePressure

% 									a=[q(561)];
% 									Pattern(j,34)=typecast(uint8(a),'uint8');       
% 									a=[q(562)];
% 									Pattern(j,35)=typecast(uint8(a),'uint8');   
									
									a=[q(563) q(564) q(565) q(566)];
									MOTUSRAW(u*10+2,2)=typecast(uint8(a),'single'); % Xaccl   
									a=[q(567) q(568) q(569) q(570)];
									MOTUSRAW(u*10+2,3)=typecast(uint8(a),'single'); % Yaccl   
									a=[q(571) q(572) q(573) q(574)];
									MOTUSRAW(u*10+2,4)=typecast(uint8(a),'single');  % Zaccl   
									a=[q(575) q(576) q(577) q(578)];
									MOTUSRAW(u*10+2,5)=typecast(uint8(a),'single');  % Xgyro   
									a=[q(579) q(580) q(581) q(582)];
									MOTUSRAW(u*10+2,6)=typecast(uint8(a),'single');  % Ygyro   
									a=[q(583) q(584) q(585) q(586)];
									MOTUSRAW(u*10+2,7)=typecast(uint8(a),'single');  % Zgyro   
									a=[q(587) q(588) q(589) q(590)];
									MOTUSRAW(u*10+2,8)=typecast(uint8(a),'single');  % Xmagn   
									a=[q(591) q(592) q(593) q(594)];
									MOTUSRAW(u*10+2,9)=typecast(uint8(a),'single');  % Ymagn   
									a=[q(595) q(596) q(597) q(598)];
									MOTUSRAW(u*10+2,10)=typecast(uint8(a),'single'); % Zmagn   
									a=[q(599) q(600) q(601) q(602)];
									MOTUSRAW(u*10+2,11)=typecast(uint8(a),'single'); % IMUTemperatureIMU  
									a=[q(603) q(604) q(605) q(606)];
									MOTUSRAW(u*10+2,12)=typecast(uint8(a),'single'); % Barometer          
									a=[q(607) q(608) q(609) q(610)];
									MOTUSRAW(u*10+2,13)=typecast(uint8(a),'single'); % TemperaturePressure

% 									a=[q(611)];
% 									Pattern(j,34)=typecast(uint8(a),'uint8');       
% 									a=[q(612)];
% 									Pattern(j,35)=typecast(uint8(a),'uint8');   
									
									a=[q(613) q(614) q(615) q(616)];
									MOTUSRAW(u*10+3,2)=typecast(uint8(a),'single'); % Xaccl   
									a=[q(617) q(618) q(619) q(620)];
									MOTUSRAW(u*10+3,3)=typecast(uint8(a),'single'); % Yaccl   
									a=[q(621) q(622) q(623) q(624)];
									MOTUSRAW(u*10+3,4)=typecast(uint8(a),'single');  % Zaccl   
									a=[q(625) q(626) q(627) q(628)];
									MOTUSRAW(u*10+3,5)=typecast(uint8(a),'single');  % Xgyro   
									a=[q(629) q(630) q(631) q(632)];
									MOTUSRAW(u*10+3,6)=typecast(uint8(a),'single');  % Ygyro   
									a=[q(633) q(634) q(635) q(636)];
									MOTUSRAW(u*10+3,7)=typecast(uint8(a),'single');  % Zgyro   
									a=[q(637) q(638) q(639) q(640)];
									MOTUSRAW(u*10+3,8)=typecast(uint8(a),'single');  % Xmagn   
									a=[q(641) q(642) q(643) q(644)];
									MOTUSRAW(u*10+3,9)=typecast(uint8(a),'single');  % Ymagn   
									a=[q(645) q(646) q(647) q(648)];
									MOTUSRAW(u*10+3,10)=typecast(uint8(a),'single'); % Zmagn   
									a=[q(649) q(650) q(651) q(652)];
									MOTUSRAW(u*10+3,11)=typecast(uint8(a),'single'); % IMUTemperatureIMU  
									a=[q(653) q(654) q(655) q(656)];
									MOTUSRAW(u*10+3,12)=typecast(uint8(a),'single'); % Barometer          
									a=[q(657) q(658) q(659) q(660)];
									MOTUSRAW(u*10+3,13)=typecast(uint8(a),'single'); % TemperaturePressure

% 									a=[q(661)];
% 									Pattern(j,34)=typecast(uint8(a),'uint8');       
% 									a=[q(662)];
% 									Pattern(j,35)=typecast(uint8(a),'uint8');   
									
									a=[q(663) q(664) q(665) q(666)];
									MOTUSRAW(u*10+4,2)=typecast(uint8(a),'single'); % Xaccl   
									a=[q(667) q(668) q(669) q(670)];
									MOTUSRAW(u*10+4,3)=typecast(uint8(a),'single'); % Yaccl   
									a=[q(671) q(672) q(673) q(674)];
									MOTUSRAW(u*10+4,4)=typecast(uint8(a),'single');  % Zaccl   
									a=[q(675) q(676) q(677) q(678)];
									MOTUSRAW(u*10+4,5)=typecast(uint8(a),'single');  % Xgyro   
									a=[q(679) q(680) q(681) q(682)];
									MOTUSRAW(u*10+4,6)=typecast(uint8(a),'single');  % Ygyro   
									a=[q(683) q(684) q(685) q(686)];
									MOTUSRAW(u*10+4,7)=typecast(uint8(a),'single');  % Zgyro   
									a=[q(687) q(688) q(689) q(690)];
									MOTUSRAW(u*10+4,8)=typecast(uint8(a),'single');  % Xmagn   
									a=[q(691) q(692) q(693) q(694)];
									MOTUSRAW(u*10+4,9)=typecast(uint8(a),'single');  % Ymagn   
									a=[q(695) q(696) q(697) q(698)];
									MOTUSRAW(u*10+4,10)=typecast(uint8(a),'single'); % Zmagn   
									a=[q(699) q(700) q(701) q(702)];
									MOTUSRAW(u*10+4,11)=typecast(uint8(a),'single'); % IMUTemperatureIMU  
									a=[q(703) q(704) q(705) q(706)];
									MOTUSRAW(u*10+4,12)=typecast(uint8(a),'single'); % Barometer          
									a=[q(707) q(708) q(709) q(710)];
									MOTUSRAW(u*10+4,13)=typecast(uint8(a),'single'); % TemperaturePressure

% 									a=[q(711)];
% 									Pattern(j,34)=typecast(uint8(a),'uint8');       
% 									a=[q(712)];
% 									Pattern(j,35)=typecast(uint8(a),'uint8');   
									
									a=[q(713) q(714) q(715) q(716)];
									MOTUSRAW(u*10+5,2)=typecast(uint8(a),'single'); % Xaccl   
									a=[q(717) q(718) q(719) q(720)];
									MOTUSRAW(u*10+5,3)=typecast(uint8(a),'single'); % Yaccl   
									a=[q(721) q(722) q(723) q(724)];
									MOTUSRAW(u*10+5,4)=typecast(uint8(a),'single');  % Zaccl   
									a=[q(725) q(726) q(727) q(728)];
									MOTUSRAW(u*10+5,5)=typecast(uint8(a),'single');  % Xgyro   
									a=[q(729) q(730) q(731) q(732)];
									MOTUSRAW(u*10+5,6)=typecast(uint8(a),'single');  % Ygyro   
									a=[q(733) q(734) q(735) q(736)];
									MOTUSRAW(u*10+5,7)=typecast(uint8(a),'single');  % Zgyro   
									a=[q(737) q(738) q(739) q(740)];
									MOTUSRAW(u*10+5,8)=typecast(uint8(a),'single');  % Xmagn   
									a=[q(741) q(742) q(743) q(744)];
									MOTUSRAW(u*10+5,9)=typecast(uint8(a),'single');  % Ymagn   
									a=[q(745) q(746) q(747) q(748)];
									MOTUSRAW(u*10+5,10)=typecast(uint8(a),'single'); % Zmagn   
									a=[q(749) q(750) q(751) q(752)];
									MOTUSRAW(u*10+5,11)=typecast(uint8(a),'single'); % IMUTemperatureIMU  
									a=[q(753) q(754) q(755) q(756)];
									MOTUSRAW(u*10+5,12)=typecast(uint8(a),'single'); % Barometer          
									a=[q(757) q(758) q(759) q(760)];
									MOTUSRAW(u*10+5,13)=typecast(uint8(a),'single'); % TemperaturePressure
% 
% 									a=[q(761)];
% 									Pattern(j,34)=typecast(uint8(a),'uint8');       
% 									a=[q(762)];
% 									Pattern(j,35)=typecast(uint8(a),'uint8');   
									
									a=[q(763) q(764) q(765) q(766)];
									MOTUSRAW(u*10+6,2)=typecast(uint8(a),'single'); % Xaccl   
									a=[q(767) q(768) q(769) q(770)];
									MOTUSRAW(u*10+6,3)=typecast(uint8(a),'single'); % Yaccl   
									a=[q(771) q(772) q(773) q(774)];
									MOTUSRAW(u*10+6,4)=typecast(uint8(a),'single');  % Zaccl   
									a=[q(775) q(776) q(777) q(778)];
									MOTUSRAW(u*10+6,5)=typecast(uint8(a),'single');  % Xgyro   
									a=[q(779) q(780) q(781) q(782)];
									MOTUSRAW(u*10+6,6)=typecast(uint8(a),'single');  % Ygyro   
									a=[q(783) q(784) q(785) q(786)];
									MOTUSRAW(u*10+6,7)=typecast(uint8(a),'single');  % Zgyro   
									a=[q(787) q(788) q(789) q(790)];
									MOTUSRAW(u*10+6,8)=typecast(uint8(a),'single');  % Xmagn   
									a=[q(791) q(792) q(793) q(794)];
									MOTUSRAW(u*10+6,9)=typecast(uint8(a),'single');  % Ymagn   
									a=[q(795) q(796) q(797) q(798)];
									MOTUSRAW(u*10+6,10)=typecast(uint8(a),'single'); % Zmagn   
									a=[q(799) q(800) q(801) q(802)];
									MOTUSRAW(u*10+6,11)=typecast(uint8(a),'single'); % IMUTemperatureIMU  
									a=[q(803) q(804) q(805) q(806)];
									MOTUSRAW(u*10+6,12)=typecast(uint8(a),'single'); % Barometer          
									a=[q(807) q(808) q(809) q(810)];
									MOTUSRAW(u*10+6,13)=typecast(uint8(a),'single'); % TemperaturePressure

% 									a=[q(811)];
% 									Pattern(j,34)=typecast(uint8(a),'uint8');       
% 									a=[q(812)];
% 									Pattern(j,35)=typecast(uint8(a),'uint8');   
									
									a=[q(813) q(814) q(815) q(816)];
									MOTUSRAW(u*10+7,2)=typecast(uint8(a),'single'); % Xaccl   
									a=[q(817) q(818) q(819) q(820)];
									MOTUSRAW(u*10+7,3)=typecast(uint8(a),'single'); % Yaccl   
									a=[q(821) q(822) q(823) q(824)];
									MOTUSRAW(u*10+7,4)=typecast(uint8(a),'single');  % Zaccl   
									a=[q(825) q(826) q(827) q(828)];
									MOTUSRAW(u*10+7,5)=typecast(uint8(a),'single');  % Xgyro   
									a=[q(829) q(830) q(831) q(832)];
									MOTUSRAW(u*10+7,6)=typecast(uint8(a),'single');  % Ygyro   
									a=[q(833) q(834) q(835) q(836)];
									MOTUSRAW(u*10+7,7)=typecast(uint8(a),'single');  % Zgyro   
									a=[q(837) q(838) q(839) q(840)];
									MOTUSRAW(u*10+7,8)=typecast(uint8(a),'single');  % Xmagn   
									a=[q(841) q(842) q(843) q(844)];
									MOTUSRAW(u*10+7,9)=typecast(uint8(a),'single');  % Ymagn   
									a=[q(845) q(846) q(847) q(848)];
									MOTUSRAW(u*10+7,10)=typecast(uint8(a),'single'); % Zmagn   
									a=[q(849) q(850) q(851) q(852)];
									MOTUSRAW(u*10+7,11)=typecast(uint8(a),'single'); % IMUTemperatureIMU  
									a=[q(853) q(854) q(855) q(856)];
									MOTUSRAW(u*10+7,12)=typecast(uint8(a),'single'); % Barometer          
									a=[q(857) q(858) q(859) q(860)];
									MOTUSRAW(u*10+7,13)=typecast(uint8(a),'single'); % TemperaturePressure

% 									a=[q(861)];
% 									Pattern(j,34)=typecast(uint8(a),'uint8');       
% 									a=[q(862)];
% 									Pattern(j,35)=typecast(uint8(a),'uint8');   
									
									a=[q(863) q(864) q(865) q(866)];
									MOTUSRAW(u*10+8,2)=typecast(uint8(a),'single'); % Xaccl   
									a=[q(867) q(868) q(869) q(870)];
									MOTUSRAW(u*10+8,3)=typecast(uint8(a),'single'); % Yaccl   
									a=[q(871) q(872) q(873) q(874)];
									MOTUSRAW(u*10+8,4)=typecast(uint8(a),'single');  % Zaccl   
									a=[q(875) q(876) q(877) q(878)];
									MOTUSRAW(u*10+8,5)=typecast(uint8(a),'single');  % Xgyro   
									a=[q(879) q(880) q(881) q(882)];
									MOTUSRAW(u*10+8,6)=typecast(uint8(a),'single');  % Ygyro   
									a=[q(883) q(884) q(885) q(886)];
									MOTUSRAW(u*10+8,7)=typecast(uint8(a),'single');  % Zgyro   
									a=[q(887) q(888) q(889) q(890)];
									MOTUSRAW(u*10+8,8)=typecast(uint8(a),'single');  % Xmagn   
									a=[q(891) q(892) q(893) q(894)];
									MOTUSRAW(u*10+8,9)=typecast(uint8(a),'single');  % Ymagn   
									a=[q(895) q(896) q(897) q(898)];
									MOTUSRAW(u*10+8,10)=typecast(uint8(a),'single'); % Zmagn   
									a=[q(899) q(900) q(901) q(902)];
									MOTUSRAW(u*10+8,11)=typecast(uint8(a),'single'); % IMUTemperatureIMU  
									a=[q(903) q(904) q(905) q(906)];
									MOTUSRAW(u*10+8,12)=typecast(uint8(a),'single'); % Barometer          
									a=[q(907) q(908) q(909) q(910)];
									MOTUSRAW(u*10+8,13)=typecast(uint8(a),'single'); % TemperaturePressure

% 									a=[q(911)];
% 									Pattern(j,34)=typecast(uint8(a),'uint8');       
% 									a=[q(912)];
% 									Pattern(j,35)=typecast(uint8(a),'uint8');   
									
									a=[q(913) q(914) q(915) q(916)];
									MOTUSRAW(u*10+9,2)=typecast(uint8(a),'single'); % Xaccl   
									a=[q(917) q(918) q(919) q(920)];
									MOTUSRAW(u*10+9,3)=typecast(uint8(a),'single'); % Yaccl   
									a=[q(921) q(922) q(923) q(924)];
									MOTUSRAW(u*10+9,4)=typecast(uint8(a),'single');  % Zaccl   
									a=[q(925) q(926) q(927) q(928)];
									MOTUSRAW(u*10+9,5)=typecast(uint8(a),'single');  % Xgyro   
									a=[q(929) q(930) q(931) q(932)];
									MOTUSRAW(u*10+9,6)=typecast(uint8(a),'single');  % Ygyro   
									a=[q(933) q(934) q(935) q(936)];
									MOTUSRAW(u*10+9,7)=typecast(uint8(a),'single');  % Zgyro   
									a=[q(937) q(938) q(939) q(940)];
									MOTUSRAW(u*10+9,8)=typecast(uint8(a),'single');  % Xmagn   
									a=[q(941) q(942) q(943) q(944)];
									MOTUSRAW(u*10+9,9)=typecast(uint8(a),'single');  % Ymagn   
									a=[q(945) q(946) q(947) q(948)];
									MOTUSRAW(u*10+9,10)=typecast(uint8(a),'single'); % Zmagn   
									a=[q(949) q(950) q(951) q(952)];
									MOTUSRAW(u*10+9,11)=typecast(uint8(a),'single'); % IMUTemperatureIMU  
									a=[q(953) q(954) q(955) q(956)];
									MOTUSRAW(u*10+9,12)=typecast(uint8(a),'single'); % Barometer          
									a=[q(957) q(958) q(959) q(960)];
									MOTUSRAW(u*10+9,13)=typecast(uint8(a),'single'); % TemperaturePressure
% 
% 									a=[q(961)];
% 									Pattern(j,34)=typecast(uint8(a),'uint8');       
% 									a=[q(962)];
% 									Pattern(j,35)=typecast(uint8(a),'uint8');   
									
									a=[q(963) q(964) q(965) q(966)];
									MOTUSRAW(u*10+10,2)=typecast(uint8(a),'single'); % Xaccl   
									a=[q(667) q(968) q(969) q(970)];
									MOTUSRAW(u*10+10,3)=typecast(uint8(a),'single'); % Yaccl   
									a=[q(971) q(972) q(973) q(974)];
									MOTUSRAW(u*10+10,4)=typecast(uint8(a),'single');  % Zaccl   
									a=[q(975) q(976) q(977) q(978)];
									MOTUSRAW(u*10+10,5)=typecast(uint8(a),'single');  % Xgyro   
									a=[q(979) q(980) q(981) q(982)];
									MOTUSRAW(u*10+10,6)=typecast(uint8(a),'single');  % Ygyro   
									a=[q(983) q(984) q(985) q(986)];
									MOTUSRAW(u*10+10,7)=typecast(uint8(a),'single');  % Zgyro   
									a=[q(987) q(988) q(989) q(990)];
									MOTUSRAW(u*10+10,8)=typecast(uint8(a),'single');  % Xmagn   
									a=[q(991) q(992) q(993) q(994)];
									MOTUSRAW(u*10+10,9)=typecast(uint8(a),'single');  % Ymagn   
									a=[q(995) q(996) q(997) q(998)];
									MOTUSRAW(u*10+10,10)=typecast(uint8(a),'single'); % Zmagn   
									a=[q(999) q(1000) q(1001) q(1002)];
									MOTUSRAW(u*10+10,11)=typecast(uint8(a),'single'); % IMUTemperatureIMU  
									a=[q(1003) q(1004) q(1005) q(1006)];
									MOTUSRAW(u*10+10,12)=typecast(uint8(a),'single'); % Barometer          
									a=[q(1007) q(1008) q(1009) q(1010)];
									MOTUSRAW(u*10+10,13)=typecast(uint8(a),'single'); % TemperaturePressure
                                    
                                    MOTUSRAW(u*10+1,16) =((MOTUSRAW(u*10+1,2)).^2 +(MOTUSRAW(u*10+1,3)).^2 +(MOTUSRAW(u*10+1,4)).^2).^0.5;
                                    MOTUSRAW(u*10+2,16) =((MOTUSRAW(u*10+2,2)).^2 +(MOTUSRAW(u*10+2,3)).^2 +(MOTUSRAW(u*10+2,4)).^2).^0.5;
                                    MOTUSRAW(u*10+3,16) =((MOTUSRAW(u*10+3,2)).^2 +(MOTUSRAW(u*10+3,3)).^2 +(MOTUSRAW(u*10+3,4)).^2).^0.5;
                                    MOTUSRAW(u*10+4,16) =((MOTUSRAW(u*10+4,2)).^2 +(MOTUSRAW(u*10+4,3)).^2 +(MOTUSRAW(u*10+4,4)).^2).^0.5;
                                    MOTUSRAW(u*10+5,16) =((MOTUSRAW(u*10+5,2)).^2 +(MOTUSRAW(u*10+5,3)).^2 +(MOTUSRAW(u*10+5,4)).^2).^0.5;
                                    MOTUSRAW(u*10+6,16) =((MOTUSRAW(u*10+6,2)).^2 +(MOTUSRAW(u*10+6,3)).^2 +(MOTUSRAW(u*10+6,4)).^2).^0.5;
                                    MOTUSRAW(u*10+7,16) =((MOTUSRAW(u*10+7,2)).^2 +(MOTUSRAW(u*10+7,3)).^2 +(MOTUSRAW(u*10+7,4)).^2).^0.5;
                                    MOTUSRAW(u*10+8,16) =((MOTUSRAW(u*10+8,2)).^2 +(MOTUSRAW(u*10+8,3)).^2 +(MOTUSRAW(u*10+8,4)).^2).^0.5;
                                    MOTUSRAW(u*10+9,16) =((MOTUSRAW(u*10+9,2)).^2 +(MOTUSRAW(u*10+9,3)).^2 +(MOTUSRAW(u*10+9,4)).^2).^0.5;
                                    MOTUSRAW(u*10+10,16)=((MOTUSRAW(u*10+10,2)).^2+(MOTUSRAW(u*10+10,3)).^2+(MOTUSRAW(u*10+10,4)).^2).^0.5;
% 
% 									a=[q(1011)];
% 									Pattern(j,34)=typecast(uint8(a),'uint8');       
% 									a=[q(1012)];
% 									Pattern(j,35)=typecast(uint8(a),'uint8');   
% 									
									a=[q(1013) q(1014) q(1015) q(1016)];
									MOTUSORI(j,2)=typecast(uint8(a),'single')*180/pi;  % Roll    
									a=[q(1017) q(1018) q(1019) q(1020)];
									MOTUSORI(j,3)=typecast(uint8(a),'single')*180/pi;  % Pitch   
									a=[q(1021) q(1022) q(1023) q(1024)];
									MOTUSORI(j,4)=typecast(uint8(a),'single')*180/pi;  % Heading 
									MOTUSORI_temp=[MOTUSORI_temp;repmat(MOTUSORI(end,:),10,1)];
                                    
                                    suite_q = [suite_q, q];
                                    boucle= boucle+1;
                                    boucle10= boucle10+10;
%%                                  =============================================================%
%                                                 Affichage                                       %
%                                     =============================================================%
% 
%                                     ======================Affichage Donnees================================%
                                    if Num_Pas_dAffichage == 0

%                                         ========================= Fenetre principale
                                        if boucle<Range  % affichage des 10 derniers points
                                            seuil_bas= 1;
                                            seuil_haut=fix(boucle);
                                        else
                                            seuil_bas= fix(boucle -( Range -1));
                                            seuil_haut=fix(boucle);
                                        end
                                        if boucle10<Range  % affichage des 10 derniers points
                                            seuil_bas10= 1;
                                            seuil_haut10=fix(boucle10);
                                        else
                                            seuil_bas10= fix(boucle10 -( Range -1));
                                            seuil_haut10=fix(boucle10);
                                        end
%                                         ========================= Fenetre secondaire
% 
% 
%                                         test seuil
%                                         si rangebas sup a rangehaut  range= 10
%                                          suil bas = 2 seuil haut = boucle
% 
%                                         si rangeeinf inf a range haut
% 
%                                               si range_bas sup a boucle
%                                                sueilbas=2
%                                                suilhaut=boucle
% 
%                                                sinon range_haut sup a boucle
%                                                      sueil_haut = boucle
%                                                      seuil_bas=rangebas
%                                                 sinon
%                                                     seuil_haut= range haut
%                                                     suil_bas = range bas

                                        if Range_bas  > Range_haut || Range_bas == Range_haut
                                            seuil_bas2= 1;
                                            seuil_haut2= fix(boucle);
                                        else
                                            if Range_bas > boucle
                                                seuil_bas2=2;
                                                seuil_haut2=fix(boucle);
                                            else
                                                seuil_bas2=fix(Range_bas);
                                                if Range_haut<boucle
                                                    seuil_haut2=fix(boucle);
                                                else
                                                    seuil_haut2=Range_haut;
                                                end
                                            end
                                        end
% 
%                                                                       seuil_haut2
%                                                                       seuil_bas2

%                                         ========================= Fenetre principale Capteur

%                                         ======================================== CAPTEUR de GAZ

                                        if Nombre_graph_P > 0                  %fenêtre capteur Ozone
                                            list_ind={};
                                            LEG={};
                                            fig1=figure(2);
                                            fig1.Name='PRESSION';
                                            movegui(fig1,'northwest');
                                            
                                            LEG{1,1}='HCEM 2';
                                            LEG{1,2}='HCEM 3';
                                            LEG{1,3}='HCEM 4';
                                            LEG{1,4}='HCEM 5';
                                            LEG{2,1}='LDE 1';
                                            LEG{2,2}='LDE 2';
                                            LEG{2,3}='LDE 3';
                                            LEG{2,4}='LDE 4';
                                            LEG{3,1}='ADU diff';
                                            LEG{4,1}='HCEM statique 1';
                                            LEG{4,2}='HCEM statique 2';
                                            LEG{5,1}='ADU abs';
                                            list_ind{1}=14:17;
                                            list_ind{2}=18:21;
                                            list_ind{3}=3;
                                            list_ind{4}=12:13;
                                            list_ind{5}=2;
                                            titre{1}='HCEM DIFF';
                                            titre{2}='LDE';
                                            titre{3}='PRESSION DIFF ADU';
                                            titre{4}='HCEM STAT';
                                            titre{5}='PRESSION ABS ADU';
                                            if Nombre_graph_P>3
                                                nb_ligne=2;
                                                nb_col=floor(Nombre_graph_P/2)+mod(Nombre_graph_P,2);
                                            else
                                                nb_ligne=1;
                                                nb_col=sum(liste_P(:));
                                            end
                                            for k_p=1:length(liste_P)
                                                if liste_P(k_p)==1   %===========================% fenetre 1
                                                    nbrePlot=sum(liste_P(1:k_p));
                                                    set(0,'CurrentFigure',fig1)
                                                    subplot(nb_ligne,nb_col,nbrePlot);
                                                    
                                                    if k_p==1 || k_p==2 || k_p==4
                                                        plot(Pressures(seuil_bas10:seuil_haut10,list_ind{k_p}),'-*')
                                                    else
                                                        
                                                        plot(AirDataSensors_temp(seuil_bas10:seuil_haut10,list_ind{k_p}),'-*')
                                                      
                                                    end
                                                    
                                                    legend(LEG{k_p,1:length(list_ind{k_p})})
                                                   
                                                    hold off
                                                    title(titre{k_p})
%                                                 
                                                end
                                            end
                                        end
                                         if Nombre_graph_AS > 0                  %fenêtre capteur Ozone
                                            list_ind={};
                                            LEG={};
                                            fig2=figure(3);
                                            fig2.Name='AIR SPEED';
                                            movegui(fig2,'northeast');
                                            offset=liste_AS(1)+liste_AS(2);
                                            LEG{1,1}='air speed';                                            
                                            LEG{2,1}='altitude';                                           
                                            list_ind{1}=5;
                                            list_ind{2}=4;                                            
                                            titre{1}='air speed';
                                            titre{2}='altitude';
                                            nb_ligne=1;
                                            for k_as=1:length(liste_AS)
                                                if liste_AS(k_as)==1   %===========================% fenetre 1
                                                    nbrePlot=sum(liste_AS(1:k_as));
                                                    set(0,'CurrentFigure',fig2)
                                                    subplot(nb_ligne,offset,nbrePlot);
                                                    
                                                    plot(PaquetAirData_temp(seuil_bas10:seuil_haut10,list_ind{k_as}),'-*')                                                    
                                                    legend(LEG{k_as,1:length(list_ind{k_as})})
                                                    hold off
                                                    title(titre{k_as})
%                                                 
                                                end
                                            end
                                         end
                                         
                                         if Nombre_graph_WP > 0 
                                            list_ind={};
                                            LEG={};
                                            fig3=figure(4);
                                            fig3.Name='WIND PACQUET';
                                            movegui(fig3,'southwest');
                                            offset=liste_WP(1)+liste_WP(2);
                                            LEG{1,1}='wind velocity N';                                            
                                            LEG{2,1}='wind velocity E';                                           
                                            list_ind{1}=2;
                                            list_ind{2}=3;                                            
                                            titre{1}='wind velocity N';
                                            titre{2}='wind velocity E';
                                            nb_ligne=1;
                                            for k_wp=1:length(liste_WP)
                                                if liste_WP(k_wp)==1   %===========================% fenetre 1
                                                    nbrePlot=sum(liste_WP(1:k_wp));
                                                    set(0,'CurrentFigure',fig3)
                                                    subplot(nb_ligne,offset,nbrePlot);
                                                    
                                                    plot(PaquetWind_temp(seuil_bas10:seuil_haut10,list_ind{k_wp}),'-*')                                                    
                                                    legend(LEG{k_wp,1:length(list_ind{k_wp})})
                                                    hold off
                                                    title(titre{k_wp})
%                                                 
                                                end
                                            end
                                         end
                                        if Nombre_graph_SS > 0 
                                            list_ind={};
                                            LEG={};
                                            fig4=figure(5);
                                            fig4.Name='SYSTEM STATE';
                                            movegui(fig4,'southeast');
                                           
                                            LEG{1,1}='Roll Spatial';                                            
                                            LEG{2,1}='Pitch Spatial'; 
                                            LEG{3,1}='Heading Spatial';                                            
                                            LEG{4,1}='G';
                                            LEG{5,1}='Roll Motus';                                            
                                            LEG{6,1}='Pitch Motus';
                                            LEG{7,1}='Heading Motus';
                                            list_ind{1}=16;
                                            list_ind{2}=17; 
                                            list_ind{3}=18;
                                            list_ind{4}=15;
                                            list_ind{5}=2;
                                            list_ind{6}=3;
                                            list_ind{7}=4;
                                            titre{1}='Roll Spatial';                                            
                                            titre{2}='Pitch Spatial'; 
                                            titre{3}='Heading Spatial';                                            
                                            titre{4}='G';
                                            titre{5}='Roll Motus';                                            
                                            titre{6}='Pitch Motus';
                                            titre{7}='Heading Motus';
                                            if sum(liste_SS(5:end))>=1 && sum(liste_SS(1:4))>=1
                                                nb_ligne=2;
                                                nb_col=max(sum(liste_SS(5:end)),sum(liste_SS(1:4)));
                                                offset=nb_col;
                                            else
                                                nb_ligne=1;
                                                nb_col=sum(liste_SS(:));
                                                offset=0;            
                                            end
                                            for k_ss=1:length(liste_SS)
                                                if liste_SS(k_ss)==1   %===========================% fenetre 1                                                   
                                                    
                                                    set(0,'CurrentFigure',fig4)
                                                   
                                                    
                                                    if k_ss<5
                                                        nbrePlot=sum(liste_SS(1:k_ss));
                                                        subplot(nb_ligne,nb_col,nbrePlot);
                                                        plot(AD_NAVIGATION_temp(seuil_bas10:seuil_haut10,list_ind{k_ss}),'-*')
                                                    else
                                                        nbrePlot=sum(liste_SS(5:k_ss))+offset;
                                                        subplot(nb_ligne,nb_col,nbrePlot);
                                                        plot(MOTUSORI_temp(seuil_bas10:seuil_haut10,list_ind{k_ss}),'-*')
                                                    end
                                                    legend(LEG{k_ss,1:length(list_ind{k_ss})})
                                                    hold off
                                                    title(titre{k_ss})
%                                                 
                                                end
                                            end
                                        end
                                        
                                        if Nombre_graph_TH > 0 
                                            list_ind={};
                                            LEG={};
                                            fig5=figure(6);
                                            fig5.Name='TEMPERATURE & HUMIDITE';
                                            movegui(fig5,'center');
                                            
                                            LEG{1,1}='Temperature SHT 1';                                            
                                            LEG{2,1}='Temperature SHT 2'; 
                                            LEG{3,1}='PT100';                                            
                                            LEG{4,1}='Humidite SHT 1';
                                            LEG{5,1}='Humidite SHT 2';                                            
                                            list_ind{1}=6;
                                            list_ind{2}=8; 
                                            list_ind{3}=3;
                                            list_ind{4}=7;
                                            list_ind{5}=9;
                                            titre{1}='Temperature SHT 1';                                            
                                            titre{2}='Temperature SHT 2';                                                                                      
                                            titre{3}='PT100';
                                            titre{4}='Humidite SHT 1';                                            
                                            titre{5}='Humidite SHT 2';
                                            
                                           if sum(liste_TH(4:end))>=1 && sum(liste_TH(1:3))>=1
                                                nb_ligne=2;
                                                nb_col=max(sum(liste_TH(4:end)),sum(liste_TH(1:3)));
                                                offset=nb_col;
                                            else
                                                nb_ligne=1;
                                                nb_col=sum(liste_TH(:));
                                                offset=0;
                                            end
                                            for k_th=1:length(liste_TH)
                                                if liste_TH(k_th)==1   %===========================% fenetre 1
                                                    if k_th<4 
                                                       nbrePlot=sum(liste_TH(1:k_th));
                                                    else
                                                       nbrePlot=offset+sum(liste_TH(4:k_th));
                                                    end
                                                        
                                                    
                                                    set(0,'CurrentFigure',fig5)
                                                    subplot(nb_ligne,nb_col,nbrePlot);
                                                   
                                                    if k_th==3
                                                        plot(T2_temp(seuil_bas10:seuil_haut10,list_ind{k_th}),'-*')
                                                    else
                                                        plot(TH_temp(seuil_bas10:seuil_haut10,list_ind{k_th}),'-*')
                                                    end
                                                    legend(LEG{k_th,1:length(list_ind{k_th})})
                                                    hold off
                                                    title(titre{k_th})
%                                                 
                                                end
                                            end
                                        end   
%                                         =====================================
% 
%                                         if Nombre_graph_MGAUSS >0                  %capteur NOx
%                                             fig2=figure(3);
%                                             fig2.Name='MOTUS';
%                                             movegui(fig2,'southwest');
%                                             offset=Num_Voie4_MGAUSS_X + Num_Voie5_MGAUSS_Y + Num_Voie6_MGAUSS_Z;
% 
%                                             if Voie4_MGAUSS_X %12
%                                                 set(0,'CurrentFigure',fig2)
%                                                 nbrePlot = Num_Voie4_MGAUSS_X;
%                                                 subplot(Nombre_de_lignes,Nombre_graph_MGAUSS,nbrePlot )
%                                                 histfit(MOTUSRAW(5:seuil_haut10,2),5000)%,seuil_bas:seuil_haut)%,'Color', 'b')
%                                                 hold off
%                                                 title('X')
%                                             end
% 
%                                             if Voie5_MGAUSS_Y
%                                                 set(0,'CurrentFigure',fig2)
%                                                 nbrePlot= Num_Voie4_MGAUSS_X + Num_Voie5_MGAUSS_Y;
%                                                 subplot(Nombre_de_lignes,Nombre_graph_MGAUSS,nbrePlot)
%                                                 histfit(MOTUSRAW(5:seuil_haut10,3),5000)%,seuil_bas:seuil_haut)%,'Color','g')
%                                                 hold off
%                                                 title('Y')
%                                             end
% 
%                                             if Voie6_MGAUSS_Z    
%                                                 set(0,'CurrentFigure',fig2)
%                                                 nbrePlot= Num_Voie4_MGAUSS_X + Num_Voie5_MGAUSS_Y + Num_Voie6_MGAUSS_Z;
%                                                 subplot(Nombre_de_lignes,Nombre_graph_MGAUSS,nbrePlot)
%                                                 
%                                                 histfit(MOTUSRAW(5:seuil_haut10,4),5000)%,seuil_bas:seuil_haut)%,'Color', 'k')
%                                                 hold off
%                                                 title('Z')
%                                             end
%                                         end
% %                                         ===================================================================================
% 
%                                         if Nombre_graph_SACC > 0                      
% 
%                                             fig3=figure(4);
%                                             fig3.Name='SPATIAL';
%                                             movegui(fig3,'northeast');
%                                             offset=Num_Voie7_SACC_X +Num_Voie8_SACC_Y+Num_Voie9_SACC_Z;
% 
%                                             if Voie7_SACC_X   %6                                             
%                                                 nbrePlot= Num_Voie7_SACC_X
%                                                 if Affichage_zoom
%                                                     set(0,'CurrentFigure',fig3)
%                                                     subplot(2,Nombre_graph_MACC,nbrePlot);
%                                                     plot(IMU(seuil_bas:seuil_haut,2),'-+','Color','b')
%                                                     hold off
%                                                     title('Acceleration X')
%                                                     subplot(2,Nombre_graph_MACC,nbrePlot+offset);
%                                                     plot(IMU(seuil_bas2:seuil_haut2,2),'-+','Color','b')
%                                                     hold off
%                                                     title('Acceleration X')
%                                                 else
%                                                     set(0,'CurrentFigure',fig3)
%                                                     subplot(Nombre_de_lignes,Nombre_graph_SACC,nbrePlot)
%                                                     plot(IMU(seuil_bas:seuil_haut,2),'-+','Color','b')
%                                                     hold off
%                                                     title('Acceleration X')
%                                                 end 
%                                                 
%                                                 
%                                             end
% 
%                                             if Voie8_SACC_Y  %7
%                                                 nbrePlot = Num_Voie7_SACC_X + Num_Voie8_SACC_Y;
%                                                 if Affichage_zoom
%                                                     set(0,'CurrentFigure',fig3)
%                                                     subplot(2,Nombre_graph_MACC,nbrePlot);
%                                                     plot(IMU(seuil_bas:seuil_haut,3),'-+','Color','g')
%                                                     hold off
%                                                     title('Acceleration Y')
%                                                     subplot(2,Nombre_graph_MACC,nbrePlot+offset);
%                                                     plot(IMU(seuil_bas2:seuil_haut2,3),'-+','Color','g')
%                                                     hold off
%                                                     title('Acceleration Y')
%                                                 else
%                                                     set(0,'CurrentFigure',fig3)
%                                                     subplot(Nombre_de_lignes,Nombre_graph_SACC,nbrePlot)
%                                                     plot(IMU(seuil_bas:seuil_haut,3),'-+','Color','g')
%                                                     hold off
%                                                     title('Acceleration Y')
%                                                 end 
%                                             end
% 
%                                             if Voie9_SACC_Z  %8
%                                                 
%                                                 nbrePlot= Num_Voie7_SACC_X +Num_Voie8_SACC_Y+Num_Voie9_SACC_Z ;
%                                                 
%                                                 
%                                                 if Affichage_zoom
%                                                     set(0,'CurrentFigure',fig3)
%                                                     subplot(2,Nombre_graph_MACC,nbrePlot);
%                                                     plot(IMU(seuil_bas:seuil_haut,4),'-+','Color','k')
%                                                     hold off
%                                                     title('Acceleration Y')
%                                                     subplot(2,Nombre_graph_MACC,nbrePlot+offset);
%                                                     plot(IMU(seuil_bas2:seuil_haut2,4),'-+','Color','k')
%                                                     hold off
%                                                     title('Acceleration Y')
%                                                 else
%                                                     set(0,'CurrentFigure',fig3)
%                                                     subplot(Nombre_de_lignes,Nombre_graph_SACC,nbrePlot)
%                                                     plot(IMU(seuil_bas:seuil_haut,4),'-+','Color','k')
%                                                     hold off
%                                                     title('Acceleration Z')
%                                                 end 
%                                             end
%                                         end
% %                                         ========================================
% 
%                                         if Nombre_graph_SGAUSS   > 0
%                                                 fig4=figure(5);
%                                                 fig4.Name='SPATIAL';
%                                                 movegui(fig4,'southeast');
%                                                  offset=Num_Voie10_SGAUSS_X+Num_Voie11_SGAUSS_Y+Num_Voie12_SGAUSS_Z;
% 
%                                                  if Voie10_SGAUSS_X  %10
%                                                      set(0,'CurrentFigure',fig4)
%                                                     nbrePlot = Num_Voie10_SGAUSS_X ;
%                                                     subplot(Nombre_de_lignes,Nombre_graph_SGAUSS,nbrePlot)
%                                                     histfit(IMU(5:seuil_haut,2),5000)%,seuil_bas:seuil_haut)%,'Color','b')
%                                                     hold off
%                                                     title('X')
%                                                  end
% 
%                                                  if Voie11_SGAUSS_Y  %11
%                                                      set(0,'CurrentFigure',fig4)
%                                                     nbrePlot = Num_Voie10_SGAUSS_X+Num_Voie11_SGAUSS_Y;
%                                                     subplot(Nombre_de_lignes,Nombre_graph_SGAUSS,nbrePlot)
%                                                     histfit(IMU(5:seuil_haut,3),5000)%,seuil_bas:seuil_haut)%,'Color','k')
%                                                     hold off
%                                                     title('Y')
%                                                  end
%                                                  
%                                                  if Voie12_SGAUSS_Z  %12 
%                                                      set(0,'CurrentFigure',fig4)
%                                                     nbrePlot = Num_Voie10_SGAUSS_X+Num_Voie11_SGAUSS_Y+Num_Voie12_SGAUSS_Z;
%                                                     subplot(Nombre_de_lignes,Nombre_graph_SGAUSS,nbrePlot)
%                                                     histfit(IMU(5:seuil_haut,4),5000)%,seuil_bas:seuil_haut)%,'Color', 'k')
%                                                     hold off
%                                                     title('Z')
%                                                  end
%                                         end
%                                         
%                                         
%                                         if Nombre_graph_SQSM   > 0
%                                                 fig5=figure(6);
%                                                 fig5.Name='QUADRATIC SUM';
%                                                 movegui(fig5,'center');
%                                                  offset=Num_MOTUS_QS+Num_SPATIAL_QS;
% 
%                                                  if MOTUS_QS  %10
%                                                     nbrePlot = Num_MOTUS_QS ;
%                                                     set(0,'CurrentFigure',fig5);
%                                                     subplot(Nombre_de_lignes,Nombre_graph_SQSM,nbrePlot)
%                                                     plot(MOTUSRAW(seuil_bas10:seuil_haut10,16),'-*','Color','b')
%                                                     hold off
%                                                     title('MOTUS')
%                                                  end
% 
%                                                  if SPATIAL_QS  %11  
%                                                     nbrePlot = Num_MOTUS_QS+Num_SPATIAL_QS;
%                                                     set(0,'CurrentFigure',fig5);
%                                                     subplot(Nombre_de_lignes,Nombre_graph_SQSM,nbrePlot)
%                                                     plot(IMU(seuil_bas:seuil_haut,16),'-+','Color','k')
%                                                     hold off
%                                                     title('SPATIAL')
%                                                  end
%                                                  
%                                         end
%                                         
%                                         if Nombre_graph_SHT >0
%                                             fig6=figure(7);
%                                             fig6.Name='SHT85';
%                                             movegui(fig6,'east');
%                                             nb_ligne=Num_Voie3_Hum_SHT1+Num_Voie4_Hum_SHT2+1;
%                                             if nb_ligne>2
%                                                 nb_ligne=2;
%                                             end 
%                                             if Num_Voie1_Temp_SHT1  %10
%                                                 nbrePlot =Num_Voie1_Temp_SHT1;
%                                                 set(0,'CurrentFigure',fig6);
%                                                 subplot(nb_ligne,Num_Voie1_Temp_SHT1+Num_Voie2_Temp_SHT2,nbrePlot)
%                                                
%                                                 plot(TH(seuil_bas:seuil_haut,6),'-*','Color','r')
%                                                 hold off
%                                                 title('TEMPERATURE 1')
%                                             end
%                                             if Num_Voie2_Temp_SHT2  %10
%                                                 nbrePlot =Num_Voie1_Temp_SHT1+Num_Voie2_Temp_SHT2;
%                                                 set(0,'CurrentFigure',fig6);
%                                                 subplot(nb_ligne,Num_Voie1_Temp_SHT1+Num_Voie2_Temp_SHT2,nbrePlot)
%                                                 plot(TH(seuil_bas:seuil_haut,8),'-+','Color','r')
%                                                 hold off
%                                                 title('TEMPERATURE 2')
%                                             end      
%                                             if Num_Voie3_Hum_SHT1  %10
%                                                 nbrePlot =Num_Voie1_Temp_SHT1+Num_Voie2_Temp_SHT2+Num_Voie3_Hum_SHT1;
%                                                 set(0,'CurrentFigure',fig6);
%                                                 subplot(nb_ligne,Num_Voie1_Temp_SHT1+Num_Voie2_Temp_SHT2,nbrePlot)
%                                                 plot(TH(seuil_bas:seuil_haut,7),'-*','Color','b')
%                                                 hold off
%                                                 title('HUMIDITE 1')
%                                             end      
%                                             if Num_Voie4_Hum_SHT2  %10
%                                                 nbrePlot =Num_Voie1_Temp_SHT1+Num_Voie2_Temp_SHT2+Num_Voie3_Hum_SHT1+Num_Voie4_Hum_SHT2;
%                                                 set(0,'CurrentFigure',fig6);
%                                                 subplot(nb_ligne,Num_Voie1_Temp_SHT1+Num_Voie2_Temp_SHT2,nbrePlot)
%                                                 plot(TH(seuil_bas:seuil_haut,9),'-+','Color','b')
%                                                 hold off
%                                                 title('HUMIDITE 2')
%                                             end      
%                                         end 
%                                         
%                                         
                                    end
                                
								 j=j+1;
								 u=u+1;
                            else
                                
                                
                                fclose(s); 
                                fopen(s);
                            end
                        end
                        timeout = timeout + 1;
                        pause(0.1);
                        message5 = sprintf('Liaison ouverte  \n');
                        %            q(0:512)=0;
                        %                 fclose(s);
                        
                    end
                    
                end
                
                
                if Sauvegarde_Donnees
                     if boucle2==12
                         
                        save(NomFichier,'suite_q','AD_NAVIGATION','IMU','PaquetAirData','PaquetWind','AirDataSensors',...
                            'Pattern','Pressures','TH','T2','MOTUSRAW','MOTUSORI','Q');
                        boucle2=1;
                     else 
                        boucle2=boucle2+1
                     end
                    
                    
                end
                
            end
        
        end
        
        
    end
end



%============= Fenetre ===============%
message0 = ' ';
% for k = 1 : 10
%   message = sprintf('%sThis is line #%d\n', message, k)
% end

message1 = sprintf('%sLe numero du port est: #%d\n',message0,Val_Com);

if AFF2D_Temp_Altitude
    message2 = sprintf('Affichage Temp/Altitude \n ');
else
    message2 = sprintf('Pas affichage Temp/Altitude \n ');
end

if AFF2D_Hum_Altitude
    message3 = sprintf('Affichage Hum/Altitude \n ');
else
    message3 = sprintf('Pas affichage Temp/Altitude \n ');
end

if Sauvegarde_Donnees
    message4 = sprintf('Sauvegarde donnees en cours \n ');
else
    message4 = sprintf('Pas de sauvegarde donnees en cours \n ');
end

message = sprintf('%s %s %s %s %s',message1,message2,message3,message4,message5);
set(handles.text2,'string',message);

sRange=int2str(Range);
message = sprintf('%sLe nombre de point est: %s\n',message0,sRange);
set(handles.text5,'string',message);

% txt12 rangehaut
sRangehaut= int2str(Range_haut);
message = sprintf('%sSeuil Haut :Le nombre de point est: %s\n',message0,sRangehaut);
set(handles.text12,'string',message);
% txt14 rangebas
sRangebas= int2str(Range_bas);
message = sprintf('%sSeuil Bas :Le nombre de point est: %s\n',message0,sRangebas);
set(handles.text14,'string',message);

end



