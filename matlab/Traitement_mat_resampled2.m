%========================================================================%
%  Traitement donnees FL_28072020                                           %
% ========================================================================%
 clear
load tower_60m_fast.mat
load('tower_60m_fast_label.mat')
load('tower_30m_fast.mat')
load('time_60m.mat')

% Post_proc_resampled
Post_proc_resampled_vers2
close all
%% Data after correction
Beta_corr= -p_horiz_LDE./( p_centrale*0.086)-0.8;  %
AirSpeed_5hole_corr= sqrt(abs((200.*p_centrale)./rho))*0.97; %Bernoulli eq'n using mbar
Alpha_corr=Alpha;

D_corr = ( 1 + (tand(Alpha_corr)).^2 + (tand(Beta_corr)).^2).^0.5;

Etape1_corr=sind(Psi_SBG).*cosd(Theta_SBG);
Etape2_corr=tand(Beta_corr).*(cosd(Psi_SBG).*cosd(Phi_SBG) + sind(Psi_SBG).*sind(Theta_SBG).*sind(Phi_SBG));
Etape3_corr=tand(Alpha_corr).*(sind(Psi_SBG).*sind(Theta_SBG).*cosd(Phi_SBG) - cosd(Psi_SBG).*sind(Phi_SBG));
WindSpeed_East_SBG_corr=(-1./D_corr).*AirSpeed_5hole_corr.*(Etape1_corr+Etape2_corr + Etape3_corr)+ GS_east_interp100Hz;

Etape4_corr=cosd(Psi_SBG).*cosd(Theta_SBG);
Etape5_corr=tand(Beta_corr).*(sind(Psi_SBG).*cosd(Phi_SBG)-cosd(Psi_SBG).*sind(Theta_SBG).*sind(Phi_SBG));
Etape6_corr=tand(Alpha_corr).*(cosd(Psi_SBG).*sind(Theta_SBG).*cosd(Phi_SBG) + sind(Psi_SBG).*sind(Phi_SBG));
WindSpeed_North_SBG_corr=(-1./D_corr).*AirSpeed_5hole_corr.*(Etape4_corr-Etape5_corr + Etape6_corr)+GS_north_interp100Hz;


Horizontal_windSpeed_SBG_corr= sqrt(WindSpeed_East_SBG_corr.^2+WindSpeed_North_SBG_corr.^2);

WD_SBG_corr=mod(atan2d(-WindSpeed_East_SBG_corr,-WindSpeed_North_SBG_corr),360);

Etape7_corr=sind(Theta_SBG)-tand(Beta_corr).*cosd(Theta_SBG).*sind(Phi_SBG)-tand(Alpha_corr).*cosd(Theta_SBG).*cosd(Phi_SBG);
Vertical_WS2_corr=(-1./D_corr(2:end)).*AirSpeed_5hole_corr(2:end).*(Etape7_corr(2:end))+GS_z2;%Vitesse vent verticale en utilisant la vitesse sol dérivée de la pression
Vertical_WS_corr=(-1./D_corr).*AirSpeed_5hole_corr.*(Etape7_corr)+GS_z_interp100Hz; %Vitesse vent verticale en utilisant la vitesse sol dérivée de l'altitude


%% ========================================================================%
% Constante Physique                                                     %
%========================================================================%
R = 8.3144598;      %gas constant [m^3PaK^-1mol^-1]
m = 0.02897;        %mass if 1 mol of air 
R = R/m;            %air constant[J/kgK]

t_60m= datetime(time_60m(:,1),time_60m(:,2),time_60m(:,3),time_60m(:,4),time_60m(:,5),time_60m(:,6));

t_date_mat= datetime(time_60m(:,1),time_60m(:,2),time_60m(:,3));
t_date_mat=sprintf('%s',t_date_mat(1));
format longG
% Note tha the leap second is not considered by posixtime
t_60m_sec= posixtime(t_60m);


S_b_t= find(t_60m>=t_100Hz(1)); %Seuil bas tower
S_b_t=S_b_t(1);


S_h_t= find(t_60m<=t_100Hz(end)); %Seuil haut tower
S_h_t=S_h_t(end);

% t_tower=(t_60m_sec(S_b_t:S_h_t)-t_60m_sec(S_b_t));

Time_range=sprintf('(On %s from %s to %s)',t_date_mat,timeofday(t_60m(S_b_t)),timeofday(t_60m(S_h_t)))

WD_mat60m=mod(atan2d(-tower_60m_fast(S_b_t:S_h_t,2),-tower_60m_fast(S_b_t:S_h_t,3)),360);
WD_mat30m=mod(atan2d(-tower_30m_fast(S_b_t:S_h_t,2),-tower_30m_fast(S_b_t:S_h_t,3)),360);

% WD_mast=atan2d(tower_60m_fast(S_b_t:S_h_t,3),tower_60m_fast(S_b_t:S_h_t,2));%conv math method2
% WD_mast60m_test=mod(270-mod(WD_mast,360),360); %convention meteo METHOD 2
% figure('Name','Wind Direction TOWER 60 m')
% plot(t_60m(S_b_t:S_h_t),WD_mast60m_test,'r')
% %hold on; plot(t_60m(S_b_t:S_h_t),WD_mat60m,'b')
% xlabel({'Time UTC',Time_range}) 
% ylabel('Wind direction (degrees)')
% legend('Method2','methode 1')
% ylim([0 360])

figure('Name','Wind speed componenets TOWER 60m')
plot(t_60m(S_b_t:S_h_t),tower_60m_fast(S_b_t:S_h_t,2),'r');hold on;
%plot(t_60m(S_b_t:S_h_t),fillmissing(tower_60m_fast(S_b_t:S_h_t,2),'linear'),'b')
hold on; plot(t_60m(S_b_t:S_h_t),tower_60m_fast(S_b_t:S_h_t,3),'b')
hold on; plot(t_60m(S_b_t:S_h_t),tower_60m_fast(S_b_t:S_h_t,4),'k')
xlabel({'Time UTC',Time_range}) 
legend('East','North','Vertical')

% figure('Name','Horizontal Wind Speed TOWER 60m')
% plot(t_60m(S_b_t:S_h_t),sqrt(tower_60m_fast(S_b_t:S_h_t,2).^2+tower_60m_fast(S_b_t:S_h_t,3).^2))
% xlabel({'Time UTC',Time_range}) 
% ylabel('Horizontal wind speed mat 60 m')
% % 
% figure('Name','Horizontal Wind Speed TOWER 30m')
% plot(t_60m(S_b_t:S_h_t),sqrt(tower_30m_fast(S_b_t:S_h_t,2).^2+tower_30m_fast(S_b_t:S_h_t,3).^2))
% xlabel({'Time UTC',Time_range}) 
% ylabel('Horizontal wind speed mat 30 m')

figure('Name','Horizontal Wind Speed TOWER 30m and 60 m')
plot(t_60m(S_b_t:S_h_t),sqrt(tower_30m_fast(S_b_t:S_h_t,2).^2+tower_30m_fast(S_b_t:S_h_t,3).^2),'r')
hold on; plot(t_60m(S_b_t:S_h_t),sqrt(tower_60m_fast(S_b_t:S_h_t,2).^2+tower_60m_fast(S_b_t:S_h_t,3).^2),'b')
xlabel({'Time UTC',Time_range}) 
ylabel('Horizontal wind speed (m.s^{-1})')
legend('Tower at 30m','Tower at 60m')

figure('Name','Horizontal Wind Speed TOWER 30m and 60 m')
plot(t_60m(S_b_t:S_h_t),sqrt(tower_30m_fast(S_b_t:S_h_t,2).^2+tower_30m_fast(S_b_t:S_h_t,3).^2),'r')
hold on; plot(t_60m(S_b_t:S_h_t),sqrt(tower_60m_fast(S_b_t:S_h_t,2).^2+tower_60m_fast(S_b_t:S_h_t,3).^2),'b')
hold on; plot(t_100Hz,Horizontal_windSpeed_SBG);
xlabel({'Time UTC',Time_range}) 
ylabel('Horizontal wind speed')
legend('Mat 30m','mat 60m','Boreal')

figure('Name','Horizontal Wind Speed TOWER 30m and 60 m')
plot(t_60m(S_b_t:S_h_t),sqrt(tower_30m_fast(S_b_t:S_h_t,2).^2+tower_30m_fast(S_b_t:S_h_t,3).^2),'r')
hold on; plot(t_60m(S_b_t:S_h_t),sqrt(tower_60m_fast(S_b_t:S_h_t,2).^2+tower_60m_fast(S_b_t:S_h_t,3).^2),'b')
hold on; plot(t_100Hz,Horizontal_windSpeed_SBG)
%hold on; plot(t_100Hz,filloutliers(Horizontal_windSpeed_SBG,'linear'))
xlabel({'Time UTC',Time_range}) 
ylabel('Horizontal wind speed')
legend('Mat 30m','mat 60m','Boreal filtré')

