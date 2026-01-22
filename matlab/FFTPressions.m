%========================================================================%
%  FFT pression avant resample                                           %
%========================================================================%
clear
load('data.mat')

%========================================================================%
% Seuil haut                                                             %
%========================================================================%
Seuil_bas=20;
Seuil_haut= 680924;
%========================================================================%
%resample et selection                                                    %
%========================================================================%
%=========================================================================%
% pression col mb 
%           8  5 trous verticales p_vert
%           9  5 trous centrales  p_centrale
%          10  5 trous Horizontales  p_horiz
%          11  Baro/Statique 1  P_Stat1
%          12  Baro/Statique 2  P_Stat2
%          13  Pitot            P_Pitot
%=========================================================================%
col=[1:15];
[Ressample_Pressures,temps]=resample(data.Pressures(Seuil_bas:Seuil_haut,col),data.Pressures(Seuil_bas:Seuil_haut,1),1,1,1,'linear');
p_vert= Ressample_Pressures(:,8);
p_centrale= Ressample_Pressures(:,9);
p_horiz= Ressample_Pressures(:,10);
p_Stat1= Ressample_Pressures(:,11);
p_Stat2= Ressample_Pressures(Seuil_bas:Seuil_haut,12);
p_Pitot= Ressample_Pressures(Seuil_bas:Seuil_haut,13);
%=========================================================================%
% IMU     acc/Gyr/                                                        %
%           2 Xaccl
%           3 Yaccl
%           4 Zaccl
%           5 Xgyro
%           6 Ygyro
%           7 Zgyro
%           8 Xmagn
%           9 Ymagn
%          10 Zmagn
%          11 TempIMU
%          12 Baro_IMU
%          13 TempPression
%=========================================================================%
col=[1:15];
[Ressample_IMU,temps]=resample(data.IMU(Seuil_bas:Seuil_haut,col),data.IMU(Seuil_bas:Seuil_haut,1),1,1,1,'linear');
IMU_Xaccl=Ressample_IMU(:,2);
IMU_Yaccl=Ressample_IMU(:,3);
IMU_Zaccl=Ressample_IMU(:,4);
IMU_Xgyro=Ressample_IMU(:,5);
IMU_Ygyro=Ressample_IMU(:,6);
IMU_Zgyro=Ressample_IMU(:,7);
IMU_Xmagn=Ressample_IMU(:,8);
IMU_Ymagn=Ressample_IMU(:,9);
IMU_Zmagn=Ressample_IMU(:,10);
IMU_TempIMU=Ressample_IMU(:,11);
IMU_Baro=Ressample_IMU(:,12);
IMU_TempPression=Ressample_IMU(:,13);
%=========================================================================%
% AD.Navigation                                                %
%           6 Latitude
%           7 Longitude
%           8 Height
%           9 VitesseNord
%           10 VitesseEast
%           11 VitesseDown
%           15 G
%           16 Roll
%           17 Pitch
%           18 Heading
%           19 AngVelX
%           20 AngVelY
%           21 AngVelZ
%=========================================================================
col=[1:26];
[Ressample_ADV,temps]=resample(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,col),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,1),1,1,1,'linear');
ADV_Lat=Ressample_ADV(:,6);
ADV_Long=Ressample_ADV(:,7);
ADV_Height=Ressample_ADV(:,8);
ADV_V_Nord=Ressample_ADV(:,9);
ADV_V_East=Ressample_ADV(:,10);
ADV_V_Down=Ressample_ADV(:,11);
ADV_G=Ressample_ADV(:,15);
ADV_Roll=Ressample_ADV(:,16);
ADV_Pitch=Ressample_ADV(:,17);
ADV_Heading=Ressample_ADV(:,18);
ADV_AngVelX=Ressample_ADV(:,19);
ADV_AngVelY=Ressample_ADV(:,20);
ADV_AngVelZ=Ressample_ADV(:,21);


%=========================================================================%
Fs=100;  % frequence d echantillonage
T=1/Fs;
L=200000
NFFT=2^nextpow2(L);



%========================================================================%
% SPECTRES PRESSIONS
%========================================================================%
%========================================================================%
% Pression Verticale sonde 5 trous                                       %
%========================================================================%
figure(10000);
p=p_vert;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad 5trous Verticale','Location','southwest');
title('Single-Sided Amplitude Spectrum of Vert5HolesProbes')
xlabel('Frequency (Hz)')
ylabel('|mb(f)|')


%========================================================================%
% Pression Centrale sonde 5 trous                                       %
%========================================================================%
figure(10001);
p=p_centrale;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad 5trous Centrale','Location','southwest');
title('Single-Sided Amplitude Spectrum of Centrale5HolesProbes')
xlabel('Frequency (Hz)')
ylabel('|mb(f)|')

