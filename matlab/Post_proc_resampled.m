%========================================================================%
%  Traitement donnees FL_30072020                                           %
%========================================================================%
clear
load Vol5_momenta.mat

load('log_vol5.mat')
load('log_vol5_label.mat')

load('Resampled_Pressures.mat')
load('Resampled_Pressures_label.mat')

load('Resample_ADnav_label.mat')
load('Resampled_ADnav_100Hz.mat')

load('Resampled_TH.mat') %SHT85
load('Resampled_TH_label.mat')

load('Resampled_T2.mat') %(Pt100)
load('Resampled_T2_label.mat')

% Mat_avril_2021_label=["TOA5","TOA5","TOA5","TOA5","TOA5","TOA5","eparadise_mat","CR6","2780","CR6.Std.10.02","CPU:e-paradise_mat.CR6","15975","eparadise_wind_10min","","","","","","","","";
%     "TIMESTAMP","TIMESTAMP","TIMESTAMP","TIMESTAMP","TIMESTAMP","TIMESTAMP","RECORD","BattV_Min","ChargeInput_Min","WindSpeedHorizontal_10m","WindAngle_10m","W_10m_Avg","WindSpeedHorizontal_41m","WindAngle_41m","W_41m_Avg","WindSpeedHorizontal_53m","WindAngle_53m","W_53m_Avg","WindSpeedHorizontal_79m","WindAngle_73m","W_79m_Avg";
%     "Year","Month","day","Hour","minutes","Seconds","RN","Volts","","meters/second","Deg","meters/second","meters/second","Deg","meters/second","meters/second","Deg","meters/second","meters/second","Deg","meters/second";
%     "","","","","","","","Min","Min","WVc","WVc","Avg","WVc","WVc","Avg","WVc","WVc","Avg","WVc","WVc","Avg"]

%% =====================================================================%
% Constante Physique                                                     %
%========================================================================%
R = 8.3144598;      %gas constant [m^3PaK^-1mol^-1]
m = 0.02897;        %mass if 1 mol of air 
R = R/m;            %air constant[J/kgK]
alpha_k_offset = [0.083 ];  % Conversion Angle Pression verticale
beta_k_offset = [0.086 ];  % Conversion Angle Pression Horzontale
%=======================================================================%
Seuil_bas=6;
Seuil_haut= 680924;
%% Pressure ============================================================%

time_100Hz=(Resampled_Pressures(:,15))./1000;
t_100Hz_3004=datetime(Resampled_Pressures(:,15)./1000,'ConvertFrom','posixtime','TicksPerSecond',1e9,'Format','dd-MMM-yyyy HH:mm:ss.SSSSSSSSS');
save('t_100Hz_3004.mat','t_100Hz_3004')

p_vert= Resampled_Pressures(:,7); %HCE HAUT-BAS
p_vert2= Resampled_Pressures(:,8);%HCE HAUT-BAS

p_vert_LDE= Resampled_Pressures(:,13);%LDE HAUT-BAS

figure('Name','Pression Haut Bas')
plot(t_100Hz_3004,p_vert); hold on
plot(t_100Hz_3004,p_vert2); hold on
plot(t_100Hz_3004,p_vert_LDE);
legend('HCE1','HCE2','LDE')
ylabel('Pressure top and bottom')
xlabel('Time in s')

%%%%%%%%%%%%%%
% p_centrale= (Ressample_Pressures(:,14)+Ressample_Pressures(:,15))/2; 

p_centrale=(Resampled_Pressures(:,3)+Resampled_Pressures(:,4))./2;

figure('Name','Central hole dynamic pressure')
plot(t_100Hz_3004,p_centrale)
ylabel('The five-hole probe dynamic pressure (mbar)')
xlabel('')

%%%%%%%%%%%%

p_horiz= Resampled_Pressures(:,9); %HCE GAUCHE-DROITE
p_horiz1= Resampled_Pressures(:,10);%HCE GAUCHE-DROITE
p_horiz_LDE= Resampled_Pressures(:,14);%LDE GAUCHE-DROITE

figure('Name','Pression gauche droite')
plot(t_100Hz_3004,p_horiz); hold on
plot(t_100Hz_3004,p_horiz1); hold on
plot(t_100Hz_3004,p_horiz_LDE)
legend('HCE1','HCE2','LDE')
ylabel('Pressure left and right')
xlabel('Time in s')

%%%%%%%%

p_Stat2=Resampled_Pressures(:,2); %Fonctionne lors du vol de 28/07/2020

figure('Name','Baro pressure')
plot(t_100Hz_3004,p_Stat2)
ylabel('Baro pressure hPa')
xlabel('')

%%%%%%%%%
% p_Pitot= (Ressample_Pressures(:,16)+Ressample_Pressures(:,17))/2;%HCE

p_Pitot=(Resampled_Pressures(:,5)+Resampled_Pressures(:,6))./2; 
figure('Name','Pitot dynamic pressure')
plot(t_100Hz_3004,p_Pitot)
ylabel('Pitot dynamic pressure mbar')
xlabel('')

figure('Name','Pitot and Centrale hole dynamic pressure')
plot(t_100Hz_3004,p_Pitot); hold on ; plot(t_100Hz_3004,p_centrale)
ylabel('Pitot dynamic pressure mbar')
xlabel('')
legend('Pitot','5hole')

%% % Temperature/ Humidite 10 Hz / frequence 10Hz
% %=========================================================================%

figure('Name','Temperature')
plot(t_100Hz_3004,Resampled_T2(:,1)); hold on
xlabel('Temperature in degrees (PT100)')

figure('Name','Temperature')
plot(t_100Hz_3004,Resampled_TH(:,1))
xlabel('Temperature in degrees')

figure('Name','Humidity')
plot(t_100Hz_3004,Resampled_TH(:,2))
xlabel('Humidity in degrees')

figure('Name','Temperature')
plot(t_100Hz_3004,Resampled_T2(:,1)); hold on
plot(t_100Hz_3004,Resampled_TH(:,1)); hold on
xlabel('Temperature in degrees ')
legend('PT100','Temp1')


%% Calculate AIR SPEED

T_pt100=Resampled_T2(:,1);

rho = 100*p_Stat2./(R*(T_pt100+273.15));  % 100 pour convsersion mb=>pascal et degre kelvin
AirSpeed_5hole= sqrt(abs((200.*p_centrale)./rho)); %Bernoulli eq'n using mbar
AirSpeed_Pitot = sqrt(abs((200.*p_Pitot)./rho));
save('AirSpeed_5hole.mat','AirSpeed_5hole');

figure('Name','Airspeed')
plot(t_100Hz_3004,AirSpeed_5hole); hold on
plot(t_100Hz_3004,AirSpeed_Pitot);
xlabel('time')
ylabel('airspeed (m/s)')
legend('5hole','Pitot')

%=========================================================================%
Alpha= -p_vert_LDE./( p_centrale*0.083 );
Beta= -p_horiz_LDE./( p_centrale*0.086);%+0.015*180/pi;  %
save('Beta.mat','Beta')
save('Alpha.mat','Alpha')

% fal=figure('Name','Alpha et Beta')
% subplot(2,1,1)
% plot(t_100Hz_3004,Alpha ); hold on
% plot(t_100Hz_3004,Beta);
% legend('Alpha','Beta')
% subplot(2,1,2)
% plot(t_100Hz_3004,Psi);ylabel('Heading angle')
% xlabel('time')
% allaxes=findobj(fal,'type','axes','tag', '')
% linkaxes(allaxes,'x')
% xlabel('Attack and sideslip angle (degrees)')


%%
Phi=Resampled_ADnav_25hzto100(:,16);
Theta=Resampled_ADnav_25hzto100(:,17);
Psi=Resampled_ADnav_25hzto100(:,18);

Vg_East=Resampled_ADnav_25hzto100(:,10);
Vg_North=Resampled_ADnav_25hzto100(:,9);
Vg_Down=Resampled_ADnav_25hzto100(:,11);


% Vg_Down=log_vol5(Seuil_bas_log:Seuil_haut_log,12)

% Vg_East=resample(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,10),data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,1),5.060196,1,1,'Linear');
% Vg_North=resample(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,9),data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,1),5.060196,1,1,'Linear');
% Vg_Down=resample(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,11),data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,1),5.060196,1,1,'Linear');

figure('Name','Ground speed (SPATIAL)')
plot(t_100Hz_3004,Vg_East); hold on
plot(t_100Hz_3004,Vg_North); hold on
plot(t_100Hz_3004,Vg_Down)
legend('East','North','Down')
ylabel('Ground speed in m/s')

f1=figure('Name','Euler angles')
subplot(3,1,1)
plot(t_100Hz_3004,Phi)
ylabel('roll angle')
subplot(3,1,2)
plot(t_100Hz_3004,Theta);ylabel('Pitch angle')
subplot(3,1,3)
plot(t_100Hz_3004,Psi);ylabel('Heading angle')
xlabel('time')
allaxes=findobj(f1,'type','axes','tag', '')
linkaxes(allaxes,'x')

