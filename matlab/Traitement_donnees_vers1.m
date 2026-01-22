%========================================================================%
%  Traitement donnees FL_28072020                                           %
%========================================================================%
% clear
load Vol2momenta.mat
%load('log_FL2_lannemezan.mat')
%========================================================================%
% Constante Physique                                                     %
%========================================================================%
R = 8.3144598;      %gas constant [m^3PaK^-1mol^-1]
m = 0.02897;        %mass if 1 mol of air 
R = R/m;            %air constant[J/kgK]

alpha_k_offset = [0.083 ];  % Conversion Angle Pression verticale
beta_k_offset = [0.086 ];  % Conversion Angle Pression Horzontale
%==========================================================================%
% Seuil haut / bas                                                         %
%==========================================================================%
Seuil_bas=3;
Seuil_haut=38300 ;
%==========================================================================%

seuilbas_p=21;
seuilhaut_p=3829980;
% col=[1:27];
% [Ressample_Pressures,temps]=resample(data.Pressures(seuilbas_p:seuilhaut_p,col),data.Pressures(seuilbas_p:seuilhaut_p,1),1,1,1,'linear');
% %%%%%%%%%%%%%%%
% p_vert= Ressample_Pressures(:,18); %HCE HAUT-BAS
% p_vert2= Ressample_Pressures(:,19);%HCE HAUT-BAS
% p_vert_LDE= Ressample_Pressures(:,24);%LDE HAUT-BAS
% figure('Name','Pression Haut Bas')
% % plot(data.Pressures(:,[18,19,24]),'DisplayName','data.Pressures(:,[20:21,25])')
% plot((Ressample_Pressures(:,27)-Ressample_Pressures(1,27))./1000,p_vert,(Ressample_Pressures(:,27)-Ressample_Pressures(1,27))./1000,p_vert1,(Ressample_Pressures(:,27)-Ressample_Pressures(1,27))./1000,p_vert_LDE)
% legend('HCE1','HCE2','LDE')
% ylabel('Pressure top and bottom of the five hole probe')
% xlabel('Time in s')

% test_diff_tempsP=diff(data.Pressures(seuilbas_p:seuilhaut_p,27));
% plot(test_diff_tempsP);

% test_diff_temps_AD=diff(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,26));
% plot(test_diff_temps_AD);


p_vert_NR= data.Pressures(seuilbas_p:seuilhaut_p,18); %HCE HAUT-BAS
p_vert2_NR= data.Pressures(seuilbas_p:seuilhaut_p,19);%HCE HAUT-BAS
p_vert_LDE_NR= data.Pressures(seuilbas_p:seuilhaut_p,24);%LDE HAUT-BAS

% p_vert_NR_ws= filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,18),'nearest'); %HCE HAUT-BAS
% p_vert2_NR_ws= filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,19),'nearest');%HCE HAUT-BAS
% p_vert_LDE_NR_ws= filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,24),'nearest');%LDE HAUT-BAS

time_pressure=(data.Pressures(seuilbas_p:seuilhaut_p,27)-data.Pressures(seuilbas_p,27))./10^3;

figure('Name','Pression Haut Bas')
plot(p_vert_NR); hold on
plot(p_vert2_NR); hold on
plot(p_vert_LDE_NR); hold on
% plot(p_vert_NR_ws); hold on
% plot(p_vert2_NR_ws); hold on
% plot(p_vert_LDE_NR_ws)
% plot(data.Pressures(seuilbas_p:seuilhaut_p,27),p_vert_NR_ws); hold on
% plot(data.Pressures(seuilbas_p:seuilhaut_p,27),p_vert2_NR_ws); hold on
% plot(data.Pressures(seuilbas_p:seuilhaut_p,27),p_vert_LDE_NR_ws)
%legend('HCE1','HCE2','LDE','HCE1_{corr}','HCE2_{corr}','LDE_{corr}')
legend('HCE1','HCE2','LDE')
ylabel('Pressure top and bottom of the five hole probe')
%xlabel('Time in s')

% figure('Name','Pression Haut Bas')
% plot(p_vert_NR); hold on
% % plot(p_vert_NR_ws); hold on
% % legend('HCE1','HCE1_{corr}')
% legend('HCE1')
% ylabel('Pressure top and bottom of the five hole probe')
% 
% figure('Name','Pression Haut Bas')
% plot(p_vert2_NR); hold on
% legend('HCE2')
% %plot(p_vert2_NR_ws); hold on
% %legend('HCE2','HCE2_{corr}')
% ylabel('Pressure top and bottom of the five hole probe')
% 
% figure('Name','Pression Haut Bas')
% plot(p_vert_LDE_NR); hold on
% legend('LDE')
% %plot(p_vert_LDE_NR_ws)
% %legend('LDE','LDE_{corr}')
% ylabel('Pressure top and bottom of the five hole probe')

%%%%%%%%%%%%%%

p_centrale_NR=(data.Pressures(seuilbas_p:seuilhaut_p,14)+data.Pressures(seuilbas_p:seuilhaut_p,15))./2; %NR : no ressample
%p_centrale_NR_ws=(filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,14),'nearest')+filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,15),'nearest'))./2;