fig3=figure('Name','Horizontal Wind Speed TOWER 30m and 60 m et BOREAL et CAP')
subplot(2,1,1)
plot(t_60m(S_b_t:S_h_t),sqrt(tower_30m_fast(S_b_t:S_h_t,2).^2+tower_30m_fast(S_b_t:S_h_t,3).^2),'r')
hold on; plot(t_60m(S_b_t:S_h_t),sqrt(tower_60m_fast(S_b_t:S_h_t,2).^2+tower_60m_fast(S_b_t:S_h_t,3).^2),'b')
hold on; plot(t_100Hz,Horizontal_windSpeed_SBG)
%hold on; plot(t_100Hz,filloutliers(filloutliers(Horizontal_windSpeed_SBG,'nearest','mean'),'previous'))
xlabel({'Time UTC',Time_range}) 
ylabel('Horizontal wind speed')
legend('Mat 30m','mat 60m','Boreal filtré')
subplot(2,1,2)
plot(t_100Hz,Psi_SBG); hold on
ylabel('Heading Boreal (degrees)')
allaxes=findobj(fig3,'type','axes','tag', '')
linkaxes(allaxes,'x')


figure('Name','Wind Direction TOWER 30m and 60 m')
plot(t_60m(S_b_t:S_h_t),WD_mat30m,'r')
hold on; plot(t_60m(S_b_t:S_h_t),WD_mat60m,'b')
xlabel({'Time UTC',Time_range}) 
ylabel('Wind direction (degrees)')
legend('Mat 30m','mat 60m')
ylim([0 360])

fig1=figure('Name','Comparison WD mast 60 m and BOREAL')
subplot(2,1,1)
plot(t_60m(S_b_t:S_h_t),WD_mat60m,'k')
hold on; plot(t_100Hz,WD_SBG,'r'); hold on
plot(t_100Hz,WD,'b');
xlabel({'Time UTC',Time_range}) 
ylabel('Wind direction (degrees)')
legend('Mat 60m','WD_{SBG}','WD_{spatial}')
ylim([0 360])
subplot(2,1,2)
plot(t_100Hz,Psi_SBG); hold on
ylabel('Heading Boreal (degrees)')
allaxes=findobj(fig1,'type','axes','tag', '')
linkaxes(allaxes,'x')

fig=figure('Name','Comparison WD mast 60 m and BOREAL')
subplot(2,1,1)
plot(t_60m(S_b_t:S_h_t),WD_mat60m,'k')
hold on; plot(t_100Hz,WD_SBG,'r'); hold on
xlabel({'Time UTC',Time_range}) 
ylabel('Wind direction (degrees)')
legend('Mat 60m','WD_{SBG}')
ylim([0 360])
subplot(2,1,2)
plot(t_100Hz,Psi_SBG); hold on
ylabel('Heading Boreal (degrees)')
allaxes=findobj(fig,'type','axes','tag', '')
linkaxes(allaxes,'x')

fig3=figure('Name','Vertical wind speed')
subplot(2,1,1)
plot(t_60m(S_b_t:S_h_t),tower_60m_fast(S_b_t:S_h_t,4),'r')
hold on;
plot(t_100Hz(2:end),Vertical_WS2_corr,'b')
hold on;
plot(t_100Hz(1:end),Vertical_WS_corr,'g')
legend('Mast','SBG and W_p','SBG and W_{alt}')
ylabel('Vertical wind speed in m/s')
xlabel('Time elapsed since take off (s)')
subplot(2,1,2)
plot(t_100Hz,Psi_SBG)
ylabel('Heading (degrees)')
xlabel({'Time since take off (s)',Time_range1}) 
allaxes=findobj(fig3,'type','axes','tag', '')
linkaxes(allaxes,'x')


%% ========================================================================%

%WD_mat60m_040820=mod(atan2d(-tower_60m_fast(:,2),-tower_60m_fast(:,3)),360);

determinationdestranches

tower_60m_fast_Wnan=fillmissing(tower_60m_fast,'linear');
Horizontal_WS_mat60m_Wnan=sqrt(tower_60m_fast_Wnan(:,2).^2+tower_60m_fast_Wnan(:,3).^2);
WD_mat60m_Wnan=mod(atan2d(-tower_60m_fast_Wnan(:,2),-tower_60m_fast_Wnan(:,3)),360);

clear k Va_mean  t_boreal d_parcourue pub BorneInf BorneSup1 Wspeed t_mat BorneSup1 Wspeed1 t_mat1 BorneSup1 Wspeed2 t_mat2 WindSpeed_North_SBG_mean WindSpeed_East_SBG_mean WD_mean WD_mean_vect NorthWS_mat60m EastWS_mat60m WD_mat60m_mean WD_mat60m_mean_vect titres1

k=1;
for i=15:2:(length(tranches1)-7)
%for i=1:2:(1)
Va_mean{k}=mean(AirSpeed_5hole(tranches1(i):tranches1(i+1))); %moyenne de la vitesse air pour la tranche x
Va_mean_corr{k}=mean(AirSpeed_5hole_corr(tranches1(i):tranches1(i+1)));

t_boreal{k}=(time_100Hz(tranches1(i+1))-time_100Hz(tranches1(i)))*1000;%durée de la tranche x en ms
d_parcourue{k}=[Va_mean_corr{k}]*([t_boreal{k}]/1000);

pub=find(t_60m(:,1)>=t_100Hz(tranches1(i)));
BorneInf{k}=pub(1);

Bornesup{k}=[BorneInf{k}]+round([t_boreal{k}]/100);
Wspeed{k}=sqrt(mean(tower_60m_fast_Wnan([BorneInf{k}]:[Bornesup{k}],2))^2+mean(tower_60m_fast_Wnan([BorneInf{k}]:[Bornesup{k}],3))^2);
t_mat{k}=[d_parcourue{k}]/[Wspeed{k}];%temps en secondes

BorneSup{k}=[BorneInf{k}]+round([t_mat{k}]*10);
Wspeed1{k}=sqrt(mean(tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup{k}],2))^2+mean(tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup{k}],3))^2);
t_mat1{k}=[d_parcourue{k}]/[Wspeed1{k}];%temps en secondes

BorneSup1{k}=[BorneInf{k}]+round([t_mat1{k}]*10);
Wspeed2{k}=sqrt(mean(tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup1{k}],2))^2+mean(tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup1{k}],3))^2);
t_mat2{k}=[d_parcourue{k}]/[Wspeed2{k}];%temps en secondes; these iterations for windspeed and period calculation relative to Mat60m are important in order to minimize the error of these two terms

% BorneSup2{k}=[BorneInf{k}]+round([t_mat2{k}]*10);
% Wspeed3{k}=sqrt(mean(tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup2{k}],2))^2+mean(tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup2{k}],3))^2);
% t_mat3{k}=[d_parcourue{k}]/[Wspeed3{k}];%

WindSpeed_North_SBG_mean{k,1}=mean(WindSpeed_North_SBG(tranches1(i):tranches1(i+1))); 
WindSpeed_East_SBG_mean{k,1}=mean(WindSpeed_East_SBG(tranches1(i):tranches1(i+1)));
Windspeed_mean{k,1}=mean(Horizontal_windSpeed_SBG(tranches1(i):tranches1(i+1)));
Windspeed_mean{k,2}=sqrt(WindSpeed_North_SBG_mean{k,1}.^2+WindSpeed_East_SBG_mean{k,1}.^2);
Windspeed_std{k,1}=std(sqrt(WindSpeed_East_SBG(tranches1(i):tranches1(i+1)).^2+WindSpeed_North_SBG(tranches1(i):tranches1(i+1)).^2));
WD_SBG_mean{k,1}=mod(atan2d(-WindSpeed_East_SBG_mean{k,1},-WindSpeed_North_SBG_mean{k,1}),360);%direction vent  moyenne à partir des moyennes des composantes de vitesse.
WD_SBG_mean_vect{k}(1:length(WindSpeed_North_SBG(tranches1(i):tranches1(i+1))),1)=mod(atan2d(-WindSpeed_East_SBG_mean{k,1},-WindSpeed_North_SBG_mean{k,1}),360);

WD_SBG_seq{k,1}=mod(atan2d(-WindSpeed_East_SBG(tranches1(i):tranches1(i+1)),-WindSpeed_North_SBG(tranches1(i):tranches1(i+1))),360);%direction vent  moyenne à partir des moyennes des composantes de vitesse.
epsilon_seq{k}=sqrt(1-(mean(cosd(WD_SBG_seq{k,1}))^2+mean(sind(WD_SBG_seq{k,1}))^2)); 
WD_std_equ25{k,1}=asind(epsilon_seq{k})*[1+0.1547*epsilon_seq{k}^3];

