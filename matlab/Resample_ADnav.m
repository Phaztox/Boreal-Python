load Vol5_momenta.mat
%load('log_lannemezan.mat')
Seuil_bas=6;
Seuil_haut= 680924;

Seuil_bas_p=51;
Seuil_haut_p= 6809240;


%% Resample data of AD NAVIGATION
data5_ADnav=data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,:);

Resample_ADnav_label={'Time','SystStatus','FilterStatus','Unixtime','MicroSecondes','Latitude(Rad)','Longitude(Rad)','Height','VitesseNord','VitesseEast','VitesseDown','Acceleration_X','Acceleration_Y','Acceleration_Z','G','Roll','Pitch','Heading','AngularVelocity_X','AngularVelocity_Y','AngularVelocity_Z','LatitudeStandardDeviation','LongitudeStandardDeviation','HeightStandardDeviation','Secondes','TSmilli','Compteur100hz'}


k=1;
for i=1:length(data5.AD_NAVIGATION(Seuil_bas:Seuil_haut,26))-1

    if (data5_ADnav(i+1,26)-data5_ADnav(i,26))==0 
 
        ADnav_vol5(k,27)=data5_ADnav(i,27);
        ADnav_vol5(k,26)=data5_ADnav(i,26);
        ADnav_vol5(k,25)=data5_ADnav(i,25);
        ADnav_vol5(k,24)=data5_ADnav(i,24);
        ADnav_vol5(k,23)=data5_ADnav(i,23);
        ADnav_vol5(k,22)=data5_ADnav(i,22);
        ADnav_vol5(k,21)=data5_ADnav(i,21);
        ADnav_vol5(k,20)=data5_ADnav(i,20);
        ADnav_vol5(k,19)=data5_ADnav(i,19);
        ADnav_vol5(k,18)=data5_ADnav(i,18);
        ADnav_vol5(k,17)=data5_ADnav(i,17);
        ADnav_vol5(k,16)=data5_ADnav(i,16);
        ADnav_vol5(k,15)=data5_ADnav(i,15);
        ADnav_vol5(k,14)=data5_ADnav(i,14);
        ADnav_vol5(k,13)=data5_ADnav(i,13);
        ADnav_vol5(k,12)=data5_ADnav(i,12);
        ADnav_vol5(k,11)=data5_ADnav(i,11);
        ADnav_vol5(k,10)=data5_ADnav(i,10);
        ADnav_vol5(k,9)=data5_ADnav(i,9);
        ADnav_vol5(k,8)=data5_ADnav(i,8);
        ADnav_vol5(k,7)=data5_ADnav(i,7);
        ADnav_vol5(k,6)=data5_ADnav(i,6);
        ADnav_vol5(k,5)=data5_ADnav(i,5);
        ADnav_vol5(k,4)=data5_ADnav(i,4);
        ADnav_vol5(k,3)=data5_ADnav(i,3);
        ADnav_vol5(k,2)=data5_ADnav(i,2);
        ADnav_vol5(k,1)=data5_ADnav(i,1);
    else 
        k=k+1;
        
        ADnav_vol5(k,27)=data5_ADnav(i+1,27);
        ADnav_vol5(k,26)=data5_ADnav(i+1,26);
        ADnav_vol5(k,25)=data5_ADnav(i+1,25);
        ADnav_vol5(k,24)=data5_ADnav(i+1,24);
        ADnav_vol5(k,23)=data5_ADnav(i+1,23);
        ADnav_vol5(k,22)=data5_ADnav(i+1,22);
        ADnav_vol5(k,21)=data5_ADnav(i+1,21);
        ADnav_vol5(k,20)=data5_ADnav(i+1,20);
        ADnav_vol5(k,19)=data5_ADnav(i+1,19);
        ADnav_vol5(k,18)=data5_ADnav(i+1,18);
        ADnav_vol5(k,17)=data5_ADnav(i+1,17);
        ADnav_vol5(k,16)=data5_ADnav(i+1,16);
        ADnav_vol5(k,15)=data5_ADnav(i+1,15);
        ADnav_vol5(k,14)=data5_ADnav(i+1,14);
        ADnav_vol5(k,13)=data5_ADnav(i+1,13);
        ADnav_vol5(k,12)=data5_ADnav(i+1,12);
        ADnav_vol5(k,11)=data5_ADnav(i+1,11);
        ADnav_vol5(k,10)=data5_ADnav(i+1,10);
        ADnav_vol5(k,9)=data5_ADnav(i+1,9);
        ADnav_vol5(k,8)=data5_ADnav(i+1,8);
        ADnav_vol5(k,7)=data5_ADnav(i+1,7);
        ADnav_vol5(k,6)=data5_ADnav(i+1,6);
        ADnav_vol5(k,5)=data5_ADnav(i+1,5);
        ADnav_vol5(k,4)=data5_ADnav(i+1,4);
        ADnav_vol5(k,3)=data5_ADnav(i+1,3);
        ADnav_vol5(k,2)=data5_ADnav(i+1,2);
        ADnav_vol5(k,1)=data5_ADnav(i+1,1);
    end