figure('Name','Central hole dynamic pressure')
plot(data.Pressures(seuilbas_p:seuilhaut_p,14))
hold on; plot(data.Pressures(seuilbas_p:seuilhaut_p,15))
legend('Sensor n°1','Sensor n°2','Sensor n°1 without spikes','Sensor n°2 without spikes')
ylabel('The five-hole probe dynamic pressure (mbar)')
%plot(filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,14),'nearest'))
%hold on; plot(filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,15),'nearest'))
legend('Sensor n°1','Sensor n°2')

% figure('Name','Central hole dynamic pressure')
% plot(p_centrale_NR)
% %hold on; plot(p_centrale_NR_ws,'r')
% ylabel('The five-hole probe dynamic pressure (mbar)')
% %legend('Original data','After removing spikes')

%% %%%%%%%%%%
% p_horiz= Ressample_Pressures(:,20); %HCE GAUCHE-DROITE
% p_horiz1= Ressample_Pressures(:,21);%HCE GAUCHE-DROITE
% p_horiz_LDE= Ressample_Pressures(:,25);%LDE GAUCHE-DROITE
% figure('Name','Pression gauche droite')
% % plot(data.Pressures(:,[20:21,25]),'DisplayName','data.Pressures(:,[20:21,25])')
% plot((Ressample_Pressures(:,27)-Ressample_Pressures(1,27))./1000,p_horiz,(Ressample_Pressures(:,27)-Ressample_Pressures(1,27))./1000,p_horiz1,(Ressample_Pressures(:,27)-Ressample_Pressures(1,27))./1000,p_horiz_LDE)
% legend('HCE1','HCE2','LDE')
% ylabel('Pressure left and rigth of the five hole probe')
% xlabel('Time in s')

p_horiz_NR= data.Pressures(seuilbas_p:seuilhaut_p,20); %HCE GAUCHE-DROITE
p_horiz1_NR= data.Pressures(seuilbas_p:seuilhaut_p,21);%HCE GAUCHE-DROITE
p_horiz_LDE_NR= data.Pressures(seuilbas_p:seuilhaut_p,25);%LDE GAUCHE-DROITE

% p_horiz_NR_ws= filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,20),'nearest','grubbs'); %HCE GAUCHE-DROITE
% p_horiz1_NR_ws= filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,21),'nearest','grubbs');%HCE GAUCHE-DROITE
% p_horiz_LDE_NR_ws= filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,25),'nearest','grubbs');%LDE GAUCHE-DROITE

% figure('Name','Pression gauche droite')
% plot(p_horiz_NR); hold on
% plot(p_horiz1_NR); hold on
% plot(p_horiz_LDE_NR); hold on
% plot(p_horiz_NR_ws); hold on
% plot(p_horiz1_NR_ws); hold on
% plot(p_horiz_LDE_NR_ws)
% legend('HCE1','HCE2','LDE','HCE1_{corr}','HCE2_{corr}','LDE_{corr}')
% ylabel('Pressure left and rigth of the five hole probe')

% figure('Name','Pression gauche droite HCEM1')
% plot(p_horiz_NR); hold on
% %plot(p_horiz_NR_ws); hold on
% legend('HCE1')
% ylabel('Pressure left and rigth of the five hole probe')
% 
% figure('Name','Pression gauche droite HCEM2')
% plot(p_horiz1_NR); hold on
% legend('HCE2')
% ylabel('Pressure left and rigth of the five hole probe')
% 
% figure('Name','Pression gauche droite LDE')
% plot(p_horiz_LDE_NR); hold on
% legend('LDE')
% ylabel('Pressure left and rigth of the five hole probe')

figure('Name','Pression gauche droite')
plot(p_horiz_NR); hold on
plot(p_horiz1_NR); hold on
plot(p_horiz_LDE_NR)
legend('HCE1','HCE2','LDE')
ylabel('Pressure left and rigth of the five hole probe')



%% %%%%%%
% p_Stat1= Ressample_Pressures(:,12); % ne fonctionne pas lors du vol de 28/07/2020
% 
% p_Stat2= Ressample_Pressures(:,13); %Fonctionne lors du vol de 28/07/2020

p_Stat2_NR= data.Pressures(seuilbas_p:seuilhaut_p,13); %Fonctionne lors du vol de 28/07/2020
%p_Stat2_NR_ws= filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,13),'nearest'); %Fonctionne lors du vol de 28/07/2020

figure('Name','Baro pressure')
% plot(data.Pressures(seuilbas_p:seuilhaut_p,27),data.Pressures(seuilbas_p:seuilhaut_p,13))
% plot((data.Pressures(seuilbas_p:seuilhaut_p,27)-data.Pressures(seuilbas_p,27))./1000,data.Pressures(seuilbas_p:seuilhaut_p,13))
%plot(data.Pressures(seuilbas_p:seuilhaut_p,27),p_Stat2_NR)
plot(data.Pressures(seuilbas_p:seuilhaut_p,27),p_Stat2_NR)
ylabel('Baro pressure(mbar)')
xlabel('')

%%%%%%%%%
% p_Pitot= (Ressample_Pressures(:,16)+Ressample_Pressures(:,17))/2;%HCE

p_Pitot_NR=(data.Pressures(seuilbas_p:seuilhaut_p,16)+data.Pressures(seuilbas_p:seuilhaut_p,17))./2; %NR: No ressample
%p_Pitot_NR_ws=(filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,16),'nearest')+filloutliers(data.Pressures(seuilbas_p:seuilhaut_p,17),'nearest'))./2; %NR: No ressample

