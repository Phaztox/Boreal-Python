
clear uu_dtrend U_mean_seq Fs L_U_detrend n_U_detrend f_U_detrend Su_detrend legendes titres filename1 filename2 variance_uu_detrend variance_uu_detrend variance_uu_detrend

determinationdestranches


k=1;
for i=1:2:(length(Tranches1)-1)
%for i=15:2:(16)
uu_dtrend{k}=detrend(WindSpeed_East_SBG_corr(Tranches1(i):Tranches1(i+1)));
%U_mean_seq{k}=mean(WindSpeed_East_SBG_corr(Tranches1(i):Tranches1(i+1)));
Fs=100;
L_U_detrend{k}=length(uu_dtrend{k});
n_U_detrend{k}=2^nextpow2(L_U_detrend{k});
f_U_detrend{k} = Fs/2*linspace(0,1,n_U_detrend{k}/2+1);
%Su_detrend{k}=(abs(fft(uu_dtrend{k}(1:cell2mat(n_U_detrend(1,k))/2+1))).^2);
Su_detrend{k}=(abs(fft(uu_dtrend{k})).^2);

num=((i+1)/2);

legendes{k} =  sprintf('U  sequence n° %s', num2str(num));
titres{k} =  sprintf('Spectral density of U "" for sequence n° %s', num2str(num));
% 
figure('Name','Spectre U_detrend  "S(f)" WITH DETREND')
loglog(cell2mat(f_U_detrend(1,k)),2*[Su_detrend{1,k}(1:cell2mat(n_U_detrend(1,k))/2+1)]./(L_U_detrend{k}.^2)./f_U_detrend{1,k}(2),'r-',cell2mat(f_U_detrend(1,k)),2*10^5./(L_U_detrend{k}.^2)./f_U_detrend{1,k}(20)*cell2mat(f_U_detrend(1,k)).^(-5/3),'k-');
%loglog(cell2mat(f_U_detrend(1,k)),2*[Su_detrend{1,k}(1:cell2mat(n_U_detrend(1,k))/2+1)]./(L_U_detrend{k}.^2)./f_U_detrend{1,k}(2),'r-',cell2mat(f_U_detrend(1,k)),cell2mat(f_U_detrend(1,k)).^(-5/3),'k-');
%loglog(cell2mat(f_U_detrend(1,k)),[Su_detrend{1,k}(1:cell2mat(n_U_detrend(1,k))/2+1)],'r-',cell2mat(f_U_detrend(1,k)),cell2mat(f_U_detrend(1,k)).^(-5/3),'k-');
%yticks([10^(-8),10^(-7),10^(-6),10^(-5),10^(-4),10^(-3),10^(-2),10^(-1),10^(0),10^(1),10^(2)]);
legend(legendes{k},'-5/3 slope','Location','northeast');
xlabel ( 'f(Hz)');
ylabel ('S_u(f) (m^2.s^-1) ');
ax=gca;
ax.FontSize=14;
filename1=sprintf('Spectre_U_%s.png', num2str(num))
filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_U',filename1)
saveas(gcf,filename2)

%title(titres{k});

figure('Name','U ')
plot(t_100Hz_3004(Tranches1(i):Tranches1(i+1)),WindSpeed_East_SBG_corr(Tranches1(i):Tranches1(i+1)))
legend(legendes{k},'Location','southwest');
xlabel ( 'time in s');
ylabel ('U in m.s^-1 ');
ax=gca;
ax.FontSize=14;
filename1=sprintf('U_%s.png',num2str(num))
filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_U',filename1)
saveas(gcf,filename2)


variance_uu_detrend{k,1}=std([uu_dtrend{1,k}]).^2;
variance_uu_detrend{k,2}=2*sum([Su_detrend{1,k}(1:cell2mat(n_U_detrend(1,k))/2+1)])/([L_U_detrend{1,k}].^2);%(**)
variance_uu_detrend{k,3}=sum([Su_detrend{1,k}])/([L_U_detrend{1,k}].^2);%(**)
k=k+1;

end