end
   
[Resampled_ADnav_25hzto100,time_adnav_tes] =resample(ADnav_vol5,ADnav_vol5(:,26),0.1,1,1);

% Resample roll
poub=[Resampled_ADnav_25hzto100(:,16),Resampled_ADnav_25hzto100(:,26)];
x=cosd(poub(:,1));
y=sind(poub(:,1));
x1=resample(x,poub(:,2),0.1,1,1,'linear');
y1=resample(y,poub(:,2),0.1,1,1,'linear');
Resampled_ADnav_25hzto100(:,16)= atan2d(y1,x1);
% Resample pitch
poub=[Resampled_ADnav_25hzto100(:,17),Resampled_ADnav_25hzto100(:,26)];
x=cosd(poub(:,1));
y=sind(poub(:,1));
x1=resample(x,poub(:,2),0.1,1,1,'linear');
y1=resample(y,poub(:,2),0.1,1,1,'linear');
Resampled_ADnav_25hzto100(:,17)=(atan2d(y1,x1));

% Pitch_interp_sin = interp1(time_resampled,Pitch_resampled_sin,time_100Hz);
% Pitch_interp_sin = fillmissing(Pitch_interp_sin,'linear');
% Pitch_interp_cos = interp1(time_resampled,Pitch_resampled_cos,time_100Hz);
% Pitch_interp_cos = fillmissing(Pitch_interp_cos,'linear');
% Pitch_interp=atan2d(Pitch_interp_sin,Pitch_interp_cos);
% % Heading
poub=[Resampled_ADnav_25hzto100(:,18),Resampled_ADnav_25hzto100(:,26)];
x=cosd(poub(:,1));
y=sind(poub(:,1));
x1=resample(x,poub(:,2),0.1,1,1,'linear');
y1=resample(y,poub(:,2),0.1,1,1,'linear');
Resampled_ADnav_25hzto100(:,18)=mod(atan2d(y1,x1),360);


fig=figure('Name','Comparison before and after resample')
subplot(5,2,1)
plot(Resampled_ADnav_25hzto100(:,26),Resampled_ADnav_25hzto100(:,6),'r')
ylabel('Latitude (rad)')
hold on;
plot(ADnav_vol5(:,26),ADnav_vol5(:,6),'b')
legend('Resampled','original')
subplot(5,2,2)
plot(Resampled_ADnav_25hzto100(:,26),Resampled_ADnav_25hzto100(:,7),'r')
ylabel('Longitude (rad)')
hold on;
plot(ADnav_vol5(:,26),ADnav_vol5(:,7),'b')
legend('Resampled','original')
subplot(5,2,3)
plot(Resampled_ADnav_25hzto100(:,26),Resampled_ADnav_25hzto100(:,8),'r')
ylabel('Height (m)')
hold on;
plot(ADnav_vol5(:,26),ADnav_vol5(:,8),'b')
legend('Resampled','original')
subplot(5,2,4)
plot(Resampled_ADnav_25hzto100(:,26),Resampled_ADnav_25hzto100(:,9),'r')
ylabel('Vitesse nord')
hold on;
plot(ADnav_vol5(:,26),ADnav_vol5(:,9),'b')
legend('Resampled','original')
subplot(5,2,5)
plot(Resampled_ADnav_25hzto100(:,26),Resampled_ADnav_25hzto100(:,10),'r')
ylabel('Vitesse est')
hold on;
plot(ADnav_vol5(:,26),ADnav_vol5(:,10),'b')
legend('Resampled','original')
subplot(5,2,6)
plot(Resampled_ADnav_25hzto100(:,26),Resampled_ADnav_25hzto100(:,11),'r')
ylabel('Vitesse verticale')
hold on;
plot(ADnav_vol5(:,26),ADnav_vol5(:,11),'b')
legend('Resampled','original')
subplot(5,2,7)
plot(Resampled_ADnav_25hzto100(:,26),Resampled_ADnav_25hzto100(:,16),'r')
ylabel('Roll')
hold on;
plot(ADnav_vol5(:,26),ADnav_vol5(:,16),'b')
legend('Resampled','original')
subplot(5,2,8)
plot(Resampled_ADnav_25hzto100(:,26),Resampled_ADnav_25hzto100(:,17),'r')
ylabel('picth')
hold on;
plot(ADnav_vol5(:,26),ADnav_vol5(:,17),'b')
legend('Resampled','original')
subplot(5,2,9)
plot(Resampled_ADnav_25hzto100(:,26),Resampled_ADnav_25hzto100(:,18),'r')
ylabel('Heading')
hold on;
plot(ADnav_vol5(:,26),ADnav_vol5(:,18),'b')
legend('Resampled','original')
allaxes=findobj(fig,'type','axes','tag', '')
linkaxes(allaxes,'x')