% figure('Name','Pitot dynamic pressure')
% plot(p_Pitot_NR)
% %hold on; plot(p_Pitot_NR_ws)
% ylabel('Pitot dynamic pressure (mbar)')
% xlabel('')

figure('Name','Pitot and Centrale hole dynamic pressure')
plot(p_Pitot_NR); hold on ; plot(p_centrale_NR)
ylabel('Dynamic pressure (mbar)')
xlabel('')
legend('Pitot','5hole')
% %=========================================================================%
% % Temperature/ Humidite 10 Hz / frequence 10Hz
% %=========================================================================%
%col=[1:5];
% [Ressample_T2,temps]=resample(data.T2(Seuil_bas:Seuil_haut,col),data.T2(Seuil_bas:Seuil_haut,1),1,1,1,'linear');

figure('Name','Temperature')
plot(data.T2(Seuil_bas:Seuil_haut,3)); hold on
legend('Pt100')
%plot(data.T2(Seuil_bas:Seuil_haut,5),data.T2(Seuil_bas:Seuil_haut,3)); hold on
%plot(filloutliers(data.T2(Seuil_bas:Seuil_haut,3),'nearest')); hold on
xlabel('Temperature in degrees (PT100)')


% %=========================================================================%
% % Temperature/ Humidite 2.5 Hz / frequence 2.5Hz
% %=========================================================================%
%col=[1:12];
% [Ressample_TH,temps]=resample(data.TH(Seuil_bas:Seuil_haut,col),data.TH(Seuil_bas:Seuil_haut,1),1,1,1,'linear');

figure('Name','Temperature')
plot(data.TH(Seuil_bas:Seuil_haut,6)); hold on
plot(data.TH(Seuil_bas:Seuil_haut,8));hold on
legend('Temp1','Temp2')
xlabel('Temperature in degrees')

figure('Name','Humidity')
plot(data.TH(Seuil_bas:Seuil_haut,7)); hold on
plot(data.TH(Seuil_bas:Seuil_haut,9));hold on;
legend('Hum1','Hum2')
ylabel('Humidity')
xlabel('Humidity in degrees')
legend('Hum1','Hum2')

figure('Name','Temperature')
plot(data.T2(Seuil_bas:Seuil_haut,3)); hold on
plot(data.TH(Seuil_bas:Seuil_haut,6)); hold on
plot(data.TH(Seuil_bas:Seuil_haut,8))
xlabel('Temperature in degrees ')
legend('PT100','Temp1','Temp2')


%% Calculate AIR SPEED
% T_p100=resample(data.T2(Seuil_bas:Seuil_haut,3),data.T2(Seuil_bas:Seuil_haut,1),1,1,1,'Linear');

T_p100=data.T2(Seuil_bas:Seuil_haut,3);
rho = 100*p_Stat2_NR(1:10:end)./(R*(T_p100+273));  % 100 pour convsersion mb=>pascal et degre kelvin
AirSpeed_5hole= sqrt(abs((200.*p_centrale_NR(1:10:end))./rho)); %Bernoulli eq'n using mbar
AirSpeed_Pitot = sqrt(abs((200.*p_Pitot_NR(1:10:end))./rho));


figure('Name','Airspeed')
plot(AirSpeed_5hole); hold on
plot(AirSpeed_Pitot);
%xlabel('time')
ylabel('airspeed (m/s)')
legend('5hole','Pitot')


% div=10;
% [Matlab_Windfrom,Matlab_Windspeed]=driftvel( Calcul_Route(1:div:end),((ADV_V_Nord(1:div:end).^2+ADV_V_East(1:div:end).^2).^0.5).*1.94384449244,ADV_Heading_degre(1:div:end),(AirSpeed_5hole(1:div:end)).*1.94384449244);
%  Matlab_Windspeed=Matlab_Windspeed/1.94384449244;
% % [Matlab_Windfrom,Matlab_Windspeed]=driftvel( Angle_Route_pixhawk_NKF(1:div:end,2),((NKF1_PixVsOvli(1:div:end,4).^2+NKF1_PixVsOvli(1:div:end,5).^2).^0.5).*1.94384449244,NKF1_PixVsOvli(1:div:end,3),ARSP_PixVsOvli(1:div:end,1).*1.94384449244);
% % Matlab_Windspeed=Matlab_Windspeed/1.94384449244;
% [Matlab_Windfrom1,Matlab_Windspeed1]=driftvel( Calcul_Route(1:end),((ADV_V_Nord(1:end).^2+ADV_V_East(1:end).^2).^0.5).*1.94384449244,ADV_Heading_degre(1:end),(AirSpeed_5hole(1:end)).*1.94384449244);
%  Matlab_Windspeed1=Matlab_Windspeed1/1.94384449244;
%=========================================================================%
%% Calcul anlge Alpha /  Beta sonde 5trous                                 %
%=========================================================================%
% Alpha = -p_vert_LDE_NR_ws(1:10:end) ./( p_centrale_NR_ws(1:10:end)*0.083 );
% Beta =-p_horiz_LDE_NR_ws(1:10:end)./( p_centrale_NR_ws(1:10:end)*0.086);  %

