%% Spectrum of all sequence using the same length and by averaging the

%% Vertcial ground speed form altitude (Boreal)


clear n L f ww Sw_mean Sw2_mean

k=1;
for i=1:2:(length(Tranches1)-1)
   
ww{:,k}=detrend(Vertical_WS_corr(Tranches1(i):Tranches1(i)+2000));
Fs=100;
L{:,k}=length(ww{:,k});
n{:,k}=2^nextpow2(L{:,k});
f{:,k} = Fs/2*linspace(0,1,n{:,k}/2+1);
Sw_mean{:,k}=abs(fft((ww{:,k})./L{:,k})).^2;
k=k+1;
end 
Sw_mean{:,k}=mean(cell2mat(Sw_mean),2);  

figure('Name','Spectre W   ')
loglog(f{1,1},2*Sw_mean{1,k}(1:n{1,1}/2+1)./(f{1,1}(2)),'r-',f{1,1},(2*Sw_mean{1,k}(52))./(f{1,1}(2))*f{1,1}'.^(-5/3),'k-');
legend('Vertical Wind Speed all seq','-5/3 slope','Location','southwest');
xlabel ( 'f(Hz) ');
ylabel ('S_w(f) (m^2.s^-1)');
%title('Spectral density of W "" (all sequence at different altitudes but with the same length)');
yticks([10^(-4),10^(-3),10^(-2),10^(-1),10^(0),10^(1),10^(2)]);
%xlim([0 20])
ax=gca;
ax.FontSize=14;
filename1=sprintf('Spectra_all_w_alt.png');
filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_W',filename1);
saveas(gcf,filename2)

%% Vertical ground speed from pressure 
% k=1;
% for i=15:2:(length(Tranches11)-7)
%    
% ww2{:,k}=detrend(Vertical_WS2_corr(Tranches1(i):Tranches1(i)+2000));
% Fs=100;
% L{:,k}=length(ww2{:,k});
% n{:,k}=2^nextpow2(L{:,k});
% f{:,k} = Fs/2*linspace(0,1,n{:,k}/2+1);
% Sw2_mean{:,k}=abs(fft((ww2{:,k})./L{:,k})).^2;
% k=k+1;
% end 
% Sw2_mean{:,k}=mean(cell2mat(Sw2_mean),2);  
% 
% figure('Name','Spectre W   ')
% loglog(f{1,1},2*Sw2_mean{1,k}(1:n{1,1}/2+1)./(f{1,1}(2)),'r-',f{1,1},(2*Sw2_mean{1,k}(10))./(f{1,1}(5))*f{1,1}'.^(-5/3),'k-');
% legend('Vertical Wind Speed all seq','-5/3 slope','Location','southwest');
% xlabel ( 'f(Hz) ');
% ylabel ('S_{w_p}(f) (m^2.s^-1)');
% yticks([10^(-4),10^(-3),10^(-2),10^(-1),10^(0),10^(1),10^(2)]);
% %xlim([0 20])
% ax=gca;
% ax.FontSize=14;
% filename1=sprintf('Spectra_all_w_p.png');
% filename2=fullfile('C:\Users\s.alaoui-sosse\Documents\MIRIAD_JUI2020\Lannemezan\Vol2_Lannemezan\Spectra_W2_new',filename1);
% saveas(gcf,filename2)

clear n1 L1 f1 ww1 Sw_mean_p1 

k=1;
for i=13:2:(25)
   
ww1{:,k}=detrend(Vertical_WS_corr(Tranches1(i):Tranches1(i)+2000));
Fs=100;
L1{:,k}=length(ww1{:,k});
n1{:,k}=2^nextpow2(L1{:,k});
f1{:,k} = Fs/2*linspace(0,1,n1{:,k}/2+1);
Sw_mean_p1{:,k}=abs(fft((ww1{:,k})./L1{:,k})).^2;
k=k+1;
end 
Sw_mean_p1{:,k}=mean(cell2mat(Sw_mean_p1),2);  

figure('Name','Spectre W   ')
loglog(f1{1,1},2*Sw_mean_p1{1,k}(1:n1{1,1}/2+1)./(f1{1,1}(2)),'r-',f1{1,1},(2*Sw_mean_p1{1,k}(52))./(f1{1,1}(2))*f1{1,1}'.^(-5/3),'k-');
legend('Vertical Wind Speed all seq','-5/3 slope','Location','southwest');
xlabel ( 'f(Hz) ');
ylabel ('S_w(f) (m^2.s^-1)');
title('Spectral density of W for the phase 1 of the flight at 110 agl');
%yticks([10^(-4),10^(-3),10^(-2),10^(-1),10^(0),10^(1),10^(2)]);
%xlim([0 20])
ax=gca;
ax.FontSize=14;
filename1=sprintf('Spectrum_w_P1_110agl.png');
filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_W',filename1);
saveas(gcf,filename2)

%%
clear n2 L2 f2 ww2 Sw_mean_p2

k=1;
for i=27:2:(43)
   
ww2{:,k}=detrend(Vertical_WS_corr(Tranches1(i):Tranches1(i)+2000));
Fs=100;
L2{:,k}=length(ww2{:,k});
n2{:,k}=2^nextpow2(L2{:,k});
f2{:,k} = Fs/2*linspace(0,1,n2{:,k}/2+1);
Sw_mean_p2{:,k}=abs(fft((ww2{:,k})./L2{:,k})).^2;
k=k+1;
end 
Sw_mean_p2{:,k}=mean(cell2mat(Sw_mean_p2),2);  

figure('Name','Spectre W   ')
loglog(f2{1,1},2*Sw_mean_p2{1,k}(1:n2{1,1}/2+1)./(f2{1,1}(2)),'r-',f2{1,1},(2*Sw_mean_p2{1,k}(52))./(f2{1,1}(2))*f2{1,1}'.^(-5/3),'k-');
legend('Vertical Wind Speed all seq','-5/3 slope','Location','southwest');
xlabel ( 'f(Hz) ');
ylabel ('S_w(f) (m^2.s^-1)');
title('Spectral density of W for the phase 1 of the flight at 90 agl');
%yticks([10^(-4),10^(-3),10^(-2),10^(-1),10^(0),10^(1),10^(2)]);
%xlim([0 20])
ax=gca;
ax.FontSize=14;
filename1=sprintf('Spectrum_w_P90agl.png');
filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_W',filename1);
saveas(gcf,filename2)