WindSpeed_North_SBG_mean_corr{k,1}=mean(WindSpeed_North_SBG_corr(tranches1(i):tranches1(i+1))); 
WindSpeed_East_SBG_mean_corr{k,1}=mean(WindSpeed_East_SBG_corr(tranches1(i):tranches1(i+1)));
Windspeed_corr_mean{k,1}=mean(Horizontal_windSpeed_SBG_corr(tranches(i):tranches(i+1)));
Windspeed_corr_mean{k,2}= sqrt(WindSpeed_North_SBG_mean_corr{k,1}.^2+WindSpeed_East_SBG_mean_corr{k,1}.^2);
Windspeed_corr_std{k,1}= std(sqrt(WindSpeed_East_SBG_corr(tranches1(i):tranches1(i+1)).^2+WindSpeed_North_SBG_corr(tranches1(i):tranches1(i+1)).^2));
WD_SBG_corr_mean{k,1}=mod(atan2d(-WindSpeed_East_SBG_mean_corr{k,1},-WindSpeed_North_SBG_mean_corr{k,1}),360);%direction vent moyenne à partir des moyennes des composantes de vitesse.
WD_SBG_corr_mean_vect{k}(1:length(WindSpeed_North_SBG_corr(tranches1(i):tranches1(i+1))),1)=mod(atan2d(-WindSpeed_East_SBG_mean_corr{k,1},-WindSpeed_North_SBG_mean_corr{k,1}),360);

WD_SBG_corr_seq{k,1}=mod(atan2d(-WindSpeed_East_SBG_corr(tranches1(i):tranches1(i+1)),-WindSpeed_North_SBG_corr(tranches1(i):tranches1(i+1))),360);%direction vent  moyenne à partir des moyennes des composantes de vitesse.
epsilon_corr_seq{k}=sqrt(1-(mean(cosd(WD_SBG_corr_seq{k,1}))^2+mean(sind(WD_SBG_corr_seq{k,1}))^2)); 
WD_std_equ25_corr{k,1}=asind(epsilon_corr_seq{k})*[1+0.1547*epsilon_corr_seq{k}^3];


NorthWS_mat60m{k}=mean(tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup1{k}],3));
EastWS_mat60m{k}=mean(tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup1{k}],2));
WS_mat60m_mean{k}=sqrt(mean(tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup1{k}],3)).^2+mean(tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup1{k}],2)).^2);
WS_mat60m_std{k}=std(sqrt(tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup1{k}],3).^2+tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup1{k}],2).^2));
WD_mat60m_mean{k}=mod(atan2d(-EastWS_mat60m{k},-NorthWS_mat60m{k}),360);%direction vent mat60m moyenne à partir des moyennes des composantes de vitesse.
WD_mat60m_mean_vect{k}(1:length(tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup1{k}],3)),1)=WD_mat60m_mean{k};%direction vent mat60m moyenne à partir des moyennes des composantes de vitesse.

WD_mat60m_seq{k,1}=mod(atan2d(-tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup1{k}],2),-tower_60m_fast_Wnan([BorneInf{k}]:[BorneSup1{k}],3)),360);%direction vent  moyenne à partir des moyennes des composantes de vitesse.
epsilon_mast_seq{k}=sqrt(1-(mean(cosd(WD_mat60m_seq{k,1}))^2+mean(sind(WD_mat60m_seq{k,1}))^2)); 
WD_std_equ25_mast{k,1}=asind(epsilon_mast_seq{k})*[1+0.1547*epsilon_mast_seq{k}^3];

Heading_mean{k,1}=mean(cosd(Psi_SBG(tranches1(i):tranches1(i+1))));
Heading_mean{k,2}=mean(sind(Psi_SBG(tranches1(i):tranches1(i+1))));
Heading_mean{k,3}=mod(atan2d(Heading_mean{k,2},Heading_mean{k,1}),360);

Altitude_mean{k,1}=mean(Altitude_interp(tranches1(i):tranches1(i+1)));

t_100Hz_middle(k,1)= t_100Hz(round((tranches1(i)+tranches1(i+1))/2));

time_100Hz_middle(k,1)=(time_100Hz(round((tranches1(i)+tranches1(i+1))/2))-time_100Hz(1));

AirSpeed_5hole_corr_mean{k,1}=mean(AirSpeed_5hole_corr(tranches1(i):tranches1(i+1)));


% titres{k} =  sprintf(' Wind direction of "Boreal" vs "60 m tower" for straigth sequence %s"', num2str(k));
%titres1{k} =  sprintf('Comparaison between Wind direction measured by "BOREAL" and the  "60m tower" for the straight sequence %s (distance)', num2str(k));
% legendes{k} =  sprintf('WD 60m-Mast; t_{mat}=%s s', num2str(t_mat{k}));
% legendes1{k} =  sprintf('WD Boreal; t_{Boreal}=%s s', num2str(t_boreal{k}/1000));

% figure('Name','WD Boreal versus 60m-Mast')
% plot(cell2mat(WD_mean),'or')
% hold on; plot(t_60m(S_b_t:S_h_t),WD_mat60m,'b')
% hold on; plot(t_100Hz(tranches1(i):tranches1(i+1)),WD_SBG(tranches1(i):tranches1(i+1)),'r'); hold on
% plot(cell2mat(WD_mat60m_mean),'og')
% hold on; plot(t_60m([BorneInf{k}]:[BorneSup1{k}]),WD_mat60m_Wnan([BorneInf{k}]:[BorneSup1{k}]),'b')
% legend('WD Boreal','WD 60m-Mast')
% ylabel('Wind direction (degrees)')

% figure('Name','WD Boreal versus 60m-Mast')
% plot((time_100Hz(tranches1(i):tranches1(i+1))-time_100Hz(tranches1(i))).*Va_mean{k},WD_SBG(tranches1(i):tranches1(i+1)),'r')
% hold on;plot((time_100Hz(tranches1(i):tranches1(i+1))-time_100Hz(tranches1(i))).*Va_mean{k},WD_SBG_mean_vect{k},'r')
% hold on; plot((t_60m_sec([BorneInf{k}]:[BorneSup1{k}])-t_60m_sec([BorneInf{k}])).*Wspeed2{k},WD_mat60m_040820([BorneInf{k}]:[BorneSup1{k}]),'b')
% hold on; plot((t_60m_sec([BorneInf{k}]:[BorneSup1{k}])-t_60m_sec([BorneInf{k}])).*Wspeed2{k},WD_mat60m_mean_vect{k},'b')
% title(titres1{k})
% legend('WD Boreal','Mean Boreal','WD 60m-Mast','Mean mast')
% ylabel('Wind direction (degrees)')
% xlabel('Travelled distance during the straight and level run (m)')

k=k+1;
end


for i=1:length(WD_SBG_mean(:,1))
if cell2mat(WD_SBG_mean(i))<20
    WD_SBG_mean{i,4}= WD_SBG_mean{i,1}+360;
else
    WD_SBG_mean{i,4}= WD_SBG_mean{i,1};
end
end
for i=1:length(WD_SBG_corr_mean(:,1))
if cell2mat(WD_SBG_corr_mean(i))<20
    WD_SBG_corr_mean{i,4}= WD_SBG_corr_mean{i,1}+360;
else
    WD_SBG_corr_mean{i,4}= WD_SBG_corr_mean{i,1};
end
end

figure('Name','Wind direction versus heading on straight and level runs')
plot(cell2mat(Heading_mean(:,3)),cell2mat(WD_SBG_mean(:,4)),'ob'); hold on;
plot(cell2mat(Heading_mean(:,3)),cell2mat(WD_SBG_corr_mean(:,4)),'or'); hold on;
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16}Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16}Wind direction (degrees)');
%title('\fontsize{16}Wind direction');
%ylim([0 360])
xlim([150 360])

%%%%% STD Non corrigé
Mean_WD_all_seq_all_cos=mean(cosd(cell2mat(WD_SBG_mean(:,1))));
Mean_WD_all_seq_all_sin=mean(sind(cell2mat(WD_SBG_mean(:,1))));
Mean_WD_all_seq_all=mod(atan2d(Mean_WD_all_seq_all_sin,Mean_WD_all_seq_all_cos),360);

% Delta_i_all= min(abs(cell2mat(WD_SBG_mean(:,1))-Mean_WD_all_seq_all),
% abs(2*pi-(cell2mat(WD_SBG_mean(:,1))-Mean_WD_all_seq_all))); %methode 1
% Winddirection_std_all=sqrt(1/length(cell2mat(WD_SBG_mean(:,1)))*sum(Delta_i_all.^2)-(1/length(cell2mat(WD_SBG_mean(:,1)))*sum(Delta_i_all)).^2);
epsilon=sqrt(1-(Mean_WD_all_seq_all_sin^2+Mean_WD_all_seq_all_cos^2)); %methode 2 est meilleure
std_WD=asind(epsilon)*[1+0.1547*epsilon^3];