Alpha = -p_vert_LDE_NR(1:10:end) ./( p_centrale_NR(1:10:end)*0.083 );
Beta =-p_horiz_LDE_NR(1:10:end)./( p_centrale_NR(1:10:end)*0.086);  %


figure('Name','Alpha et Beta')
% plot(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,26),Alpha ); hold on
% plot(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,26),Beta);
plot(Alpha ); hold on
plot(Beta);
xlabel('Attack and sideslip angle (degrees)')
legend('Alpha','Beta')

%%
Phi=data.AD_NAVIGATION(Seuil_bas:Seuil_haut,16);
Theta=data.AD_NAVIGATION(Seuil_bas:Seuil_haut,17);
Psi=data.AD_NAVIGATION(Seuil_bas:Seuil_haut,18);

% Phi_ws=atan2d(filloutliers(sind(Phi),'nearest','mean'),filloutliers(cosd(Phi),'nearest','mean'));%ws=without spikes
% Theta_ws=atan2d(filloutliers(sind(Theta),'nearest','mean'),filloutliers(cosd(Theta),'nearest','mean'));%ws=without spikes
% Psi_ws= mod(atan2d(filloutliers(sind(Psi),'nearest','mean'),filloutliers(cosd(Psi),'nearest','mean')),360);%ws=without spikes

%Psi2=filloutliers(data.MOTUSORI(Seuil_bas:Seuil_haut,4),'linear');
% Phi=resample(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,16),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,1),5.060196,1,1,'Linear'); %1000 HZ
% Theta=resample(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,17),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,1),5.060196,1,1,'Linear'); %1000 HZ
% Psi=resample(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,18),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,1),5.060196,1,1,'Linear'); %1000 HZ

fig=figure('Name','Attitude angles')
subplot(3,1,1)
plot(Phi,'b')
ylim([-50,50])
ylabel('Roll angle (degrees)')
subplot(3,1,2)
plot(Theta,'b')
ylim([-50,50])
ylabel('Pitch angle (degrees)')
subplot(3,1,3)
plot(Psi)
ylim([0,400])
ylabel('Heading angle(degrees)')
allaxes=findobj(fig,'type','axes','tag', '')
linkaxes(allaxes,'x')


fig=figure('Name','Attitude angles and sideslip angles')
subplot(4,1,1)
plot(Phi,'b')
ylim([-50,50])
ylabel('Roll angle (degrees)')
subplot(4,1,2)
plot(Theta,'b')
ylim([-50,50])
ylabel('Pitch angle (degrees)')
subplot(4,1,3)
plot(Psi)
ylim([0,400])
ylabel('Heading angle(degrees)')
subplot(4,1,4)
plot(Beta,'r')
ylabel('Sideslip angle (degrees)')
allaxes=findobj(fig,'type','axes','tag', '')
linkaxes(allaxes,'x')
%%  Grouns speed

% Vg_Down=log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,12)
% Vg_East=resample(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,10),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,1),5.060196,1,1,'Linear');
% Vg_North=resample(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,9),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,1),5.060196,1,1,'Linear');
% Vg_Down=resample(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,11),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,1),5.060196,1,1,'Linear');

Vg_East=data.AD_NAVIGATION(Seuil_bas:Seuil_haut,10);
Vg_North=data.AD_NAVIGATION(Seuil_bas:Seuil_haut,9);
Vg_Down=data.AD_NAVIGATION(Seuil_bas:Seuil_haut,11);

% Vg_East_ws=filloutliers(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,10),'nearest','grubbs');
% Vg_North_ws=filloutliers(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,9),'nearest','grubbs');
% Vg_Down_ws=filloutliers(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,11),'nearest','grubbs');

fig=figure('Name','Ground speed and CAP')
subplot(3,1,1)
plot(Vg_East); hold on
plot(Vg_North); hold on
plot(Vg_Down)
legend('East','North','Down')
ylabel('Ground speed in m/s')
% subplot(3,1,2)
% plot(Psi_ws); hold on
ylabel('Heading')
% subplot(3,1,3)
subplot(3,1,2)
plot(sqrt(Vg_East.^2+Vg_North.^2)); 
legend('Horiz ground speed','Down')
ylabel('Ground speed in m/s')
allaxes=findobj(fig,'type','axes','tag', '')
linkaxes(allaxes,'x')

figure('Name','Wind speed ADU')
% plot(sqrt(filloutliers(data.PaquetWind(Seuil_bas:Seuil_haut,2),'previous').^2+filloutliers(data.PaquetWind(Seuil_bas:Seuil_haut,3),'previous').^2));
plot(sqrt(data.PaquetWind(Seuil_bas:Seuil_haut,2).^2+data.PaquetWind(Seuil_bas:Seuil_haut,3).^2));

title('Wind speed of ADU')


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