fig=figure('Name','Ground speed (SPATIAL) and CAP')
subplot(3,1,1)
plot(t_100Hz_3004,Vg_East); hold on
plot(t_100Hz_3004,Vg_North); hold on
plot(t_100Hz_3004,Vg_Down)
legend('East','North','Down')
ylabel('Ground speed in m/s')
subplot(3,1,2)
plot(t_100Hz_3004,Psi); hold on
ylabel('Heading')
xlabel('Time')
subplot(3,1,3)
plot(t_100Hz_3004,sqrt(Vg_East.^2+Vg_North.^2)); 
legend('Horiz ground speed','Down')
ylabel('Ground speed in m/s')
allaxes=findobj(fig,'type','axes','tag', '')
linkaxes(allaxes,'x')

% figure('Name','Wind speed ADU')
% plot(sqrt(data5.PaquetWind(41:656240,3).^2+data5.PaquetWind(41:656240,4).^2));
% title('Wind speed of ADU')
% Modele complexe de lenchow
D = ( 1 + (tand(Alpha)).^2 + (tand(Beta)).^2).^0.5;

Etape1=sind(Psi).*cosd(Theta);
Etape2=tand(Beta).*(cosd(Psi).*cosd(Phi) + sind(Psi).*sind(Theta).*sind(Phi));
Etape3=tand(Alpha).*(sind(Psi).*sind(Theta).*cosd(Phi) - cosd(Psi).*sind(Phi));
WindSpeed_East=(-1./D).*AirSpeed_5hole.*(Etape1+Etape2 + Etape3)+ Vg_East;

Etape4=cosd(Psi).*cosd(Theta);
Etape5=tand(Beta).*(sind(Psi).*cosd(Phi)-cosd(Psi).*sind(Theta).*sind(Phi));
Etape6=tand(Alpha).*(cosd(Psi).*sind(Theta).*cosd(Phi) + sind(Psi).*sind(Phi));
WindSpeed_North=(-1./D).*AirSpeed_5hole.*(Etape4-Etape5 + Etape6)+Vg_North;

Horizontal_windSpeed= (WindSpeed_East.^2+WindSpeed_North.^2).^0.5;
WD=mod(atan2d(-WindSpeed_East,-WindSpeed_North),360);

Etape7=sind(Theta)-tand(Beta).*cosd(Theta).*sind(Phi)-tand(Alpha).*cosd(Theta).*cosd(Phi);
Vertical_WS_spatial=(-1./D).*AirSpeed_5hole.*Etape7-Vg_Down; %Vitesse vent verticale en utilisant la vitesse sol dérivée de l'altitude

% Modele complexe de lenchow
% D = ( 1 + (tand(Alpha)).^2 + (tand(Beta)).^2).^0.5;
% 
% Etape1_2=sind(Psi2).*cosd(Theta);
% Etape2_2=tand(Beta).*(cosd(Psi2).*cosd(Phi) + sind(Psi2).*sind(Theta).*sind(Phi));
% Etape3_2=tand(Alpha).*(sind(Psi2).*sind(Theta).*cosd(Phi) - cosd(Psi2).*sind(Phi));
% WindSpeed_East_2=(-1./D).*AirSpeed_5hole.*(Etape1_2+Etape2_2 + Etape3_2)+ Vg_East;
% 
% Etape4_2=cosd(Psi2).*cosd(Theta);
% Etape5_2=tand(Beta).*(sind(Psi2).*cosd(Phi)-cosd(Psi2).*sind(Theta).*sind(Phi));
% Etape6_2=tand(Alpha).*(cosd(Psi2).*sind(Theta).*cosd(Phi) + sind(Psi2).*sind(Phi));
% WindSpeed_North_2=(-1./D).*AirSpeed_5hole.*(Etape4_2-Etape5_2 + Etape6_2)+Vg_North;
% 
% Horizontal_windSpeed2= (WindSpeed_East_2.^2+WindSpeed_North_2.^2).^0.5;
% WD2=mod(atan2d(-WindSpeed_East_2,-WindSpeed_North_2),360);

% figure('Name','Wind speed speed')
% plot(time_100Hz,Horizontal_windSpeed); hold on
% plot(time_100Hz,Horizontal_windSpeed2); hold on
% legend('with Heading SPATIAL','with Heading MOTUS')
% ylabel('Wind speed in m/s')
% subplot(2,1,2)
% plot(time_100Hz,WD); hold on
% plot(time_100Hz,WD2); hold on
% legend('with Heading SPATIAL',' with Heading MOTUS')
% ylabel('WD in degrees')

f3=figure('Name','Wind speed speed')
subplot(5,1,1)
plot(t_100Hz_3004,Horizontal_windSpeed); hold on
ylabel('Wind speed in m/s')
subplot(5,1,2)
plot(t_100Hz_3004,WD); hold on
ylabel('WD in degrees')
subplot(5,1,3)
plot(t_100Hz_3004,Phi)
ylabel('roll angle')
subplot(5,1,4)
plot(t_100Hz_3004,Theta);ylabel('Pitch angle')
subplot(5,1,5)
plot(t_100Hz_3004,Psi);ylabel('Heading angle')
xlabel('time')
allaxes=findobj(f3,'type','axes','tag', '')
linkaxes(allaxes,'x')

figure('Name','Wind speed speed')
plot(t_100Hz_3004,Horizontal_windSpeed); hold on
ylabel('Wind speed in m/s')


figure('Name','Wind direction')
plot(t_100Hz_3004,WD); hold on
legend('with Heading SPATIAL')
ylabel('WD in degrees')

% Modele simplifie de lenchow
% Calcul_Simplifie_Vent_VitesseEast=(-1).*AirSpeed_5hole.*sind(Psi+Beta)+ADV_V_East;
% Calcul_Simplifie_Vent_VitesseNord=(-1).*AirSpeed_5hole.*cosd(Psi+Beta)+ADV_V_Nord;
% Calcul_Simplifie_Vent_Horizontal=(Calcul_Simplifie_Vent_VitesseEast.^2+Calcul_Simplifie_Vent_VitesseNord.^2).^0.5;
% Calcul_Simplifie_Direction_Vent=mod(atan2d(-1*Calcul_Simplifie_Vent_VitesseEast,-1*Calcul_Simplifie_Vent_VitesseNord),360);
% 
 %% 3D temperature
 
figure('Name','3D Temperature')
subplot(2,1,1)
Y = Resampled_ADnav_25hzto100(:,6).*180/pi;
X =  Resampled_ADnav_25hzto100(:,7).*180/pi;
Z =  Resampled_ADnav_25hzto100(:,8);
C = T_pt100(1:end);
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;Z(:);nan],...
      'CData', [nan;C(:);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp')
view(3)
barre=colorbar;
barre.Label.String = 'Temperature (degrees))';
title ('Temperature');
xlabel('Longitude (degrees)');
ylabel('Latitude  (degrees)');
zlabel('Height agl (m)');
subplot(2,1,2)
Y =  Resampled_ADnav_25hzto100(:,6).*180/pi;
X =  Resampled_ADnav_25hzto100(:,7).*180/pi;
Z =  Resampled_ADnav_25hzto100(:,8);
C = T_pt100(1:end);
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;Z(:);nan],...
      'CData', [nan;C(:);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp')
view([0,0,1])
barre=colorbar;
barre.Label.String = 'Temperature (degrees))';
title ('Temperature');
xlabel('Longitude (degrees)');
ylabel('Latitude  (degrees)');
zlabel('Height agl (m)');

figure('Name','3D GS')
subplot(2,1,1)
Y =  Resampled_ADnav_25hzto100(:,6).*180/pi;
X =  Resampled_ADnav_25hzto100(:,7).*180/pi;
Z =  Resampled_ADnav_25hzto100(:,8);
C = sqrt( Resampled_ADnav_25hzto100(:,9).^2+ Resampled_ADnav_25hzto100(:,10).^2);
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;Z(:);nan],...
      'CData', [nan;C(:);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp')
view(3)
barre=colorbar;
barre.Label.String = 'GS(m/s))';
title ('GS');
xlabel('Longitude (degrees)');
ylabel('Latitude  (degrees)');
zlabel('Height agl (m)');
subplot(2,1,2)
Y =  Resampled_ADnav_25hzto100(:,6).*180/pi;
X =  Resampled_ADnav_25hzto100(:,7).*180/pi;
Z =  Resampled_ADnav_25hzto100(:,8);
C = sqrt( Resampled_ADnav_25hzto100(:,9).^2+ Resampled_ADnav_25hzto100(:,10).^2);
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;Z(:);nan],...
      'CData', [nan;C(:);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp')
view([0,0,1])
barre=colorbar;
barre.Label.String = 'GS (m/s))';
title ('GS');
xlabel('Longitude (degrees)');
ylabel('Latitude  (degrees)');
zlabel('Height agl (m)');

figure('Name', 'Flight Path 2D');
plot( Resampled_ADnav_25hzto100(:,7).*180/pi,  Resampled_ADnav_25hzto100(:,6).*180/pi,'b')
set(gca, 'FontSize', 12)
title('2D Flight Path')
ylabel('Latitude [\circ]')
xlabel('Longitude [\circ]')

%% %%%%%%%%%%%%%%%%%%%%%%%% BOREAL DATA %%%%%%%%%%%%%%%%%%

%Euler angles from BOREAL data
fig1=figure('Name','Euler angles (Boreal data)');
subplot(3,1,1)
plot(log_vol5(:,13)); hold on; 
xlabel('')
ylabel('Heading(degrees)')
subplot(3,1,2)
plot(log_vol5(:,15)); hold on; 
xlabel('')
ylabel('Pitch(degrees)')
subplot(3,1,3)
plot(log_vol5(:,14)); hold on; 
xlabel('')
ylabel('Roll(degrees)')
allaxes=findobj(fig1,'type','axes','tag', '')
linkaxes(allaxes,'x')

% Convert date to UNIX Time %%%%%%%%

t = datetime(log_vol5(:,2),log_vol5(:,3),log_vol5(:,4),log_vol5(:,5),log_vol5(:,6),log_vol5(:,8));

format longG
% Note that the leap second is not considered by posixtime
t1 = posixtime(t);

figure('Name','Time')
plot(t1(:,1))


f=figure('Name','Ground speed vs RPM vs Cap (Boreal data)')
subplot(3,1,1)
plot(t,log_vol5(:,12)./3.6)
ylabel('Ground speed (m/s)')
subplot(3,1,2)
plot(t,log_vol5(:,17))
ylabel('RPM')
subplot(3,1,3)
plot(t,log_vol5(:,13))
ylabel('cap')
all_ha = findobj( f, 'type', 'axes', 'tag', '' );
linkaxes( all_ha, 'x' );



%% %%%%%%%%%%%%%%%%%%%%%%%%Comparison between logdata and Our data %%%%%%%%%%%%%%%%%

% Seuil_bas=173000;
% Seuil_haut= 500000;
% col=[1:26];
% [Ressample_ADV,temps]=resample(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,col),data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,1),1,1,1,'linear');
% col=[1:20];
% [Ressample_LOG,temps1]=resample(log_vol5(Seuil_bas:Seuil_haut,col),log_vol5(Seuil_bas:Seuil_haut,1),1,1,1,'linear');


