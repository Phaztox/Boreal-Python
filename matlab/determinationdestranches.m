
%Determination des tranches du vol de lannemezan

i=find(Resampled_ADnav_25hzto100(:,16)>-10 & Resampled_ADnav_25hzto100(:,16)<10);

%Indices de tranches impaires ( allers)
jimp=find(Resampled_ADnav_25hzto100(:,18)>48 & Resampled_ADnav_25hzto100(:,18)<58);  
kimp=find(Resampled_ADnav_25hzto100(:,18)>58 & Resampled_ADnav_25hzto100(:,18)<70 );

kimp=find(Resampled_ADnav_25hzto100(:,18)>84 & Resampled_ADnav_25hzto100(:,18)<97);
kimp=find(Resampled_ADnav_25hzto100(:,18)>95 & Resampled_ADnav_25hzto100(:,18)<107);

limp=union(jimp,kimp);
n=find(Resampled_ADnav_25hzto100(:,8)>170);
mimp=intersect(i,limp);
mimp=intersect(n,mimp);%tous les indices de toutes les tranches impaires ( tranches où le drone se dirige vers le nord 'allers')
aimp=diff(mimp);% calculer la différence entre deux éléments successifs pour distinguer chaque tranche impaire.
bimp=find(aimp>500);%Permet de detecter la separation entre deux tranches.
% himp=diff(bimp);   %ca sert à voir si les tranches selectionnées durent longtemps ou nn et si nn les supprimer
% q=find(himp<500);
%  bimp(q+1)=[];
%Indices de tranches paires ( retours)
jpair=find(Resampled_ADnav_25hzto100(:,18)>245 & Resampled_ADnav_25hzto100(:,18)<264); 
mpair=intersect(i,jpair);
n=find(Resampled_ADnav_25hzto100(:,8)>170);
mpair=intersect(n,mpair);%Indices de tranches impaires ( allers)
apair=diff(mpair);% calculer la différence entre deux éléments successifs pour distinguer chaque tranche impaire.
bpair=find(apair>500);%Permet de detecter la separation entre deux tranches.

%vecteur qui regroupe tous les indices des tranches impaires
mimpdebimp1=mimp(bimp);
mimpdebimp2=mimp(bimp+1);
indiceimpaire=union(mimpdebimp1,mimpdebimp2);
tranchesimp=union(mimp(1),indiceimpaire);
tranchesimp=union(tranchesimp,mimp(end));

% dimp=diff(tranchesimp);
% cimp=find(dimp>1000);
% tranchesimp1=tranchesimp(cimp);

dimp=diff(tranchesimp);
cimp=find(dimp>1000);


qi=[];
ki=1;
for li=1:2:(length(tranchesimp)-1);
         qi(ki)=tranchesimp(li+1)-tranchesimp(li);       
 ki=ki+1;
end;

 ji=1;
for ki=1:length(qi)
   
 if qi(ki)>1000
     tranchesimpf(ji)=tranchesimp(2*ki-1);
     tranchesimpf(ji+1)=tranchesimp(2*ki);
     ji=ji+2;
 end;
end;

 tranchesimpf=tranchesimpf'; % le tableau avec les indices des tranches impaires 


%vecteur qui regroupe tous les indices des tranches paires
mpairdebpair1=mpair(bpair);
mpairdebpair2=mpair(bpair+1);
indicespair=union(mpairdebpair1,mpairdebpair2);
tranchespair=union(mpair(1),indicespair);
tranchespair=union(tranchespair,mpair(end));

dpair=diff(tranchespair);
cpair=find(dpair>1000);


qp=[];
kp=1;
for lp=1:2:(length(tranchespair)-1);
         qp(kp)=tranchespair(lp+1)-tranchespair(lp);       
 kp=kp+1;
end;

 jp=1;
for kp=1:length(qp)
   
 if qp(kp)>1000
     tranchespairf(jp)=tranchespair(kp*2-1);
     tranchespairf(jp+1)=tranchespair(kp*2);
     jp=jp+2;
 end;
end;    

 tranchespairf=tranchespairf'; % le tableau avec les indices des tranches paires 



%==========VECTEUR TOUTES LES TRANCHES=================
tranches=union(tranchesimpf,tranchespairf);