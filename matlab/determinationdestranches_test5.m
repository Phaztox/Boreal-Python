clear qp1 tranches tranches1 i jimp dpair kimp limp mimp aimp bimp jpair kpair lpair n mpair apair bpair apair_test mpair_test mimpdebimp1 mimpdebimp2 indiceimpaire tranchesimp dimp cimp ki qi  ji tranchesimpf mpairdebpair1 mpairdebpair2 indicespair tranchespair dpair cpair tranchespair jp kp qp jp tranchespairf tranches tranchespairf1 tranchesimprf tranches_test
%Determination of straight and level flight runs
% In order to re-use this code, it's important to change the limits of
% 'jimp' and 'kimp' and 'jpair' 

%Indices de tranches impaires ( allers)
jimp=find(abs(Psi-255)<= 10);  % Heading angle limits
kimp=find(abs(Psi-298)<= 5 );  % Heading angle limits
rimp=find(abs(Psi-300)<= 6 );  % Heading angle limits
simp=find(abs(Psi-270)<= 5 );  % Heading angle limits
uimp=find(abs(Psi-212)<= 10 );  % Heading angle limits
fimp=find(abs(Psi-217)<= 15 );  % Heading angle limits
vimp=find(abs(Psi-220)<= 10 );  % Heading angle limits
wimp=find(abs(Psi-300)<= 8 );  % Heading angle limits
yimp=find(abs(Psi-265)<= 5 );  % Heading angle limits
dimp=find(abs(Psi-272)<= 8 );  % Heading angle limits
gimp=find(abs(Psi-220)<= 6 );  % Heading angle limits
himp=find(abs(Psi-212)<= 12 );  % Heading angle limits
limp1=union(jimp,kimp);
limp2=union(limp1,rimp);
limp3=union(limp2,simp);
limp4=union(limp3,uimp);
limp5=union(limp4,vimp);
limp6=union(limp5,wimp);
limp7=union(limp6,yimp);
limp8=union(limp7,dimp);
limp9=union(limp8,gimp);
limp10=union(limp9,fimp);
limp=union(limp10,himp);
n=find(Resampled_ADnav_25hzto100(:,8) > 147);
mimp=intersect(n,limp);%tous les indices de toutes les tranches impaires ( tranches où le drone se dirige vers le nord 'allers')
dimp=intersect(mimp,find(abs(Phi)<15));
%dimp=mimp;
ddimp=diff(dimp);
bimp_test=find(ddimp>1);%Permet de detecter la separation entre deux tranches.

%Indices de tranches paires ( retours)
jpair=find(abs(Psi-53)<= 5 );  % Heading angle limits
kpair=find(abs(Psi-90)<= 10 );  % Heading angle limits
rpair=find(abs(Psi-100)<= 5 );  % Heading angle limits
spair=find(abs(Psi-73)<= 10 );  % Heading angle limits
upair=find(abs(Psi-38)<= 7 );  % Heading angle limits
ypair=find(abs(Psi-60)<= 5 );  % Heading angle limits
vpair=find(abs(Psi-92)<= 5 );  % Heading angle limits
wpair=find(abs(Psi-104)<= 5 );  % Heading angle limits
dpair=find(abs(Psi-75)<= 4 );  % Heading angle limits
gpair=find(abs(Psi-40)<= 3 );  % Heading angle limits
hpair=find(abs(Psi-25)<= 5 );  % Heading angle limits
pair1=union(jpair,kpair);
pair2=union(pair1,rpair);
pair3=union(pair2,spair);
pair4=union(pair3,upair);
pair5=union(pair4,ypair);
pair6=union(pair5,vpair);
pair7=union(pair6,wpair);
pair8=union(pair7,dpair);
pair9=union(pair8,gpair);
pair=union(pair9,hpair);
n=find(Resampled_ADnav_25hzto100(:,8) > 147);
mpair=intersect(n,pair);%Indices de tranches impaires ( allers)
apair=diff(mpair);% calculer la différence entre deux éléments successifs pour distinguer chaque tranche impaire.
%bpair=find(apair>3000);%Permet de detecter la separation entre deux tranches.
dpair=intersect(mpair,find(abs(Phi)<15));
%dpair=mpair;
ddpair=diff(dpair);
bpair_test=find(ddpair>1);%Permet de detecter la separation entre deux tranches.

mimpdebimp1=dimp(bimp_test);
mimpdebimp2=dimp(bimp_test+1);
indiceimpaire=sort([mimpdebimp1;mimpdebimp2]);
tranchesimp=sort([dimp(1);indiceimpaire]);
tranchesimp=sort([tranchesimp;dimp(end)]);

qi=[];
ki=1;
for li=1:2:(length(tranchesimp)-1)
         qi(ki,1)=tranchesimp(li+1)-tranchesimp(li);       
 ki=ki+1;
end

tranchesimpf=[];
 ji=1;
