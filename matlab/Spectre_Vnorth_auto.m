 clear i vv_dtrend V_mean_seq Fs L_V_detrend n_V_detrend f_V_detrend Sv_detrend legendes titres num filename1 filename2 k
%    v spectrum for all straight flight sequences%%%%%%     %

k=1;
for i=1:2:(length(Tranches1)-1)
%for i=1:2:(1)

vv_dtrend{k}=detrend(WindSpeed_North_SBG_corr(Tranches1(i):Tranches1(i+1)));
V_mean_seq{k}=mean(WindSpeed_North_SBG_corr(Tranches1(i):Tranches1(i+1)));
Fs=100;
L_V_detrend{k}=length(vv_dtrend{k});
n_V_detrend{k}=2^nextpow2(L_V_detrend{k});
f_V_detrend{k} = Fs/2*linspace(0,1,n_V_detrend{k}/2+1);
%Sv_detrend{k}=(abs(fft(vv_dtrend{k}(1:cell2mat(n_U_detrend(1,k))/2+1))).^2);
Sv_detrend{k}=(abs(fft(vv_dtrend{k})).^2);

num=(i+1)/2; %le -7 est parce qu'on commence par i=15

legendes{k} =  sprintf('V  sequence n°%s', num2str(num));
titres{k} =  sprintf('Spectral density of V for sequence n°%s', num2str(num));

figure('Name','Spectre V_detrend  "S(f)" WITH DETREND')
loglog(cell2mat(f_V_detrend(1,k)),2*[Sv_detrend{1,k}(1:cell2mat(n_V_detrend(1,k))/2+1)]./(L_V_detrend{k}.^2)./f_V_detrend{1,k}(2),'r-',cell2mat(f_V_detrend(1,k)),2*10^4./(L_V_detrend{k}.^2)./f_V_detrend{1,k}(40)*cell2mat(f_V_detrend(1,k)).^(-5/3),'k-');
%loglog(cell2mat(f_V_detrend(1,k)),2*[SV_detrend{1,k}(1:cell2mat(n_V_detrend(1,k))/2+1)]./(L_V_detrend{k}.^2)./f_V_detrend{1,k}(2),'r-',cell2mat(f_V_detrend(1,k)),cell2mat(f_V_detrend(1,k)).^(-5/3),'k-');
%loglog(cell2mat(f_V_detrend(1,k)),[SV_detrend{1,k}(1:cell2mat(n_V_detrend(1,k))/2+1)],'r-',cell2mat(f_V_detrend(1,k)),cell2mat(f_V_detrend(1,k)).^(-5/3),'k-');
%yticks([10^(-8),10^(-7),10^(-6),10^(-5),10^(-4),10^(-3),10^(-2),10^(-1),10^(0),10^(1),10^(2)]);
legend(legendes{k},'-5/3 slope','Location','northeast');
%title(titres{k})
xlabel ( 'f(Hz)');
ylabel ('S_v(f) (m^2.s^-1) ');
ax=gca;
ax.FontSize=14;
filename1=sprintf('Spectre_V_%s.png',num2str(num))
filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_V',filename1)
saveas(gcf,filename2)
% 
%title(titres{k});

figure('Name','V WITH DETREND')
%plot((temps(Tranches1(i):Tranches1(i+1))-temps(i)).*0.01,vv_dtrend{k});
plot(t_100Hz_3004(Tranches1(i):Tranches1(i+1)),WindSpeed_North_SBG_corr(Tranches1(i):Tranches1(i+1)))
legend(legendes{k},'Location','southwest');
xlabel ( 'Time in s');
ylabel ('V in m.s^-1 ');
ax=gca;
ax.FontSize=14;
filename1=sprintf('V_%s.png',num2str(num))
filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_V',filename1)
saveas(gcf,filename2)

k=k+1;

end