%========================================================================%
% Pression Horzontale sonde 5 trous                                       %
%========================================================================%
figure(10002);
p=p_horiz;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad 5trous Horizontale','Location','southwest');
title('Single-Sided Amplitude Spectrum of Horizontal5HolesProbes')
xlabel('Frequency (Hz)')
ylabel('|mb(f)|')


%========================================================================%
% Pression Baro/Statique 1                                       %
%========================================================================%
figure(10003);
p=p_Stat1;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Baro_Stat1','Location','southwest');
title('Single-Sided Amplitude Spectrum of Baro_Stat1')
xlabel('Frequency (Hz)')
ylabel('|mb(f)|')

%========================================================================%
% Pression Baro/Statique 2                                      %
%========================================================================%
figure(10004);
p=p_Stat2;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Baro Stat2','Location','southwest');
title('Single-Sided Amplitude Spectrum of Baro Stat2')
xlabel('Frequency (Hz)')
ylabel('|mb(f)|')


%========================================================================%
% Pression Pitot                                     %
%========================================================================%
figure(10005);
p=p_Pitot;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Pitot','Location','southwest');
title('Single-Sided Amplitude Spectrum of Pitot')
xlabel('Frequency (Hz)')
ylabel('|mb(f)|')



%========================================================================%
% SPECTRES IMU
%========================================================================%
%========================================================================%
% ACC X                                    %
%========================================================================%
figure(20000);
p=IMU_Xaccl;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad AccX','Location','southwest');
title('Single-Sided Amplitude Spectrum of AccX')
xlabel('Frequency (Hz)')
ylabel('|m/s/s(f)|')



%========================================================================%
% ACC Y                                     %
%========================================================================%
figure(20001);
p=IMU_Yaccl;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad AccY','Location','southwest');
title('Single-Sided Amplitude Spectrum of AccY')
xlabel('Frequency (Hz)')
ylabel('|m/s/s(f)|')


%========================================================================%
% ACC Z                                     %
%========================================================================%
figure(20002);
p=IMU_Zaccl;

f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad AccZ','Location','southwest');
title('Single-Sided Amplitude Spectrum of AccZ')
xlabel('Frequency (Hz)')
ylabel('|m/s/s(f)|')



%========================================================================%
% Gyro X                                       %
%========================================================================%
figure(20003);
p=IMU_Xgyro;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Xgyro','Location','southwest');
title('Single-Sided Amplitude Spectrum of Xgyro')
xlabel('Frequency (Hz)')
ylabel('|rad/s/s(f)|')


%========================================================================%
% Gyro Y                                     %
%========================================================================%
figure(20004);
p=IMU_Ygyro;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Ygyro','Location','southwest');
title('Single-Sided Amplitude Spectrum of Ygyro')
xlabel('Frequency (Hz)')
ylabel('|rad/s/s(f)|')


%========================================================================%
% Gyro Z                                    %
%========================================================================%
figure(20005);
p=IMU_Zgyro;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Zgyro','Location','southwest');
title('Single-Sided Amplitude Spectrum of Zgyro')
xlabel('Frequency (Hz)')
ylabel('|rad/s/s(f)|')


%========================================================================%
% Magn X                                       %
%========================================================================%
figure(20006);
p=IMU_Xmagn;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Xmagn','Location','southwest');
title('Single-Sided Amplitude Spectrum of Xmagn')
xlabel('Frequency (Hz)')
ylabel('|mG(f)|')


%========================================================================%
% Magn Y                                     %
%========================================================================%
figure(20007);
p=IMU_Ymagn;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Ymagn','Location','southwest');
title('Single-Sided Amplitude Spectrum of Ymagn')
xlabel('Frequency (Hz)')
ylabel('|mG(f)|')

%========================================================================%
% Magne Z                                    %
%========================================================================%
figure(20008);
p=IMU_Zmagn;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Zmagn','Location','southwest');
title('Single-Sided Amplitude Spectrum of Zmagn')
xlabel('Frequency (Hz)')
ylabel('|mG(f)|')



%========================================================================%
% Température IMU                                      %
%========================================================================%
figure(20009);
p=IMU_TempIMU;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Temperature','Location','southwest');
title('Single-Sided Amplitude Spectrum of Temperature')
xlabel('Frequency (Hz)')
ylabel('|degCelsius(f)|')