% Etape1=sind(Psi_ws).*cosd(Theta_ws);
% Etape2=tand(Beta).*(cosd(Psi_ws).*cosd(Phi_ws) + sind(Psi_ws).*sind(Theta_ws).*sind(Phi_ws));
% Etape3=tand(Alpha).*(sind(Psi_ws).*sind(Theta_ws).*cosd(Phi_ws) - cosd(Psi_ws).*sind(Phi_ws));
% WindSpeed_East=(-1./D).*AirSpeed_5hole.*(Etape1+Etape2 + Etape3)+ Vg_East;
% 
% Etape4=cosd(Psi_ws).*cosd(Theta_ws);
% Etape5=tand(Beta).*(sind(Psi_ws).*cosd(Phi_ws)-cosd(Psi_ws).*sind(Theta_ws).*sind(Phi_ws));
% Etape6=tand(Alpha).*(cosd(Psi_ws).*sind(Theta_ws).*cosd(Phi_ws) + sind(Psi_ws).*sind(Phi_ws));
% WindSpeed_North=(-1./D).*AirSpeed_5hole.*(Etape4-Etape5 + Etape6)+Vg_North;
% 
% Horizontal_windSpeed= (WindSpeed_East.^2+WindSpeed_North.^2).^0.5;
% WD=mod(atan2d(-WindSpeed_East,-WindSpeed_North),360);

fig1=figure('Name','Wind speed and direction and heading angle')
subplot(3,1,1)
plot(Horizontal_windSpeed); hold on
ylabel('Wind speed (m/s)')
subplot(3,1,2)
plot(WD); hold on
ylabel('WD in (degrees)')
subplot(3,1,3)
plot(Psi)
ylim([0,400])
ylabel('Heading angle(degrees)')
allaxes=findobj(fig1,'type','axes','tag', '')
linkaxes(allaxes,'x')

figure('Name','Wind speed LENSCHOW versus ADU')
plot(Horizontal_windSpeed); hold on
plot(sqrt(data.PaquetWind(Seuil_bas:Seuil_haut,2).^2+data.PaquetWind(Seuil_bas:Seuil_haut,3).^2));
title('Wind speed of ADU')
legend('Lenschow','ADU')

% Modele simplifie de lenchow
% Calcul_Simplifie_Vent_VitesseEast=(-1).*AirSpeed_5hole.*sind(Psi+Beta)+ADV_V_East;
% Calcul_Simplifie_Vent_VitesseNord=(-1).*AirSpeed_5hole.*cosd(Psi+Beta)+ADV_V_Nord;
% Calcul_Simplifie_Vent_Horizontal=(Calcul_Simplifie_Vent_VitesseEast.^2+Calcul_Simplifie_Vent_VitesseNord.^2).^0.5;
% Calcul_Simplifie_Direction_Vent=mod(atan2d(-1*Calcul_Simplifie_Vent_VitesseEast,-1*Calcul_Simplifie_Vent_VitesseNord),360);
% 
 %% 3D temperature
 
% figure('Name','3D Temperature')
% subplot(2,1,1)
% Y = data.AD_NAVIGATION(Seuil_bas:Seuil_haut,6).*180/pi;
% X = data.AD_NAVIGATION(Seuil_bas:Seuil_haut,7).*180/pi;
% Z = data.AD_NAVIGATION(Seuil_bas:Seuil_haut,8);
% C = T_p100(1:end);
% patch('XData', [nan;X(:);nan],...
%       'YData', [nan;Y(:);nan],...
%       'ZData', [nan;Z(:);nan],...
%       'CData', [nan;C(:);nan],...
%       'FaceColor', 'interp', ...
%       'EdgeColor', 'interp')
% view(3)
% barre=colorbar;
% barre.Label.String = 'Temperature (degrees))';
% title ('Temperature');
% xlabel('Longitude (degrees)');
% ylabel('Latitude  (degrees)');
% zlabel('Height agl (m)');
% 
% subplot(2,1,2)
% Y = data.AD_NAVIGATION(Seuil_bas:Seuil_haut,6).*180/pi;
% X = data.AD_NAVIGATION(Seuil_bas:Seuil_haut,7).*180/pi;
% Z = data.AD_NAVIGATION(Seuil_bas:Seuil_haut,8);
% C = T_p100(1:end);
% patch('XData', [nan;X(:);nan],...
%       'YData', [nan;Y(:);nan],...
%       'ZData', [nan;Z(:);nan],...
%       'CData', [nan;C(:);nan],...
%       'FaceColor', 'interp', ...
%       'EdgeColor', 'interp')
% view([0,0,1])
% barre=colorbar;
% barre.Label.String = 'Temperature (degrees))';
% title ('Temperature');
% xlabel('Longitude (degrees)');
% ylabel('Latitude  (degrees)');
% zlabel('Height agl (m)');
% 
% figure('Name','3D GS')
% subplot(2,1,1)
% Y = data.AD_NAVIGATION(Seuil_bas:Seuil_haut,6).*180/pi;
% X = data.AD_NAVIGATION(Seuil_bas:Seuil_haut,7).*180/pi;
% Z = data.AD_NAVIGATION(Seuil_bas:Seuil_haut,8);
% C = sqrt(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,9).^2+data.AD_NAVIGATION(Seuil_bas:Seuil_haut,10).^2);
% patch('XData', [nan;X(:);nan],...
%       'YData', [nan;Y(:);nan],...
%       'ZData', [nan;Z(:);nan],...
%       'CData', [nan;C(:);nan],...
%       'FaceColor', 'interp', ...
%       'EdgeColor', 'interp')
% view(3)
% barre=colorbar;
% barre.Label.String = 'GS(m/s))';
% title ('GS');
% xlabel('Longitude (degrees)');
% ylabel('Latitude  (degrees)');
% zlabel('Height agl (m)');
% 
% subplot(2,1,2)
% Y = data.AD_NAVIGATION(Seuil_bas:Seuil_haut,6).*180/pi;
% X = data.AD_NAVIGATION(Seuil_bas:Seuil_haut,7).*180/pi;
% Z = data.AD_NAVIGATION(Seuil_bas:Seuil_haut,8);
% C = sqrt(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,9).^2+data.AD_NAVIGATION(Seuil_bas:Seuil_haut,10).^2);
% patch('XData', [nan;X(:);nan],...
%       'YData', [nan;Y(:);nan],...
%       'ZData', [nan;Z(:);nan],...
%       'CData', [nan;C(:);nan],...
%       'FaceColor', 'interp', ...
%       'EdgeColor', 'interp')
% view([0,0,1])
% barre=colorbar;
% barre.Label.String = 'GS (m/s))';
% title ('GS');
% xlabel('Longitude (degrees)');
% ylabel('Latitude  (degrees)');
% zlabel('Height agl (m)');
% 
%log_FL2_lannemezan_label={'T_CPU(s)','Annee','Mois','Jour','Heure','Minutes','Secondes','Secondes décimales','Longitude','Latitude','Altitude AMSL (m)','Vitesse sol (km/h)','Cap (°)','Roulis (°)','Tangage (°)','Lacet (°)','RPM','Distance (m)','Radar (m)','Pbaro(pa)',' Mag'};
% data_mast_label={'Date_jour' 'Date_mois' 'Date_annee'	'Time_heure' 'Time_min' 'Time_sec'	'Direction'	'Temp C'	'Wind1avg m/s'	'Wind1max m/s'	'Wind1std m/s'	'Wind2avg m/s'	'Wind2max m/s'	'Wind2std m/s'	'Batt V'}				


