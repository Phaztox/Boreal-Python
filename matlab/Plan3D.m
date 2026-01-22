figure('Name','3D WS SBG; 1st part')
for i=3:2:(11)
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

%% Tous le vol
load WindSpeed_East_SBG_mean_corr_wholeFlight.mat
load WindSpeed_North_SBG_mean_corr_wholeFlight.mat
figure('Name','3D WS SBG')
Y =  lat_interp(Tranches1(11):Tranches1(end));
X =  long_interp(Tranches1(11):Tranches1(end));
Z =  Horizontal_windSpeed_SBG(Tranches1(11):Tranches1(end)); % in m/s
C = Horizontal_windSpeed_SBG(Tranches1(11):Tranches1(end));
% patch('XData', [nan;X(:);nan],...
%       'YData', [nan;Y(:);nan],...
%       'ZData', [nan;Z(:);nan],...
%       'CData', [nan;C(:);nan],...
%       'FaceColor', 'interp', ...
%       'EdgeColor', 'interp')
plot(X,Y,'b')
hold on;
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
%title ('GS');
% xlabel('Longitude (degrees) [SBG data]');
% ylabel('Latitude  (degrees) [SBG data]');
% zlabel('Height agl (m)');
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
%title ('GS');
xlabel('Longitude (degrees)','FontSize',12,'FontWeight','bold');% [SBG data]
ylabel('Latitude  (degrees) ','FontSize',12,'FontWeight','bold');% [SBG data]
zlabel('Height agl (m)');
%colormap jet
hold on
Y8 =  47.095;
X8 =  -1.90;
text(X8,Y8,'WD');
quiver(X8,Y8,WindSpeed_East_SBG_mean_corr_wholeFlight,WindSpeed_North_SBG_mean_corr_wholeFlight,0.0003,'LineWidth',2,'MaxHeadSize',250,'color',[0 0 1]);

%%
figure('Name','3D WS SBG; 2nd part')
for i=13:2:(43)
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

%%
figure('Name','3D WS SBG; 3th part')
for i=45:2:(75)
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
%%
figure('Name','3D WS SBG; 4th part')
for i=77:2:(99)
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

%%
figure('Name','3D WS SBG; 5th part')
for i=105:2:(135)
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
%%
figure('Name','3D WS SBG; 6th part')
for i=137:2:(167)
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

figure('Name','3D WS SBG; 7th part')
for i=169:2:(195)
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