Seuil_bas_log=find(t>= t_100Hz_3004(1));
Seuil_bas_log=Seuil_bas_log(1);

Seuil_haut_log=find(t<= t_100Hz_3004(end));
Seuil_haut_log=Seuil_haut_log(end);


fg=figure('Name','Heading and altitude in function of time (hours and minutes) BOREAL DATA')
subplot(2,1,1)
plot(t(Seuil_bas_log:Seuil_haut_log),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360))
ylabel('Heading')
subplot(2,1,2)
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,11))
ylabel('Altitude asl in m')
all_ha = findobj( fg, 'type', 'axes', 'tag', '' );
linkaxes( all_ha, 'x' );

f=figure('Name','Ground speed vs RPM vs Cap')
subplot(3,1,1)
plot(t_100Hz_3004,sqrt( Resampled_ADnav_25hzto100(:,9).^2+ Resampled_ADnav_25hzto100(:,10).^2)); hold on; 
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,12)./3.6);
legend('Ground speed AD navigation(m/s)','Ground speed Boreal(m/s)')
ylabel('Ground speed (m/s)')
subplot(3,1,2)
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,17))
ylabel('RPM (data boreal)')
subplot(3,1,3)
plot(t(Seuil_bas_log:Seuil_haut_log),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360))
%plot(t_100Hz_3004, Resampled_ADnav_25hzto100(:,18)); hold on;
%legend('Heading boreal','Heading ADnav')
legend('Heading boreal')
ylabel('Heading (data boreal)')
all_ha = findobj( f, 'type', 'axes', 'tag', '' );
linkaxes( all_ha, 'x' );

f=figure('Name','Ground speed vs RPM vs roll')
subplot(3,1,1)
plot(t_100Hz_3004,sqrt( Resampled_ADnav_25hzto100(:,9).^2+ Resampled_ADnav_25hzto100(:,10).^2)); hold on; 
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,12)./3.6);
legend('Ground speed AD navigation(m/s)','Ground speed Boreal(m/s)')
ylabel('Ground speed (m/s)')
subplot(3,1,2)
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,17))
ylabel('RPM (data boreal)')
subplot(3,1,3)
plot(t_100Hz_3004, Resampled_ADnav_25hzto100(:,16)); hold on; 
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,14))
legend('Roll ADnav','Roll boreal')
ylabel('Roll (degrees)')
all_ha = findobj( f, 'type', 'axes', 'tag', '' );
linkaxes( all_ha, 'x' );

% time_lapse=data5.AD_NAVIGATION(18165,26)./10^3-t1(755);
% 
% 
% f=figure('Name','Ground speed vs RPM vs Heading + time_lapse')
% subplot(3,1,1)
% plot(time_100Hz, sqrt(Resampled_ADnav_25hzto100(:,9).^2+ Resampled_ADnav_25hzto100(:,10).^2)); hold on; 
% plot((t1(Seuil_bas_log:Seuil_haut_log)-t1(Seuil_bas_log)),log_vol5(Seuil_bas_log:Seuil_haut_log,12)./3.6);
% legend('Ground speed AD navigation(m/s)','Ground speed Boreal(m/s)')
% ylabel('Ground speed (m/s)')
% subplot(3,1,2)
% plot((t1(Seuil_bas_log:Seuil_haut_log)-t1(Seuil_bas_log)),log_vol5(Seuil_bas_log:Seuil_haut_log,17))
% ylabel('RPM (data boreal)')
% subplot(3,1,3)
% plot(time_100Hz, Resampled_ADnav_25hzto100(:,18)); hold on; 
% plot((t1(Seuil_bas_log:Seuil_haut_log)-t1(Seuil_bas_log)),log_vol5(Seuil_bas_log:Seuil_haut_log,13))
% legend('Heading ADnav','Heading boreal')
% ylabel('Heading (data boreal)')
% all_ha = findobj( f, 'type', 'axes', 'tag', '' );
% linkaxes( all_ha, 'x' );

figure('Name','3D ground speed (Boreal data)')
subplot(2,1,1)
X = log_vol5(:,9);
Y = log_vol5(:,10);
Z = log_vol5(:,11);
C = log_vol5(:,12)./3.6;
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;Z(:);nan],...
      'CData', [nan;C(:);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp')
view(3)
barre=colorbar;
barre.Label.String = 'Ground speed boreal)';
title ('Ground speed boreal');
ylabel('Longitude (degrees)');
xlabel('Latitude  (degrees)');
zlabel('Height agl (m)');
subplot(2,1,2)
X = log_vol5(:,9);
Y = log_vol5(:,10);
Z = log_vol5(:,11);
C = log_vol5(:,12)./3.6;
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;Z(:);nan],...
      'CData', [nan;C(:);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp')
view([0,0,1])
barre=colorbar;
barre.Label.String = 'Ground speed boreal)';
title ('Ground speed boreal');
ylabel('Longitude (degrees)');
xlabel('Latitude  (degrees)');
zlabel('Height agl (m)');


figure('Name','2D pattern')
X = log_vol5(:,9);%longitude
Y = log_vol5(:,10);%latitude
Z = log_vol5(:,11);
plot(X,Y)
xlabel('Longitude (degrees)');
ylabel('Latitude (degrees)');
title('2D flight path');

figure('Name', 'Flight Path 2D (Comparison)');
plot( Resampled_ADnav_25hzto100(:,7).*180/pi, Resampled_ADnav_25hzto100(:,6).*180/pi,'b');hold on;
plot(log_vol5(:,9),log_vol5(:,10),'r')
set(gca, 'FontSize', 12)
legend('Spatial','SBG')
title('2D Flight Path')
ylabel('Latitude [\circ]')
xlabel('Longitude [\circ]')

%% %%%%%%%%%%%%%%%% MOTUS DATA%%%%%%%%%%%%%%%%%%%%%%%%%%
t_Motus=datetime(data5.MOTUSORI(Seuil_bas:Seuil_haut,6)./1000,'ConvertFrom','posixtime','TicksPerSecond',1e9,'Format','dd-MMM-yyyy HH:mm:ss.SSSSSSSSS');

figm=figure('Name','ROLL PITCH HEADING BOREAL MOTUS SPATIAL');

subplot(3,1,1)
plot(t_Motus,data5.MOTUSORI(Seuil_bas:Seuil_haut,2)); hold on;
% plot(t_Motus,filloutliers(data5.MOTUSORI(Seuil_bas:Seuil_haut,2),'previous')); hold on;
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,14));hold on;
plot(t_100Hz_3004, Resampled_ADnav_25hzto100(:,16)); hold on;
xlabel('Time');
ylabel('Roll (degrees)');
legend('MOTUS lin','BOREAL','SPATIAL')
% legend('MOTUS','BOREAL','SPATIAL')