%========================================================================%
% Baro IMU                                     %
%========================================================================%
figure(20010);
p=IMU_Baro;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Baro IMU','Location','southwest');
title('Single-Sided Amplitude Spectrum of Baro')
xlabel('Frequency (Hz)')
ylabel('|PressionPa(f)|')




%========================================================================%
% Temp Pressue IMU                                    %
%========================================================================%
figure(20011);
p=IMU_TempPression;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Temperature Pression','Location','southwest');
title('Single-Sided Amplitude Spectrum of Temperature Pression')
xlabel('Frequency (Hz)')
ylabel('|degCelsius(f)|')

%========================================================================%
% SPECTRES ADV
%========================================================================%
%========================================================================%
% Lat                                   %
%========================================================================%
figure(30000);
p=ADV_Lat;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Latitude','Location','southwest');
title('Single-Sided Amplitude Spectrum of Latitude')
xlabel('Frequency (Hz)')
ylabel('|degLat(f)|')

%========================================================================%
% Long                                  %
%========================================================================%
figure(30001);
p=ADV_Long;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Longitude','Location','southwest');
title('Single-Sided Amplitude Spectrum of Longitude')
xlabel('Frequency (Hz)')
ylabel('|degLong(f)|')

%========================================================================%
% Height                                   %
%========================================================================%
figure(30002);
p=ADV_Height;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Altitude QNH','Location','southwest');
title('Single-Sided Amplitude Spectrum of Altitude QNH')
xlabel('Frequency (Hz)')
ylabel('|m(f)|')

%========================================================================%
% Nord                                       %
%========================================================================%
figure(30003);
p=ADV_V_Nord;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Vitesse Sol Nord','Location','southwest');
title('Single-Sided Amplitude Spectrum of Speed Sol Nord ')
xlabel('Frequency (Hz)')
ylabel('|m(f)|')

%========================================================================%
% East                                    %
%========================================================================%
figure(30004);
p=ADV_V_East;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Vitesse Sol South','Location','southwest');
title('Single-Sided Amplitude Spectrum of Speed Sol South ')
xlabel('Frequency (Hz)')
ylabel('|m(f)|')

%========================================================================%
% Down                                   %
%========================================================================%
figure(30005);
p=ADV_V_Down;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Vitesse Sol Down','Location','southwest');
title('Single-Sided Amplitude Spectrum of Speed Sol Down ')
xlabel('Frequency (Hz)')
ylabel('|m(f)|')

%========================================================================%
% G                                     %
%========================================================================%
figure(30006);
p=ADV_G;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad  AccG','Location','southwest');
title('Single-Sided Amplitude Spectrum of ACCg ')
xlabel('Frequency (Hz)')
ylabel('|g(f)|')

%========================================================================%
% Roll                                    %
%========================================================================%
figure(30007);
p=ADV_Roll;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Roll Rad','Location','southwest');
title('Single-Sided Amplitude Spectrum of Roll ')
xlabel('Frequency (Hz)')
ylabel('|Rad(f)|')

%========================================================================%
% Pitch                                                                  %
%========================================================================%
figure(30008);
p=ADV_Pitch;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Pitch Rad','Location','southwest');
title('Single-Sided Amplitude Spectrum of Pitch ')
xlabel('Frequency (Hz)')
ylabel('|Rad(f)|')

%========================================================================%
% Heading                                                                %
%========================================================================%
figure(30009);
p=ADV_Heading;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Heading Rad','Location','southwest');
title('Single-Sided Amplitude Spectrum of Heading ')
xlabel('Frequency (Hz)')
ylabel('|Rad(f)|')

%========================================================================%
% AngVelX                                                                %
%========================================================================%
figure(30010);
p=ADV_AngVelX;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Angular Velocity X','Location','southwest');
title('Single-Sided Amplitude Spectrum of Angular Velocity X ')
xlabel('Frequency (Hz)')
ylabel('|Rad(f)|')

%========================================================================%
% AngVelY                                                                %
%========================================================================%
figure(30011);
p=ADV_AngVelY;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Angular Velocity Y','Location','southwest');
title('Single-Sided Amplitude Spectrum of Angular Velocity Z ')
xlabel('Frequency (Hz)')
ylabel('|Rad(f)|')

%========================================================================%
% AngVelZ                                                                %
%========================================================================%
figure(30012);
p=ADV_AngVelZ;
f = Fs/2*linspace(0,1,NFFT/2+1);
Y = fft(p,NFFT)/L;
loglog(f,2*abs(Y(1:NFFT/2+1)),'-g');
legend('Miriad Angular Velocity Z','Location','southwest');
title('Single-Sided Amplitude Spectrum of Angular Velocity Z ')
xlabel('Frequency (Hz)')
ylabel('|Rad(f)|')


