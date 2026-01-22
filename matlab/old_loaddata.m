function Result = loaddata(filename, zero_offset_pressure, whatload)
if nargin < 1
    Result = 0
    return;
end

f = fopen(filename);
if ~f
    Result = 0;
    return;
end





% %==================================================================%
% % Intialisation de parametres pour calculs GPS time
% TSmilli_old =0;
% GPSMilli_old =0;
% tref = [1980 01 06 0 0 0];  % 1980 janvier 06
% year = 2016;
% month = 06;
% day = 15;
% hour = 0;
% min =0; 
% sec=0;
% %==================================================================%
length_data = length((fread(f)))
taille_fichier=1024;%512 
%=================  Lecture Option des donnees ====================%
if nargin == 1
    whatload = 15;
    zero_offset_pressure = [13653 13653 13653 13653 13653 13653];
elseif nargin == 2
    whatload = 15;
end
%==================================================================%
Result.AD_NAVIGATION_label={'Time','SystStatus','FilterStatus','Unixtime','MicroSecondes',...
    'Latitude(Rad)','Longitude(Rad)','Height','VitesseNord','VitesseEast','VitesseDown',...
    'Acceleration_X','Acceleration_Y','Acceleration_Z','G','Roll','Pitch','Heading',...
    'AngularVelocity_X','AngularVelocity_Y','AngularVelocity_Z',...
    'LatitudeStandardDeviation','LongitudeStandardDeviation','HeightStandardDeviation','Secondes','TSmilli'};
Result.AD_NAVIGATION = zeros(floor(length_data/taille_fichier), 26);
%==================================================================% 
%  Result.PaquetGNSS_label={'Time','Unixtime','Microseconds','Latitude(Rad)','Longitude(Rad)','Height',...
%    'VitesseNord','VitesseEast','VitesseDown', 'LatitudeStandardDeviation','LongitudeStandardDeviation','HeightStandardDeviation',...
%    'Reserved','Reserved','Reserved','Reserved','SystStatus','Secondes','TSmilli'};
% Result.PaquetGNSS = zeros(floor(length_data/taille_fichier), 19);
%==================================================================%  
Result.PaquetAirData_label={'Time','BaroRetard(s)','AirSpeedRetard(s)','BaroAltitude(m)','AirSpeed(m/s)',...
    'BaroStandardDeviation(m)','AirSpeedStandardDeviation(m/s)','StatusAirData','Secondes','TSmilli'};
 Result.PaquetAirData=   zeros(floor(length_data/taille_fichier), 10);
%==================================================================%
 Result.PaquetWind_label={'Time','WindVelocityNorth(m/s)','WindVelocityEast(m/s)',...
     'WindVelocityStandardDeviation(m/s)','Secondes','TSmilli'};
 Result.PaquetWind=   zeros(floor(length_data/taille_fichier), 6);
%==================================================================%
 Result.AirDataSensors_label={'Time','AbsolutePressure(Pa)','DifferentialPressure(Pa)',...
     'FlagsRawStatus','Temperature(c)','Secondes','TSmilli'};
 Result.AirDataSensors=   zeros(floor(length_data/taille_fichier), 7);
%==================================================================%
% if bitand(whatload, 8)
Result.IMU_label = {'Time','Xaccl', 'Yaccl', 'Zaccl','Xgyro', 'Ygyro', 'Zgyro', 'Xmagn', 'Ymagn', 'Zmagn', 'TemperatureIMU','Barometer','TemperaturePressure','Secondes','TSmilli','QuadSum'};
%    Result.IMU = zeros(floor(length_data/512*10), 12);     %  Il y a 10 valeures par lignes 
 Result.IMU = zeros(floor(length_data/taille_fichier), 16);
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
 Result.Pattern= zeros(floor(length_data/taille_fichier), 53);
% end
%==================================================================%
Result.MOTUSRAW_label = {'Time','Xaccl', 'Yaccl', 'Zaccl','Xgyro', 'Ygyro', 'Zgyro', 'Xmagn', 'Ymagn', 'Zmagn', 'TemperatureIMU','Barometer','TemperaturePressure','Secondes','TSmilli','QuadSum'};
%    Result.IMU = zeros(floor(length_data/512*10), 12);     %  Il y a 10 valeures par lignes 
 Result.MOTUSRAW = zeros(floor(length_data/taille_fichier)*10, 16);

Result.MOTUSORI_label = {'Time','Roll', 'Pitch', 'Heading','Secondes','TSmilli'};
%    Result.IMU = zeros(floor(length_data/512*10), 12);     %  Il y a 10 valeures par lignes 
 Result.MOTUSORI = zeros(floor(length_data/taille_fichier), 6);
%==================================================================%
% Modif MIRIAD PressionBaro1, PressionBaro2, PressionPitot         %
%==================================================================%
% if bitand(whatload, 4)
    Result.Pressures_label = {'Time','Data1Baro', 'Data2Baro', 'Data3HCE1','Data4HCE4',....
        'Data5HCE5', 'Data6HCE6', 'Data7LDE1', 'Data8LDE2', 'Data9LDE3','Data10LDE4','Baro1', 'Baro2' ...
        'Pressure1HCE1', 'Pressure2HCE2','Pressure3HCE3', 'Pressure4HCE4','Pressure5LDE1',...
        'Pressure6LDE2', 'Pressure7LDE3','Pressure8LDE4','Secondes','TSmilli'};
     Result.Pressures = zeros(floor(length_data/taille_fichier)*10, 23);   % Données a 1000Hz
% end

%==================================================================%
% Modif MIRIAD PressionBaro1, PressionBaro2, PressionPitot         %
%==================================================================%
    Result.TH_label = {'Time','digi1','digi2','digi3','digi4', 'Temp1', 'Hum1', 'Temp2', 'Hum2','Secondes','TSmilli'};
    Result.TH = zeros(floor(length_data/512), 11); % Donnees a 2.5 Hz
%     i_TH = 1;
    Result.T2_label = {'Time','digi1', 'Temp2','Secondes','Tsmilli'};
    Result.T2 = zeros(floor(length_data/512), 5);  % Donnees a 10 Hz 
%     i_T2 = 1;

%======================Boucle de lecture==================================
j = 1;
u = 0;
um = 0;
%
% Retour au debut fichier
frewind(f);
taille_paquet=taille_fichier;   % 1 512
debut_paquet=1;  
steps = (length_data/taille_paquet);
saut= taille_paquet*4; % Saut de 4 lignes de 512  
% j=length_data/taille_paquet
%=========================================================================%
 
%   while j < length_data/taille_paquet +1
   while j < length_data/taille_paquet -4 %+1 % suppression dernier paquet
 %   while j < 800 -4 %+1 % suppression dernier paquet
      fseek(f,debut_paquet-1+saut,'bof');
        
% Lecture packet 20 IMU         
        %X=fread(f,1,'uint16');    % SystStatus     add_0 et 1 --header 00 C2  
    %if X == 15104 %3B00 %49664 %C2 00
 
    
        Result.AD_NAVIGATION(j,2)=fread(f,1,'uint16');    % SystStatus     add_0 et 1 --header 00 C2         
        Result.AD_NAVIGATION(j,3)=fread(f,1,'uint16');    % FilterStatus   add_2 et 3
        Result.AD_NAVIGATION(j,4)=fread(f,1,'uint32');    % Unixtime       add_4 5 et 6 7
        Result.AD_NAVIGATION(j,5)=fread(f,1,'uint32');    % MicroSecondes  add_8 9 et 10 11
        Result.AD_NAVIGATION(j,6)=fread(f,1,'float64');   % Latitude(Rad)  add_12 13 et 14 15  16 17 et 18 19
        Result.AD_NAVIGATION(j,7)=fread(f,1,'float64');   % Longitude(Rad) add_20 21 et 22 23  24 25 et 26 27
        Result.AD_NAVIGATION(j,8)=fread(f,1,'float64');   % Height         add_28 29 et 30 31  32 33 et 34 35
        Result.AD_NAVIGATION(j,9)=fread(f,1,'float32');   % VitesseNord    add_36 37 et 38 39
        Result.AD_NAVIGATION(j,10)=fread(f,1,'float32');  % VitesseEast    add_40 41 et 42 43
        Result.AD_NAVIGATION(j,11)=fread(f,1,'float32');  % VitesseDown    add_44 45 et 46 47
        Result.AD_NAVIGATION(j,12)=fread(f,1,'float32');  % Acceleration_X add_48 49 et 50 51
        Result.AD_NAVIGATION(j,13)=fread(f,1,'float32');  % Acceleration_Y add_52 53 et 54 55
        Result.AD_NAVIGATION(j,14)=fread(f,1,'float32');  % Acceleration_Z add_56 57 et 58 59
        Result.AD_NAVIGATION(j,15)=fread(f,1,'float32');  % G              add_60 61 et 62 63
        Result.AD_NAVIGATION(j,16)=fread(f,1,'float32');  % Roll           add_64 65 et 66 67
        Result.AD_NAVIGATION(j,17)=fread(f,1,'float32');  % Pitch          add_68 69 et 70 71
        Result.AD_NAVIGATION(j,18)=fread(f,1,'float32');  % Heading        add_72 73 et 74 75
        Result.AD_NAVIGATION(j,19)=fread(f,1,'float32');  % AngularVelocity_X   add_76 77 et 78 79
        Result.AD_NAVIGATION(j,20)=fread(f,1,'float32');  % AngularVelocity_Y   add_80 81 et 82 83
        Result.AD_NAVIGATION(j,21)=fread(f,1,'float32');  % AngularVelocity_Z   add_84 85 et 86 87
        Result.AD_NAVIGATION(j,22)=fread(f,1,'float32');  % LatitudeStandardDeviation   add_88 89 et 90 91
        Result.AD_NAVIGATION(j,23)=fread(f,1,'float32');  % LongitudeStandardDeviation  add_92 93 et 94 95
        Result.AD_NAVIGATION(j,24)=fread(f,1,'float32');  % HeightStandardDeviation     add_96 97 et 98 99