subplot(3,1,2)
plot(t_Motus,data5.MOTUSORI(Seuil_bas:Seuil_haut,3)); hold on;
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,15));hold on;
plot(t_100Hz_3004, Resampled_ADnav_25hzto100(:,17)); hold on;
legend('MOTUS','BOREAL','SPATIAL')
xlabel('Time');
ylabel('Pitch(degrees)');

subplot(3,1,3)
plot(t_Motus,data5.MOTUSORI(Seuil_bas:Seuil_haut,4)); hold on;
% plot(t_Motus,filloutliers(data5.MOTUSORI(Seuil_bas:Seuil_haut,4),'previous')); hold on;
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,13));hold on;
plot(t_100Hz_3004, Resampled_ADnav_25hzto100(:,18)); hold on;
xlabel('Time');
ylabel('Heading (degrees)');
legend('MOTUS lin','BOREAL','SPATIAL')
% legend('MOTUS','BOREAL','SPATIAL')
allaxes=findobj(figm,'type','axes','tag', '')
linkaxes(allaxes,'x')

figure('Name','Static pressure measured by "Boreal" versus "HCEM pressure sensor"')
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,20)./100)
hold on; plot(t_100Hz_3004,p_Stat2)
xlabel('Time elapsed since take off')
ylabel('Baro')
legend('Boreal','HCEM')
% Vg_East2=sind(Psi2).*log_vol5(Seuil_bas_log:Seuil_haut_log,12)./3.6;
% Vg_North2=cosd(Psi2).*log_vol5(Seuil_bas_log:Seuil_haut_log,12)./3.6;
P0=1015;%mbar According to Campistrous data

%H_p_Stat2=-R*(T_pt100+273.15)/9.81.*log(p_Stat2/P0);
H_p_Stat2=[1-(p_Stat2/P0).^(0.0065*R/9.81)].*(T_pt100+273.15)/0.0065;
% H_p_Stat2=[(p_Stat2/P0).^(1/5.257)-1].*(T_pt100+273.15)/0.0065;

Pstat_interp=interp1(t1(Seuil_bas_log:Seuil_haut_log,1),log_vol5(Seuil_bas_log:Seuil_haut_log,20),time_100Hz);
%Pstat_interp=fillmissing(Pstat_interp,'linear');
H_p_Stat_boreal=[1-((Pstat_interp)/100/P0).^(0.0065*R/9.81)].*(T_pt100+273.15)/0.0065;
%H_p_Stat_boreal=[1-((Pstat_interp-500)/100/P0).^(0.0065*R/9.81)].*(T_pt100+273.15)/0.0065;

% h_boreal_interp=interp1(t1(Seuil_bas_log:Seuil_haut_log,1),log_vol5(Seuil_bas_log:Seuil_haut_log,11),time_100Hz);
% h_boreal_interp=fillmissing(h_boreal_interp,'linear');
% P_h_boreal=P0*exp(-9.81/R*h_boreal_interp./(T_pt100+273.15));%mbar


figure('Name','Static pressure and ALtitude measured by "Boreal" versus "HCEM pressure sensor"')
subplot(2,1,1)
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,20)./100)
hold on; plot(t_100Hz_3004,p_Stat2)
%hold on; plot(t_100Hz_3004,P_h_boreal)
xlabel('Time elapsed since take off')
ylabel('Baro')
legend('Boreal','HCEM')
subplot(2,1,2)
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,11))
hold on; plot(t_100Hz_3004,Resampled_ADnav_25hzto100(:,8))
hold on; plot(t_100Hz_3004,H_p_Stat2)
hold on; plot(t_100Hz_3004,H_p_Stat_boreal)
xlabel('Time elapsed since take off')
ylabel('Altitude')
legend('Boreal','Spatial','Altitude form HCEM','Altitude from static pressure boreal')
%legend('Boreal','Spatial')


figure('Name','Static pressure measured by "Boreal" and filtred by lowpass filter')
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,20)./100)
hold on; plot(t_100Hz_3004,p_Stat2)
xlabel('Time elapsed since take off')
ylabel('Baro')
legend('Boreal','HCEM')

d = designfilt('lowpassiir','FilterOrder',1 ,'PassbandFrequency', 0.002); 
%d = designfilt('lowpassiir','FilterOrder',1 ,'PassbandFrequency', 0.2,'SampleRate',100); 
y = filtfilt(d,p_Stat2);
%y=lowpass(p_Stat2,0.001,100);
figure('Name','Pressure (hcem) filtered')
plot(p_Stat2)
hold on;plot(y) 
legend('Before filter','Filtered')


%% WIND SPEED POST PROCESSING USING SBG DATA and after RESAMPLING DATA %%%%%%%%%%%

% Ground speed from latitude and longitude%%%

lat=log_vol5(Seuil_bas_log:Seuil_haut_log,10).*pi/180; %in radians
diff_lat = diff(lat); 


long=log_vol5(Seuil_bas_log:Seuil_haut_log,9).*pi/180; %in radians
diff_long = diff(long);

diff_time =diff(t1(Seuil_bas_log:Seuil_haut_log,1)); 

time=t1(Seuil_bas_log:Seuil_haut_log,1);
% time=(t1(Seuil_bas_log:Seuil_haut_log,1)-t1(Seuil_bas_log,1));

%% %% Ground speed componenets %%%%%%%
t_time=timeofday(t);

t_date=datetime(log_vol5(:,2),log_vol5(:,3),log_vol5(:,4));
t_date=sprintf('%s',t_date(1));

Time_range=sprintf('(On %s from %s to %s)',t_date,t_time(Seuil_bas_log),t_time(Seuil_haut_log))


figure('Name','Cap et heading')
plot(t(Seuil_bas_log:Seuil_haut_log,1),log_vol5(Seuil_bas_log:Seuil_haut_log,13));
hold on;
plot(t(Seuil_bas_log:Seuil_haut_log,1),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360));
legend('Course angle','Heading angle') %% terminology according ti the label : Course angle= cap and heading= lacet.
xlabel({'Time since take off (s)',Time_range}) 

Course_angle=log_vol5(Seuil_bas_log:Seuil_haut_log,13);

GS_east=sind(Course_angle).*log_vol5(Seuil_bas_log:Seuil_haut_log,12)./3.6; % in m/s
GS_north=cosd(Course_angle).*log_vol5(Seuil_bas_log:Seuil_haut_log,12)./3.6; % in m/s
GS_z=diff(log_vol5(Seuil_bas_log:Seuil_haut_log,11))./diff_time;
d = designfilt('lowpassiir','FilterOrder',1 ,'PassbandFrequency', 0.002); 
GS_z_filtre = filtfilt(d,GS_z);
GS_z_outliers=filloutliers(GS_z,'pchip','mean');


% GS_z2=-(diff(p_Stat2)*100./diff(Resampled_ADnav_25hzto100(:,27)/1000))./(rho(2:end).*9.81);
% d = designfilt('lowpassiir','FilterOrder',1 ,'PassbandFrequency', 1,'SampleRate',100); 
% y = filtfilt(d,GS_z2);
% figure('Name','GZ pression apres filtre')
% plot(t_100Hz_3004(2:end),GS_z2)
% hold on; plot(t_100Hz_3004(2:end),y)
% legend('Original','filtre')
GS_z2=-(diff(y)*100./diff(Resampled_ADnav_25hzto100(:,27)/1000))./(rho(2:end).*9.81);
% time_pressure=(Resampled_ADnav_25hzto100(2:end,27)-Resampled_ADnav_25hzto100(1,27))./10^3;
% time_pressure=datetime(Resampled_ADnav_25hzto100(2:end,27)./1000,'ConvertFrom','posixtime','TicksPerSecond',1e9,'Format','dd-MMM-yyyy HH:mm:ss.SSSSSSSSS');

figure('Name','Gz altitude GZ pression')
plot(t_100Hz_3004(2:end),GS_z2)
hold on; plot(t(Seuil_bas_log+1:Seuil_haut_log,1),GS_z)
hold on; plot(t(Seuil_bas_log+1:Seuil_haut_log,1),GS_z_outliers)
%hold on; plot(t_100Hz_3004,Vg_Down)
%legend('G_z','G_z (pressure)','G_z spatial')
legend('G_z (pressure)','G_z','GS_z_outliers')
xlabel({'Time since take off (s)',Time_range}) 

figure('Name','Ground speed components from BOREAL IMU')
plot(t(Seuil_bas_log:Seuil_haut_log,1),GS_east);
hold on;
plot(t(Seuil_bas_log:Seuil_haut_log,1),GS_north);
hold on;
plot(t(Seuil_bas_log+1:Seuil_haut_log,1),GS_z);
legend('East ground speed','North ground speed') %% terminology according ti the label : Course angle= cap and heading= lacet.
xlabel({'Time since take off (s)',Time_range}) 