for ki=1:length(qi)
   
 if qi(ki)>1000 
     tranchesimpf(ji,1)=tranchesimp(2*ki-1);
     tranchesimpf(ji+1,1)=tranchesimp(2*ki);
 end
     ji=ji+2;
end

imp=find(tranchesimpf>0);
tranchesimpf1=tranchesimpf(imp);
% tranchesimpf1=[tranchesimp(1);tranchesimpf(imp)];
% tranchesimpf1=[tranchesimpf1;tranchesimp(end)];

%vecteur qui regroupe tous les indices des tranches paires

mpairdebpair1=dpair(bpair_test);
mpairdebpair2=dpair(bpair_test+1);
indicespair=sort([mpairdebpair1;mpairdebpair2]);
tranchespair=sort([dpair(1);indicespair]);
tranchespair=sort([tranchespair;dpair(end)]);

qp=[];
kp=1;
for lp=1:2:(length(tranchespair)-1)
         qp(kp,1)=tranchespair(lp+1)-tranchespair(lp);       
 kp=kp+1;
end

 jp=1;
for kp=1:length(qp)
   
 if qp(kp)>1000 
     tranchespairf(jp,1)=tranchespair(2*kp-1);
     tranchespairf(jp+1,1)=tranchespair(2*kp);
     jp=jp+2;
 end
end    

pr=find(tranchespairf>0);
tranchespairf1=tranchespairf(pr); 
% tranchespairf1=[tranchespair(1);tranchespairf1];
% tranchespairf1=[tranchespairf1;tranchespair(end)];% le tableau avec les indices des tranches paires 
%==========VECTEUR TOUTES LES TRANCHES=================
tranches_test=sort([tranchesimp;tranchespair]);
tranches=sort([tranchesimpf1;tranchespairf1]);

qp1=[];
ki=1;
for li=1:2:(length(tranches)-1)
         qp1(ki,1)=tranches(li+1)-tranches(li);       
 ki=ki+1;
end
 jp=1;
for kp1=1:length(qp1)
   
 if qp1(kp1)>1000 
     tranches1(jp,1)=tranches(2*kp1-1);
     tranches1(jp+1,1)=tranches(2*kp1);
     jp=jp+2;
 end
end    

 f1=figure('Name','Euler angles')
subplot(3,1,1)
plot(t_100Hz_3004,Phi,'b')
ylabel('roll angle')
subplot(3,1,2)
plot(t_100Hz_3004,Theta);ylabel('Pitch angle')
subplot(3,1,3)
plot(t_100Hz_3004,Psi,'b');ylabel('Heading angle')
hold on;
for i=1:2:length(tranches1)-1
plot(t_100Hz_3004(tranches1(i):tranches1(i+1)),Psi(tranches1(i):tranches1(i+1)))
end
xlabel('time')
allaxes=findobj(f1,'type','axes','tag', '')
linkaxes(allaxes,'x')

f2=figure('Name','Euler angles2')
subplot(3,1,1)
plot(t_100Hz_3004,Phi,'b')
ylabel('roll angle')
subplot(3,1,2)
plot(t_100Hz_3004,Theta);ylabel('Pitch angle')
subplot(3,1,3)
plot(t_100Hz_3004,Psi,'b');ylabel('Heading angle')
hold on;
for i=1:2:length(tranches)-1
plot(t_100Hz_3004(tranches(i):tranches(i+1)),Psi(tranches(i):tranches(i+1)))
hold on;
end
xlabel('time')
allaxes=findobj(f2,'type','axes','tag', '')
linkaxes(allaxes,'x')

f3=figure('Name','Euler angles3')
subplot(3,1,1)
plot(t_100Hz_3004,Phi,'b')
ylabel('roll angle')
subplot(3,1,2)
plot(t_100Hz_3004,Theta);ylabel('Pitch angle')
subplot(3,1,3)
plot(t_100Hz_3004,Psi,'b');ylabel('Heading angle')
hold on;
for i=1:2:length(tranches_test)-1
plot(t_100Hz_3004(tranches_test(i):tranches_test(i+1)),Psi(tranches_test(i):tranches_test(i+1)))
hold on;
end
hold on;
xlabel('time')
allaxes=findobj(f3,'type','axes','tag', '')
linkaxes(allaxes,'x')

load Tranches1
f1=figure('Name','Euler angles4')
subplot(3,1,1)
plot(t_100Hz_3004,Phi,'b')
ylabel('roll angle')
subplot(3,1,2)
plot(t_100Hz_3004,Theta);ylabel('Pitch angle')
subplot(3,1,3)
plot(t_100Hz_3004,Psi,'b');ylabel('Heading angle')
hold on;
for i=1:2:length(Tranches1)-1
plot(t_100Hz_3004(Tranches1(i):Tranches1(i+1)),Psi(Tranches1(i):Tranches1(i+1)))
end
xlabel('time')
allaxes=findobj(f1,'type','axes','tag', '')
linkaxes(allaxes,'x')