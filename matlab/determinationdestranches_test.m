clear qp1 tranches tranches1 i jimp dpair kimp limp mimp aimp bimp jpair kpair lpair n mpair apair bpair apair_test mpair_test mimpdebimp1 mimpdebimp2 indiceimpaire tranchesimp dimp cimp ki qi  ji tranchesimpf mpairdebpair1 mpairdebpair2 indicespair tranchespair dpair cpair tranchespair jp kp qp jp tranchespairf tranches
%Determination of straight and level flight runs
% In order to re-use this code, it's important to change the limits of
% 'jimp' and 'kimp' and 'jpair' 
% Keep the limits of i  between -5 and 5 degrees. 

i=find(Resampled_ADnav_25hzto100(:,16)>=(-5) & Resampled_ADnav_25hzto100(:,16) <=5); %Roll angle limits

%Indices de tranches impaires ( allers)
jimp=find(Resampled_ADnav_25hzto100(:,18) >= 245 & Resampled_ADnav_25hzto100(:,18) <= 264);  % Heading angle limits
kimp=find(Resampled_ADnav_25hzto100(:,18) >= 292 & Resampled_ADnav_25hzto100(:,18) <= 307);% Heading angle limits
rimp=find(Resampled_ADnav_25hzto100(:,18) >= 292 & Resampled_ADnav_25hzto100(:,18) <= 303);% Heading angle limits
simp=find(Resampled_ADnav_25hzto100(:,18) >= 265 & Resampled_ADnav_25hzto100(:,18) <= 275);% Heading angle limits
uimp=find(Resampled_ADnav_25hzto100(:,18) >= 205 & Resampled_ADnav_25hzto100(:,18) <= 220);% Heading angle limits
vimp=find(Resampled_ADnav_25hzto100(:,18) >= 209 & Resampled_ADnav_25hzto100(:,18) <= 230);% Heading angle limits
wimp=find(Resampled_ADnav_25hzto100(:,18) >= 292 & Resampled_ADnav_25hzto100(:,18) <= 308);% Heading angle limits
yimp=find(Resampled_ADnav_25hzto100(:,18) >= 292 & Resampled_ADnav_25hzto100(:,18) <= 308);% Heading angle limits
dimp=find(Resampled_ADnav_25hzto100(:,18) >= 264 & Resampled_ADnav_25hzto100(:,18) <= 275);% Heading angle limits
gimp=find(Resampled_ADnav_25hzto100(:,18) >= 214 & Resampled_ADnav_25hzto100(:,18) <= 226);% Heading angle limits
himp=find(Resampled_ADnav_25hzto100(:,18) >= 200 & Resampled_ADnav_25hzto100(:,18) <= 224);% Heading angle limits
limp1=union(jimp,kimp);
limp2=union(limp1,rimp);
limp3=union(limp2,simp);
limp4=union(limp3,uimp);
limp5=union(limp4,vimp);
limp6=union(limp5,wimp);
limp7=union(limp6,yimp);
limp8=union(limp7,dimp);
limp9=union(limp8,gimp);
limp=union(limp9,himp);
n=find(Resampled_ADnav_25hzto100(:,8) > 147);
mimp=intersect(i,limp);
mimp=intersect(n,mimp);%tous les indices de toutes les tranches impaires ( tranches où le drone se dirige vers le nord 'allers')
aimp=diff(mimp);% calculer la différence entre deux éléments successifs pour distinguer chaque tranche impaire.
% bimp=find(aimp>6700);%Permet de detecter la separation entre deux tranches.
bimp=find(aimp>500);%Permet de detecter la separation entre deux tranches.
mimp_test=mimp(find(aimp==1)); 
aimp_test=diff(mimp_test);
bimp_test=find(aimp_test>5000);%Permet de detecter la separation entre deux tranches.