GS_north_resampled=resample(GS_north,time,100,1,1); % in m/s
GS_z_resampled=resample(GS_z,time(2:end),100,1,1); % in m/s
GS_east_resampled=resample(GS_east,time,100,1,1); % in m/s
time_resampled=resample(t1(Seuil_bas_log:Seuil_haut_log,1),t1(Seuil_bas_log:Seuil_haut_log,1),100,1,1); 
time_resampled_date=datetime(time_resampled,'ConvertFrom','posixtime','TicksPerSecond',1e9,'Format','dd-MMM-yyyy HH:mm:ss.SSSSSSSSS');

Course_cos_resampled=resample(cosd(Course_angle),time,100,1,1);
Course_cos_interp=interp1(time_resampled,Course_cos_resampled,time_100Hz);
%Course_cos_interp=fillmissing(Course_cos_interp,'linear');
Course_sin_resampled=resample(sind(Course_angle),time,100,1,1);
Course_sin_interp=interp1(time_resampled,Course_sin_resampled,time_100Hz);
%Course_sin_interp=fillmissing(Course_sin_interp,'linear');
Course_angle_interp=mod(atan2d(Course_sin_interp,Course_cos_interp),360);

Altitude_interp100Hz=interp1(time,log_vol5(Seuil_bas_log:Seuil_haut_log,11),time_100Hz); % in m/s

Altitude_resampled=resample(log_vol5(Seuil_bas_log:Seuil_haut_log,11),time,100,1,1);
Altitude_interp1=interp1(time_resampled,Altitude_resampled,time_100Hz);
%Altitude_interp=fillmissing(Altitude_interp1,'linear');
save('Altitude_interp1.mat','Altitude_interp1')

GS_north_interp100Hz=interp1(time_resampled,GS_north_resampled,time_100Hz); % in m/s
%GS_north_interp100Hz=fillmissing(GS_north_interp100Hz,'linear');

GS_z_interp100Hz=interp1(time_resampled(21:end),GS_z_resampled,time_100Hz); % in m/s
%GS_z_interp100Hz=fillmissing(GS_z_interp100Hz,'linear');

GS_east_interp100Hz=interp1(time_resampled,GS_east_resampled,time_100Hz); % in m/s
%GS_east_interp100Hz=fillmissing(GS_east_interp100Hz,'linear');


fg=figure('Name','Ground speed after and befor resampling')
subplot(3,1,1)
plot(t(Seuil_bas_log:Seuil_haut_log,1),GS_east,'k'); hold on ; plot(time_resampled_date,GS_east_resampled,'r')
legend('East GS non Resampled','East GS Resampled')
xlabel('Time')
ylabel('East Ground speed m/s')
subplot(3,1,2)
plot(t(Seuil_bas_log:Seuil_haut_log,1),GS_north,'k');hold on; plot(time_resampled_date,GS_north_resampled,'g');
xlabel('Time')
ylabel('North Ground speed m/s')
legend('North non GS Resampled','North GS Resampled')
subplot(3,1,3)
plot(t(Seuil_bas_log+1:Seuil_haut_log,1),GS_z,'k');hold on; plot(time_resampled_date(21:end),GS_z_resampled,'b');
xlabel('Time')
ylabel('Vertical Ground speed m/s')
legend('Vertical non GS Resampled','Vertical GS Resampled','Vertical GS Resampled and interpolated')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')

figure('Name','Altitude after and befor resampling')
plot(t(Seuil_bas_log:Seuil_haut_log,1),log_vol5(Seuil_bas_log:Seuil_haut_log,11),'k'); hold on ; plot(t_100Hz_3004,Altitude_interp100Hz,'r')
 hold on ; plot(t_100Hz_3004,Altitude_interp1,'b')
legend('Original','Interpolated','Resampled')
xlabel('Time')
ylabel('Altitude m')

%% Wind speed using BOREAL GROUND SPEED YAW PITCH AND ROLL
Roll_resampled_cos=resample(cosd(log_vol5(Seuil_bas_log:Seuil_haut_log,14)),time,100,1,1); % in m/s
Roll_resampled_sin=resample(sind(log_vol5(Seuil_bas_log:Seuil_haut_log,14)),time,100,1,1); % in m/s
Roll_resampled=atan2d(Roll_resampled_sin,Roll_resampled_cos);

Pitch_resampled_cos=resample(cosd(log_vol5(Seuil_bas_log:Seuil_haut_log,15)),time,100,1,1); % in m/s
Pitch_resampled_sin=resample(sind(log_vol5(Seuil_bas_log:Seuil_haut_log,15)),time,100,1,1); % in m/s
Pitch_resampled=atan2d(Pitch_resampled_sin,Pitch_resampled_cos);

Heading_boreal=log_vol5(Seuil_bas_log:Seuil_haut_log,16);
Heading_resampled_cos=resample(cosd(Heading_boreal),time,100,1,1); % in m/s
Heading_resampled_sin=resample(sind(Heading_boreal),time,100,1,1); % in m/s
Heading_resampled=mod(atan2d(Heading_resampled_sin,Heading_resampled_cos),360);


time_adv=(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,26)-data5.AD_NAVIGATION(Seuil_bas,26))./1000;
%% % %  Interpolation of euler angles from SBG (Boreal) to time_adv   %%%%%%%%%%%%%%%
t2=datetime(Resampled_ADnav_25hzto100(:,26)./1000, 'ConvertFrom', 'posixtime');

t_time_ADV=timeofday(t2);
% t3=datetime(round(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,26)),'ConvertFrom','epochtime',"TicksPerSecond",1000) %Method 2 which is similar to t2

Time_range1=sprintf('(On %s from %s to %s)',t_date,t_time_ADV(1),t_time_ADV(end));

figure('Name','Cap et heading')
plot(t(Seuil_bas_log:Seuil_haut_log,1),log_vol5(Seuil_bas_log:Seuil_haut_log,13));
hold on;
plot(t(Seuil_bas_log:Seuil_haut_log,1),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360));
legend('Course angle','Heading angle') %% terminology according ti the label : Course angle= cap and heading= lacet.
xlabel({'Time since take off (s)',Time_range}) 

% Roll_interp = interp1(time,log_vol5(Seuil_bas_log:Seuil_haut_log,14),time_100Hz);
% Pitch_interp = interp1(time,log_vol5(Seuil_bas_log:Seuil_haut_log,15),time_100Hz);
% Heading_interp = interp1(time,mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360),time_100Hz);

Pitch_interp_sin = interp1(time_resampled,Pitch_resampled_sin,time_100Hz);
%Pitch_interp_sin = fillmissing(Pitch_interp_sin,'linear');
Pitch_interp_cos = interp1(time_resampled,Pitch_resampled_cos,time_100Hz);
%Pitch_interp_cos = fillmissing(Pitch_interp_cos,'linear');
Pitch_interp=atan2d(Pitch_interp_sin,Pitch_interp_cos);

Roll_interp_sin = interp1(time_resampled,Roll_resampled_sin,time_100Hz);
%Roll_interp_sin = fillmissing(Roll_interp_sin,'linear');
Roll_interp_cos = interp1(time_resampled,Roll_resampled_cos,time_100Hz);
%Roll_interp_cos = fillmissing(Roll_interp_cos,'linear');
Roll_interp=atan2d(Roll_interp_sin,Roll_interp_cos);

Heading_interp_sin = interp1(time_resampled,Heading_resampled_sin,time_100Hz);
%Heading_interp_sin = fillmissing(Heading_interp_sin,'linear');
Heading_interp_cos = interp1(time_resampled,Heading_resampled_cos,time_100Hz);
%Heading_interp_cos = fillmissing(Heading_interp_cos,'linear');
Heading_interp = mod(atan2d(Heading_interp_sin,Heading_interp_cos),360);
% Heading_interp =fillmissing(Heading_interp,'linear');

figure('Name','Heading angle after resampling and after interpolation')
plot(t(Seuil_bas_log:Seuil_haut_log,1),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360),'k')
hold on; plot(time_resampled_date,Heading_resampled,'b');
hold on; plot(t_100Hz_3004,Heading_interp,'g')
xlabel('Time')
ylabel('Heading angle ')
legend('Heading non Resampled','Heading Resampled','Heading interpolated')

fg=figure('Name','EULER angles after resampling')
subplot(3,1,1)
plot(t(Seuil_bas_log:Seuil_haut_log,1),log_vol5(Seuil_bas_log:Seuil_haut_log,14),'k');
hold on ; plot(time_resampled_date,Roll_resampled,'b')
hold on; plot(t_100Hz_3004,Roll_interp,'g')
legend('Roll non Resampled','Roll resampled','Roll interpolated')
xlabel('Time')
ylabel('Roll angle')
subplot(3,1,2)
plot(t(Seuil_bas_log:Seuil_haut_log,1),log_vol5(Seuil_bas_log:Seuil_haut_log,15),'k');
hold on; plot(time_resampled_date,Pitch_resampled,'b');
hold on; plot(t_100Hz_3004,Pitch_interp,'g')
legend('Pitch non Resampled','Pitch Resampled','Pitch interpolated')
xlabel('Time')
ylabel('Pitch angle')
subplot(3,1,3)
plot(t(Seuil_bas_log:Seuil_haut_log,1),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360),'k')
hold on; plot(time_resampled_date,Heading_resampled,'b');
hold on; plot(t_100Hz_3004,Heading_interp,'g')
xlabel('Time')
ylabel('Heading angle ')
legend('Heading non Resampled','Heading Resampled','Heading interpolated')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')
 