[Resample_ADnav_25hz,time_adnav_25hz] =resample(ADnav_vol5,ADnav_vol5(:,26),0.025,1,1);
%%  With timout filling

% [data5_ADnav_timeout,time1] =resample(data5_ADnav,data5_ADnav(:,27),1,1,1); % in m/s
% 
% k=1;
% for i=1:length(data5_ADnav_timeout(:,26))-1
% 
%     if (data5_ADnav_timeout(i+1,26)-data5_ADnav_timeout(i,26))==0 
%  
%         ADnav_vol5_timeout(k,27)=data5_ADnav_timeout(i,27);
%         ADnav_vol5_timeout(k,26)=data5_ADnav_timeout(i,26);
%         ADnav_vol5_timeout(k,25)=data5_ADnav_timeout(i,25);
%         ADnav_vol5_timeout(k,24)=data5_ADnav_timeout(i,24);
%         ADnav_vol5_timeout(k,23)=data5_ADnav_timeout(i,23);
%         ADnav_vol5_timeout(k,22)=data5_ADnav_timeout(i,22);
%         ADnav_vol5_timeout(k,21)=data5_ADnav_timeout(i,21);
%         ADnav_vol5_timeout(k,20)=data5_ADnav_timeout(i,20);
%         ADnav_vol5_timeout(k,19)=data5_ADnav_timeout(i,19);
%         ADnav_vol5_timeout(k,18)=data5_ADnav_timeout(i,18);
%         ADnav_vol5_timeout(k,17)=data5_ADnav_timeout(i,17);
%         ADnav_vol5_timeout(k,16)=data5_ADnav_timeout(i,16);
%         ADnav_vol5_timeout(k,15)=data5_ADnav_timeout(i,15);
%         ADnav_vol5_timeout(k,14)=data5_ADnav_timeout(i,14);
%         ADnav_vol5_timeout(k,13)=data5_ADnav_timeout(i,13);
%         ADnav_vol5_timeout(k,12)=data5_ADnav_timeout(i,12);
%         ADnav_vol5_timeout(k,11)=data5_ADnav_timeout(i,11);
%         ADnav_vol5_timeout(k,10)=data5_ADnav_timeout(i,10);
%         ADnav_vol5_timeout(k,9)=data5_ADnav_timeout(i,9);
%         ADnav_vol5_timeout(k,8)=data5_ADnav_timeout(i,8);
%         ADnav_vol5_timeout(k,7)=data5_ADnav_timeout(i,7);
%         ADnav_vol5_timeout(k,6)=data5_ADnav_timeout(i,6);
%         ADnav_vol5_timeout(k,5)=data5_ADnav_timeout(i,5);
%         ADnav_vol5_timeout(k,4)=data5_ADnav_timeout(i,4);
%         ADnav_vol5_timeout(k,3)=data5_ADnav_timeout(i,3);
%         ADnav_vol5_timeout(k,2)=data5_ADnav_timeout(i,2);
%         ADnav_vol5_timeout(k,1)=data5_ADnav_timeout(i,1);
%     else 
%         k=k+1;
%         
%         ADnav_vol5_timeout(k,27)=data5_ADnav_timeout(i+1,27);
%         ADnav_vol5_timeout(k,26)=data5_ADnav_timeout(i+1,26);
%         ADnav_vol5_timeout(k,25)=data5_ADnav_timeout(i+1,25);
%         ADnav_vol5_timeout(k,24)=data5_ADnav_timeout(i+1,24);
%         ADnav_vol5_timeout(k,23)=data5_ADnav_timeout(i+1,23);
%         ADnav_vol5_timeout(k,22)=data5_ADnav_timeout(i+1,22);
%         ADnav_vol5_timeout(k,21)=data5_ADnav_timeout(i+1,21);
%         ADnav_vol5_timeout(k,20)=data5_ADnav_timeout(i+1,20);
%         ADnav_vol5_timeout(k,19)=data5_ADnav_timeout(i+1,19);
%         ADnav_vol5_timeout(k,18)=data5_ADnav_timeout(i+1,18);
%         ADnav_vol5_timeout(k,17)=data5_ADnav_timeout(i+1,17);
%         ADnav_vol5_timeout(k,16)=data5_ADnav_timeout(i+1,16);
%         ADnav_vol5_timeout(k,15)=data5_ADnav_timeout(i+1,15);
%         ADnav_vol5_timeout(k,14)=data5_ADnav_timeout(i+1,14);
%         ADnav_vol5_timeout(k,13)=data5_ADnav_timeout(i+1,13);
%         ADnav_vol5_timeout(k,12)=data5_ADnav_timeout(i+1,12);
%         ADnav_vol5_timeout(k,11)=data5_ADnav_timeout(i+1,11);
%         ADnav_vol5_timeout(k,10)=data5_ADnav_timeout(i+1,10);
%         ADnav_vol5_timeout(k,9)=data5_ADnav_timeout(i+1,9);
%         ADnav_vol5_timeout(k,8)=data5_ADnav_timeout(i+1,8);
%         ADnav_vol5_timeout(k,7)=data5_ADnav_timeout(i+1,7);
%         ADnav_vol5_timeout(k,6)=data5_ADnav_timeout(i+1,6);
%         ADnav_vol5_timeout(k,5)=data5_ADnav_timeout(i+1,5);
%         ADnav_vol5_timeout(k,4)=data5_ADnav_timeout(i+1,4);
%         ADnav_vol5_timeout(k,3)=data5_ADnav_timeout(i+1,3);
%         ADnav_vol5_timeout(k,2)=data5_ADnav_timeout(i+1,2);
%         ADnav_vol5_timeout(k,1)=data5_ADnav_timeout(i+1,1);
%     end
%  
% end
%    
% [Resampled_ADnav_25hzto100_timeout,time_100] =resample(ADnav_vol5_timeout,ADnav_vol5_timeout(:,26),0.1,1,1);
% 
% %[Resample_ADnav_25hz_timeout,time_25hz] =resample(ADnav_vol5_timeout,ADnav_vol5_timeout(:,26),0.025,1,1);
% 
% figure('Name','Comparison before and after resample')
% plot(Resampled_ADnav_25hzto100_timeout(:,26),Resampled_ADnav_25hzto100_timeout(:,6),'r')
% ylabel('Latitude (rad)')
% hold on;
% plot(ADnav_vol5_timeout(:,26),ADnav_vol5_timeout(:,6),'b')
% legend('Resampled','original')
%Meme resultat que sans combler le temps mort 
%%
plot(ADnav_vol5(:,26))

