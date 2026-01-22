figure('Name','3D WS SBG; 1st part')

Y =  lat_interp(Tranches1(17):Tranches1(21));
X =  long_interp(Tranches1(17):Tranches1(21));
Z =  Horizontal_windSpeed_SBG(Tranches1(17):Tranches1(21)); % in m/s
C = Horizontal_windSpeed_SBG(Tranches1(17):Tranches1(21));
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;Z(:);nan],...
      'CData', [nan;C(:);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
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
hold on;
Y7 =  47.089872;
X7 =  -1.905770;
text(X7+0.0005,Y7,'Tower')
plot(X7,Y7,'o')
hold on;
line([X1,X2],[Y1,Y2],'LineStyle','--')
text((X1+X2)/2-.0005,(Y1+Y2)/2,'360 m')
hold on;
line([X2,X5],[Y2,Y5],'LineStyle','--')
text((X2+X5)/2-0.001,(Y2+Y5)/2,'1 km')
hold on;
view([0,0,1])
barre=colorbar;
barre.Label.String = 'WS (using SBG data) (m/s))';
title ('GS');
xlabel('Longitude (degrees) [SBG data]');
ylabel('Latitude  (degrees) [SBG data]');
zlabel('Height agl (m)');
colormap turbo

% %% figure('Name','3D WS SBG; 1st part')
% for i=3:2:(11)
% Y =  lat_interp(Tranches1(i):Tranches1(i+1));
% X =  long_interp(Tranches1(i):Tranches1(i+1));
% Z =  Horizontal_windSpeed_SBG(Tranches1(i):Tranches1(i+1)); % in m/s
% C = Horizontal_windSpeed_SBG(Tranches1(i):Tranches1(i+1));
% % patch('XData', [nan;X(:);nan],...
% %       'YData', [nan;Y(:);nan],...
% %       'ZData', [nan;Z(:);nan],...
% %       'CData', [nan;C(:);nan],...
% %       'FaceColor', 'interp', ...
% %       'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
% geoplot(Y,X)
% hold on;
% end
% hold on;
% Y1 =  47.0910862;
% X1 =  -1.9242482;
% text(X1+0.0005,Y1,'T1')
% geoplot(Y1,X1,'o')
% hold on;
% Y2 =  47.0896387;
% X2 =   -1.9200307;
% text(X2+0.0005,Y2,'T2')
% geoplot(Y2,X2,'o')
% hold on;
% Y3 =  47.0881907;
% X3 = -1.9158266;
% text(X3+0.0005,Y3,'T3')
% geoplot(Y3,X3,'o')
% hold on;
% Y4 =  47.0944458;
% X4 =  -1.9086843;
% text(X4+0.0005,Y4,'T4')
% geoplot(Y4,X4,'o')
% hold on;
% Y5 =  47.0928155;
% X5 =  -1.9057454;
% text(X5+0.0005,Y5,'T5')
% geoplot(Y5,X5,'o')
% hold on;
% Y6 =  47.0911936;
% X6 =  -1.9028205;
% text(X6+0.0005,Y6,'T6')
% geoplot(Y6,X6,'o')
% view([0,0,1])
% barre=colorbar;
% barre.Label.String = 'WS (using SBG data) (m/s))';
% title ('GS');
% % xlabel('Longitude (degrees) [SBG data]');
% % ylabel('Latitude  (degrees) [SBG data]');
% % zlabel('Height agl (m)');

%% figure('Name','3D WS SBG; 1st part')
for i=3:2:(11)
Y =  lat_interp(Tranches1(i):Tranches1(i+1));
X =  long_interp(Tranches1(i):Tranches1(i+1));
U =  WindSpeed_East_SBG(Tranches1(i):Tranches1(i+1)); % in m/s
V = WindSpeed_North_SBG(Tranches1(i):Tranches1(i+1));
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;U(:);nan],...
      'CData', [nan;sqrt(V.^2+U.^2);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
hold on;
quiver(X(1:100:end),Y(1:100:end),U(1:100:end),V(1:100:end),'LineWidth',1)
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
line([X1,X2],[Y1,Y2],'LineStyle','--')
text((X1+X2)/2-.0005,(Y1+Y2)/2,'360 m')
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
hold on;
Y7 =  47.089872;
X7 =  -1.905770;
text(X7+0.0005,Y7,'Tower')
plot(X7,Y7,'o')
hold on;
line([X2,X5],[Y2,Y5],'LineStyle','--')
text((X2+X5)/2-0.001,(Y2+Y5)/2,'1 km')
hold on;
% northarrow('latitude',47.0459,'longitude', -1.5443);
% hold on;
view([0,0,1])
barre=colorbar;
barre.Label.String = 'WS (using SBG data) (m/s))';
title ('GS');
xlabel('Longitude (degrees) [SBG data]');
ylabel('Latitude  (degrees) [SBG data]');
zlabel('Height agl (m)');
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
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
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
hold on;Y7 =  47.089872;
X7 =  -1.905770;
text(X7+0.0005,Y7,'Tower')
plot(X7,Y7,'o')
hold on;
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
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
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
hold on;
Y7 =  47.089872;
X7 =  -1.905770;
text(X7+0.0005,Y7,'Tower')
plot(X7,Y7,'o')
hold on;
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
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
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
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
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
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
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
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
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
hold on;
Y7 =  47.089872;
X7 =  -1.905770;
text(X7+0.0005,Y7,'Tower')
plot(X7,Y7,'o')
hold on;
view([0,0,1])
barre=colorbar;
barre.Label.String = 'WS (using SBG data) (m/s))';
title ('GS');
xlabel('Longitude (degrees) [SBG data]');
ylabel('Latitude  (degrees) [SBG data]');
zlabel('Height agl (m)');

%%

figure('Name','3D WS SBG; 2nd and 6 th and 4th part when flying at 90 m agl')
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
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
hold on;
end
hold on;
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
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
hold on;
end
hold on;
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
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
hold on;
end
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
hold on;
Y7 =  47.089872;
X7 =  -1.905770;
text(X7+0.0005,Y7,'Tower')
plot(X7,Y7,'o')
hold on;
view([0,0,1])
barre=colorbar;
barre.Label.String = 'WS (using SBG data) (m/s))';
title ('GS');
xlabel('Longitude (degrees) [SBG data]');
ylabel('Latitude  (degrees) [SBG data]');
zlabel('Height agl (m)');
colormap turbo
%%
figure('Name','3D WS SBG; 3nd, 5th and 7th part when flying at 110 m asl')
for i=45:2:(75)
Y =  lat_interp(Tranches1(i):Tranches1(i+1));
X =  long_interp(Tranches1(i):Tranches1(i+1));
Z =  Altitude_interp100Hz(Tranches1(i):Tranches1(i+1)); % in m/s
%Z = Horizontal_windSpeed_SBG(Tranches1(i):Tranches1(i+1));
C = Horizontal_windSpeed_SBG(Tranches1(i):Tranches1(i+1));
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;Z(:);nan],...
      'CData', [nan;C(:);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
hold on;
end
hold on;
for i=105:2:(135)
Y =  lat_interp(Tranches1(i):Tranches1(i+1));
X =  long_interp(Tranches1(i):Tranches1(i+1));
Z =  Altitude_interp100Hz(Tranches1(i):Tranches1(i+1)); % in m/s
%Z = Horizontal_windSpeed_SBG(Tranches1(i):Tranches1(i+1));
C = Horizontal_windSpeed_SBG(Tranches1(i):Tranches1(i+1));
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;Z(:);nan],...
      'CData', [nan;C(:);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
hold on;
end
hold on;
for i=169:2:(195)
Y =  lat_interp(Tranches1(i):Tranches1(i+1));
X =  long_interp(Tranches1(i):Tranches1(i+1));
Z =  Altitude_interp100Hz(Tranches1(i):Tranches1(i+1)); % in m/s
%Z = Horizontal_windSpeed_SBG(Tranches1(i):Tranches1(i+1));
C = Horizontal_windSpeed_SBG(Tranches1(i):Tranches1(i+1));
patch('XData', [nan;X(:);nan],...
      'YData', [nan;Y(:);nan],...
      'ZData', [nan;Z(:);nan],...
      'CData', [nan;C(:);nan],...
      'FaceColor', 'interp', ...
      'EdgeColor', 'interp','Marker','o','MarkerFaceColor','flat')
hold on;
end
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
hold on;
Y7 =  47.089872;
X7 =  -1.905770;
text(X7+0.0005,Y7,'Tower')
plot(X7,Y7,'o')
hold on;
view(3)
%view([0,0,1])
barre=colorbar;
barre.Label.String = 'WS (using SBG data) (m/s))';
title ('GS');
xlabel('Longitude (degrees) [SBG data]');
ylabel('Latitude  (degrees) [SBG data]');
zlabel('Height agl (m)');
colormap turbo

%%
figure('Name','3D WS SBG; 1st part')
Y =  lat_interp(:);
X =  long_interp(:);
Z =  Horizontal_windSpeed_SBG(:); % in m/s
C = Horizontal_windSpeed_SBG(:);
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
hold on;
Y7 =  47.089872;
X7 =  -1.905770;
text(X7+0.0005,Y7,'Tower')
plot(X7,Y7,'o')
hold on;
line([X1,X2],[Y1,Y2],'LineStyle','--')
text((X1+X2)/2-.0005,(Y1+Y2)/2,'360 m')
hold on;
line([X2,X5],[Y2,Y5],'LineStyle','--')
text((X2+X5)/2-0.001,(Y2+Y5)/2,'1 km')
hold on;
view([0,0,1])
barre=colorbar;
barre.Label.String = 'WS (using SBG data) (m/s))';
title ('GS');
xlabel('Longitude (degrees) [SBG data]');
ylabel('Latitude  (degrees) [SBG data]');
zlabel('Height agl (m)');
colormap turbo