% Lecture packet 28 IMU      
        Result.IMU(j,2)=fread(f,1,'float32');  % Xaccl   add_100 101 et 102 103   % On ne demarre pas a un car il y a time
        Result.IMU(j,3)=fread(f,1,'float32');  % Yaccl   add_104 105 et 106 107
        Result.IMU(j,4)=fread(f,1,'float32');  % Zaccl   add_108 109 et 110 111
        Result.IMU(j,5)=fread(f,1,'float32');  % Xgyro   add_112 113 et 114 115
        Result.IMU(j,6)=fread(f,1,'float32');  % Ygyro   add_116 117 et 118 119
        Result.IMU(j,7)=fread(f,1,'float32');  % Zgyro   add_120 121 et 122 123
        Result.IMU(j,8)=fread(f,1,'float32');  % Xmagn   add_124 125 et 126 127
        Result.IMU(j,9)=fread(f,1,'float32');  % Ymagn   add_128 129 et 130 131
        Result.IMU(j,10)=fread(f,1,'float32'); % Zmagn   add_132 133 et 134 135
        Result.IMU(j,11)=fread(f,1,'float32'); % IMUTemperatureIMU  add_136 137 et 138 139
        Result.IMU(j,12)=fread(f,1,'float32'); % Barometer          add_140 141 et 142 143
        Result.IMU(j,13)=fread(f,1,'float32'); % TemperaturePressure add_144 145 et 146 147

        Result.IMU(j,16) =((Result.IMU(j,2)).^2 +(Result.IMU(j,3)).^2 +(Result.IMU(j,4)).^2).^0.5;
         
 % Lecture packet AIR DATA UNIT N] 68
        Result.PaquetAirData(j,2)=fread(f,1,'float32');  % Barometrique Altitude delay(s)              add_148 149 et 150 151     
        Result.PaquetAirData(j,3)=fread(f,1,'float32');  % Air Speed Delay(s)                          add_152 153 et 154 155
        Result.PaquetAirData(j,4)=fread(f,1,'float32');  % Barometrique Altitude(m)                    add_156 157 et 158 159
        Result.PaquetAirData(j,5)=fread(f,1,'float32');  % AirSpeed (m/s)                              add_160 161 et 162 163
        Result.PaquetAirData(j,6)=fread(f,1,'float32');  % Barometrique Standard deviation             add_164 165 et 166 167
        Result.PaquetAirData(j,7)=fread(f,1,'float32');  % Air Speed Standard deviation                add_168 169 et 170 171
        Result.PaquetAirData(j,8)=fread(f,1,'uint8');    % Status                                       add_172

 % Lecture packet Wind Packet  
        Result.PaquetWind(j,2)=fread(f,1,'float32');  % WindVelocityNorth(m/s) add_ 173 et 174 175 176 
        Result.PaquetWind(j,3)=fread(f,1,'float32');  % WindVelocityEast(m/s) add_ 177 et 178 179 180 
        Result.PaquetWind(j,4)=fread(f,1,'float32');  % WindVelocityStandardDeviation(m/s) add_181 et 182 183 184
  
 % Lecture packet Air Data Sensors  
        Result.AirDataSensors(j,2)=fread(f,1,'float32'); % Absolute pressure(Pa) 185 et 186 187 188
        Result.AirDataSensors(j,3)=fread(f,1,'float32');  % Differential pressue (Pa) 189 et 190 191 192
        Result.AirDataSensors(j,4)=fread(f,1,'uint8');    % Status 193
        Result.AirDataSensors(j,5)=fread(f,1,'float32');  % add 194 195 196 197
        
 % Saut de 35 lignes       
        
        Temp= fread(f, 36, '*uchar');%add_233
    
    % Lecture separateurs
        Result.Pattern(j,2)=fread(f,1,'uint8'); % AA      add_234
        Result.Pattern(j,3)=fread(f,1,'uint8'); % BB      add_235
    % Capteurs pressions HCE / Baro
 
        pression_brute0=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_236 %add_237  % Pression Baro1 HCEMO611
        pression_brute1=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_238 %add_239  % Pression Baro1 HCEMO611
        
        s =( 24575 - 2730)/( 1100 - 600);
        Result_0 = (pression_brute0 - 2730)/s + 600;
        Result_1 = (pression_brute1 - 2730)/s + 600;
                     
        % data_pressure diff HCEM50mbar
        pression_brute2=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_240 %add_241       
        pression_brute3=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_242 %add_243
        pression_brute4=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_244 %add_245        
        pression_brute5=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_246 %add_247        
        
        % Pmax = 5FFF = 24575
        % Pmin = 0AAA = 2730
        % FSS= 5555 = 21845
        
        s =( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb
        
        
        
        Result_2 = (pression_brute2 - 2730)/s + (-0);  % Pitot %
        Result_3 = (pression_brute3 - 2730)/s + (-0);  
        Result_4 = (pression_brute4 - 2730)/s + (-0);  
        Result_5 = (pression_brute5 - 2730)/s + (-0);  

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute6 = double((typecast(uint8(a),'int16')));          
%         pression_brute6=double(fread(f,1,'int16'));% .*256+fread(f,1,'uint8'); %add_248 %add_249
        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute7 = double((typecast(uint8(a),'int16')));
%         pression_brute7=double(fread(f,1,'int16'));%*256+fread(f,1,'uint8'); %add_250 %add_251
        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute8 = double((typecast(uint8(a),'int16')));
%         pression_brute8=double(fread(f,1,'int16'));%*256+fread(f,1,'uint8'); %add_252 %add_253
        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute9 = double((typecast(uint8(a),'int16')));
%         pression_brute9=double(fread(f,1,'int16'));%*256+fread(f,1,'uint8'); %add_254 %add_255
        
            %  Scale factor LDE +/500pa = 60 --> /100mb
           
            Result_6=pression_brute6 /6000 ; % mb
            Result_7=pression_brute7 /6000 ; % mb
            Result_8=pression_brute8 /6000 ; % mb
            Result_9=pression_brute9 /6000 ; % mb
                            
        Result.Pressures(u*10+1,2)=pression_brute0; % Baro
        Result.Pressures(u*10+1,3)=pression_brute1; % Baro
        Result.Pressures(u*10+1,4)=pression_brute2; % Diff 1 HCE
        Result.Pressures(u*10+1,5)=pression_brute3; % Diff 2
        Result.Pressures(u*10+1,6)=pression_brute4; % Diff 3
        Result.Pressures(u*10+1,7)=pression_brute5; % Diff 4 
        Result.Pressures(u*10+1,8)=pression_brute6; % Diff 5 LDE
        Result.Pressures(u*10+1,9)=pression_brute7; % Diff 6
        Result.Pressures(u*10+1,10)=pression_brute8; % Diff 7
        Result.Pressures(u*10+1,11)=pression_brute9;  % Diff 8      
                
        Result.Pressures(u*10+1,12)=Result_0;  % Baro
        Result.Pressures(u*10+1,13)=Result_1;  % Baro
        Result.Pressures(u*10+1,14)=Result_2;  % Diff 1 HCE
        Result.Pressures(u*10+1,15)=Result_3;  % Diff 2
        Result.Pressures(u*10+1,16)=Result_4;  % Diff 3
        Result.Pressures(u*10+1,17)=Result_5;  % Diff 4     
        Result.Pressures(u*10+1,18)=Result_6;  % Diff 5 LDE
        Result.Pressures(u*10+1,19)=Result_7;  % Diff 6
        Result.Pressures(u*10+1,20)=Result_8;  % Diff 7
        Result.Pressures(u*10+1,21)=Result_9;  % Diff 8
        
%         %%%%%%%%%%%%%%%%% ADD 296 ---> 297 FF
%         Temp= fread(f, 41, '*uchar');  
        
 
     
 %========================================================================%
 % Lecture patern  Pression temp                       
 %========================================================================% 
        Result.Pattern(j,4) = fread(f, 1, 'uint8');   %CC
        Result.Pattern(j,5) = fread(f, 1, 'uint8');   %DD
%=========================================================================%     
% Lecture Temperature HT75
%=========================================================================% 
%
        digi1=fread(f,1,'uint8')*256 +fread(f,1,'uint8');    % data_temp_sht75_1     %add_222 et add_223
        digi2=fread(f,1,'uint8')*256+fread(f,1,'uint8');                             %add_224 et add_225    
        T1 = -39.7 + 0.01*digi1;
        RHlinear1 = -2.0468 + 0.0367*digi2 - 1.5955e-6*digi2^2;
        H1 = (T1 - 25)*(0.01 + 0.00008*digi2) + RHlinear1;
        Result.TH(j,2)=digi1;
        Result.TH(j,3)=digi2; 
        
        Result.TH(j,6)=T1;
        Result.TH(j,7)=H1;

%=========================================================================%     
% Lecture Temperature HT75
%=========================================================================% 
%
        digi1=fread(f,1,'uint8')*256 +fread(f,1,'uint8');    % data_temp_sht75_1     %add_222 et add_223
        digi2=fread(f,1,'uint8')*256+fread(f,1,'uint8');                             %add_224 et add_225    
        T1 = -39.7 + 0.04*digi1;
        RHlinear1 = -2.0468 + 0.5872*digi2 -  4.0845e-4*digi2^2;
        H1 = (T1 - 25)*(0.01 + 0.00128*digi2) + RHlinear1;
        Result.TH(j,4)=digi1;
        Result.TH(j,5)=digi2; 
        
        Result.TH(j,8)=T1;
        Result.TH(j,9)=H1;

 %========================================================================%
 % Lecture patern  Pression temp                       
 %========================================================================% 
         Result.Pattern(j,6) = fread(f, 1, 'uint8');   %EE
         Result.Pattern(j,7) = fread(f, 1, 'uint8');   %AA

%=========================================================================%     
% Lecture Temperature Max31865
%=========================================================================%        
        
         digi1= fread(f,1,'uint8')*256 +fread(f,1,'uint8');
         T2= digi1/32 - 256;
         Result.T2(j,2)=digi1;
         Result.T2(j,3)=T2;

%=========================================================================%
%  Saut ligne add270
         pouet= fread(f, 1, 'uint8');   %FF

%=========================================================================%     
% Lecture Pression sur echatillonage 2
%=========================================================================%            
            
        Result.Pattern(j,8)=fread(f,1,'uint8'); % 22      add_271
        Result.Pattern(j,9)=fread(f,1,'uint8'); % 22      add_272

        pression_brute0=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_273 %add_274  % Pression Baro1 HCEMO611
        pression_brute1=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_275 %add_276  % Pression Baro1 HCEMO611
        
        s =( 24575 - 2730)/( 1100 - 600);
        Result_0 = (pression_brute0 - 2730)/s + 600;
        Result_1 = (pression_brute1 - 2730)/s + 600;
                     
        % data_pressure diff HCEM10
        pression_brute2=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_277 %add_278       
        pression_brute3=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_279 %add_280
        pression_brute4=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_281 %add_282        
        pression_brute5=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_283 %add_284        
        
        s =( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb
        
        Result_2 = (pression_brute2 - 2730)/s + (-0);  % Pitot %
        Result_3 = (pression_brute3 - 2730)/s + (-0);  
        Result_4 = (pression_brute4 - 2730)/s + (-0);  
        Result_5 = (pression_brute5 - 2730)/s + (-0);  

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute6 = double((typecast(uint8(a),'int16')));          

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute7 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute8 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute9 = double((typecast(uint8(a),'int16')));
        
            %  Scale factor LDE +/500pa = 60 --> /100mb
           
        Result_6=pression_brute6 /6000 ; % mb
        Result_7=pression_brute7 /6000 ; % mb
        Result_8=pression_brute8 /6000 ; % mb
        Result_9=pression_brute9 /6000 ; % mb
                            
        Result.Pressures(u*10+2,2)=pression_brute0; % Baro
        Result.Pressures(u*10+2,3)=pression_brute1; % Baro
        Result.Pressures(u*10+2,4)=pression_brute2; % Diff 1 HCE
        Result.Pressures(u*10+2,5)=pression_brute3; % Diff 2
        Result.Pressures(u*10+2,6)=pression_brute4; % Diff 3
        Result.Pressures(u*10+2,7)=pression_brute5; % Diff 4 
        Result.Pressures(u*10+2,8)=pression_brute6; % Diff 5 LDE
        Result.Pressures(u*10+2,9)=pression_brute7; % Diff 6
        Result.Pressures(u*10+2,10)=pression_brute8; % Diff 7
        Result.Pressures(u*10+2,11)=pression_brute9;  % Diff 8      
                
        Result.Pressures(u*10+2,12)=Result_0;  % Baro
        Result.Pressures(u*10+2,13)=Result_1;  % Baro
        Result.Pressures(u*10+2,14)=Result_2;  % Diff 1 HCE
        Result.Pressures(u*10+2,15)=Result_3;  % Diff 2
        Result.Pressures(u*10+2,16)=Result_4;  % Diff 3
        Result.Pressures(u*10+2,17)=Result_5;  % Diff 4     
        Result.Pressures(u*10+2,18)=Result_6;  % Diff 5 LDE
        Result.Pressures(u*10+2,19)=Result_7;  % Diff 6
        Result.Pressures(u*10+2,20)=Result_8;  % Diff 7
        Result.Pressures(u*10+2,21)=Result_9;  % Diff 8            
            
%=========================================================================%     
% Lecture Pression sur echatillonage 3
%=========================================================================%            
            
        Result.Pattern(j,10)=fread(f,1,'uint8'); % 33      add_271
        Result.Pattern(j,11)=fread(f,1,'uint8'); % 33      add_272

        pression_brute0=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_295 %add_296  % Pression Baro1 HCEMO611
        pression_brute1=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_297 %add_298  % Pression Baro1 HCEMO611
        
        s =( 24575 - 2730)/( 1100 - 600);
        Result_0 = (pression_brute0 - 2730)/s + 600;
        Result_1 = (pression_brute1 - 2730)/s + 600;
                     
        % data_pressure diff HCEM10
        pression_brute2=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_299 %add_300       
        pression_brute3=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_301 %add_302
        pression_brute4=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_303 %add_304        
        pression_brute5=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_305 %add_306        
        
        s =( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb % +/- 100 mb
        
        Result_2 = (pression_brute2 - 2730)/s + (-0);  % Pitot %
        Result_3 = (pression_brute3 - 2730)/s + (-0);  
        Result_4 = (pression_brute4 - 2730)/s + (-0);  
        Result_5 = (pression_brute5 - 2730)/s + (-0);  

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute6 = double((typecast(uint8(a),'int16')));          

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute7 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute8 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute9 = double((typecast(uint8(a),'int16')));
        
            %  Scale factor LDE +/500pa = 60 --> /100mb
           
        Result_6=pression_brute6 /6000 ; % mb
        Result_7=pression_brute7 /6000 ; % mb
        Result_8=pression_brute8 /6000 ; % mb
        Result_9=pression_brute9 /6000 ; % mb
                            
        Result.Pressures(u*10+3,2)=pression_brute0; % Baro
        Result.Pressures(u*10+3,3)=pression_brute1; % Baro
        Result.Pressures(u*10+3,4)=pression_brute2; % Diff 1 HCE
        Result.Pressures(u*10+3,5)=pression_brute3; % Diff 2
        Result.Pressures(u*10+3,6)=pression_brute4; % Diff 3
        Result.Pressures(u*10+3,7)=pression_brute5; % Diff 4 
        Result.Pressures(u*10+3,8)=pression_brute6; % Diff 5 LDE
        Result.Pressures(u*10+3,9)=pression_brute7; % Diff 6
        Result.Pressures(u*10+3,10)=pression_brute8; % Diff 7
        Result.Pressures(u*10+3,11)=pression_brute9;  % Diff 8      
                
        Result.Pressures(u*10+3,12)=Result_0;  % Baro
        Result.Pressures(u*10+3,13)=Result_1;  % Baro
        Result.Pressures(u*10+3,14)=Result_2;  % Diff 1 HCE
        Result.Pressures(u*10+3,15)=Result_3;  % Diff 2
        Result.Pressures(u*10+3,16)=Result_4;  % Diff 3
        Result.Pressures(u*10+3,17)=Result_5;  % Diff 4     
        Result.Pressures(u*10+3,18)=Result_6;  % Diff 5 LDE
        Result.Pressures(u*10+3,19)=Result_7;  % Diff 6
        Result.Pressures(u*10+3,20)=Result_8;  % Diff 7
        Result.Pressures(u*10+3,21)=Result_9;  % Diff 8                    
            
 
        
%=========================================================================%     
% Lecture Pression sur echatillonage 4
%=========================================================================%            
            
        Result.Pattern(j,12)=fread(f,1,'uint8'); % 44      add_315
        Result.Pattern(j,13)=fread(f,1,'uint8'); % 44      add_316

        pression_brute0=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_317 %add_318  % Pression Baro1 HCEMO611
        pression_brute1=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_319 %add_320  % Pression Baro1 HCEMO611
        
        s =( 24575 - 2730)/( 1100 - 600);
        Result_0 = (pression_brute0 - 2730)/s + 600;
        Result_1 = (pression_brute1 - 2730)/s + 600;
                     
        % data_pressure diff HCEM10
        pression_brute2=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_321 %add_322       
        pression_brute3=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_323 %add_324
        pression_brute4=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_325 %add_326        
        pression_brute5=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_327 %add_328        
        
      s =( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb
        
        Result_2 = (pression_brute2 - 2730)/s + (-0);  % Pitot %
        Result_3 = (pression_brute3 - 2730)/s + (-0);  
        Result_4 = (pression_brute4 - 2730)/s + (-0);  
        Result_5 = (pression_brute5 - 2730)/s + (-0);  

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute6 = double((typecast(uint8(a),'int16')));          

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute7 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute8 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute9 = double((typecast(uint8(a),'int16')));
        
            %  Scale factor LDE +/500pa = 60 --> /100mb
           
        Result_6=pression_brute6 /6000 ; % mb
        Result_7=pression_brute7 /6000 ; % mb
        Result_8=pression_brute8 /6000 ; % mb
        Result_9=pression_brute9 /6000 ; % mb
                            
        Result.Pressures(u*10+4,2)=pression_brute0; % Baro
        Result.Pressures(u*10+4,3)=pression_brute1; % Baro
        Result.Pressures(u*10+4,4)=pression_brute2; % Diff 1 HCE
        Result.Pressures(u*10+4,5)=pression_brute3; % Diff 2
        Result.Pressures(u*10+4,6)=pression_brute4; % Diff 3
        Result.Pressures(u*10+4,7)=pression_brute5; % Diff 4 
        Result.Pressures(u*10+4,8)=pression_brute6; % Diff 5 LDE
        Result.Pressures(u*10+4,9)=pression_brute7; % Diff 6
        Result.Pressures(u*10+4,10)=pression_brute8; % Diff 7
        Result.Pressures(u*10+4,11)=pression_brute9;  % Diff 8      
                
        Result.Pressures(u*10+4,12)=Result_0;  % Baro
        Result.Pressures(u*10+4,13)=Result_1;  % Baro
        Result.Pressures(u*10+4,14)=Result_2;  % Diff 1 HCE
        Result.Pressures(u*10+4,15)=Result_3;  % Diff 2
        Result.Pressures(u*10+4,16)=Result_4;  % Diff 3
        Result.Pressures(u*10+4,17)=Result_5;  % Diff 4     
        Result.Pressures(u*10+4,18)=Result_6;  % Diff 5 LDE
        Result.Pressures(u*10+4,19)=Result_7;  % Diff 6
        Result.Pressures(u*10+4,20)=Result_8;  % Diff 7
        Result.Pressures(u*10+4,21)=Result_9;  % Diff 8                    
                    
%=========================================================================%     
% Lecture Pression sur echatillonage 5
%=========================================================================%            
            
        Result.Pattern(j,14)=fread(f,1,'uint8'); % 55      add_337
        Result.Pattern(j,15)=fread(f,1,'uint8'); % 55      add_338

        pression_brute0=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_339 %add_340  % Pression Baro1 HCEMO611
        pression_brute1=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_341 %add_342  % Pression Baro1 HCEMO611
        
        s =( 24575 - 2730)/( 1100 - 600);
        Result_0 = (pression_brute0 - 2730)/s + 600;
        Result_1 = (pression_brute1 - 2730)/s + 600;
                     
        % data_pressure diff HCEM10
        pression_brute2=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_343 %add_344       
        pression_brute3=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_345 %add_346
        pression_brute4=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_347 %add_348        
        pression_brute5=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_349 %add_350        
        
        s =( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb
        
        Result_2 = (pression_brute2 - 2730)/s + (-0);  % Pitot %
        Result_3 = (pression_brute3 - 2730)/s + (-0);  
        Result_4 = (pression_brute4 - 2730)/s + (-0);  
        Result_5 = (pression_brute5 - 2730)/s + (-0);  

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute6 = double((typecast(uint8(a),'int16')));          

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute7 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute8 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute9 = double((typecast(uint8(a),'int16')));
        
            %  Scale factor LDE +/500pa = 60 --> /100mb
           
        Result_6=pression_brute6 /6000 ; % mb
        Result_7=pression_brute7 /6000 ; % mb
        Result_8=pression_brute8 /6000 ; % mb
        Result_9=pression_brute9 /6000 ; % mb
                            
        Result.Pressures(u*10+5,2)=pression_brute0; % Baro
        Result.Pressures(u*10+5,3)=pression_brute1; % Baro
        Result.Pressures(u*10+5,4)=pression_brute2; % Diff 1 HCE
        Result.Pressures(u*10+5,5)=pression_brute3; % Diff 2
        Result.Pressures(u*10+5,6)=pression_brute4; % Diff 3
        Result.Pressures(u*10+5,7)=pression_brute5; % Diff 4 
        Result.Pressures(u*10+5,8)=pression_brute6; % Diff 5 LDE
        Result.Pressures(u*10+5,9)=pression_brute7; % Diff 6
        Result.Pressures(u*10+5,10)=pression_brute8; % Diff 7
        Result.Pressures(u*10+5,11)=pression_brute9;  % Diff 8      
                
        Result.Pressures(u*10+5,12)=Result_0;  % Baro
        Result.Pressures(u*10+5,13)=Result_1;  % Baro
        Result.Pressures(u*10+5,14)=Result_2;  % Diff 1 HCE
        Result.Pressures(u*10+5,15)=Result_3;  % Diff 2
        Result.Pressures(u*10+5,16)=Result_4;  % Diff 3
        Result.Pressures(u*10+5,17)=Result_5;  % Diff 4     
        Result.Pressures(u*10+5,18)=Result_6;  % Diff 5 LDE
        Result.Pressures(u*10+5,19)=Result_7;  % Diff 6
        Result.Pressures(u*10+5,20)=Result_8;  % Diff 7
        Result.Pressures(u*10+5,21)=Result_9;  % Diff 8            

     
 
%=========================================================================%     
% Lecture Pression sur echatillonage 6
%=========================================================================%            
            
        Result.Pattern(j,16)=fread(f,1,'uint8'); % 66      add_359
        Result.Pattern(j,17)=fread(f,1,'uint8'); % 66      add_360

        pression_brute0=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_361 %add_362  % Pression Baro1 HCEMO611
        pression_brute1=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_363 %add_364  % Pression Baro1 HCEMO611
        
        s =( 24575 - 2730)/( 1100 - 600);
        Result_0 = (pression_brute0 - 2730)/s + 600;
        Result_1 = (pression_brute1 - 2730)/s + 600;
                     
        % data_pressure diff HCEM10
        pression_brute2=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_365 %add_366       
        pression_brute3=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_367 %add_368
        pression_brute4=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_369 %add_370        
        pression_brute5=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_371 %add_372        
        
        s =( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb
        
        Result_2 = (pression_brute2 - 2730)/s + (-0);  % Pitot %
        Result_3 = (pression_brute3 - 2730)/s + (-0);  
        Result_4 = (pression_brute4 - 2730)/s + (-0);  
        Result_5 = (pression_brute5 - 2730)/s + (-0);  

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute6 = double((typecast(uint8(a),'int16')));          

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute7 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute8 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute9 = double((typecast(uint8(a),'int16')));
        
            %  Scale factor LDE +/500pa = 60 --> /100mb
           
        Result_6=pression_brute6 /6000 ; % mb
        Result_7=pression_brute7 /6000 ; % mb
        Result_8=pression_brute8 /6000 ; % mb
        Result_9=pression_brute9 /6000 ; % mb
                            
        Result.Pressures(u*10+6,2)=pression_brute0; % Baro
        Result.Pressures(u*10+6,3)=pression_brute1; % Baro
        Result.Pressures(u*10+6,4)=pression_brute2; % Diff 1 HCE
        Result.Pressures(u*10+6,5)=pression_brute3; % Diff 2
        Result.Pressures(u*10+6,6)=pression_brute4; % Diff 3
        Result.Pressures(u*10+6,7)=pression_brute5; % Diff 4 
        Result.Pressures(u*10+6,8)=pression_brute6; % Diff 5 LDE
        Result.Pressures(u*10+6,9)=pression_brute7; % Diff 6
        Result.Pressures(u*10+6,10)=pression_brute8; % Diff 7
        Result.Pressures(u*10+6,11)=pression_brute9;  % Diff 8      
                
        Result.Pressures(u*10+6,12)=Result_0;  % Baro
        Result.Pressures(u*10+6,13)=Result_1;  % Baro
        Result.Pressures(u*10+6,14)=Result_2;  % Diff 1 HCE
        Result.Pressures(u*10+6,15)=Result_3;  % Diff 2
        Result.Pressures(u*10+6,16)=Result_4;  % Diff 3
        Result.Pressures(u*10+6,17)=Result_5;  % Diff 4     
        Result.Pressures(u*10+6,18)=Result_6;  % Diff 5 LDE
        Result.Pressures(u*10+6,19)=Result_7;  % Diff 6
        Result.Pressures(u*10+6,20)=Result_8;  % Diff 7
        Result.Pressures(u*10+6,21)=Result_9;  % Diff 8            

%=========================================================================%     
% Lecture Pression sur echatillonage 7
%=========================================================================%            
            
        Result.Pattern(j,18)=fread(f,1,'uint8'); % 77      add_359
        Result.Pattern(j,19)=fread(f,1,'uint8'); % 77      add_360

        pression_brute0=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_361 %add_362  % Pression Baro1 HCEMO611
        pression_brute1=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_363 %add_364  % Pression Baro1 HCEMO611
        
        s =( 24575 - 2730)/( 1100 - 600);
        Result_0 = (pression_brute0 - 2730)/s + 600;
        Result_1 = (pression_brute1 - 2730)/s + 600;
                     
        % data_pressure diff HCEM10
        pression_brute2=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_365 %add_366       
        pression_brute3=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_367 %add_368
        pression_brute4=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_369 %add_370        
        pression_brute5=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_371 %add_372        
        
       s =( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb
        
        Result_2 = (pression_brute2 - 2730)/s + (-0);  % Pitot %
        Result_3 = (pression_brute3 - 2730)/s + (-0);  
        Result_4 = (pression_brute4 - 2730)/s + (-0);  
        Result_5 = (pression_brute5 - 2730)/s + (-0);  

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute6 = double((typecast(uint8(a),'int16')));          

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute7 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute8 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute9 = double((typecast(uint8(a),'int16')));
        
            %  Scale factor LDE +/500pa = 60 --> /100mb
           
        Result_6=pression_brute6 /6000 ; % mb
        Result_7=pression_brute7 /6000 ; % mb
        Result_8=pression_brute8 /6000 ; % mb
        Result_9=pression_brute9 /6000 ; % mb
                            
        Result.Pressures(u*10+7,2)=pression_brute0; % Baro
        Result.Pressures(u*10+7,3)=pression_brute1; % Baro
        Result.Pressures(u*10+7,4)=pression_brute2; % Diff 1 HCE
        Result.Pressures(u*10+7,5)=pression_brute3; % Diff 2
        Result.Pressures(u*10+7,6)=pression_brute4; % Diff 3
        Result.Pressures(u*10+7,7)=pression_brute5; % Diff 4 
        Result.Pressures(u*10+7,8)=pression_brute6; % Diff 5 LDE
        Result.Pressures(u*10+7,9)=pression_brute7; % Diff 6
        Result.Pressures(u*10+7,10)=pression_brute8; % Diff 7
        Result.Pressures(u*10+7,11)=pression_brute9;  % Diff 8      
                
        Result.Pressures(u*10+7,12)=Result_0;  % Baro
        Result.Pressures(u*10+7,13)=Result_1;  % Baro
        Result.Pressures(u*10+7,14)=Result_2;  % Diff 1 HCE
        Result.Pressures(u*10+7,15)=Result_3;  % Diff 2
        Result.Pressures(u*10+7,16)=Result_4;  % Diff 3
        Result.Pressures(u*10+7,17)=Result_5;  % Diff 4     
        Result.Pressures(u*10+7,18)=Result_6;  % Diff 5 LDE
        Result.Pressures(u*10+7,19)=Result_7;  % Diff 6
        Result.Pressures(u*10+7,20)=Result_8;  % Diff 7
        Result.Pressures(u*10+7,21)=Result_9;  % Diff 8            

%=========================================================================%     
% Lecture Pression sur echatillonage 8
%=========================================================================%            
            
        Result.Pattern(j,20)=fread(f,1,'uint8'); % 88      add_403
        Result.Pattern(j,21)=fread(f,1,'uint8'); % 88      add_404

        pression_brute0=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_405 %add_406  % Pression Baro1 HCEMO611
        pression_brute1=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_407 %add_408  % Pression Baro1 HCEMO611
        
        s =( 24575 - 2730)/( 1100 - 600);
        Result_0 = (pression_brute0 - 2730)/s + 600;
        Result_1 = (pression_brute1 - 2730)/s + 600;
                     
        % data_pressure diff HCEM10
        pression_brute2=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_409 %add_410       
        pression_brute3=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_411 %add_412
        pression_brute4=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_413 %add_414        
        pression_brute5=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_415 %add_416        
        
       s =( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb
        
        Result_2 = (pression_brute2 - 2730)/s + (-0);  % Pitot %
        Result_3 = (pression_brute3 - 2730)/s + (-0);  
        Result_4 = (pression_brute4 - 2730)/s + (-0);  
        Result_5 = (pression_brute5 - 2730)/s + (-0);  

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute6 = double((typecast(uint8(a),'int16')));          

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute7 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute8 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute9 = double((typecast(uint8(a),'int16')));
        
            %  Scale factor LDE +/500pa = 60 --> /100mb
           
        Result_6=pression_brute6 /6000 ; % mb
        Result_7=pression_brute7 /6000 ; % mb
        Result_8=pression_brute8 /6000 ; % mb
        Result_9=pression_brute9 /6000 ; % mb
                            
        Result.Pressures(u*10+8,2)=pression_brute0; % Baro
        Result.Pressures(u*10+8,3)=pression_brute1; % Baro
        Result.Pressures(u*10+8,4)=pression_brute2; % Diff 1 HCE
        Result.Pressures(u*10+8,5)=pression_brute3; % Diff 2
        Result.Pressures(u*10+8,6)=pression_brute4; % Diff 3
        Result.Pressures(u*10+8,7)=pression_brute5; % Diff 4 
        Result.Pressures(u*10+8,8)=pression_brute6; % Diff 5 LDE
        Result.Pressures(u*10+8,9)=pression_brute7; % Diff 6
        Result.Pressures(u*10+8,10)=pression_brute8; % Diff 7
        Result.Pressures(u*10+8,11)=pression_brute9;  % Diff 8      
                
        Result.Pressures(u*10+8,12)=Result_0;  % Baro
        Result.Pressures(u*10+8,13)=Result_1;  % Baro
        Result.Pressures(u*10+8,14)=Result_2;  % Diff 1 HCE
        Result.Pressures(u*10+8,15)=Result_3;  % Diff 2
        Result.Pressures(u*10+8,16)=Result_4;  % Diff 3
        Result.Pressures(u*10+8,17)=Result_5;  % Diff 4     
        Result.Pressures(u*10+8,18)=Result_6;  % Diff 5 LDE
        Result.Pressures(u*10+8,19)=Result_7;  % Diff 6
        Result.Pressures(u*10+8,20)=Result_8;  % Diff 7
        Result.Pressures(u*10+8,21)=Result_9;  % Diff 8    
        
%=========================================================================%     
% Lecture Pression sur echatillonage 9
%=========================================================================%            
            
        Result.Pattern(j,22)=fread(f,1,'uint8'); % 99      add_425
        Result.Pattern(j,23)=fread(f,1,'uint8'); % 99      add_426

        pression_brute0=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_427 %add_428  % Pression Baro1 HCEMO611
        pression_brute1=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_429 %add_430  % Pression Baro1 HCEMO611
        
        s =( 24575 - 2730)/( 1100 - 600);
        Result_0 = (pression_brute0 - 2730)/s + 600;
        Result_1 = (pression_brute1 - 2730)/s + 600;
                     
        % data_pressure diff HCEM10
        pression_brute2=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_431 %add_432       
        pression_brute3=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_433 %add_434
        pression_brute4=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_435 %add_436        
        pression_brute5=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_437 %add_438        
        
       s =( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb
        
        Result_2 = (pression_brute2 - 2730)/s + (-0);  % Pitot %
        Result_3 = (pression_brute3 - 2730)/s + (-0);  
        Result_4 = (pression_brute4 - 2730)/s + (-0);  
        Result_5 = (pression_brute5 - 2730)/s + (-0);  

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute6 = double((typecast(uint8(a),'int16')));          

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute7 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute8 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute9 = double((typecast(uint8(a),'int16')));
        
            %  Scale factor LDE +/500pa = 60 --> /100mb
           
        Result_6=pression_brute6 /6000 ; % mb
        Result_7=pression_brute7 /6000 ; % mb
        Result_8=pression_brute8 /6000 ; % mb
        Result_9=pression_brute9 /6000 ; % mb
                            
        Result.Pressures(u*10+9,2)=pression_brute0; % Baro
        Result.Pressures(u*10+9,3)=pression_brute1; % Baro
        Result.Pressures(u*10+9,4)=pression_brute2; % Diff 1 HCE
        Result.Pressures(u*10+9,5)=pression_brute3; % Diff 2
        Result.Pressures(u*10+9,6)=pression_brute4; % Diff 3
        Result.Pressures(u*10+9,7)=pression_brute5; % Diff 4 
        Result.Pressures(u*10+9,8)=pression_brute6; % Diff 5 LDE
        Result.Pressures(u*10+9,9)=pression_brute7; % Diff 6
        Result.Pressures(u*10+9,10)=pression_brute8; % Diff 7
        Result.Pressures(u*10+9,11)=pression_brute9;  % Diff 8      
                
        Result.Pressures(u*10+9,12)=Result_0;  % Baro
        Result.Pressures(u*10+9,13)=Result_1;  % Baro
        Result.Pressures(u*10+9,14)=Result_2;  % Diff 1 HCE
        Result.Pressures(u*10+9,15)=Result_3;  % Diff 2
        Result.Pressures(u*10+9,16)=Result_4;  % Diff 3
        Result.Pressures(u*10+9,17)=Result_5;  % Diff 4     
        Result.Pressures(u*10+9,18)=Result_6;  % Diff 5 LDE
        Result.Pressures(u*10+9,19)=Result_7;  % Diff 6
        Result.Pressures(u*10+9,20)=Result_8;  % Diff 7
        Result.Pressures(u*10+9,21)=Result_9;  % Diff 8            

%=========================================================================%     
% Lecture Pression sur echatillonage 10
%=========================================================================%            
            
        Result.Pattern(j,24)=fread(f,1,'uint8'); % AA      add_447
        Result.Pattern(j,25)=fread(f,1,'uint8'); % AA      add_448

        pression_brute0=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_449 %add_450  % Pression Baro1 HCEMO611
        pression_brute1=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_451 %add_452  % Pression Baro1 HCEMO611
        
        s =( 24575 - 2730)/( 1100 - 600);
        Result_0 = (pression_brute0 - 2730)/s + 600;
        Result_1 = (pression_brute1 - 2730)/s + 600;
                     
        % data_pressure diff HCEM10
        pression_brute2=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_453 %add_454       
        pression_brute3=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_455 %add_456
        pression_brute4=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_457 %add_458        
        pression_brute5=fread(f,1,'uint8')*256+fread(f,1,'uint8'); %add_459 %add_460        
        
        s =( 24575 - 2730)/( 50 - (-0));  % +/- 50 mb
        
        Result_2 = (pression_brute2 - 2730)/s + (-0);  % Pitot %
        Result_3 = (pression_brute3 - 2730)/s + (-0);  
        Result_4 = (pression_brute4 - 2730)/s + (-0);  
        Result_5 = (pression_brute5 - 2730)/s + (-0);  

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute6 = double((typecast(uint8(a),'int16')));          

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute7 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute8 = double((typecast(uint8(a),'int16')));

        q1= fread(f,1,'uint8');
        q2=fread(f,1,'uint8');
        a=[q2,q1];
        pression_brute9 = double((typecast(uint8(a),'int16')));
        
            %  Scale factor LDE +/500pa = 60 --> /100mb
           
        Result_6=pression_brute6 /6000 ; % mb
        Result_7=pression_brute7 /6000 ; % mb
        Result_8=pression_brute8 /6000 ; % mb
        Result_9=pression_brute9 /6000 ; % mb
                            
        Result.Pressures(u*10+10,2)=pression_brute0; % Baro
        Result.Pressures(u*10+10,3)=pression_brute1; % Baro
        Result.Pressures(u*10+10,4)=pression_brute2; % Diff 1 HCE
        Result.Pressures(u*10+10,5)=pression_brute3; % Diff 2
        Result.Pressures(u*10+10,6)=pression_brute4; % Diff 3
        Result.Pressures(u*10+10,7)=pression_brute5; % Diff 4 
        Result.Pressures(u*10+10,8)=pression_brute6; % Diff 5 LDE
        Result.Pressures(u*10+10,9)=pression_brute7; % Diff 6
        Result.Pressures(u*10+10,10)=pression_brute8; % Diff 7
        Result.Pressures(u*10+10,11)=pression_brute9;  % Diff 8      
                
        Result.Pressures(u*10+10,12)=Result_0;  % Baro
        Result.Pressures(u*10+10,13)=Result_1;  % Baro
        Result.Pressures(u*10+10,14)=Result_2;  % Diff 1 HCE
        Result.Pressures(u*10+10,15)=Result_3;  % Diff 2
        Result.Pressures(u*10+10,16)=Result_4;  % Diff 3
        Result.Pressures(u*10+10,17)=Result_5;  % Diff 4     
        Result.Pressures(u*10+10,18)=Result_6;  % Diff 5 LDE
        Result.Pressures(u*10+10,19)=Result_7;  % Diff 6
        Result.Pressures(u*10+10,20)=Result_8;  % Diff 7
        Result.Pressures(u*10+10,21)=Result_9;  % Diff 8        


% Saut de 23 lignes       
%=========================================================================%       
        Temp= fread(f, 24, '*uchar');%add_1521       
%=========================================================================%

%------------------ Pattern -------------------------------------------%
         Result.Pattern(j,26)=fread(f,1,'uint8');  % 494 c0
         Result.Pattern(j,27)=fread(f,1,'uint8');  % 565 01

%----------------  -------------------------------------%      
 
 %       Temp= fread(f, 168, '*uchar');         %add_496
 %----------------  Compteur Seconde-------------------------------------%  
        Compteur=fread(f,1,'uint8')*256+fread(f,1,'uint8');%add_497 ET 498
        Result.AD_NAVIGATION(j,25)=Compteur;
        Result.IMU(j,14)=Compteur;
        Result.MOTUSRAW((um*10+1),14)=Compteur;
        Result.MOTUSRAW((um*10+2),14)=Compteur;
        Result.MOTUSRAW((um*10+3),14)=Compteur;
        Result.MOTUSRAW((um*10+4),14)=Compteur;
        Result.MOTUSRAW((um*10+5),14)=Compteur;
        Result.MOTUSRAW((um*10+6),14)=Compteur;
        Result.MOTUSRAW((um*10+7),14)=Compteur;
        Result.MOTUSRAW((um*10+8),14)=Compteur;
        Result.MOTUSRAW((um*10+9),14)=Compteur;
        Result.MOTUSRAW((um*10+10),14)=Compteur;
        Result.MOTUSORI((um+1),5)=Compteur;
        Result.TH(j,10)= Compteur;
        Result.T2(j,4)= Compteur;
        Result.PaquetAirData(j,9)= Compteur;      
        Result.AirDataSensors(j,6)= Compteur;    
        Result.Pressures(j,22)= Compteur;
        Result.PaquetWind (j,5)= Compteur;
      
%------------------ Pattern -------------------------------------------%
         Result.Pattern(j,28)=fread(f,1,'uint8');  % 494 c5
         Result.Pattern(j,29)=fread(f,1,'uint8');  % 565 12
%----------------  Compteur block-------------------------------------%        
       
       Compteur=(fread(f,1,'uint8')*16777216+fread(f,1,'uint8')*65536+fread(f,1,'uint8')*256+fread(f,1,'uint8')); %add_501 502 et 503 504 
        Result.AD_NAVIGATION(j,1)=Compteur;
        Result.IMU(j,1)=Compteur;
        Result.MOTUSRAW((um*10+1),1)=Compteur;
        Result.MOTUSRAW((um*10+2),1)=Compteur;
        Result.MOTUSRAW((um*10+3),1)=Compteur;
        Result.MOTUSRAW((um*10+4),1)=Compteur;
        Result.MOTUSRAW((um*10+5),1)=Compteur;
        Result.MOTUSRAW((um*10+6),1)=Compteur;
        Result.MOTUSRAW((um*10+7),1)=Compteur;
        Result.MOTUSRAW((um*10+8),1)=Compteur;
        Result.MOTUSRAW((um*10+9),1)=Compteur;
        Result.MOTUSRAW((um*10+10),1)=Compteur;
        Result.MOTUSORI((um+1),1)=Compteur;
        Result.TH(j,1)= Compteur;
        Result.T2(j,1)= Compteur;
        Result.PaquetAirData(j,1)= Compteur;
        Result.AirDataSensors(j,1)= Compteur;         
   
        Result.Pressures(j,1)= Compteur;
        Result.Pressures(j+1,1)= Compteur;
        Result.Pressures(j+2,1)= Compteur;
        Result.Pressures(j+3,1)= Compteur;
        Result.Pressures(j+4,1)= Compteur;
        Result.Pressures(j+5,1)= Compteur;
        Result.Pressures(j+6,1)= Compteur;
        Result.Pressures(j+7,1)= Compteur;
        Result.Pressures(j+8,1)= Compteur;
        Result.Pressures(j+9,1)= Compteur;
        
        
        
        Result.PaquetWind (j,1)= Compteur;
   
 %------------------ Pattern -------------------------------------------%
        Result.Pattern(j,30)=fread(f,1,'uint8');  % 497  c1
        Result.Pattern(j,31)=fread(f,1,'uint8');  % 498  0
        
 %----------------  Compteur temps tsmilli-------------------------------------% 
        % Compteur Temps 100 ms
       Result.AD_NAVIGATION(j,26) = ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3;

       Result.IMU(j,15)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3;
       
	   Result.MOTUSRAW((um*10+1),15)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3; 
	   Result.MOTUSRAW((um*10+2),15)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 10;%e3; 
	   Result.MOTUSRAW((um*10+3),15)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 20;%e3; 
	   Result.MOTUSRAW((um*10+4),15)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 30;%e3; 
	   Result.MOTUSRAW((um*10+5),15)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 40;%e3; 
	   Result.MOTUSRAW((um*10+6),15)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 50;%e3; 
	   Result.MOTUSRAW((um*10+7),15)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 60;%e3; 
	   Result.MOTUSRAW((um*10+8),15)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 70;%e3; 
	   Result.MOTUSRAW((um*10+9),15)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 80;%e3; 
	   Result.MOTUSRAW((um*10+10),15)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 90;%e3; 
       
	   Result.MOTUSORI(j,6)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3;
       Result.TH(j,11)= ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3;
       Result.T2(j,5)= ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3;
       
       Result.Pressures(u*10+1,23)= ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 ;
       Result.Pressures(u*10+2,23)= ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 10;%e3;
       Result.Pressures(u*10+3,23)= ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 20;%e3;
       Result.Pressures(u*10+4,23)= ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 30;%e3;
       Result.Pressures(u*10+5,23)= ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 40;%e3;
       Result.Pressures(u*10+6,23)= ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 50;%e3;
       Result.Pressures(u*10+7,23)= ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 60;%e3;
       Result.Pressures(u*10+8,23)= ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 70;%e3;
       Result.Pressures(u*10+9,23)= ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 80;%e3;
       Result.Pressures(u*10+10,23)= ((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3 + 90;%e3;
       
       
       
       Result.PaquetAirData(j,10)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3;
       Result.PaquetWind (j,6)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3;
       Result.AirDataSensors(j,7)=((Result.AD_NAVIGATION(j,4)*1e6)+ Result.AD_NAVIGATION(j,5))/1e3;
      
       
   % Saut de 23 lignes       
%=========================================================================%       
        Temp= fread(f, 5, '*uchar');% 509      
 %------------------ Pattern -------------------------------------------%
        Result.Pattern(j,32)=fread(f,1,'uint8');  % 510  BB
        Result.Pattern(j,33)=fread(f,1,'uint8');  % 511  BB
		
%=========================================================================%       
%							END OF BLOCK 1								  %
%=========================================================================%       
        fseek(f,48,'cof'); 
        
        test = fread (f,1,'uint16');
        
        fseek(f,-50,'cof');
        
        if test == 49836 %C2AC
            
% Lecture packet 28 MOTUS  1    
        Result.MOTUSRAW(um*10+1,2)=fread(f,1,'float32');  % Xaccl   
        Result.MOTUSRAW(um*10+1,3)=fread(f,1,'float32');  % Yaccl   
        Result.MOTUSRAW(um*10+1,4)=fread(f,1,'float32');  % Zaccl   
        Result.MOTUSRAW(um*10+1,5)=fread(f,1,'float32');  % Xgyro   
        Result.MOTUSRAW(um*10+1,6)=fread(f,1,'float32');  % Ygyro   
        Result.MOTUSRAW(um*10+1,7)=fread(f,1,'float32');  % Zgyro   
        Result.MOTUSRAW(um*10+1,8)=fread(f,1,'float32');  % Xmagn   
        Result.MOTUSRAW(um*10+1,9)=fread(f,1,'float32');  % Ymagn   
        Result.MOTUSRAW(um*10+1,10)=fread(f,1,'float32'); % Zmagn   
        Result.MOTUSRAW(um*10+1,11)=fread(f,1,'float32'); % IMUTemperatureIMU  
        Result.MOTUSRAW(um*10+1,12)=fread(f,1,'float32'); % Barometer          
        Result.MOTUSRAW(um*10+1,13)=fread(f,1,'float32'); % TemperaturePressure
       
        Result.Pattern((um+1),34)=fread(f,1,'uint8');  % 48  AC
        Result.Pattern((um+1),35)=fread(f,1,'uint8');  % 49  C2
		
% Lecture packet 28 MOTUS  2    
        Result.MOTUSRAW(um*10+2,2)=fread(f,1,'float32');  % Xaccl   
        Result.MOTUSRAW(um*10+2,3)=fread(f,1,'float32');  % Yaccl   
        Result.MOTUSRAW(um*10+2,4)=fread(f,1,'float32');  % Zaccl   
        Result.MOTUSRAW(um*10+2,5)=fread(f,1,'float32');  % Xgyro   
        Result.MOTUSRAW(um*10+2,6)=fread(f,1,'float32');  % Ygyro   
        Result.MOTUSRAW(um*10+2,7)=fread(f,1,'float32');  % Zgyro   
        Result.MOTUSRAW(um*10+2,8)=fread(f,1,'float32');  % Xmagn   
        Result.MOTUSRAW(um*10+2,9)=fread(f,1,'float32');  % Ymagn   
        Result.MOTUSRAW(um*10+2,10)=fread(f,1,'float32'); % Zmagn   
        Result.MOTUSRAW(um*10+2,11)=fread(f,1,'float32'); % IMUTemperatureIMU  
        Result.MOTUSRAW(um*10+2,12)=fread(f,1,'float32'); % Barometer          
        Result.MOTUSRAW(um*10+2,13)=fread(f,1,'float32'); % TemperaturePressure
       
        Result.Pattern((um+1),36)=fread(f,1,'uint8');  % 98  AC
        Result.Pattern((um+1),37)=fread(f,1,'uint8');  % 99  C3
		
% Lecture packet 28 MOTUS  3    
        Result.MOTUSRAW(um*10+3,2)=fread(f,1,'float32');  % Xaccl   
        Result.MOTUSRAW(um*10+3,3)=fread(f,1,'float32');  % Yaccl   
        Result.MOTUSRAW(um*10+3,4)=fread(f,1,'float32');  % Zaccl   
        Result.MOTUSRAW(um*10+3,5)=fread(f,1,'float32');  % Xgyro   
        Result.MOTUSRAW(um*10+3,6)=fread(f,1,'float32');  % Ygyro   
        Result.MOTUSRAW(um*10+3,7)=fread(f,1,'float32');  % Zgyro   
        Result.MOTUSRAW(um*10+3,8)=fread(f,1,'float32');  % Xmagn   
        Result.MOTUSRAW(um*10+3,9)=fread(f,1,'float32');  % Ymagn   
        Result.MOTUSRAW(um*10+3,10)=fread(f,1,'float32'); % Zmagn   
        Result.MOTUSRAW(um*10+3,11)=fread(f,1,'float32'); % IMUTemperatureIMU  
        Result.MOTUSRAW(um*10+3,12)=fread(f,1,'float32'); % Barometer          
        Result.MOTUSRAW(um*10+3,13)=fread(f,1,'float32'); % TemperaturePressure
       
        Result.Pattern((um+1),38)=fread(f,1,'uint8');  % 98  AC
        Result.Pattern((um+1),39)=fread(f,1,'uint8');  % 99  C4
		
% Lecture packet 28 MOTUS  4    
        Result.MOTUSRAW(um*10+4,2)=fread(f,1,'float32');  % Xaccl   
        Result.MOTUSRAW(um*10+4,3)=fread(f,1,'float32');  % Yaccl   
        Result.MOTUSRAW(um*10+4,4)=fread(f,1,'float32');  % Zaccl   
        Result.MOTUSRAW(um*10+4,5)=fread(f,1,'float32');  % Xgyro   
        Result.MOTUSRAW(um*10+4,6)=fread(f,1,'float32');  % Ygyro   
        Result.MOTUSRAW(um*10+4,7)=fread(f,1,'float32');  % Zgyro   
        Result.MOTUSRAW(um*10+4,8)=fread(f,1,'float32');  % Xmagn   
        Result.MOTUSRAW(um*10+4,9)=fread(f,1,'float32');  % Ymagn   
        Result.MOTUSRAW(um*10+4,10)=fread(f,1,'float32'); % Zmagn   
        Result.MOTUSRAW(um*10+4,11)=fread(f,1,'float32'); % IMUTemperatureIMU  
        Result.MOTUSRAW(um*10+4,12)=fread(f,1,'float32'); % Barometer          
        Result.MOTUSRAW(um*10+4,13)=fread(f,1,'float32'); % TemperaturePressure
       
        Result.Pattern((um+1),40)=fread(f,1,'uint8');  % 98  AC
        Result.Pattern((um+1),41)=fread(f,1,'uint8');  % 99  C5
		
% Lecture packet 28 MOTUS  5    
        Result.MOTUSRAW(um*10+5,2)=fread(f,1,'float32');  % Xaccl   
        Result.MOTUSRAW(um*10+5,3)=fread(f,1,'float32');  % Yaccl   
        Result.MOTUSRAW(um*10+5,4)=fread(f,1,'float32');  % Zaccl   
        Result.MOTUSRAW(um*10+5,5)=fread(f,1,'float32');  % Xgyro   
        Result.MOTUSRAW(um*10+5,6)=fread(f,1,'float32');  % Ygyro   
        Result.MOTUSRAW(um*10+5,7)=fread(f,1,'float32');  % Zgyro   
        Result.MOTUSRAW(um*10+5,8)=fread(f,1,'float32');  % Xmagn   
        Result.MOTUSRAW(um*10+5,9)=fread(f,1,'float32');  % Ymagn   
        Result.MOTUSRAW(um*10+5,10)=fread(f,1,'float32'); % Zmagn   
        Result.MOTUSRAW(um*10+5,11)=fread(f,1,'float32'); % IMUTemperatureIMU  
        Result.MOTUSRAW(um*10+5,12)=fread(f,1,'float32'); % Barometer          
        Result.MOTUSRAW(um*10+5,13)=fread(f,1,'float32'); % TemperaturePressure
       
        Result.Pattern((um+1),42)=fread(f,1,'uint8');  % 98  AC
        Result.Pattern((um+1),43)=fread(f,1,'uint8');  % 99  C6
		
% Lecture packet 28 MOTUS  6    
        Result.MOTUSRAW(um*10+6,2)=fread(f,1,'float32');  % Xaccl   
        Result.MOTUSRAW(um*10+6,3)=fread(f,1,'float32');  % Yaccl   
        Result.MOTUSRAW(um*10+6,4)=fread(f,1,'float32');  % Zaccl   
        Result.MOTUSRAW(um*10+6,5)=fread(f,1,'float32');  % Xgyro   
        Result.MOTUSRAW(um*10+6,6)=fread(f,1,'float32');  % Ygyro   
        Result.MOTUSRAW(um*10+6,7)=fread(f,1,'float32');  % Zgyro   
        Result.MOTUSRAW(um*10+6,8)=fread(f,1,'float32');  % Xmagn   
        Result.MOTUSRAW(um*10+6,9)=fread(f,1,'float32');  % Ymagn   
        Result.MOTUSRAW(um*10+6,10)=fread(f,1,'float32'); % Zmagn   
        Result.MOTUSRAW(um*10+6,11)=fread(f,1,'float32'); % IMUTemperatureIMU  
        Result.MOTUSRAW(um*10+6,12)=fread(f,1,'float32'); % Barometer          
        Result.MOTUSRAW(um*10+6,13)=fread(f,1,'float32'); % TemperaturePressure
       
        Result.Pattern((um+1),44)=fread(f,1,'uint8');  % 98  AC
        Result.Pattern((um+1),45)=fread(f,1,'uint8');  % 99  C7
		
% Lecture packet 28 MOTUS  7    
        Result.MOTUSRAW(um*10+7,2)=fread(f,1,'float32');  % Xaccl   
        Result.MOTUSRAW(um*10+7,3)=fread(f,1,'float32');  % Yaccl   
        Result.MOTUSRAW(um*10+7,4)=fread(f,1,'float32');  % Zaccl   
        Result.MOTUSRAW(um*10+7,5)=fread(f,1,'float32');  % Xgyro   
        Result.MOTUSRAW(um*10+7,6)=fread(f,1,'float32');  % Ygyro   
        Result.MOTUSRAW(um*10+7,7)=fread(f,1,'float32');  % Zgyro   
        Result.MOTUSRAW(um*10+7,8)=fread(f,1,'float32');  % Xmagn   
        Result.MOTUSRAW(um*10+7,9)=fread(f,1,'float32');  % Ymagn   
        Result.MOTUSRAW(um*10+7,10)=fread(f,1,'float32'); % Zmagn   
        Result.MOTUSRAW(um*10+7,11)=fread(f,1,'float32'); % IMUTemperatureIMU  
        Result.MOTUSRAW(um*10+7,12)=fread(f,1,'float32'); % Barometer          
        Result.MOTUSRAW(um*10+7,13)=fread(f,1,'float32'); % TemperaturePressure
       
        Result.Pattern((um+1),46)=fread(f,1,'uint8');  % 98  AC
        Result.Pattern((um+1),47)=fread(f,1,'uint8');  % 99  C8
		
% Lecture packet 28 MOTUS  8    
        Result.MOTUSRAW(um*10+8,2)=fread(f,1,'float32');  % Xaccl   
        Result.MOTUSRAW(um*10+8,3)=fread(f,1,'float32');  % Yaccl   
        Result.MOTUSRAW(um*10+8,4)=fread(f,1,'float32');  % Zaccl   
        Result.MOTUSRAW(um*10+8,5)=fread(f,1,'float32');  % Xgyro   
        Result.MOTUSRAW(um*10+8,6)=fread(f,1,'float32');  % Ygyro   
        Result.MOTUSRAW(um*10+8,7)=fread(f,1,'float32');  % Zgyro   
        Result.MOTUSRAW(um*10+8,8)=fread(f,1,'float32');  % Xmagn   
        Result.MOTUSRAW(um*10+8,9)=fread(f,1,'float32');  % Ymagn   
        Result.MOTUSRAW(um*10+8,10)=fread(f,1,'float32'); % Zmagn   
        Result.MOTUSRAW(um*10+8,11)=fread(f,1,'float32'); % IMUTemperatureIMU  
        Result.MOTUSRAW(um*10+8,12)=fread(f,1,'float32'); % Barometer          
        Result.MOTUSRAW(um*10+8,13)=fread(f,1,'float32'); % TemperaturePressure
       
        Result.Pattern((um+1),48)=fread(f,1,'uint8');  % 98  AC
        Result.Pattern((um+1),49)=fread(f,1,'uint8');  % 99  C9
		
% Lecture packet 28 MOTUS  9    
        Result.MOTUSRAW(um*10+9,2)=fread(f,1,'float32');  % Xaccl   
        Result.MOTUSRAW(um*10+9,3)=fread(f,1,'float32');  % Yaccl   
        Result.MOTUSRAW(um*10+9,4)=fread(f,1,'float32');  % Zaccl   
        Result.MOTUSRAW(um*10+9,5)=fread(f,1,'float32');  % Xgyro   
        Result.MOTUSRAW(um*10+9,6)=fread(f,1,'float32');  % Ygyro   
        Result.MOTUSRAW(um*10+9,7)=fread(f,1,'float32');  % Zgyro   
        Result.MOTUSRAW(um*10+9,8)=fread(f,1,'float32');  % Xmagn   
        Result.MOTUSRAW(um*10+9,9)=fread(f,1,'float32');  % Ymagn   
        Result.MOTUSRAW(um*10+9,10)=fread(f,1,'float32'); % Zmagn   
        Result.MOTUSRAW(um*10+9,11)=fread(f,1,'float32'); % IMUTemperatureIMU  
        Result.MOTUSRAW(um*10+9,12)=fread(f,1,'float32'); % Barometer          
        Result.MOTUSRAW(um*10+9,13)=fread(f,1,'float32'); % TemperaturePressure
       
        Result.Pattern((um+1),50)=fread(f,1,'uint8');  % 98  AC
        Result.Pattern((um+1),51)=fread(f,1,'uint8');  % 99  CA
		
% Lecture packet 28 MOTUS  10    
        Result.MOTUSRAW(um*10+10,2)=fread(f,1,'float32');  % Xaccl   
        Result.MOTUSRAW(um*10+10,3)=fread(f,1,'float32');  % Yaccl   
        Result.MOTUSRAW(um*10+10,4)=fread(f,1,'float32');  % Zaccl   
        Result.MOTUSRAW(um*10+10,5)=fread(f,1,'float32');  % Xgyro   
        Result.MOTUSRAW(um*10+10,6)=fread(f,1,'float32');  % Ygyro   
        Result.MOTUSRAW(um*10+10,7)=fread(f,1,'float32');  % Zgyro   
        Result.MOTUSRAW(um*10+10,8)=fread(f,1,'float32');  % Xmagn   
        Result.MOTUSRAW(um*10+10,9)=fread(f,1,'float32');  % Ymagn   
        Result.MOTUSRAW(um*10+10,10)=fread(f,1,'float32'); % Zmagn   
        Result.MOTUSRAW(um*10+10,11)=fread(f,1,'float32'); % IMUTemperatureIMU  
        Result.MOTUSRAW(um*10+10,12)=fread(f,1,'float32'); % Barometer          
        Result.MOTUSRAW(um*10+10,13)=fread(f,1,'float32'); % TemperaturePressure
               
        Result.Pattern((um+1),52)=fread(f,1,'uint8');  % 98  AB
        Result.Pattern((um+1),53)=fread(f,1,'uint8');  % 99  CD
	   
	   
	    Result.MOTUSORI((um+1),2)=fread(f,1,'float32');  % Roll           
        Result.MOTUSORI((um+1),3)=fread(f,1,'float32');  % Pitch          
        Result.MOTUSORI((um+1),4)=fread(f,1,'float32');  % Heading        

        
        
	   Result.MOTUSRAW(um*10+1,16) =((Result.MOTUSRAW(um*10+1,2)).^2 +(Result.MOTUSRAW(um*10+1,3)).^2 +(Result.MOTUSRAW(um*10+1,4)).^2).^0.5;
	   Result.MOTUSRAW(um*10+2,16) =((Result.MOTUSRAW(um*10+2,2)).^2 +(Result.MOTUSRAW(um*10+2,3)).^2 +(Result.MOTUSRAW(um*10+2,4)).^2).^0.5;
	   Result.MOTUSRAW(um*10+3,16) =((Result.MOTUSRAW(um*10+3,2)).^2 +(Result.MOTUSRAW(um*10+3,3)).^2 +(Result.MOTUSRAW(um*10+3,4)).^2).^0.5;
	   Result.MOTUSRAW(um*10+4,16) =((Result.MOTUSRAW(um*10+4,2)).^2 +(Result.MOTUSRAW(um*10+4,3)).^2 +(Result.MOTUSRAW(um*10+4,4)).^2).^0.5;
	   Result.MOTUSRAW(um*10+5,16) =((Result.MOTUSRAW(um*10+5,2)).^2 +(Result.MOTUSRAW(um*10+5,3)).^2 +(Result.MOTUSRAW(um*10+5,4)).^2).^0.5;
	   Result.MOTUSRAW(um*10+6,16) =((Result.MOTUSRAW(um*10+6,2)).^2 +(Result.MOTUSRAW(um*10+6,3)).^2 +(Result.MOTUSRAW(um*10+6,4)).^2).^0.5;
	   Result.MOTUSRAW(um*10+7,16) =((Result.MOTUSRAW(um*10+7,2)).^2 +(Result.MOTUSRAW(um*10+7,3)).^2 +(Result.MOTUSRAW(um*10+7,4)).^2).^0.5;
	   Result.MOTUSRAW(um*10+8,16) =((Result.MOTUSRAW(um*10+8,2)).^2 +(Result.MOTUSRAW(um*10+8,3)).^2 +(Result.MOTUSRAW(um*10+8,4)).^2).^0.5;
	   Result.MOTUSRAW(um*10+9,16) =((Result.MOTUSRAW(um*10+9,2)).^2 +(Result.MOTUSRAW(um*10+9,3)).^2 +(Result.MOTUSRAW(um*10+9,4)).^2).^0.5;
	   Result.MOTUSRAW(um*10+10,16)=((Result.MOTUSRAW(um*10+10,2)).^2+(Result.MOTUSRAW(um*10+10,3)).^2+(Result.MOTUSRAW(um*10+10,4)).^2).^0.5;
        
	   um=um+1;
	   
        end
       
	   u=u+1;
       j=j+1;
       debut_paquet=debut_paquet+taille_paquet;

   waitbar(j / steps)
   end

 Result.MOTUSRAW=Result.MOTUSRAW((1:um*10),:);
 Result.MOTUSORI=Result.MOTUSORI((1:um),:);
 Result.Pressures=Result.Pressures((1:u*10),:);
 Result.AD_NAVIGATION=Result.AD_NAVIGATION(1:j-1,:);
 Result.IMU= Result.IMU(1:j-1,:);
 Result.TH=Result.TH(1:j-1,:);
 Result.T2=Result.T2(1:j-1,:);
 Result.PaquetAirData=Result.PaquetAirData(1:j-1,:);
 Result.AirDataSensors=Result.AirDataSensors(1:j-1,:);     
 Result.PaquetWind=Result.PaquetWind(1:j-1,:);
 Result.Pattern=Result.Pattern(1:j-1,:);

 waitbar(1/1);
 
 f1 = figure;
 plot(Result.AD_NAVIGATION(:,1))
 f2 = figure;
 plot(diff(Result.AD_NAVIGATION(:,1)))
 mean(diff(Result.AD_NAVIGATION(:,1)))




    