%% Spectrum of all sequence using the same length and by averaging the
% amplitude of energy
clear n L f;
k=1;
for i=1:2:length(Tranches1)-1
   
uu{:,k}=detrend(WindSpeed_East_SBG_corr(Tranches1(i):Tranches1(i)+2000));
Fs=100;
L{:,k}=length(uu{:,k});
n{:,k}=2^nextpow2(L{:,k});
f{:,k} = Fs/2*linspace(0,1,n{:,k}/2+1);
Su_mean{:,k}=abs(fft((uu{:,k})./L{:,k})).^2;
k=k+1;
end 
Su_mean{:,k}=mean(cell2mat(Su_mean),2);  

figure('Name','Spectre U east   ')
loglog(f{1,1},2*Su_mean{1,k}(1:n{1,1}/2+1)./(f{1,1}(2)),'r-',f{1,1},(2*Su_mean{1,k}(25))./(f{1,1}(2))*f{1,1}'.^(-5/3),'k-');
legend({'East Wind Speed all seq','-5/3 slope'},'Location','southwest','Fontsize',10);
xlabel ( 'f(Hz) ');
ylabel ('S_u(f) (m^2.s^-1)');
%yticks([10^(-4),10^(-3),10^(-2),10^(-1),10^(0),10^(1),10^(2)]);
%xlim([0 20])
ax=gca;
ax.FontSize=14;
filename1=sprintf('Spectra_U_all.png')
filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_U',filename1)
saveas(gcf,filename2)