%%%%%%%%%%%%%% STD corrigé
Mean_WD_all_seq_all_cos_corr=mean(cosd(cell2mat(WD_SBG_corr_mean(:,1))));
Mean_WD_all_seq_all_sin_corr=mean(sind(cell2mat(WD_SBG_corr_mean(:,1))));
Mean_WD_all_seq_all_corr=mod(atan2d(Mean_WD_all_seq_all_sin_corr,Mean_WD_all_seq_all_cos_corr),360);

% Delta_i_corr_all=
% min(abs(cell2mat(WD_SBG_corr_mean(:,3))-Mean_WD_all_seq_all_corr), abs(360-(cell2mat(WD_SBG_corr_mean(:,3))-Mean_WD_all_seq_all_corr))); %methode 1
% Winddirection_std_corr_all=sqrt(1/length(cell2mat(WD_SBG_corr_mean(:,3)))*sum(Delta_i_corr_all.^2)-(1/length(cell2mat(WD_SBG_corr_mean(:,3)))*sum(Delta_i_corr_all)).^2);
epsilon_corr=sqrt(1-(Mean_WD_all_seq_all_sin_corr^2+Mean_WD_all_seq_all_cos_corr^2)); %methode 2
std_WD_corr=asind(epsilon_corr)*[1+0.1547*epsilon_corr^3];


figure('Name','Wind speed versus heading on straight and level runs')
plot(cell2mat(Heading_mean(:,3)),cell2mat(Windspeed_mean(:,2)),'ob'); hold on;
plot(cell2mat(Heading_mean(:,3)),cell2mat(Windspeed_corr_mean(:,2)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16}Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16}Wind speed (m.s^{-1})');
%title('\fontsize{16}Wind speed');
xlim([150 360])
std_WS_corr=std(cell2mat(Windspeed_corr_mean(:,2)));
std_WS=std(cell2mat(Windspeed_mean(:,2)));

figure('Name','East wind speed versus heading on straight and level runs')
plot(cell2mat(Heading_mean(:,3)),cell2mat(WindSpeed_East_SBG_mean),'ob'); hold on;
plot(cell2mat(Heading_mean(:,3)),cell2mat(WindSpeed_East_SBG_mean_corr),'or'); hold on;
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16} East wind speed (m.s^{-1})');
%title('\fontsize{16} East wind speed');
xlim([150 360])
std_VE_corr=std(cell2mat(WindSpeed_East_SBG_mean_corr));
std_VE=std(cell2mat(WindSpeed_East_SBG_mean));

figure('Name','North wind speed versus heading on straight and level runs')
plot(cell2mat(Heading_mean(:,3)),cell2mat(WindSpeed_North_SBG_mean),'ob'); hold on;
plot(cell2mat(Heading_mean(:,3)),cell2mat(WindSpeed_North_SBG_mean_corr),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} North wind speed (m.s^{-1})');
%title('\fontsize{16} North wind speed');
xlim([150 360])
std_VN_corr=std(cell2mat(WindSpeed_North_SBG_mean_corr));
std_VN=std(cell2mat(WindSpeed_North_SBG_mean));