fig=figure('Name','Euler angles after interpolation')
subplot(3,1,1)
plot(t(Seuil_bas_log:Seuil_haut_log,1),log_vol5(Seuil_bas_log:Seuil_haut_log,14),'k')
hold on; plot(t_100Hz_3004,Roll_interp,'b')
legend('Roll non interp','Roll interp')
subplot(3,1,2)
plot(t(Seuil_bas_log:Seuil_haut_log,1),log_vol5(Seuil_bas_log:Seuil_haut_log,15),'k')
hold on; plot(t_100Hz_3004,Pitch_interp,'r')
legend('Pitch non interp','Pitch interp')
subplot(3,1,3)
plot(t(Seuil_bas_log:Seuil_haut_log,1),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360),'k')
hold on; plot(t_100Hz_3004,Heading_interp,'g')
legend('Heading non interp','Heading interp')
allaxes=findobj(fig,'type','axes','tag', '')
linkaxes(allaxes,'x')
 

Theta_SBG=Pitch_interp ;
Phi_SBG=Roll_interp ;
Psi_SBG=Heading_interp ;

save('Theta_SBG.mat','Theta_SBG');
save('Phi_SBG.mat','Phi_SBG');
save('Psi_SBG.mat','Psi_SBG');

lat_resampled_cos=resample(cosd(log_vol5(Seuil_bas_log:Seuil_haut_log,10)),time,100,1,1); % in m/s
lat_resampled_sin=resample(sind(log_vol5(Seuil_bas_log:Seuil_haut_log,10)),time,100,1,1); % in m/s
lat_resampled=atan2d(lat_resampled_sin,lat_resampled_cos);
lat_interp_sin = interp1(time_resampled,lat_resampled_sin,time_100Hz);
lat_interp_cos = interp1(time_resampled,lat_resampled_cos,time_100Hz);
lat_interp=atan2d(lat_interp_sin,lat_interp_cos);
save('lat_interp.mat','lat_interp')

long_resampled_cos=resample(cosd(log_vol5(Seuil_bas_log:Seuil_haut_log,9)),time,100,1,1); % in m/s
long_resampled_sin=resample(sind(log_vol5(Seuil_bas_log:Seuil_haut_log,9)),time,100,1,1); % in m/s
long_resampled=atan2d(long_resampled_sin,long_resampled_cos);
long_interp_sin = interp1(time_resampled,long_resampled_sin,time_100Hz);
long_interp_cos = interp1(time_resampled,long_resampled_cos,time_100Hz);
long_interp=atan2d(long_interp_sin,long_interp_cos);
save('long_interp.mat','long_interp')

height_resampled=resample(log_vol5(Seuil_bas_log:Seuil_haut_log,11),time,100,1,1); % in m/s
height_interp = interp1(time_resampled,height_resampled,time_100Hz);

figure('Name','Longitude SBG')
plot(t1(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,9))
hold on;plot(time_100Hz,long_interp)
hold on; plot(time_resampled,long_resampled)
legend('original','Interpolated','resampled')

figure('Name','Latitude SBG')
plot(t1(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,10))
hold on;plot(time_100Hz,lat_interp)
hold on; plot(time_resampled,lat_resampled)
legend('original','Interpolated','resampled')


fg=figure('Name','Ground speed (Comparison SPATIAL and SBG IMU)')
subplot(3,1,1)
plot(t_100Hz_3004,Vg_East); hold on; plot(time_resampled_date,GS_east_resampled,'r')
legend('Spatial','SBG')
xlabel('Time')
ylabel('East Ground speed m/s')
subplot(3,1,2)
plot(t_100Hz_3004,Vg_North);hold on; plot(time_resampled_date,GS_north_resampled,'r');
xlabel('Time')
ylabel('North Ground speed m/s')
legend('Spatial','SBG')
subplot(3,1,3)
plot(t_100Hz_3004,-Vg_Down); hold on; plot(time_resampled_date(21:end),GS_z_resampled,'r');
xlabel('Time')
ylabel('Vertical Ground speed m/s')
legend('Spatial','SBG')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')


figure('Name','2D pattern')
X = log_vol5(:,9);%longitude
Y = log_vol5(:,10);%latitude
plot(X,Y);hold on;
plot(long_interp,lat_interp,'r')
legend('Original','Resampled')
xlabel('Longitude (degrees)');
ylabel('Latitude (degrees)');
title('2D flight path');


fg=figure('Name','Comparaison Attitude angles SBG et SPATIAL')
subplot(3,1,1)
plot(t_100Hz_3004,Theta_SBG);hold on;
plot(t_100Hz_3004,Theta);ylabel('Pitch angle')
legend('SBG IMU','Spatial IMU')
subplot(3,1,2)
plot(t_100Hz_3004,Phi_SBG);hold on
plot(t_100Hz_3004,Phi)
ylabel('roll angle')
subplot(3,1,3)
plot(t_100Hz_3004,Psi_SBG);hold on; plot(t_100Hz_3004,Psi);ylabel('Heading angle')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')


fg=figure('Name','Attitude angles and attack and sideslip')
subplot(3,2,1)
plot(t_100Hz_3004,Theta_SBG)
ylabel('Pitch')
subplot(3,2,3)
plot(t_100Hz_3004,Phi_SBG)
ylabel('Roll')
subplot(3,2,5)
plot(t_100Hz_3004,Psi_SBG)
ylabel('Heading')
subplot(3,2,2)
plot(t_100Hz_3004,Alpha)
ylabel('Alpha')
subplot(3,2,4)
plot(t_100Hz_3004,Beta)
ylabel('Beta')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')


save('GS_east_interp100Hz.mat','GS_east_interp100Hz');
save('GS_north_interp100Hz.mat','GS_north_interp100Hz');
save('GS_z_interp100Hz.mat','GS_z_interp100Hz');
save('GS_z2.mat','GS_z2');


D = ( 1 + (tand(Alpha)).^2 + (tand(Beta)).^2).^0.5;

Etape1_SBG=sind(Psi_SBG).*cosd(Theta_SBG);
Etape2_SBG=tand(Beta).*(cosd(Psi_SBG).*cosd(Phi_SBG) + sind(Psi_SBG).*sind(Theta_SBG).*sind(Phi_SBG));
Etape3_SBG=tand(Alpha).*(sind(Psi_SBG).*sind(Theta_SBG).*cosd(Phi_SBG) - cosd(Psi_SBG).*sind(Phi_SBG));
WindSpeed_East_SBG=(-1./D).*AirSpeed_5hole.*(Etape1_SBG+Etape2_SBG + Etape3_SBG)+ GS_east_interp100Hz;
%WindSpeed_East_SBG_fit=filloutliers(WindSpeed_East_SBG,'nearest','mean');
%WindSpeed_East_SBG_fit=filloutliers(WindSpeed_East_SBG_fit,'linear');

Etape4_SBG=cosd(Psi_SBG).*cosd(Theta_SBG);
Etape5_SBG=tand(Beta).*(sind(Psi_SBG).*cosd(Phi_SBG)-cosd(Psi_SBG).*sind(Theta_SBG).*sind(Phi_SBG));
Etape6_SBG=tand(Alpha).*(cosd(Psi_SBG).*sind(Theta_SBG).*cosd(Phi_SBG) + sind(Psi_SBG).*sind(Phi_SBG));
WindSpeed_North_SBG=(-1./D).*AirSpeed_5hole.*(Etape4_SBG-Etape5_SBG + Etape6_SBG)+GS_north_interp100Hz;
%WindSpeed_North_SBG_fit=filloutliers(WindSpeed_North_SBG_fit,'linear');


Horizontal_windSpeed_SBG= sqrt(WindSpeed_East_SBG.^2+WindSpeed_North_SBG.^2);
%Horizontal_windSpeed_SBG_fit=sqrt(WindSpeed_East_SBG_fit.^2+WindSpeed_North_SBG_fit.^2);

WD_SBG=mod(atan2d(-WindSpeed_East_SBG,-WindSpeed_North_SBG),360);

Etape7_SBG=sind(Theta_SBG)-tand(Beta).*cosd(Theta_SBG).*sind(Phi_SBG)-tand(Alpha).*cosd(Theta_SBG).*cosd(Phi_SBG);
Vertical_WS2=(-1./D(2:end)).*AirSpeed_5hole(2:end).*(Etape7_SBG(2:end))+GS_z2;%Vitesse vent verticale en utilisant la vitesse sol dérivée de la pression
Vertical_WS=(-1./D).*AirSpeed_5hole.*(Etape7_SBG)+GS_z_interp100Hz; %Vitesse vent verticale en utilisant la vitesse sol dérivée de l'altitude