% himp=diff(bimp);   %ca sert à voir si les tranches selectionnées durent longtemps ou nn et si nn les supprimer
% q=find(himp<500);
%  bimp(q+1)=[];
%Indices de tranches paires ( retours)
jpair=find(Resampled_ADnav_25hzto100(:,18) >= 48 & Resampled_ADnav_25hzto100(:,18) <= 58);  % Heading angle limits
kpair=find(Resampled_ADnav_25hzto100(:,18) >= 84 & Resampled_ADnav_25hzto100(:,18) <= 97);% Heading angle limits
rpair=find(Resampled_ADnav_25hzto100(:,18) >= 95 & Resampled_ADnav_25hzto100(:,18) <= 107);% Heading angle limits
spair=find(Resampled_ADnav_25hzto100(:,18) >= 68 & Resampled_ADnav_25hzto100(:,18) <= 80);% Heading angle limits
upair=find(Resampled_ADnav_25hzto100(:,18) >= 35 & Resampled_ADnav_25hzto100(:,18) <= 43);% Heading angle limits
ypair=find(Resampled_ADnav_25hzto100(:,18) >= 35 & Resampled_ADnav_25hzto100(:,18) <= 44);% Heading angle limits
vpair=find(Resampled_ADnav_25hzto100(:,18) >= 87 & Resampled_ADnav_25hzto100(:,18) <= 97);% Heading angle limits
wpair=find(Resampled_ADnav_25hzto100(:,18) >= 99 & Resampled_ADnav_25hzto100(:,18) <= 109);% Heading angle limits
dpair=find(Resampled_ADnav_25hzto100(:,18) >= 72 & Resampled_ADnav_25hzto100(:,18) <= 79);% Heading angle limits
gpair=find(Resampled_ADnav_25hzto100(:,18) >= 37 & Resampled_ADnav_25hzto100(:,18) <= 43);% Heading angle limits
hpair=find(Resampled_ADnav_25hzto100(:,18) >= 22 & Resampled_ADnav_25hzto100(:,18) <= 28);% Heading angle limits
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
dpair=intersect(i,pair);%Indices de tranches impaires ( allers)
mpair=intersect(n,dpair);%Indices de tranches impaires ( allers)
apair=diff(mpair);% calculer la différence entre deux éléments successifs pour distinguer chaque tranche impaire.
bpair=find(apair(1:end,1)>500);%Permet de detecter la separation entre deux tranches.
mpair_test=mpair(find(apair==1));
apair_test=diff(mpair_test);
bpair_test=find(apair_test(1:end,1)>5000);%Permet de detecter la separation entre deux tranches de vol droit qui ont le mm cap. 3000 dépend du vol et est equivalente à 30s dans ce cas. 

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

mimpdebimp1=mimp_test(bimp_test);
mimpdebimp2=mimp_test(bimp_test+1);
indiceimpaire=union(mimpdebimp1,mimpdebimp2);
tranchesimp=union(mimp_test(1),indiceimpaire);
tranchesimp=union(tranchesimp,mimp_test(end));
% dimp=diff(tranchesimp);
% cimp=find(dimp>1000);
% tranchesimp1=tranchesimp(cimp);
% dimp=diff(tranchesimp);
% cimp=find(dimp>1000);


qi=[];
ki=1;
for li=1:2:(length(tranchesimp)-1)
         qi(ki)=tranchesimp(li+1)-tranchesimp(li);       
 ki=ki+1;
end

% qp1=[];
% ki=1;
% for li=1:2:(length(tranchespairf)-1)
%          qp1(ki)=tranchespairf(li+1)-tranchespairf(li);       
%  ki=ki+1;
% end

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
% mpairdebpair1=mpair(bpair+cpt1);
% mpairdebpair2=mpair(bpair+cpt1+1);
% extremities=find(apair_test==1);
mpairdebpair1=mpair_test(bpair_test);
mpairdebpair2=mpair_test(bpair_test+1);
indicespair=union(mpairdebpair1,mpairdebpair2);
tranchespair=union(mpair_test(1),indicespair);
tranchespair=union(tranchespair,mpair_test(end));
% tranchespair=union(mpair(1+cpt1),indicespair);
% tranchespair=union(tranchespair,mpair(end));

% dpair=diff(tranchespair);
% cpair=find(dpair>1000);


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
plot(t_100Hz,Phi,'b')
ylabel('roll angle')
subplot(3,1,2)
plot(t_100Hz,Theta);ylabel('Pitch angle')
subplot(3,1,3)
plot(t_100Hz,Psi,'b');ylabel('Heading angle')
hold on;
for i=1:2:length(tranches)-1
%subplot(3,1,3)
plot(t_100Hz(tranches(i):tranches(i+1)),Psi(tranches(i):tranches(i+1)))
end
xlabel('time')
allaxes=findobj(f1,'type','axes','tag', '')
linkaxes(allaxes,'x')