figure('Name', 'Flight Path 2D');
plot(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,6).*180/pi, data.AD_NAVIGATION(Seuil_bas:Seuil_haut,7).*180/pi,'b')
set(gca, 'FontSize', 12)
title('2D Flight Path')
xlabel('Latitude [\circ]')
ylabel('Longitude [\circ]')


%% %%%%%%%%%%%%%%%%%%%%%%%% BOREAL DATA %%%%%%%%%%%%%%%%%%
% 
% fig1=figure('Name','Heading ROLL PITCH Boreal ');
% subplot(3,1,1)
% plot(log_FL2_lannemezan(:,13)); hold on; 
% xlabel('')
% ylabel('Heading(degrees)')
% subplot(3,1,2)
% plot(log_FL2_lannemezan(:,15)); hold on; 
% xlabel('')
% ylabel('Pitch(degrees)')
% subplot(3,1,3)
% plot(log_FL2_lannemezan(:,14)); hold on; 
% xlabel('')
% ylabel('Roll(degrees)')
% allaxes=findobj(fig1,'type','axes','tag', '')
% linkaxes(allaxes,'x')
% 

%% Convert date to UNIX Time %%%%%%%%

% % t = datetime(log_FL2_lannemezan(:,2),log_FL2_lannemezan(:,3),log_FL2_lannemezan(:,4),log_FL2_lannemezan(:,5),log_FL2_lannemezan(:,6),log_FL2_lannemezan(:,7),log_FL2_lannemezan(:,8),'Timezone','Europe/Paris');
% t = datetime(log_FL2_lannemezan(:,2),log_FL2_lannemezan(:,3),log_FL2_lannemezan(:,4),log_FL2_lannemezan(:,5),log_FL2_lannemezan(:,6),log_FL2_lannemezan(:,8));
% 
% format longG
% % Note tha the leap second is not considered by posixtime
% t1 = posixtime(t);
% 
% figure('Name','Time')
% plot(t1(:,1))

%% FIGURES %%%%%%%%

% f=figure('Name','Ground speed vs RPM vs Cap')
% subplot(3,1,1)
% plot(t1,log_FL2_lannemezan(:,12)./3.6)
% ylabel('Ground speed (m/s)')
% subplot(3,1,2)
% plot(t1,log_FL2_lannemezan(:,17))
% ylabel('RPM')
% subplot(3,1,3)
% plot(t1,log_FL2_lannemezan(:,13))
% ylabel('cap')
% all_ha = findobj( f, 'type', 'axes', 'tag', '' );
% linkaxes( all_ha, 'x' );
% 

% f1=figure('Name','Ground speed vs RPM vs Cap 1')
% subplot(3,1,1)
% plot(log_FL2_lannemezan(:,12)./3.6)
% ylabel('Ground speed (m/s)')
% subplot(3,1,2)
% plot(log_FL2_lannemezan(:,17))
% ylabel('RPM')
% subplot(3,1,3)
% plot(log_FL2_lannemezan(:,13))
% ylabel('cap')
% all_ha = findobj( f1, 'type', 'axes', 'tag', '' );
% linkaxes( all_ha, 'x' );
 

