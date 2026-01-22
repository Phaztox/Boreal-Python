clear qp1 tranches tranches1 i jimp dpair kimp limp mimp aimp bimp jpair kpair lpair n mpair apair bpair apair_test mpair_test mimpdebimp1 mimpdebimp2 indiceimpaire tranchesimp dimp cimp ki qi  ji tranchesimpf mpairdebpair1 mpairdebpair2 indicespair tranchespair dpair cpair tranchespair jp kp qp jp tranchespairf tranches
%Determination of straight and level flight runs
% In order to re-use this code, it's important to change the limits of
% 'jimp' and 'kimp' and 'jpair' 
% Keep the limits of i  between -5 and 5 degrees. 
load Resampled_ADnav_100Hz

%Indices de tranches impaires ( allers)
jimp=find(abs(Psi-255)<= 5);  % Heading angle limits
rimp=find(abs(Psi-300)<= 10 );  % Heading angle limits
uimp=find(abs(Psi-212)<= 5 );  % Heading angle limits
vimp=find(abs(Psi-220)<= 5 );  % Heading angle limits
wimp=find(abs(Psi-300)<= 5 );  % Heading angle limits
yimp=find(abs(Psi-265)<= 5 );  % Heading angle limits
dimp=find(abs(Psi-270)<= 5 );  % Heading angle limits
gimp=find(abs(Psi-220)<= 5 );  % Heading angle limits
himp=find(abs(Psi-215)<= 5 );  % Heading angle limits
limp1=union(jimp,rimp);
limp4=union(limp1,uimp);
limp5=union(limp4,vimp);
limp6=union(limp5,wimp);
limp7=union(limp6,yimp);
limp8=union(limp7,dimp);
limp9=union(limp8,gimp);
limp=union(limp9,himp);
n=find(Resampled_ADnav_25hzto100(:,8) > 147);
mimp=intersect(n,limp);%tous les indices de toutes les tranches impaires ( tranches où le drone se dirige vers le nord 'allers')
aimp=diff(mimp);% calculer la différence entre deux éléments successifs pour distinguer chaque tranche impaire.
dimp=intersect(mimp,find(abs(Phi)<5));
ddimp=diff(dimp);
dddimp=diff(ddimp);
bimp=find(dddimp>500);%Permet de detecter la separation entre deux tranches.


%Indices de tranches paires ( retours)
jpair=find(abs(Psi-53)<= 5 );  % Heading angle limits
kpair=find(abs(Psi-90)<= 5 );  % Heading angle limits
rpair=find(abs(Psi-100)<= 5 );  % Heading angle limits
spair=find(abs(Psi-74)<= 5 );  % Heading angle limits
upair=find(abs(Psi-40)<= 5 );  % Heading angle limits
vpair=find(abs(Psi-92)<= 5 );  % Heading angle limits
wpair=find(abs(Psi-104)<= 5 );  % Heading angle limits
dpair=find(abs(Psi-75)<= 5 );  % Heading angle limits
gpair=find(abs(Psi-40)<= 5 );  % Heading angle limits
hpair=find(abs(Psi-25)<= 5 );  % Heading angle limits
pair1=union(jpair,kpair);
pair2=union(pair1,rpair);
pair3=union(pair2,spair);
pair4=union(pair3,upair);
pair6=union(pair5,vpair);
pair7=union(pair6,wpair);
pair8=union(pair7,dpair);
pair9=union(pair8,gpair);
pair=union(pair9,hpair);
n=find(Resampled_ADnav_25hzto100(:,8) > 147);
mpair=intersect(n,pair);%Indices de tranches impaires ( allers)
%apair=diff(mpair);% calculer la différence entre deux éléments successifs pour distinguer chaque tranche impaire.
%bpair=find(apair>3000);%Permet de detecter la separation entre deux tranches.
dpair=intersect(mpair,find(abs(Phi)<5));
ddpair=diff(dpair);
dddpair=diff(ddpair);
bpair=find(dddpair>500);%Permet de detecter la separation entre deux tranches.

%In order to check if there is some aberant values and delete them

