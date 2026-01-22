%% Spectrum of all sequence using the same length and by averaging the
% amplitude of energy
clear n L f Sv_mean Fs vv k;
k=1;
for i=1:2:length(Tranches1)-1
   
vv{:,k}=detrend(WindSpeed_North_SBG_corr(Tranches1(i):Tranches1(i)+2000));
Fs=100;
L{:,k}=length(vv{:,k});
n{:,k}=2^nextpow2(L{:,k});
f{:,k} = Fs/2*linspace(0,1,n{:,k}/2+1);
Sv_mean{:,k}=abs(fft((vv{:,k})./L{:,k})).^2;
k=k+1;
end 
Sv_mean{:,k}=mean(cell2mat(Sv_mean),2);  

figure('Name','Spectre V north   ')
loglog(f{1,1},2*Sv_mean{1,k}(1:n{1,1}/2+1)./(f{1,1}(2)),'r-',f{1,1},(2*Sv_mean{1,k}(17))./(f{1,1}(2))*f{1,1}'.^(-5/3),'k-');
legend({'North Wind Speed all seq','-5/3 slope'},'Location','southwest','Fontsize',10);
xlabel ( 'f(Hz) ');
ylabel ('S_v(f) (m^2.s^-1)');
%title('Spectral density of W "" (all sequence at different altitudes but with the same length)');
%yticks([10^(-4),10^(-3),10^(-2),10^(-1),10^(0),10^(1),10^(2)]);
%xlim([0 20])
ax=gca;
ax.FontSize=14;
filename1=sprintf('Spectra_V_all.png')
filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_V',filename1)
saveas(gcf,filename2)