%% %%%%%%%%%%%%%%%%%%%%%%%%Comparison between logdata and FL_28072020 data %%%%%%%%%%%%%%%%%
% Seuil_bas=173000;
% Seuil_haut= 500000;
% col=[1:26];
% [Ressample_ADV,temps]=resample(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,col),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,1),1,1,1,'linear');
% col=[1:20];
% [Ressample_LOG,temps1]=resample(log_FL2_lannemezan(Seuil_bas:Seuil_haut,col),log_FL2_lannemezan(Seuil_bas:Seuil_haut,1),1,1,1,'linear');

% Seuil_bas_log=find(t1.*10^3>=data.AD_NAVIGATION(Seuil_bas,26));
% Seuil_bas_log=Seuil_bas_log(1);
% 
% Seuil_haut_log=find(t1.*10^3<=data.AD_NAVIGATION(Seuil_haut,26));
% Seuil_haut_log=Seuil_haut_log(end);
% 
% f=figure('Name','Ground speed vs RPM vs Cap')
% subplot(3,1,1)
% plot(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,26),sqrt(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,9).^2+data.AD_NAVIGATION(Seuil_bas:Seuil_haut,10).^2)); hold on; 
% plot(t1(Seuil_bas_log:Seuil_haut_log).*10^3,log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,12)./3.6);
% legend('Ground speed AD navigation(m/s)','Ground speed Boreal(m/s)')
% ylabel('Ground speed (m/s)')
% subplot(3,1,2)
% plot(t1(Seuil_bas_log:Seuil_haut_log).*10^3,log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,17))
% ylabel('RPM (data boreal)')
% subplot(3,1,3)
% plot(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,26),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,18)); hold on; 
% plot(t1(Seuil_bas_log:Seuil_haut_log).*10^3,log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,13))
% legend('Heading ADnav','Heading boreal')
% ylabel('Heading (data boreal)')
% all_ha = findobj( f, 'type', 'axes', 'tag', '' );
% linkaxes( all_ha, 'x' );
% 
% f=figure('Name','Ground speed vs RPM vs roll')
% subplot(3,1,1)
% plot(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,26),sqrt(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,9).^2+data.AD_NAVIGATION(Seuil_bas:Seuil_haut,10).^2)); hold on; 
% plot(t1(Seuil_bas_log:Seuil_haut_log).*10^3,log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,12)./3.6);
% legend('Ground speed AD navigation(m/s)','Ground speed Boreal(m/s)')
% ylabel('Ground speed (m/s)')
% subplot(3,1,2)
% plot(t1(Seuil_bas_log:Seuil_haut_log).*10^3,log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,17))
% ylabel('RPM (data boreal)')
% subplot(3,1,3)
% plot(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,26),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,16)); hold on; 
% plot(t1(Seuil_bas_log:Seuil_haut_log).*10^3,log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,14))
% legend('Roll ADnav','Roll boreal')
% ylabel('Roll (degrees)')
% all_ha = findobj( f, 'type', 'axes', 'tag', '' );
% linkaxes( all_ha, 'x' );
% 
% time_lapse=data.AD_NAVIGATION(18165,26)./10^3-t1(755);
% 
% 
% f=figure('Name','Ground speed vs RPM vs Heading + time_lapse')
% subplot(3,1,1)
% plot(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,26),sqrt(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,9).^2+data.AD_NAVIGATION(Seuil_bas:Seuil_haut,10).^2)); hold on; 
% plot(t1(Seuil_bas_log:Seuil_haut_log).*10^3+time_lapse.*10^3,log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,12)./3.6);
% legend('Ground speed AD navigation(m/s)','Ground speed Boreal(m/s)')
% ylabel('Ground speed (m/s)')
% subplot(3,1,2)
% plot(t1(Seuil_bas_log:Seuil_haut_log).*10^3+time_lapse.*10^3,log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,17))
% ylabel('RPM (data boreal)')
% subplot(3,1,3)
% plot(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,26),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,18)); hold on; 
% plot(t1(Seuil_bas_log:Seuil_haut_log).*10^3+time_lapse.*10^3,log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,13))
% legend('Heading ADnav','Heading boreal')
% ylabel('Heading (data boreal)')
% all_ha = findobj( f, 'type', 'axes', 'tag', '' );
% linkaxes( all_ha, 'x' );

% figure('Name','3D ground speed')
% subplot(2,1,1)
% Y = log_FL2_lannemezan(:,9);
% X = log_FL2_lannemezan(:,10);
% Z = log_FL2_lannemezan(:,11);
% C = log_FL2_lannemezan(:,12);
% patch('XData', [nan;X(:);nan],...
%       'YData', [nan;Y(:);nan],...
%       'ZData', [nan;Z(:);nan],...
%       'CData', [nan;C(:);nan],...
%       'FaceColor', 'interp', ...
%       'EdgeColor', 'interp')
% view(3)
% barre=colorbar;
% barre.Label.String = 'Ground speed boreal)';
% title ('Ground speed boreal');
% ylabel('Longitude (degrees)');
% xlabel('Latitude  (degrees)');
% zlabel('Height agl (m)');
% subplot(2,1,2)
% Y = log_FL2_lannemezan(:,9);
% X = log_FL2_lannemezan(:,10);
% Z = log_FL2_lannemezan(:,11);
% C = log_FL2_lannemezan(:,12);patch('XData', [nan;X(:);nan],...
%       'YData', [nan;Y(:);nan],...
%       'ZData', [nan;Z(:);nan],...
%       'CData', [nan;C(:);nan],...
%       'FaceColor', 'interp', ...
%       'EdgeColor', 'interp')
% view([0,0,1])
% barre=colorbar;
% barre.Label.String = 'Ground speed boreal)';
% title ('Ground speed boreal');
% ylabel('Longitude (degrees)');
% xlabel('Latitude  (degrees)');
% zlabel('Height agl (m)');