save('WindSpeed_East_SBG.mat','WindSpeed_East_SBG');
save('WindSpeed_North_SBG.mat','WindSpeed_North_SBG');
save('Horizontal_windSpeed_SBG.mat','Horizontal_windSpeed_SBG');
save('WD_SBG.mat','WD_SBG');
save('Vertical_WS2.mat','Vertical_WS2');
save('Vertical_WS.mat','Vertical_WS');

fg=figure('Name','Comparisons')
subplot(5,2,1)
plot(t_100Hz_3004,Etape1_SBG)
ylabel('eq1')
subplot(5,2,3)
plot(t_100Hz_3004,Etape2_SBG)
ylabel('eq2')
subplot(5,2,5)
plot(t_100Hz_3004,Etape3_SBG)
ylabel('eq3')
subplot(5,2,7)
plot(t_100Hz_3004,GS_east_interp100Hz)
ylabel('East Ground speed')
subplot(5,2,9)
plot(t_100Hz_3004,Alpha)
ylabel('Attack angle')
subplot(5,2,2)
plot(t_100Hz_3004,Psi_SBG)
ylabel('Heading')
subplot(5,2,4)
plot(t_100Hz_3004,Theta_SBG)
ylabel('Pitch')
subplot(5,2,6)
plot(t_100Hz_3004,Phi_SBG)
ylabel('Roll')
subplot(5,2,8)
plot(t_100Hz_3004,AirSpeed_5hole)
ylabel('Airspeed')
subplot(5,2,10)
plot(t_100Hz_3004,WindSpeed_East_SBG)
ylabel('East wind speed SBG')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')

fg=figure('Name','Comparisons etape 1')
subplot(4,1,1)
plot(t_100Hz_3004,Etape1_SBG)
ylabel('eq1')
subplot(4,1,2)
plot(t_100Hz_3004,sind(Psi_SBG))
ylabel('Sin psi')
subplot(4,1,3)
plot(t_100Hz_3004,cosd(Theta_SBG))
ylabel('cos theta')
subplot(4,1,4)
plot(t(Seuil_bas_log:Seuil_haut_log,1),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360),'k')
hold on;plot(t_100Hz_3004,Psi_SBG)
ylabel('Heading')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')
% fig1=figure('Name','Wind speed components')
% subplot(3,1,1)
% plot(t_100Hz_3004,WindSpeed_East_SBG); hold on
% plot(t_100Hz_3004,WindSpeed_East)
% legend('with boreal','with spatial')
% ylabel('East wind speed in m/s')
% subplot(3,1,2)
% plot(t_100Hz_3004,WindSpeed_North_SBG); hold on
% plot(t_100Hz_3004,WindSpeed_North);
% ylabel('North wind speed (m/s)')
% legend('with IMU boreal','with spatial')
% subplot(3,1,3)
% plot(t_100Hz_3004,Psi_SBG); hold on
% ylabel('Heading Boreal (degrees)')
% xlabel({'Time since take off (s)',Time_range1}) 
% allaxes=findobj(fig1,'type','axes','tag', '')
% linkaxes(allaxes,'x')

fig1=figure('Name','Wind speed components')
subplot(3,1,1)
plot(t_100Hz_3004,WindSpeed_East_SBG); hold on
legend('With Boreal IMU')
ylabel('East wind speed in m/s')
subplot(3,1,2)
plot(t_100Hz_3004,WindSpeed_North_SBG); hold on
ylabel('North wind speed (m/s)')
legend('With Boreal IMU')
subplot(3,1,3)
plot(t_100Hz_3004,Psi_SBG); hold on
ylabel('Heading Boreal (degrees)')
xlabel({'Time since take off (s)',Time_range1}) 
allaxes=findobj(fig1,'type','axes','tag', '')
linkaxes(allaxes,'x')

% fig2=figure('Name','Horizontal wind speed')
% subplot(3,1,1)
% plot(t_100Hz_3004,Horizontal_windSpeed_SBG); hold on
% plot(t_100Hz_3004,filloutliers(Horizontal_windSpeed_SBG,'nearest','mean')); hold on
% plot(t_100Hz_3004,Horizontal_windSpeed_SBG_fit)
% plot(t_100Hz_3004,Horizontal_windSpeed)
% legend('with boreal','with filloutliers','with filloutliers on wind speed componenets','with spatial')
% ylabel('Wind speed in m/s')
% subplot(3,1,2)
% plot(t_100Hz_3004,WD_SBG); hold on
% plot(t_100Hz_3004,WD);
% ylabel('Heading Boreal (degrees)')
% legend('with IMU boreal','with spatial')
% ylabel('WD_SBG in degrees')
% xlabel({'Time since take off (s)',Time_range1})
% subplot(3,1,3)
% plot(t_100Hz_3004,Psi_SBG); hold on
% ylabel('Heading')
% xlabel({'Time since take off (s)',Time_range1})
% allaxes=findobj(fig2,'type','axes','tag', '')
% linkaxes(allaxes,'x')
% 
% fig2=figure('Name','Horizontal wind speed')
% subplot(5,1,1)
% plot(t_100Hz_3004,Horizontal_windSpeed_SBG); hold on
% %plot(t_100Hz_3004,filloutliers(Horizontal_windSpeed_SBG,'nearest','mean')); hold on
% plot(t_100Hz_3004,Horizontal_windSpeed_SBG_fit)
% legend('with boreal','with filloutliers on wind speed componenets')
% ylabel('Wind speed in m/s')
% subplot(5,1,2)
% plot(t_100Hz_3004,WD_SBG); hold on
% ylabel('Heading Boreal (degrees)')
% legend('with IMU boreal')
% ylabel('WD_SBG in degrees')
% xlabel({'Time since take off (s)',Time_range1})
% subplot(5,1,3)
% plot(t_100Hz_3004,Psi_SBG); hold on
% ylabel('Heading')
% subplot(5,1,4)
% plot(t_100Hz_3004,Phi_SBG); hold on
% ylabel('Roll')
% subplot(5,1,5)
% plot(t_100Hz_3004,Theta_SBG); hold on
% ylabel('Pitch')
% xlabel({'Time since take off (s)',Time_range1})
% allaxes=findobj(fig2,'type','axes','tag', '')
% linkaxes(allaxes,'x')


% 
fig2=figure('Name','Horizontal wind speed')
subplot(3,1,1)
plot(t_100Hz_3004,Horizontal_windSpeed_SBG); hold on
%plot(t_100Hz_3004,filloutliers(Horizontal_windSpeed_SBG,'nearest','mean')); hold on
%plot(t_100Hz_3004,Horizontal_windSpeed_SBG_fit)
ylabel('Wind speed in m/s')
subplot(3,1,2)
plot(t_100Hz_3004,WD_SBG); hold on
ylabel('Heading Boreal (degrees)')
legend('with IMU boreal')
ylabel('WD_SBG in degrees')
xlabel({'Time since take off (s)',Time_range1})
subplot(3,1,3)
plot(t(Seuil_bas_log:Seuil_haut_log,1),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360),'k')
hold on;plot(t_100Hz_3004,Psi_SBG); hold on
ylabel('Heading')
xlabel({'Time since take off (s)',Time_range1})
legend('Original','After resampling')
allaxes=findobj(fig2,'type','axes','tag', '')
linkaxes(allaxes,'x')

fig2=figure('Name','wind speed components, WS, WD, Heading angle')
subplot(5,1,1)
plot(t_100Hz_3004,WindSpeed_East_SBG)
ylabel('East Wind speed in m/s')
subplot(5,1,2)
plot(t_100Hz_3004,WindSpeed_North_SBG)
ylabel('North Wind speed in m/s')
subplot(5,1,3)
plot(t_100Hz_3004,Horizontal_windSpeed_SBG); hold on
%plot(t_100Hz_3004,filloutliers(Horizontal_windSpeed_SBG,'nearest','mean')); hold on
%plot(t_100Hz_3004,Horizontal_windSpeed_SBG_fit)
%legend('with boreal','with filloutliers on wind speed componenets')
ylabel('Wind speed in m/s')
subplot(5,1,4)
plot(t_100Hz_3004,WD_SBG); hold on
ylabel('Heading Boreal (degrees)')
legend('with IMU boreal')
ylabel('WD_SBG in degrees')
xlabel({'Time since take off (s)',Time_range1})
subplot(5,1,5)
plot(t(Seuil_bas_log:Seuil_haut_log,1),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360),'k')
hold on;plot(t_100Hz_3004,Psi_SBG); hold on
ylabel('Heading')
legend('Original data','After resampling')
xlabel({'Time since take off (s)',Time_range1})
allaxes=findobj(fig2,'type','axes','tag', '')
linkaxes(allaxes,'x')