figure('Name','Flight path 2D')
plot(ADnav_vol5(:,6),ADnav_vol5(:,7))
ylabel('Longitude (radians)')
xlabel('Latitude (radians)')

figure('Name','Longitude')
plot((ADnav_vol5(:,26)-ADnav_vol5(1,26))./10^3,ADnav_vol5(:,7))
ylabel('Longitude (radians)')
xlabel('Time')

% figure('Name','Static pressure measured by BOreal versus OUR')
% plot(t1(Seuil_bas_log:Seuil_haut_log)-t1(Seuil_bas_log),log_lannemezan(Seuil_bas_log:Seuil_haut_log,20)./100)
% hold on; plot((data5.Pressures(Seuil_bas_p:Seuil_haut_p,27)-data5.Pressures(Seuil_bas_p,27))./10^3,p_Stat2_NR)
% xlabel('Time elapsed since take off')
% ylabel('Baro')

% k=1;
% Time_diff25Hz=diff(ADnav_vol5(:,26));
% ADnav_vol5_100Hz=[];
% for i=1:(length(ADnav_vol5(:,26))-1)
%     if(Time_diff25Hz(i)>39)
%     ADnav_vol5_100Hz(k,1)= ADnav_vol5(i,26);
%     ADnav_vol5_100Hz(k+1,1)= ADnav_vol5(i,26)+10;
%     ADnav_vol5_100Hz(k+2,1)= ADnav_vol5(i,26)+20;
%     ADnav_vol5_100Hz(k+3,1)= ADnav_vol5(i,26)+30;
%     k=k+4;
%     else
%     ADnav_vol5_100Hz(k,1)= ADnav_vol5(i,26);
%     k=k+1;
%     end
%     
%     if(Time_diff25Hz(i)>29 && Time_diff25Hz(i)<39)
%     ADnav_vol5_100Hz(k,1)= ADnav_vol5(i,26);
%     ADnav_vol5_100Hz(k+1,1)= ADnav_vol5(i,26)+10;
%     ADnav_vol5_100Hz(k+2,1)= ADnav_vol5(i,26)+20;
%     k=k+3;
%     else 
%     ADnav_vol5_100Hz(k,1)= ADnav_vol5(i,26);
%     k=k+1;
%     end
%     
%     if(Time_diff25Hz(i)>19 && Time_diff25Hz(i)<29)
%     ADnav_vol5_100Hz(k,1)= ADnav_vol5(i,26);
%     ADnav_vol5_100Hz(k+1,1)= ADnav_vol5(i,26)+10;
%     k=k+2;
%     else 
%     ADnav_vol5_100Hz(k,1)= ADnav_vol5(i,26);
%     k=k+1;
%     end
%    
% end