% for l=1:100
% if apair(l)~=1 
%    apair_test=apair(l+1:end);
%    mpair_test=mpair(l+1:end);
%     j=j+1;
% end
% end
% bpair_test=find(apair_test(1:end,1)>1000);%Permet de detecter la separation entre deux tranches.

% c_bpair=diff(bpair_test);
% 
% j=1;
% k=1;
% for j=1:length(c_bpair)
% if (bpair_test(j+1,1)-bpair_test(j,1))<10
%     bpair_test1(k,1)=bpair_test(j);
% else
%      bpair_test1(k,1)=bpair_test(j+1);
% end
% 
% j=j+1;
% k=k+1;
% end

% cpt1=max(cpt(1:100,:)); %pour determiner les valeurs hors ce qu'on cherche
% 
% mpair_new=mpair(cpt1+1:end);
% apair_new=diff(mpair_new);% calculer la différence entre deux éléments successifs pour distinguer chaque tranche impaire.
% bpair_new=find(apair_new(1:end,1)>500);%Permet de detecter la separation entre deux tranches.

% bpair=find(apair(cpt1+1:end,1)>500);%Permet de detecter la separation entre deux tranches.
% cpair=diff(bpair);
% dpair=find(cpair>1000);
% cpair_new=cpair(dpair);

%vecteur qui regroupe tous les indices des tranches impaires
mimpdebimp1=dimp(bimp+1);
mimpdebimp2=dimp(bimp+2);
indiceimpaire=union(mimpdebimp1,mimpdebimp2);
tranchesimp=union(dimp(1),indiceimpaire);
tranchesimp=union(tranchesimp,dimp(end));

qi=[];
ki=1;
for li=1:2:(length(tranchesimp)-1)
         qi(ki)=tranchesimp(li+1)-tranchesimp(li);       
 ki=ki+1;
end

 ji=1;
for ki=1:length(qi)
   
 if qi(ki)>1000 && qi(ki)<4500 
     tranchesimpf(ji)=tranchesimp(2*ki-1);
     tranchesimpf(ji+1)=tranchesimp(2*ki);
     ji=ji+2;
 end
end

 tranchesimpf=tranchesimpf'; % le tableau avec les indices des tranches impaires 

%vecteur qui regroupe tous les indices des tranches paires

mpairdebpair1=dpair(bpair+1);
mpairdebpair2=dpair(bpair+2);
indicespair=union(mpairdebpair1,mpairdebpair2);
tranchespair=union(dpair(1),indicespair);
tranchespair=union(tranchespair,dpair(end));

qp=[];
kp=1;
for lp=1:2:(length(tranchespair)-1)
         qp(kp)=tranchespair(lp+1)-tranchespair(lp);       
 kp=kp+1;
end

 jp=1;
for kp=1:length(qp)
   
 if qp(kp)>1000 &&  qp(kp)<4500 
     tranchespairf(jp)=tranchespair(2*kp-1);
     tranchespairf(jp+1)=tranchespair(2*kp);
     jp=jp+2;
 end
end    

 tranchespairf=tranchespairf'; % le tableau avec les indices des tranches paires 

%==========VECTEUR TOUTES LES TRANCHES=================
tranches_test=union(tranchesimp,tranchespair);
tranches=union(tranchesimpf,tranchespairf);

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

f1=figure('Name','Euler angles')
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
end
xlabel('time')
allaxes=findobj(f1,'type','axes','tag', '')
linkaxes(allaxes,'x')

load Tranches
 f1=figure('Name','Euler angles')
subplot(3,1,1)
plot(t_100Hz_3004,Phi,'b')
ylabel('roll angle')
subplot(3,1,2)
plot(t_100Hz_3004,Theta);ylabel('Pitch angle')
subplot(3,1,3)
plot(t_100Hz_3004,Psi,'b');ylabel('Heading angle')
hold on;
for i=1:2:length(Tranches)-1
%subplot(3,1,3)
plot(t_100Hz_3004(Tranches(i):Tranches(i+1)),Psi(Tranches(i):Tranches(i+1)))
end
xlabel('time')
allaxes=findobj(f1,'type','axes','tag', '')
linkaxes(allaxes,'x')