fg=figure('Name','WD and WS and heading on straight and level runs')
for i=1:2:(length(WD_SBG_mean(:,1))-1)
subplot(3,1,1)
plot(t_100Hz_middle(i,1),cell2mat(WD_SBG_mean(i)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(i+1,1),cell2mat(WD_SBG_mean(i+1)),'og','MarkerFaceColor','g');hold on;
plot(t_100Hz_middle(i,1),cell2mat(WD_SBG_corr_mean(i)),'om','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(i+1,1),cell2mat(WD_SBG_corr_mean(i+1)),'ob','MarkerFaceColor','b');hold on;
ylabel('Wind direction (degrees)')
legend('North Direction','South direction','North Direction (corr)','South direction (corr)','location','southeast')
ylim([0 360])
subplot(3,1,2)
plot(t_100Hz_middle(i,1),cell2mat(Windspeed_mean(i,2)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(i+1,1),cell2mat(Windspeed_mean(i+1,2)),'og','MarkerFaceColor','g');hold on;
plot(t_100Hz_middle(i,1),cell2mat(Windspeed_corr_mean(i,2)),'om','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(i+1,1),cell2mat(Windspeed_corr_mean(i+1,2)),'ob','MarkerFaceColor','b');hold on;
ylabel('Wind speed (m^{-1})')
subplot(3,1,3)
plot(t_100Hz_middle(i,1),cell2mat(Heading_mean(i,3)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(i+1,1),cell2mat(Heading_mean(i+1,3)),'og','MarkerFaceColor','g'); hold on;
ylabel('Heading (degrees)')
end
plot(t_100Hz(tranches1(15):tranches1(length(tranches1)-7)),Psi_SBG(tranches1(15):tranches1(length(tranches1)-7)));hold on
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')

figu=figure('Name','WD and WS and heading on straight and level runs')
for i=1:2:(length(WD_SBG_mean(:,1))-1)
subplot(2,1,1)
plot(t_100Hz_middle(i,1),cell2mat(WD_SBG_mean(i)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(i+1,1),cell2mat(WD_SBG_mean(i+1)),'og','MarkerFaceColor','g');hold on;
plot(t_100Hz_middle(i,1),cell2mat(WD_SBG_corr_mean(i)),'om','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(i+1,1),cell2mat(WD_SBG_corr_mean(i+1)),'ob','MarkerFaceColor','b');hold on;
ylabel('Wind direction (degrees)')
legend('North Direction','South direction','North Direction (corr)','South direction (corr)','location','southeast')
ylim([0 360])
subplot(2,1,2)
plot(t_100Hz_middle(i,1),cell2mat(Windspeed_mean(i,2)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(i+1,1),cell2mat(Windspeed_mean(i+1,2)),'og','MarkerFaceColor','g');hold on;
plot(t_100Hz_middle(i,1),cell2mat(Windspeed_corr_mean(i,2)),'om','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(i+1,1),cell2mat(Windspeed_corr_mean(i+1,2)),'ob','MarkerFaceColor','b');hold on;
ylabel('Wind speed (m^{-1})')
xlabel({'Time UTC',Time_range}) 
end
allaxes=findobj(figu,'type','axes','tag', '')
linkaxes(allaxes,'x')


figure('Name','Heading on straight and level runs')
plot(t_100Hz(tranches1(15):tranches1(length(tranches1)-7)),Psi_SBG(tranches1(15):tranches1(length(tranches1)-7)));hold on
for i=1:2:(length(WD_SBG_mean(:,1))-1)
plot(t_100Hz_middle(i,1),cell2mat(Heading_mean(i,3)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(i+1,1),cell2mat(Heading_mean(i+1,3)),'og','MarkerFaceColor','g'); hold on;
ylabel('Heading (degrees)')
legend('','N runs','S runs')
end
xlabel({'Time UTC',Time_range}) 


%%
fg=figure('Name','WD and WS and heading on straight and level runs BOREAL vs MAST')
subplot(3,1,1)
plot(t_100Hz_middle(:,1),cell2mat(WD_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WD_SBG_corr_mean(:,1)),'om','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WD_mat60m_mean),'ok','MarkerFaceColor','k') ; hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('Wind direction (degrees)')
ylim([0 360])
subplot(3,1,2)
plot(t_100Hz_middle(:,1),cell2mat(Windspeed_mean(:,2)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(Windspeed_corr_mean(:,2)),'om','MarkerFaceColor','m'); hold on;
%plot(t_100Hz_middle(:,1),cell2mat(Windspeed_corr_mean(:,2)),'oy','MarkerFaceColor','y'); hold on;
%plot(t_100Hz_middle(:,1),sqrt(cell2mat(NorthWS_mat60m(i)).^2+cell2mat(EastWS_mat60m(i)).^2),'ok','MarkerFaceColor','k')
plot(t_100Hz_middle(:,1),cell2mat(WS_mat60m_mean),'ok','MarkerFaceColor','k'); hold on;
ylabel('Wind speed (m^{-1})')
subplot(3,1,3)
plot(t_100Hz_middle(:,1),cell2mat(Heading_mean(:,3)),'ob','MarkerFaceColor','b'); hold on;
ylabel('Heading (degrees)')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')

fg=figure('Name','WD and WS on straight and level runs BOREAL vs MAST')
subplot(2,1,1)
plot(t_100Hz_middle(:,1),cell2mat(WD_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WD_SBG_corr_mean(:,1)),'om','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WD_mat60m_mean),'ok','MarkerFaceColor','k') ; hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('Wind direction (degrees)')
ylim([0 360])
subplot(2,1,2)
plot(t_100Hz_middle(:,1),cell2mat(Windspeed_mean(:,2)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(Windspeed_corr_mean(:,2)),'om','MarkerFaceColor','m'); hold on;
%plot(t_100Hz_middle(:,1),cell2mat(Windspeed_corr_mean(:,2)),'oy','MarkerFaceColor','y'); hold on;
%plot(t_100Hz_middle(:,1),sqrt(cell2mat(NorthWS_mat60m).^2+cell2mat(EastWS_mat60m).^2),'ok','MarkerFaceColor','k')
plot(t_100Hz_middle(:,1),cell2mat(WS_mat60m_mean),'ok','MarkerFaceColor','k'); hold on;
ylabel('Wind speed (m^{-1})')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')

fg=figure('Name','WD and WS and heading on straight and level runs BOREAL vs MAST')
subplot(4,1,1)
plot(t_100Hz_middle(:,1),cell2mat(WD_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WD_SBG_corr_mean(:,1)),'om','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WD_mat60m_mean),'ok','MarkerFaceColor','k') ; hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('Wind direction (degrees)')
ylim([0 360])
subplot(4,1,2)
plot(t_100Hz_middle(:,1),cell2mat(Windspeed_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(Windspeed_corr_mean(:,1)),'om','MarkerFaceColor','m'); hold on;
%plot(t_100Hz_middle(:,1),cell2mat(Windspeed_corr_mean(:,2)),'oy','MarkerFaceColor','y'); hold on;
%plot(t_100Hz_middle(:,1),sqrt(cell2mat(NorthWS_mat60m).^2+cell2mat(EastWS_mat60m).^2),'ok','MarkerFaceColor','k')
plot(t_100Hz_middle(:,1),cell2mat(WS_mat60m_mean),'ok','MarkerFaceColor','k'); hold on;
ylabel('Wind speed (m^{-1})')
subplot(4,1,3)
plot(t_100Hz_middle(:,1),cell2mat(Heading_mean(:,3)),'ob','MarkerFaceColor','b'); hold on;
ylabel('Heading (degrees)')
subplot(4,1,4)
plot(t_100Hz_middle(:,1),cell2mat(Va_mean),'or'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(Va_mean_corr),'om'); hold on;
legend('Original','Corrected')
ylabel('Airspeed(m.s{-1})')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')


fg1=figure('Name','WIND speed and heading in function of time BOREAL vs MAST')
subplot(2,1,1)
plot(t_60m(BorneInf{1}:BorneSup1{end}),Horizontal_WS_mat60m_Wnan(BorneInf{1}:BorneSup1{end}),'b'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(Windspeed_corr_mean(:,2)),'om','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WS_mat60m_mean(:)),'ok','MarkerFaceColor','k'); hold on;
legend('Mast 60 m','Boreal Corrected','Mast 60 m mean')
ylabel('Wind speed (m/s)')
subplot(2,1,2)
plot(t_100Hz_middle(:,1),cell2mat(Heading_mean(:,3)),'ob','MarkerFaceColor','b'); hold on;
ylabel('Heading (degrees)')
plot(t_100Hz(tranches1(15):tranches1(length(tranches1)-7)),Psi_SBG(tranches1(15):tranches1(length(tranches1)-7)))
allaxes=findobj(fg1,'type','axes','tag', '')
linkaxes(allaxes,'x')

fg2=figure('Name','WIND direction and heading in function of time BOREAL vs MAST')
plot(t_60m(BorneInf{1}:BorneSup1{end}),WD_mat60m_Wnan(BorneInf{1}:BorneSup1{end}),'b'); hold on;
%subplot(3,1,1)
% plot(t_60m(BorneInf{1}:BorneSup1{end}),WD_mat60m_Wnan(BorneInf{1}:BorneSup1{end}),'b'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WD_SBG_corr_mean(:,1)),'om','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WD_mat60m_mean(:)),'ok','MarkerFaceColor','k'); hold on;
%plot(t_100Hz_middle(:,1),cell2mat(WD_SBG_corr_mean(:,3)),'og','MarkerFaceColor','g');
%hold on; %method2
legend('Mast 60 m','Boreal Corrected','Mast 60 m mean')
ylabel('Wind direction (degree)')
% subplot(3,1,2)
% plot(t_100Hz_middle(:,1),cell2mat(Altitude_mean(:,1)),'ob','MarkerFaceColor','b'); hold on;
% ylabel('Altitude asl (m)')
% subplot(3,1,3)
% plot(t_100Hz_middle(:,1),cell2mat(Heading_mean(:,3)),'ob','MarkerFaceColor','b'); hold on;
% ylabel('Heading (degrees)')
% plot(t_100Hz(tranches1(15):tranches1(length(tranches1)-7)),Psi_SBG(tranches1(15):tranches1(length(tranches1)-7)));
% ylim([0,360]);
allaxes=findobj(fg2,'type','axes','tag', '')
linkaxes(allaxes,'x')

% fg=figure('Name','WD and WS and heading and Va and altitude on straight and level runs BOREAL vs MAST')
% for i=1:(length(WD_SBG_mean(:,1))-1)
% subplot(5,1,1)
% plot(t_100Hz_middle(i,1),cell2mat(WD_SBG_mean(i)),'or','MarkerFaceColor','r'); hold on;
% plot(t_100Hz_middle(i,1),cell2mat(WD_SBG_corr_mean(i)),'om','MarkerFaceColor','m'); hold on;
% plot(t_100Hz_middle(i,1),cell2mat(WD_mat60m_mean(i)),'ok','MarkerFaceColor','k') ; hold on;
% legend('Boreal Original','Boreal Corrected','Mast 60 m')
% ylabel('Wind direction (degrees)')
% ylim([0 360])
% subplot(5,1,2)
% plot(t_100Hz_middle(i,1),cell2mat(Windspeed_mean(i,1)),'or','MarkerFaceColor','r'); hold on;
% plot(t_100Hz_middle(i,1),cell2mat(Windspeed_corr_mean(i,1)),'om','MarkerFaceColor','m'); hold on;
% %plot(t_100Hz_middle(i,1),cell2mat(Windspeed_corr_mean(i,2)),'oy','MarkerFaceColor','y'); hold on;
% %plot(t_100Hz_middle(i,1),sqrt(cell2mat(NorthWS_mat60m(i)).^2+cell2mat(EastWS_mat60m(i)).^2),'ok','MarkerFaceColor','k')
% plot(t_100Hz_middle(i,1),cell2mat(WS_mat60m_mean(i)),'ok','MarkerFaceColor','k'); hold on;
% ylabel('Wind speed (m^{-1})')
% subplot(5,1,3)
% plot(t_100Hz,Psi_SBG);hold on;
% plot(t_100Hz_middle(i,1),cell2mat(Heading_mean(i,3)),'ob','MarkerFaceColor','b'); hold on;
% ylabel('Heading (degrees)')
% subplot(5,1,4)
% plot(t_100Hz_middle(i,1),cell2mat(Va_mean(i)),'or'); hold on;
% plot(t_100Hz_middle(i,1),cell2mat(Va_mean_corr(i)),'om'); hold on;
% legend('Original','Corrected')
% ylabel('Airspeed(m.s{-1})')
% subplot(5,1,5)
% plot(t_100Hz,Altitude_interp);hold on;
% plot(t_100Hz_middle(i,1),cell2mat(Altitude_mean(i)),'or'); hold on;
% ylabel('Altitude (m.s)')
% end
% allaxes=findobj(fg,'type','axes','tag', '')
% linkaxes(allaxes,'x')

fg=figure('Name','WIND COMPONENTS and heading on straight and level runs BOREAL vs MAST')
subplot(4,1,1)
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_North_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_North_SBG_mean_corr(:,1)),'*m','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(NorthWS_mat60m(:)),'ok','MarkerFaceColor','k'); hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('North wind speed (m/s)')
subplot(4,1,2)
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_East_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_East_SBG_mean_corr(:,1)),'*m','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(EastWS_mat60m(:)),'ok','MarkerFaceColor','k') ; hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('East wind speed (m/s)')
subplot(4,1,3)
plot(t_100Hz_middle(:,1),cell2mat(Heading_mean(:,3)),'ob','MarkerFaceColor','b'); hold on;
ylabel('Heading (degrees)')
subplot(4,1,4)
plot(t_100Hz_middle(:,1),cell2mat(Va_mean(:)),'or'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(Va_mean_corr(:)),'om'); hold on;
legend('Original','Corrected')
ylabel('Airspeed(m.s{-1})')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')

fg=figure('Name','WIND COMPONENTS on straight and level runs BOREAL vs MAST')
subplot(2,1,1)
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_North_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_North_SBG_mean_corr(:,1)),'*m','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(NorthWS_mat60m(:)),'ok','MarkerFaceColor','k'); hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('North wind speed (m/s)')
subplot(2,1,2)
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_East_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_East_SBG_mean_corr(:,1)),'*m','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(EastWS_mat60m(:)),'ok','MarkerFaceColor','k') ; hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('East wind speed (m/s)')
xlabel({'Time UTC',Time_range})
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')

figure('Name','Airspeed mean')
plot(t_100Hz_middle(:,1),cell2mat(AirSpeed_5hole_corr_mean(:)),'ob','MarkerFaceColor','b'); hold on;
ylabel('Airspeed (m.s^{-1})')
xlabel({'Time UTC',Time_range}) 

figure('Name','Altitude mean')
plot(t_100Hz_middle(:,1),cell2mat(Altitude_mean(:)),'ob','MarkerFaceColor','b'); hold on;
ylabel('Altitude(m)')
xlabel({'Time UTC',Time_range}) 

figure('Name','Altitude mean (article)')
plot(t_100Hz_middle(1:49,1),cell2mat(Altitude_mean(1:49)),'ob','MarkerFaceColor','b'); hold on;
ylabel('Altitude(m)')
xlabel({'Time UTC',Time_range}) 

figure('Name','Heading from BOREAL and its mean')
plot(t_100Hz_middle(:,1),cell2mat(Heading_mean(:,3)),'ob','MarkerFaceColor','b'); hold on;
plot(t_100Hz,Psi_SBG);hold on;
ylabel('Heading (degrees)')
xlabel({'Time UTC',Time_range}) 

figure('Name','East wind speed and heading on straight and level runs BOREAL vs MAST')
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_East_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_East_SBG_mean_corr(:,1)),'*m','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(EastWS_mat60m(:)),'ok','MarkerFaceColor','k') ; hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('East wind speed (m/s)')
xlabel({'Time UTC',Time_range}) 



figure('Name','north wind speed and heading on straight and level runs BOREAL vs MAST')
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_North_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_North_SBG_mean_corr(:,1)),'*m','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(NorthWS_mat60m(:)),'ok','MarkerFaceColor','k'); hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('North wind speed (m/s)')
xlabel({'Time UTC',Time_range}) 


%%

figure('Name','East wind speed and heading on straight and level runs BOREAL vs MAST')
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WindSpeed_East_SBG_mean(1:(length(WD_SBG_mean(:,1))-31))),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WindSpeed_East_SBG_mean_corr(1:(length(WD_SBG_mean(:,1))-31))),'*m','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(EastWS_mat60m(1:(length(WD_SBG_mean(:,1))-31))),'ok','MarkerFaceColor','k') ; hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('East wind speed (m/s)')
xlabel('Time UTC') 


figure('Name','north wind speed and heading on straight and level runs BOREAL vs MAST')
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WindSpeed_North_SBG_mean(1:(length(WD_SBG_mean(:,1))-31))),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WindSpeed_North_SBG_mean_corr(1:(length(WD_SBG_mean(:,1))-31))),'*m','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(NorthWS_mat60m(1:(length(WD_SBG_mean(:,1))-31))),'ok','MarkerFaceColor','k'); hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('North wind speed (m/s)')
xlabel('Time UTC') 

fgn=figure('Name','WD and WS on straight and level runs BOREAL vs MAST (article)')
subplot(2,1,1)
%plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WD_SBG_mean(1:(length(WD_SBG_mean(:,1))-31),3)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WD_SBG_corr_mean(1:(length(WD_SBG_mean(:,1))-31),1)),'om','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WD_mat60m_mean(1:(length(WD_SBG_mean(:,1))-31))),'ok','MarkerFaceColor','k') ; hold on;
legend('Boreal ','60 m Mast')
ylabel('Wind direction (degrees)')
ylim([0 360])
subplot(2,1,2)
%plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(Windspeed_mean(1:(length(WD_SBG_mean(:,1))-31),1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(Windspeed_corr_mean(1:(length(WD_SBG_mean(:,1))-31),1)),'om','MarkerFaceColor','m'); hold on;
%plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(Windspeed_corr_mean(1:(length(WD_SBG_mean(:,1))-31),2)),'oy','MarkerFaceColor','y'); hold on;
%plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),sqrt(cell2mat(NorthWS_mat60m(1:(length(WD_SBG_mean(:,1))-31))).^2+cell2mat(EastWS_mat60m(1:(length(WD_SBG_mean(:,1))-31))).^2),'ok','MarkerFaceColor','k')
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WS_mat60m_mean(1:(length(WD_SBG_mean(:,1))-31))),'ok','MarkerFaceColor','k'); hold on;
ylabel('Wind speed (m^{-1})')
xlabel('Time UTC')
allaxes=findobj(fgn,'type','axes','tag', '')
linkaxes(allaxes,'x')

fg=figure('Name','WIND COMPONENTS on straight and level runs BOREAL vs MAST (article)')
subplot(2,1,1)
%plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WindSpeed_North_SBG_mean(1:(length(WD_SBG_mean(:,1))-31),1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WindSpeed_North_SBG_mean_corr(1:(length(WD_SBG_mean(:,1))-31),1)),'*m','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(NorthWS_mat60m(1:(length(WD_SBG_mean(:,1))-31))),'ok','MarkerFaceColor','k'); hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('North wind speed (m/s)')
subplot(2,1,2)
%plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WindSpeed_East_SBG_mean(1:(length(WD_SBG_mean(:,1))-31),1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WindSpeed_East_SBG_mean_corr(1:(length(WD_SBG_mean(:,1))-31),1)),'*m','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(EastWS_mat60m(1:(length(WD_SBG_mean(:,1))-31))),'ok','MarkerFaceColor','k') ; hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('East wind speed (m/s)')
xlabel('Time UTC')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')

%%%%% STD Non corrigé Article
Mean_WD_all_seq_all_cos_article=mean(cosd(cell2mat(WD_SBG_mean(1:49,1))));
Mean_WD_all_seq_all_sin_article=mean(sind(cell2mat(WD_SBG_mean(1:49,1))));
Mean_WD_all_seq_all_article=mod(atan2d(Mean_WD_all_seq_all_sin_article,Mean_WD_all_seq_all_cos_article),360);
epsilon_article=sqrt(1-(Mean_WD_all_seq_all_sin_article^2+Mean_WD_all_seq_all_cos_article^2)); %methode 2 est meilleure
std_WD_article=asind(epsilon_article)*[1+0.1547*epsilon_article^3];

%%%%%%%%%%%%%% STD corrigé Article
Mean_WD_all_seq_all_cos_corr_article=mean(cosd(cell2mat(WD_SBG_corr_mean(1:49,1))));
Mean_WD_all_seq_all_sin_corr_article=mean(sind(cell2mat(WD_SBG_corr_mean(1:49,1))));
Mean_WD_all_seq_all_corr_article=mod(atan2d(Mean_WD_all_seq_all_sin_corr_article,Mean_WD_all_seq_all_cos_corr_article),360);
epsilon_corr_article=sqrt(1-(Mean_WD_all_seq_all_sin_corr_article^2+Mean_WD_all_seq_all_cos_corr_article^2)); %methode 2
std_WD_corr_article=asind(epsilon_corr_article)*[1+0.1547*epsilon_corr_article^3];

%%%%% STD WS article
std_WS_corr_article=std(cell2mat(Windspeed_corr_mean(1:49,2)));
std_WS_article=std(cell2mat(Windspeed_mean(1:49,2)));


fgn=figure('Name','WD and WS on straight and level runs BOREAL vs MAST')
subplot(2,1,1)
%plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(WD_SBG_mean(1:(length(WD_SBG_mean(:,1))-31),3)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))),1),cell2mat(WD_SBG_corr_mean(1:(length(WD_SBG_mean(:,1))),1)),'om','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))),1),cell2mat(WD_mat60m_mean(1:(length(WD_SBG_mean(:,1))))),'ok','MarkerFaceColor','k') ; hold on;
legend('Boreal after correction','60 m Mast')
ylabel('Wind direction (degrees)')
ylim([0 360])
subplot(2,1,2)
%plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(Windspeed_mean(1:(length(WD_SBG_mean(:,1))-31),1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))),1),cell2mat(Windspeed_corr_mean(1:(length(WD_SBG_mean(:,1))),1)),'om','MarkerFaceColor','m'); hold on;
%plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),cell2mat(Windspeed_corr_mean(1:(length(WD_SBG_mean(:,1))-31),2)),'oy','MarkerFaceColor','y'); hold on;
%plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))-31),1),sqrt(cell2mat(NorthWS_mat60m(1:(length(WD_SBG_mean(:,1))-31))).^2+cell2mat(EastWS_mat60m(1:(length(WD_SBG_mean(:,1))-31))).^2),'ok','MarkerFaceColor','k')
plot(t_100Hz_middle(1:(length(WD_SBG_mean(:,1))),1),cell2mat(WS_mat60m_mean(1:(length(WD_SBG_mean(:,1))))),'ok','MarkerFaceColor','k'); hold on;
ylabel('Wind speed (m^{-1})')
xlabel('Time UTC')
allaxes=findobj(fgn,'type','axes','tag', '')
linkaxes(allaxes,'x')