fig2=figure('Name','Wind direction and Euler angles')
subplot(4,1,1)
plot(t_100Hz_3004,WD_SBG); hold on
ylabel('Heading Boreal (degrees)')
legend('with IMU boreal')
ylabel('WD_SBG in degrees')
xlabel({'Time since take off (s)',Time_range1})
subplot(4,1,2)
plot(t(Seuil_bas_log:Seuil_haut_log,1),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360),'k')
hold on;plot(t_100Hz_3004,Psi_SBG); hold on
ylabel('Heading')
legend('Original data','After resampling')
xlabel({'Time since take off (s)',Time_range1})
subplot(4,1,3)
plot(t(Seuil_bas_log:Seuil_haut_log,1),log_vol5(Seuil_bas_log:Seuil_haut_log,14),'k')
hold on;plot(t_100Hz_3004,Phi_SBG); hold on
ylabel('Roll')
legend('Original data','After resampling')
xlabel({'Time since take off (s)',Time_range1})
subplot(4,1,4)
plot(t(Seuil_bas_log:Seuil_haut_log,1),log_vol5(Seuil_bas_log:Seuil_haut_log,15),'k')
hold on;plot(t_100Hz_3004,Theta_SBG); hold on
ylabel('Pitch')
legend('Original data','After resampling')
xlabel({'Time since take off (s)',Time_range1})
allaxes=findobj(fig2,'type','axes','tag', '')
linkaxes(allaxes,'x')

fig3=figure('Name','Vertical wind speed')
subplot(2,1,1)
plot(t_100Hz_3004,Vertical_WS,'k')
hold on;plot(t_100Hz_3004(2:end),Vertical_WS2,'r')
hold on;plot(t_100Hz_3004,Vertical_WS_spatial,'b')
legend('SBG and W_{altitude}','SBG and W_p','W Spatial')
ylabel('Vertical wind speed in m/s')
xlabel('Time elapsed since take off (s)')
subplot(2,1,2)
plot(t_100Hz_3004,Psi_SBG)
ylabel('Heading (degrees)')
xlabel({'Time since take off (s)',Time_range1}) 
allaxes=findobj(fig3,'type','axes','tag', '')
linkaxes(allaxes,'x')
%%
fig2=figure('Name','VN, Sideslip, Sideslip, WD, Heading angle')
subplot(5,1,1)
plot(t_100Hz_3004,WindSpeed_North_SBG)
ylabel('North Wind speed in m/s')
subplot(5,1,2)
plot(t_100Hz_3004,Beta)
ylabel('Sideslipe')
subplot(5,1,3)
plot(t(Seuil_bas_log:Seuil_haut_log),log_vol5(Seuil_bas_log:Seuil_haut_log,11))
ylabel('Altitude (m)')
subplot(5,1,4)
plot(t_100Hz_3004,WD_SBG); hold on
ylabel('WD in degrees')
xlabel({'Time since take off (s)',Time_range1})
subplot(5,1,5)
plot(t(Seuil_bas_log:Seuil_haut_log,1),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360),'k')
hold on;plot(t_100Hz_3004,Psi_SBG); hold on
plot(t_100Hz_3004,Course_angle_interp);
ylabel('Heading')
legend('Original data','After resampling','Course angle after resampling')
xlabel({'Time since take off (s)',Time_range1})
allaxes=findobj(fig2,'type','axes','tag', '')
linkaxes(allaxes,'x')

fig2=figure('Name','Pitch and alpha and HEADING')
subplot(2,1,1)
plot(t_100Hz_3004,Theta_SBG);hold on;
plot(t_100Hz_3004,Alpha)
legend('Pitch angle','AOA')
subplot(2,1,2)
%plot(t(Seuil_bas_log:Seuil_haut_log,1),mod(log_vol5(Seuil_bas_log:Seuil_haut_log,16),360),'k')
hold on;plot(t_100Hz_3004,Psi_SBG); hold on
%plot(t_100Hz_3004,Course_angle_interp);
ylabel('Heading')
allaxes=findobj(fig2,'type','axes','tag', '')
linkaxes(allaxes,'x')

fig2=figure('Name','Pitch and Alpha')
plot(t_100Hz_3004,Theta_SBG);hold on;
plot(t_100Hz_3004,Alpha)
legend('Pitch angle','AOA')

fig2=figure('Name','Pitch and Beta')
plot(t_100Hz_3004,Theta_SBG);hold on;
plot(t_100Hz_3004,Beta)
legend('Pitch angle','AO Sideslip')
% figure('Name','Pitch and alpha')
% plot(Alpha(tranches1(15):tranches1(length(tranches1)-5)),Theta_SBG(tranches1(15):tranches1(length(tranches1)-5)),'.');hold on;
% ylabel('Pitch angle')
% xlabel('AOA')

fig2=figure('Name','Comparison of wind vector ')
subplot(3,1,1)
plot(t_100Hz_3004,Horizontal_windSpeed_SBG); hold on
plot(t_100Hz_3004,Horizontal_windSpeed); hold on
legend('SBG','Spatial')
ylabel('Wind speed in m/s')
subplot(3,1,2)
plot(t_100Hz_3004,WD_SBG); hold on
plot(t_100Hz_3004,WD); hold on
legend('SBG','Spatial')
ylabel('WD_SBG in degrees')
xlabel({'Time since take off (s)',Time_range1})
subplot(3,1,3)
plot(t_100Hz_3004,Psi_SBG); hold on
plot(t_100Hz_3004,Psi);ylabel('Heading angle')
ylabel('Heading')
xlabel({'Time since take off (s)',Time_range1})
legend('SBG','Spatial')
allaxes=findobj(fig2,'type','axes','tag', '')
linkaxes(allaxes,'x')


figure('Name','3D WS SBG')
Y =  lat_interp(1:100:end);
X =  long_interp(1:100:end);
Z =  Horizontal_windSpeed_SBG(1:100:end); % in m/s
C = Horizontal_windSpeed_SBG(1:100:end);
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;Z(:);nan],...
      'CData', [nan;C(:);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp')
hold on;
Y1 =  47.0910862;
X1 =  -1.9242482;
text(X1+0.0005,Y1,'T1')
plot(X1,Y1,'o')
hold on;
Y2 =  47.0896387;
X2 =   -1.9200307;
text(X2+0.0005,Y2,'T2')
plot(X2,Y2,'o')
hold on;
Y3 =  47.0881907;
X3 = -1.9158266;
text(X3+0.0005,Y3,'T3')
plot(X3,Y3,'o')
hold on;
Y4 =  47.0944458;
X4 =  -1.9086843;
text(X4+0.0005,Y4,'T4')
plot(X4,Y4,'o')
hold on;
Y5 =  47.0928155;
X5 =  -1.9057454;
text(X5+0.0005,Y5,'T5')
plot(X5,Y5,'o')
hold on;
Y6 =  47.0911936;
X6 =  -1.9028205;
text(X6+0.0005,Y6,'T6')
plot(X6,Y6,'o')
view([0,0,1])
barre=colorbar;
barre.Label.String = 'WS (using SBG data) (m/s))';
title ('GS');
xlabel('Longitude (degrees) [SBG data]');
ylabel('Latitude  (degrees) [SBG data]');
zlabel('Height agl (m)');

load Tranches1
figure('Name','3D WS SBG')
for i=77:2:(length(Tranches1)-109)
Y =  lat_interp(Tranches1(i):Tranches1(i+1));
X =  long_interp(Tranches1(i):Tranches1(i+1));
Z =  Horizontal_windSpeed_SBG(Tranches1(i):Tranches1(i+1)); % in m/s
C = Horizontal_windSpeed_SBG(Tranches1(i):Tranches1(i+1));
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;Z(:);nan],...
      'CData', [nan;C(:);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp')
hold on;
end
Y1 =  47.0910862;
X1 =  -1.9242482;
text(X1+0.0005,Y1,'T1')
plot(X1,Y1,'o')
hold on;
Y2 =  47.0896387;
X2 =   -1.9200307;
text(X2+0.0005,Y2,'T2')
plot(X2,Y2,'o')
hold on;
Y3 =  47.0881907;
X3 = -1.9158266;
text(X3+0.0005,Y3,'T3')
plot(X3,Y3,'o')
hold on;
Y4 =  47.0944458;
X4 =  -1.9086843;
text(X4+0.0005,Y4,'T4')
plot(X4,Y4,'o')
hold on;
Y5 =  47.0928155;
X5 =  -1.9057454;
text(X5+0.0005,Y5,'T5')
plot(X5,Y5,'o')
hold on;
Y6 =  47.0911936;
X6 =  -1.9028205;
text(X6+0.0005,Y6,'T6')
plot(X6,Y6,'o')
view([0,0,1])
barre=colorbar;
barre.Label.String = 'WS (using SBG data) (m/s))';
title ('GS');
xlabel('Longitude (degrees) [SBG data]');
ylabel('Latitude  (degrees) [SBG data]');
zlabel('Height agl (m)');