% k=1;
% Time_diff25Hz=diff(ADnav_vol5(:,26));
% ADnav_vol5_100Hz=[];
% for i=1:(length(ADnav_vol5(:,26))-1)
%     if (diff(diff(diff(data5_ADnav(i,26))))==0)
%     ADnav_vol5_100Hz(k,1)= ADnav_vol5(i,26);
%     ADnav_vol5_100Hz(k+1,1)= ADnav_vol5(i,26)+10;
%     ADnav_vol5_100Hz(k+2,1)= ADnav_vol5(i,26)+20;
%     ADnav_vol5_100Hz(k+3,1)= ADnav_vol5(i,26)+30;
%     k=k+4;
%     end
%     if (diff(data5_ADnav(i,26))))==0)
% end
% 
% k=1;
% Time_diff25Hz=diff(ADnav_vol5(:,26));
% ADnav_vol5_100Hz=[];
% for i=1:(length(ADnav_vol5(:,26))-1)   
%     ADnav_vol5_100Hz(k,1)= ADnav_vol5(i,26);
%     ADnav_vol5_100Hz(k+1,1)= ADnav_vol5(i,26)+10;
%     ADnav_vol5_100Hz(k+2,1)= ADnav_vol5(i,26)+20;
%     ADnav_vol5_100Hz(k+3,1)= ADnav_vol5(i,26)+30;
%     k=k+4;
% end

% ADnav_vol5_100Hz=[ADnav_vol5_100Hz;ADnav_vol5(end,26)];
% 
% k=1;
% ADnav_vol5_1000Hz=[];
% for i=1:(length(ADnav_vol5_100Hz(:,1))-1)
%     
%     ADnav_vol5_1000Hz(k,1)= ADnav_vol5_100Hz(i,1);
%     ADnav_vol5_1000Hz(k+1,1)= ADnav_vol5_100Hz(i,1)+1;
%     ADnav_vol5_1000Hz(k+2,1)= ADnav_vol5_100Hz(i,1)+2;
%     ADnav_vol5_1000Hz(k+3,1)= ADnav_vol5_100Hz(i,1)+3;
%     ADnav_vol5_1000Hz(k+4,1)= ADnav_vol5_100Hz(i,1)+4;
%     ADnav_vol5_1000Hz(k+5,1)= ADnav_vol5_100Hz(i,1)+5;
%     ADnav_vol5_1000Hz(k+6,1)= ADnav_vol5_100Hz(i,1)+6;
%     ADnav_vol5_1000Hz(k+7,1)= ADnav_vol5_100Hz(i,1)+7;
%     ADnav_vol5_1000Hz(k+8,1)= ADnav_vol5_100Hz(i,1)+8;
%     ADnav_vol5_1000Hz(k+9,1)= ADnav_vol5_100Hz(i,1)+9;
%     
%     k=k+10;
% end
%     ADnav_vol5_1000Hz=[ADnav_vol5_1000Hz;ADnav_vol5_100Hz(end)];
%     


%% Resample pressure data