fg=figure('Name','WIND COMPONENTS on straight and level runs BOREAL vs MAST')
subplot(2,1,1)
%plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_North_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_North_SBG_mean_corr(:,1)),'*m','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(NorthWS_mat60m(:)),'ok','MarkerFaceColor','k'); hold on;
ylabel('North wind speed (m/s)')
legend('Boreal after Correction','Mast 60 m')
subplot(2,1,2)
%plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_East_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_East_SBG_mean_corr(:,1)),'*m','MarkerFaceColor','m'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(EastWS_mat60m(:)),'ok','MarkerFaceColor','k') ; hold on;
ylabel('East wind speed (m/s)')
xlabel('Time UTC')
allaxes=findobj(fg,'type','axes','tag', '');
linkaxes(allaxes,'x')

fg=figure('Name','WIND COMPONENTS on straight and level runs BOREAL  ')
subplot(2,1,1)
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_North_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_North_SBG_mean_corr(:,1)),'*g','MarkerFaceColor','m'); hold on;
%plot(t_100Hz_middle(:,1),cell2mat(NorthWS_mat60m(:)),'ok','MarkerFaceColor','k'); hold on;
legend('Boreal before correction','Boreal after correction')
ylabel('North wind speed (m/s)')
subplot(2,1,2)
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_East_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WindSpeed_East_SBG_mean_corr(:,1)),'*g','MarkerFaceColor','m'); hold on;
%plot(t_100Hz_middle(:,1),cell2mat(EastWS_mat60m(:)),'ok','MarkerFaceColor','k') ; hold on;
legend('Boreal Original','Boreal Corrected','Mast 60 m')
ylabel('East wind speed (m/s)')
xlabel('Time UTC')
allaxes=findobj(fg,'type','axes','tag', '')
linkaxes(allaxes,'x')

