f5=figure('Name','Euler angles2')
subplot(5,1,1)
plot(t_100Hz_3004,Phi,'b')
ylabel('roll angle')
subplot(5,1,2)
plot(t_100Hz_3004,Psi,'b');ylabel('Heading angle')
subplot(5,1,3)
plot(t_100Hz_3004,sind(Psi),'b');ylabel('Heading angle (sin)')
subplot(5,1,4)
plot(t_100Hz_3004(2:end),diff(sind(Psi)),'b');ylabel('Heading angle (diff de sin)')
subplot(5,1,5)
plot(t_100Hz_3004,cosd(Psi),'b');ylabel('Heading angle (cos)')
xlabel('time')
allaxes=findobj(f5,'type','axes','tag', '')
linkaxes(allaxes,'x')


clear qp1 tranches tranches1 i jimp dpair kimp jimp limp mimp aimp bimp jpair kpair lpair n mpair apair bpair apair_test mpair_test mimpdebimp1 mimpdebimp2 indiceimpaire tranchesimp dimp cimp ki qi  ji tranchesimpf mpairdebpair1 mpairdebpair2 indicespair tranchespair dpair cpair tranchespair jp kp qp jp tranchespairf tranches tranchespairf1 tranchesimprf tranches_test
%Determination of straight and level flight runs
% In order to re-use this code, it's important to change the limits of
% 'jimp' and 'kimp' and 'jpair' 

%Indices de tranches impaires ( allers)
dsP=diff(sind(Psi));
jimp=find(abs(dsP)<=0.0007);  % Heading angle limits
ddimp=diff(jimp);
bimp_test=find(ddimp>200);%Permet de detecter la separation entre deux tranches.

mimpdebimp1=jimp(bimp_test);
mimpdebimp2=jimp(bimp_test+1);
indiceimpaire=sort([mimpdebimp1;mimpdebimp2]);


f1=figure('Name','Euler angles4')
subplot(3,1,1)
plot(t_100Hz_3004,Phi,'b')
ylabel('roll angle')
subplot(3,1,2)
plot(t_100Hz_3004,Theta);ylabel('Pitch angle')
subplot(3,1,3)
plot(t_100Hz_3004,Psi,'b');ylabel('Heading angle')
hold on;
for i=1:2:length(indiceimpaire)-1
plot(t_100Hz_3004(indiceimpaire(i):indiceimpaire(i+1)),Psi(indiceimpaire(i):indiceimpaire(i+1)))
end
xlabel('time')
allaxes=findobj(f1,'type','axes','tag', '')
linkaxes(allaxes,'x')