Pressures_1000Hz=data5.Pressures(Seuil_bas_p:Seuil_haut_p,12:25);
Pressures_1000Hz_label={'Baro1 HCEM STAT','Baro2 HCEM STAT','Pressure1HCE2 Sonde 5T','Pressure2HCE3 Sonde 5T','Pressure3HCE4 Pitot','Pressure4HCE5 Pitot','Pressure5HCE10 HAUT-BAS','Pressure6HCE10 HAUT-BAS','Pressure7HCE10 GAUCHE-DROITE','Pressure8HCE10 GAUCHE-DROITE','LDE1 HAUT-BAS BRUT','LDE2 GAUCHE-DROITE BRUT','LDE1 HAUT-BAS','LDE2 GAUCHE-DROITE','TSmilli'};

k=1;
Pressures_100Hz=[];
for i=1:10:length(Pressures_1000Hz)-9
  
    Pressures_100Hz(k,:)=mean(Pressures_1000Hz(i:i+9,:),1);  
 k=k+1; 
end

Resampled_Pressures_label={'Baro1 HCEM STAT','Baro2 HCEM STAT','Pressure1HCE2 Sonde 5T','Pressure2HCE3 Sonde 5T','Pressure3HCE4 Pitot','Pressure4HCE5 Pitot','Pressure5HCE10 HAUT-BAS','Pressure6HCE10 HAUT-BAS','Pressure7HCE10 GAUCHE-DROITE','Pressure8HCE10 GAUCHE-DROITE','LDE1 HAUT-BAS BRUT','LDE2 GAUCHE-DROITE BRUT','LDE1 HAUT-BAS','LDE2 GAUCHE-DROITE','TSmilli'};
Pressures_100Hz(:,15)=data5.Pressures(Seuil_bas_p:10:Seuil_haut_p,27);

[Resampled_Pressures,time_p] =resample(Pressures_100Hz(:,:),Pressures_100Hz(:,15),0.1,1,1); %Resampling at 100Hz

figure('Name','Comparison between resampled and non resampled data')
plot(Pressures_100Hz(:,15),Pressures_100Hz(:,2)); hold on; 
plot(Resampled_Pressures(:,15),Resampled_Pressures(:,2))

figure('Name','Comparison between resampled and averaged data on 10 values and resampled data taking one value from 10')
plot(Resample_p_100Hz(:,13),'b');hold on;plot(Resampled_Pressures(:,2))
label('Resampled 1 from 10','Resampled average on 10')


figure('Name','Comparison between resampled and averaged data on 10 values and resampled data taking one value from 10')
plot(Resample_p_100Hz(:,13),'b');hold on;plot(Resampled_Pressures(:,2))
label('Resampled 1 from 10','Resampled average on 10')


pressures_1000Hz=data5.Pressures(Seuil_bas_p:Seuil_haut_p,1:end);  
pressures_100Hz=data5.Pressures(Seuil_bas_p:10:Seuil_haut_p,1:end);  

[Resample_p_100Hz,time_p_100] =resample(pressures_100Hz,pressures_100Hz(:,27),0.1,1,1);
 

figure('Name','Comparison between resampled and non resampled data')
plot(pressures_100Hz(:,16)); hold on; 
plot(Resample_p_100Hz(:,16))


%% Resample temperature data

TH=[data5.TH(Seuil_bas:Seuil_haut,6:7),data5.TH(Seuil_bas:Seuil_haut,11)];

Resampled_TH_label={'Temp1','Hum1'};

[Resampled_TH,time_TH] =resample(TH,TH(:,3),0.1,1,1); %Resampling at 100Hz

figure('Name','Comparison between resampled and non resampled data')
plot(TH(:,3),TH(:,1),'b'); hold on; 
plot(Resampled_TH(:,3),Resampled_TH(:,1),'r')
legend('Brut','resampled')


T2=[filloutliers(data5.T2(Seuil_bas:Seuil_haut,3),'linear'),data5.T2(Seuil_bas:Seuil_haut,5)];


figure;hold on;plot(data5.T2(Seuil_bas:Seuil_haut,3),'b');plot(T2(:,1),'r');
legend('Original','without outliers')

Resampled_T2_label={'Temp1','Hum1'};

[Resampled_T2,time_T2] =resample(T2,T2(:,2),0.1,1,1); %Resampling at 100Hz

figure('Name','Comparison between resampled and non resampled data')
plot(T2(:,2),T2(:,1),'b'); hold on; 
plot(Resampled_T2(:,2),Resampled_T2(:,1),'r')
legend('Brut','resampled')