fgn=figure('Name','WD and WS on straight and level runs BOREAL ')
subplot(2,1,1)
plot(t_100Hz_middle(:,1),cell2mat(WD_SBG_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(WD_SBG_corr_mean(:,1)),'og','MarkerFaceColor','g'); hold on;
%plot(t_100Hz_middle(:,1),cell2mat(WD_mat60m_mean(:)),'ok','MarkerFaceColor','k') ; hold on;
legend('Boreal before correction','Boreal after correction')
ylabel('Wind direction (degrees)')
ylim([0 360])
subplot(2,1,2)
plot(t_100Hz_middle(:,1),cell2mat(Windspeed_mean(:,1)),'or','MarkerFaceColor','r'); hold on;
plot(t_100Hz_middle(:,1),cell2mat(Windspeed_corr_mean(:,1)),'og','MarkerFaceColor','g'); hold on;
%plot(t_100Hz_middle(:,1),cell2mat(Windspeed_corr_mean(:,2)),'oy','MarkerFaceColor','y'); hold on;
%plot(t_100Hz_middle(:,1),sqrt(cell2mat(NorthWS_mat60m(:)).^2+cell2mat(EastWS_mat60m(:)).^2),'ok','MarkerFaceColor','k')
%plot(t_100Hz_middle(:,1),cell2mat(WS_mat60m_mean(:)),'ok','MarkerFaceColor','k'); hold on;
ylabel('Wind speed (m^{-1})')
xlabel('Time UTC')
allaxes=findobj(fgn,'type','axes','tag', '')
linkaxes(allaxes,'x')

%%  WD and WS and VE and VN BOreal versus mast WITH STANDARD DEVIATION


fgstd=figure('Name','WD and WS on straight and level runs BOREAL vs Mast WITH STD')
subplot(2,1,1)
errorbar( time_100Hz_middle(:,1),cell2mat(WD_mat60m_mean(:)),cell2mat(WD_std_equ25_mast(:,1)),'ok','Markersize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
%errorbar( time_100Hz_middle(:,1),cell2mat(WD_SBG_mean(:,1)),cell2mat(WD_std_equ25(:)),'or','Markersize',5,'MarkerFaceColor','r','MarkerEdgeColor','r');
hold on;
errorbar( time_100Hz_middle(:,1),cell2mat(WD_SBG_corr_mean(:,1)),cell2mat(WD_std_equ25_corr(:)),'om','Markersize',5,'MarkerFaceColor','m','MarkerEdgeColor','m');
legend('60m Mast','Boreal ')
ylabel('Wind direction (degrees)')
ylim([0 360])
subplot(2,1,2)
errorbar( time_100Hz_middle(:,1),cell2mat(WS_mat60m_mean(:)),cell2mat(WS_mat60m_std(:)),'ok','Markersize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
%errorbar( time_100Hz_middle(:,1),cell2mat(Windspeed_mean(:,1)),cell2mat(Windspeed_std(:)),'ok','Markersize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
hold on;
errorbar( time_100Hz_middle(:,1),cell2mat(Windspeed_corr_mean(:,1)),cell2mat(Windspeed_corr_std(:)),'om','Markersize',5,'MarkerFaceColor','m','MarkerEdgeColor','m');
ylabel('Wind speed (m^{-1})')
xlabel('Time elapsed since take off (s)')
allaxes=findobj(fgstd,'type','axes','tag', '')
linkaxes(allaxes,'x')

fgstd=figure('Name','WD and WS on straight and level runs BOREAL vs Mast WITH STD (article)')
subplot(2,1,1)
plot(time_100Hz(tranches1(15):tranches(113))-time_100Hz(1),WD_SBG_corr(tranches1(15):tranches(113)),'m');hold on;
plot((t_60m_sec(BorneInf{1}:BorneSup1{43})-t_60m_sec(S_b_t)),WD_mat60m_Wnan(BorneInf{1}:BorneSup1{43}),'k'); hold on;
errorbar( time_100Hz_middle(1:49,1),cell2mat(WD_mat60m_mean(1:49)),cell2mat(WD_std_equ25_mast(1:49,1)),'ok','Markersize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
%errorbar( time_100Hz_middle(:,1),cell2mat(WD_SBG_mean(:,1)),cell2mat(WD_std_equ25(:)),'or','Markersize',5,'MarkerFaceColor','r','MarkerEdgeColor','r');
hold on;
errorbar( time_100Hz_middle(1:49,1),cell2mat(WD_SBG_corr_mean(1:49,1)),cell2mat(WD_std_equ25_corr(1:49)),'om','Markersize',5,'MarkerFaceColor','m','MarkerEdgeColor','m');
legend('Boreal','60m Mast','Boreal','60m Mast')
ylabel('Wind direction (degrees)')
ylim([0 360])
subplot(2,1,2)
plot(time_100Hz(tranches1(15):tranches(113))-time_100Hz(1),Horizontal_windSpeed_SBG_corr(tranches1(15):tranches(113)),'m');hold on;
plot((t_60m_sec(BorneInf{1}:BorneSup1{43})-t_60m_sec(S_b_t)),Horizontal_WS_mat60m_Wnan(BorneInf{1}:BorneSup1{43}),'k'); hold on;
errorbar( time_100Hz_middle(1:49,1),cell2mat(WS_mat60m_mean(1:49)),cell2mat(WS_mat60m_std(1:49)),'ok','Markersize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
hold on;
errorbar( time_100Hz_middle(1:49,1),cell2mat(Windspeed_corr_mean(1:49,1)),cell2mat(Windspeed_corr_std(1:49)),'om','Markersize',5,'MarkerFaceColor','m','MarkerEdgeColor','m');
ylabel('Wind speed (m^{-1})')
xlabel('Time elapsed since take off (s)')
allaxes=findobj(fgstd,'type','axes','tag', '')
linkaxes(allaxes,'x')

fgstd=figure('Name','WD and WS on straight and level runs BOREAL vs Mast WITH STD (article)')
subplot(2,1,1)
errorbar( time_100Hz_middle(1:49,1),cell2mat(WD_mat60m_mean(1:49)),cell2mat(WD_std_equ25_mast(1:49,1)),'ok','Markersize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
%errorbar( time_100Hz_middle(:,1),cell2mat(WD_SBG_mean(:,1)),cell2mat(WD_std_equ25(:)),'or','Markersize',5,'MarkerFaceColor','r','MarkerEdgeColor','r');
hold on;
errorbar( time_100Hz_middle(1:49,1),cell2mat(WD_SBG_corr_mean(1:49,1)),cell2mat(WD_std_equ25_corr(1:49)),'om','Markersize',5,'MarkerFaceColor','m','MarkerEdgeColor','m');
legend('60m Mast','Boreal ')
ylabel('Wind direction (degrees)')
ylim([0 360])
subplot(2,1,2)
errorbar( time_100Hz_middle(1:49,1),cell2mat(WS_mat60m_mean(1:49)),cell2mat(WS_mat60m_std(1:49)),'ok','Markersize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
%errorbar( time_100Hz_middle(:,1),cell2mat(Windspeed_mean(:,1)),cell2mat(Windspeed_std(:)),'ok','Markersize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
hold on;
errorbar( time_100Hz_middle(1:49,1),cell2mat(Windspeed_corr_mean(1:49,1)),cell2mat(Windspeed_corr_std(1:49)),'om','Markersize',5,'MarkerFaceColor','m','MarkerEdgeColor','m');
ylabel('Wind speed (m^{-1})')
xlabel('Time elapsed since take off (s)')
allaxes=findobj(fgstd,'type','axes','tag', '')
linkaxes(allaxes,'x')

figure('Name','WD on straight and level runs BOREAL vs Mast WITH STD')
errorbar( time_100Hz_middle(:,1),cell2mat(WD_mat60m_mean(:)),cell2mat(WD_std_equ25_mast(:,1)),'ok','Markersize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
%errorbar( time_100Hz_middle(:,1),cell2mat(WD_SBG_mean(:,1)),cell2mat(WD_std_equ25(:)),'or','Markersize',5,'MarkerFaceColor','r','MarkerEdgeColor','r');
hold on;
errorbar( time_100Hz_middle(:,1),cell2mat(WD_SBG_corr_mean(:,1)),cell2mat(WD_std_equ25_corr(:)),'om','Markersize',5,'MarkerFaceColor','m','MarkerEdgeColor','m');
legend('60m Mast','Boreal ')
ylabel('Wind direction (degrees)')
ylim([0 360])


figure('Name',' WS on straight and level runs BOREAL vs Mast WITH STD')
errorbar( time_100Hz_middle(:,1),cell2mat(WS_mat60m_mean(:)),cell2mat(WS_mat60m_std(:)),'ok','Markersize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
hold on;
errorbar( time_100Hz_middle(:,1),cell2mat(Windspeed_corr_mean(:,1)),cell2mat(Windspeed_corr_std(:)),'om','Markersize',5,'MarkerFaceColor','m','MarkerEdgeColor','m');
ylabel('Wind speed (m^{-1})')
xlabel('Time elapsed since take off (s)')
legend('60m Mast','Boreal ')

%% Determination of coefficient correction

%%%%%%%%%%% Alpha_corr correction%%%%%%%%%%%%%

Delta_W_Alpha_corr=AirSpeed_5hole_corr.*[sind(Alpha_corr).*cosd(Beta).*sind(Theta_SBG)+cosd(Alpha_corr).*cosd(Beta).*cosd(Phi_SBG).*cosd(Theta_SBG)];
dAlpha_corr=-mean(Vertical_WS2)/mean(Delta_W_Alpha_corr);

%%%%%%%%%%%%%Beta Correction%%%%%%%%
Delta_W_Beta=AirSpeed_5hole_corr.*[cosd(Alpha_corr).*sind(Beta).*sind(Theta_SBG)+cosd(Beta).*sind(Phi_SBG).*cosd(Theta_SBG)-sind(Alpha_corr).*sind(Beta).*cosd(Phi_SBG).*cosd(Theta_SBG)];
cov_W_phi=cov(Vertical_WS2,sind(Phi_SBG(2:end)));
cov_delta_phi=cov(Delta_W_Beta,sind(Phi_SBG));

dBeta=-cov_W_phi(1,2)/cov_delta_phi(1,2);


%%
%%%%%%%%% Alpha_corr correction on one sequence %%%%%%%%%%%%%

k=1;
for i=15:2:(length(tranches1)-7)
Delta_W_Alpha_corr_seq1{k,1}=AirSpeed_5hole(tranches(i):tranches(i+1)).*(sind(Alpha_corr(tranches(i):tranches(i+1))).*cosd(Beta(tranches(i):tranches(i+1))).*sind(Theta_SBG(tranches(i):tranches(i+1)))+cosd(Alpha_corr(tranches(i):tranches(i+1))).*cosd(Beta(tranches(i):tranches(i+1))).*cosd(Phi_SBG(tranches(i):tranches(i+1))).*cosd(Theta_SBG(tranches(i):tranches(i+1))));
dAlpha_corr_seq{k,1}=-mean(Vertical_WS2(tranches(i):tranches(i+1)))/mean(Delta_W_Alpha_corr_seq1{k,1});

%%%%%%%%%%%%%Beta Correction on one seuence %%%%%%%%
Delta_W_Beta_seq1{k,1}=AirSpeed_5hole(tranches(i):tranches(i+1)).*(cosd(Alpha_corr(tranches(i):tranches(i+1))).*sind(Beta(tranches(i):tranches(i+1))).*sind(Theta_SBG(tranches(i):tranches(i+1)))+cosd(Beta(tranches(i):tranches(i+1))).*sind(Phi_SBG(tranches(i):tranches(i+1))).*cosd(Theta_SBG(tranches(i):tranches(i+1)))-sind(Alpha_corr(tranches(i):tranches(i+1))).*sind(Beta(tranches(i):tranches(i+1))).*cosd(Phi_SBG(tranches(i):tranches(i+1))).*cosd(Theta_SBG(tranches(i):tranches(i+1))));
cov_W_phi_seq1{k,1}=cov(Vertical_WS2(tranches(i):tranches(i+1)),sind(Phi_SBG(tranches(i):tranches(i+1))));
cov_W_phi_seq1{k,1}=cov_W_phi_seq1{k,1}(1,2);
cov_delta_phi_seq1{k,1}=cov(Delta_W_Beta_seq1{k,1},sind(Phi_SBG(tranches(i):tranches(i+1))));
cov_delta_phi_seq1{k,1}=cov_delta_phi_seq1{k,1}(1,2);

dBeta_seq{k,1}=-cov_W_phi_seq1{k,1}/cov_delta_phi_seq1{k,1};

k=k+1;
end

Alpha_corr_correction=mean(cell2mat(dAlpha_corr_seq));
Beta_correction=mean(cell2mat(dBeta_seq));

%%
MAE_VN=mean(abs(cell2mat(NorthWS_mat60m')-cell2mat(WindSpeed_North_SBG_mean_corr)));
MAE_VE=mean(abs(cell2mat(EastWS_mat60m')-cell2mat(WindSpeed_East_SBG_mean_corr)));

std_VN_diff_mast_boreal=std(cell2mat(NorthWS_mat60m')-cell2mat(WindSpeed_North_SBG_mean_corr));
std_VE_diff_mast_boreal=std(cell2mat(EastWS_mat60m')-cell2mat(WindSpeed_East_SBG_mean_corr));


MAE_WS=mean(abs(cell2mat(WS_mat60m_mean')-cell2mat(Windspeed_corr_mean(:,2))));
%MAE_WD=mean(abs(cell2mat(WD_mat60m_mean')-cell2mat(WD_SBG_corr_mean(:,1))));

std_WS_diff_mast_boreal=std(cell2mat(WS_mat60m_mean')-cell2mat(Windspeed_corr_mean(:,2)));
%std_WD_diff_mast_boreal=std(cell2mat(WD_mat60m_mean')-cell2mat(WD_SBG_corr_mean(:,1)));

MAE_WS_article=mean(abs(cell2mat(WS_mat60m_mean(1:49)')-cell2mat(Windspeed_corr_mean(1:49,2))));
MAE_WD_article=mean(abs(cell2mat(WD_mat60m_mean(1:49)')-cell2mat(WD_SBG_corr_mean(1:49,1))));

std_WS_diff_mast_boreal_article=std(cell2mat(WS_mat60m_mean(1:49)')-cell2mat(Windspeed_corr_mean(1:49,2)));

%%%%% STD WS article
std_WS_corr_article=std(cell2mat(Windspeed_corr_mean(1:49,2)));
std_WS_Mast_article=std(cell2mat(WS_mat60m_mean(1:49)));


%%%%%%%%%%%%%% STD MAST Article
Mean_WD_cos_MAST_article=mean(cosd(cell2mat(WD_mat60m_mean(1:49))));
Mean_WD_MAST_sin_article=mean(sind(cell2mat(WD_mat60m_mean(1:49))));
Mean_WD_MAST_article=mod(atan2d(Mean_WD_MAST_sin_article,Mean_WD_cos_MAST_article),360);
epsilon_mast_article=sqrt(1-(Mean_WD_MAST_sin_article^2+Mean_WD_cos_MAST_article^2)); %methode 2
std_WD_mast_article=asind(epsilon_mast_article)*[1+0.1547*epsilon_mast_article^3];

%%%%%%%%%%%%%% STD (mast-boreal)) Article
diff_mast_boreal=abs(cell2mat(WD_mat60m_mean(1:49)')-cell2mat(WD_SBG_corr_mean(1:49,1)));
Mean_WD_diff_cos_article=mean(cosd(diff_mast_boreal));
Mean_WD_diff_sin_article=mean(sind(diff_mast_boreal));
Mean_WD_diff_article=mod(atan2d(Mean_WD_diff_sin_article,Mean_WD_diff_cos_article),360);
epsilon_diff_article=sqrt(1-(Mean_WD_diff_sin_article^2+Mean_WD_diff_cos_article^2)); %methode 2
std_WD_diff_article=asind(epsilon_diff_article)*[1+0.1547*epsilon_diff_article^3];



% Traitement_mat_resampled
% close all
% Spectre_Ueast_auto
% close all
%  Spectre_Vnorth_auto
%  close all
%  Spectre_W_auto
%  close all