%% %%%%%%%%%%%%%%%% MOTUS DATA%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure('Name','ROLL PITCH HEADING BOREAL MOTUS SPATIAL');
% 
% subplot(3,1,1)
% plot(FL2_04082020.MOTUSORI(Seuil_bas:Seuil_haut,6),filloutliers(FL2_04082020.MOTUSORI(Seuil_bas:Seuil_haut,2),'linear')); hold on;
% plot(FL2_04082020.MOTUSORI(Seuil_bas:Seuil_haut,6),filloutliers(FL2_04082020.MOTUSORI(Seuil_bas:Seuil_haut,2),'previous')); hold on;
% plot(t1(Seuil_bas_log:Seuil_haut_log).*10^3,log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,14));hold on;
% plot(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,26),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,16)); hold on;
% xlabel('Time');
% ylabel('Roll (degrees)');
% legend('MOTUS lin','motus pre','BOREAL','SPATIAL')
% % legend('MOTUS','BOREAL','SPATIAL')
% 
% subplot(3,1,2)
% plot(FL2_04082020.MOTUSORI(Seuil_bas:Seuil_haut,6),filloutliers(FL2_04082020.MOTUSORI(Seuil_bas:Seuil_haut,3),'linear')); hold on;
% plot(t1(Seuil_bas_log:Seuil_haut_log).*10^3,log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,15));hold on;
% plot(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,26),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,17)); hold on;
% legend('MOTUS','BOREAL','SPATIAL')
% xlabel('Time');
% ylabel('Pitch(degrees)');
% 
% subplot(3,1,3)
% plot(FL2_04082020.MOTUSORI(Seuil_bas:Seuil_haut,6),filloutliers(FL2_04082020.MOTUSORI(Seuil_bas:Seuil_haut,4),'linear')); hold on;
% plot(FL2_04082020.MOTUSORI(Seuil_bas:Seuil_haut,6),filloutliers(FL2_04082020.MOTUSORI(Seuil_bas:Seuil_haut,4),'previous')); hold on;
% plot(t1(Seuil_bas_log:Seuil_haut_log).*10^3,log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,13));hold on;
% plot(data.AD_NAVIGATION(Seuil_bas:Seuil_haut,26),data.AD_NAVIGATION(Seuil_bas:Seuil_haut,18)); hold on;
% xlabel('Time');
% ylabel('Heading (degrees)');
% legend('MOTUS lin','motus pre','BOREAL','SPATIAL')
% % legend('MOTUS','BOREAL','SPATIAL')
% 
% figure('Name','Static pressure measured by BOreal versus OUR')
% plot(t1(Seuil_bas_log:Seuil_haut_log)-t1(Seuil_bas_log),log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,20)./100)
% hold on; plot((data.Pressures(seuilbas_p:seuilhaut_p,27)-data.Pressures(seuilbas_p,27))./10^3,p_Stat2_NR)
% xlabel('Time elapsed since take off')
% ylabel('Baro')
% legend('Boreal','HCEM')
% % Vg_East2=sind(Psi2).*log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,12)./3.6;
% % Vg_North2=cosd(Psi2).*log_FL2_lannemezan(Seuil_bas_log:Seuil_haut_log,12)./3.6;
% d = designfilt('lowpassiir','FilterOrder',7 ,'PassbandFrequency', 0.1); 
% y = filtfilt(d,p_Stat2_NR);
% figure('Name','Pressure filtered')
% plot(p_Stat2_NR)
% hold on;plot(y) 
% legend('Before filter','Filtered')

% % Modele complexe de lenchow
% D = ( 1 + (tand(Alpha)).^2 + (tand(Beta)).^2).^0.5;
% 
% Etape1_3=sind(Psi2).*cosd(Theta);
% Etape2_3=tand(Beta).*(cosd(Psi2).*cosd(Phi) + sind(Psi2).*sind(Theta).*sind(Phi));
% Etape3_3=tand(Alpha).*(sind(Psi2).*sind(Theta).*cosd(Phi) - cosd(Psi2).*sind(Phi));
% WindSpeed_East_3=(-1./D).*AirSpeed_5hole.*(Etape1_3+Etape2_3 + Etape3_3)+ Vg_East2;
% 
% Etape4_3=cosd(Psi2).*cosd(Theta);
% Etape5_3=tand(Beta).*(sind(Psi2).*cosd(Phi)-cosd(Psi2).*sind(Theta).*sind(Phi));
% Etape6_3=tand(Alpha).*(cosd(Psi2).*sind(Theta).*cosd(Phi) + sind(Psi2).*sind(Phi));
% WindSpeed_North_3=(-1./D).*AirSpeed_5hole.*(Etape4_3-Etape5_3 + Etape6_3)+Vg_North2;
% 
% Horizontal_windSpeed3= (WindSpeed_East_3.^2+WindSpeed_North_3.^2).^0.5;
% WD3=mod(atan2d(-WindSpeed_East_3,-WindSpeed_North_3),360);