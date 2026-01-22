%========================================================================%
%  Traitement donnees FL_28072020                                           %
%========================================================================%
clear
load Vol5_momenta
close all
%========================================================================%
% Constante Physique                                                     %
%========================================================================%
R = 8.3144598;      %gas constant [m^3PaK^-1mol^-1]
m = 0.02897;        %mass if 1 mol of air 
R = R/m;            %air constant[J/kgK]
alpha_k_offset = [0.083 ];  % Conversion Angle Pression verticale
beta_k_offset = [0.086 ];  % Conversion Angle Pression Horzontale
%==========================================================================%
Seuil_bas=6;
Seuil_haut= 680924;

Seuil_bas_p=51;
Seuil_haut_p= 6809240;

%=========================Pressures =====================================%

time_1000Hz=(data5.Pressures(Seuil_bas_p:Seuil_haut_p,27))./1000; % in seconds
t_1000Hz=datetime(data5.Pressures(Seuil_bas_p:Seuil_haut_p,27)./1000,'ConvertFrom','posixtime','TicksPerSecond',1e9,'Format','dd-MMM-yyyy HH:mm:ss.SSSSSSSSS');

time_100Hz=(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,26))./1000; % in seconds
t_100Hz=datetime(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,26)./1000,'ConvertFrom','posixtime','TicksPerSecond',1e9,'Format','dd-MMM-yyyy HH:mm:ss.SSSSSSSSS');

figure('Name','Time 1000Hz')
plot(time_1000Hz)

figure('Name','Time 100Hz')
plot(time_100Hz)

%%%%Vertical pressure (Angle of attack)%%%%%%%%%%%%
p_vert= data5.Pressures(Seuil_bas_p:Seuil_haut_p,18); %HCE HAUT-BAS
p_vert2= data5.Pressures(Seuil_bas_p:Seuil_haut_p,19);%HCE HAUT-BAS


p_vert_LDE= data5.Pressures(Seuil_bas_p:Seuil_haut_p,24);%LDE HAUT-BAS


figure('Name','Pression Haut Bas')
plot(p_vert); hold on
plot(p_vert2); hold on
plot(p_vert_LDE);
legend('HCE1','HCE2','LDE')
ylabel('Pressure between top and bottom')
xlabel('Time in s')

%%%%%%%%%%%%%%

p_centrale=(data5.Pressures(Seuil_bas_p:Seuil_haut_p,14)+data5.Pressures(Seuil_bas_p:Seuil_haut_p,15))./2;

figure('Name','Central hole dynamic pressure')
plot(p_centrale)
ylabel('The five-hole probe dynamic pressure (mbar)')
xlabel('time s ')

%%%%%%%%%%%%%%

p_pitot=(data5.Pressures(Seuil_bas_p:Seuil_haut_p,16)+data5.Pressures(Seuil_bas_p:Seuil_haut_p,17))./2;

figure('Name','Central hole dynamic pressure')
plot(p_pitot)
ylabel('The five-hole probe dynamic pressure (mbar)')
xlabel('time s ')


%%%%%%%%%%%%

p_horiz= data5.Pressures(Seuil_bas_p:Seuil_haut_p,20); %HCE GAUCHE-DROITE
p_horiz1= data5.Pressures(Seuil_bas_p:Seuil_haut_p,21);%HCE GAUCHE-DROITE
p_horiz_LDE= data5.Pressures(Seuil_bas_p:Seuil_haut_p,25);%LDE GAUCHE-DROITE

figure('Name','Pression gauche droite')
plot(p_horiz); hold on
plot(p_horiz1); hold on
plot(p_horiz_LDE)
legend('HCE1','HCE2','LDE')
ylabel('Pressure left and right')
xlabel('Time in s')

%%%%%%%%

p_Stat2=data5.Pressures(Seuil_bas_p:Seuil_haut_p,13); 

figure('Name','Baro pressure')
plot(p_Stat2)
ylabel('Baro pressure hPa')
xlabel('')

%%%%%%%%%%%%%%%

figure('Name','Pitot and Central hole dynamic pressure')
plot(p_pitot); hold on ; plot(p_centrale)
ylabel('Dynamic pressure (mbar)')
xlabel('')
legend('Pitot','5hole')

% % Temperature/ Humidite 10 Hz / frequence 10Hz
% %=========================================================================%

figure('Name','Temperature')
plot(data5.T2(Seuil_bas:Seuil_haut,3)); hold on
ylabel('Temperature in degrees (PT100)')

figure('Name','Temperature')
plot(data5.TH(Seuil_bas:Seuil_haut,6)); hold on
plot(data5.TH(Seuil_bas:Seuil_haut,8))
legend('Temp1','Temp2')
ylabel('Temperature in degrees')

figure('Name','Humidity')
plot(data5.TH(Seuil_bas:Seuil_haut,7)); hold on
plot(data5.TH(Seuil_bas:Seuil_haut,9))
legend('Hum1','Hum2')
ylabel('Humidity in degrees')


figure('Name','Temperature')
plot(data5.T2(Seuil_bas:Seuil_haut,3)); hold on
plot(data5.TH(Seuil_bas:Seuil_haut,6)); hold on
plot(data5.TH(Seuil_bas:Seuil_haut,8))
ylabel('Temperature in degrees ')
legend('PT100','Temp1','Temp2')

% % Latitude / longitude / 2 D
% %=========================================================================%

figure('Name','Latitude')
plot(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,26),data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,6))
ylabel('Latitude (rad)')
xlabel('time')

figure('Name','Longitude')
plot(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,7))
ylabel('Longitude (rad)')

figure('Name','2D plan')
plot(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,7).*180/pi,data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,6).*180/pi)
ylabel('Latitude')
xlabel('Longitude')

figure('Name','3D plan')
plot3(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,6).*180/pi,data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,7).*180/pi,data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,8))
xlabel('Latitude')
ylabel('Longitude')
zlabel('Height')

lat=data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,6).*180/pi;
long=data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,7).*180/pi;
height=data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,8);

%%%Animation en 3D %%%%%%%%%%
% curve=animatedline('LineWidth',1)
% view(43,42);
% hold on;
% for i=1:1000:length(lat)
%    addpoints(curve,lat(i),long(i),height(i))
% scatter3(lat(i),long(i),height(i))
% drawnow
% pause(0.01)
% end

figure
curve=animatedline('LineWidth',1)
view(2);
hold on;
for i=1:500:length(lat)
   addpoints(curve,long(i),lat(i))
plot(long(i),lat(i))
drawnow
pause(0.01)
end
%% Attitude angles%%%%%%

% % Latitude / longitude / 2 D
% %=========================================================================%

figure('Name','Latitude')
plot(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,16))
ylabel('Roll')

figure('Name','Longitude')
plot(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,17))
ylabel('Pitch')

figure('Name','2D plan')
plot(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,18))
ylabel('Heading')


