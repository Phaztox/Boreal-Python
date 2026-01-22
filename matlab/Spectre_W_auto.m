
%determinationdestranches

%%   Vertical ground speed derived from pressure
clear n; 

% k=1;
% 
% for i=1:2:(length(Tranches1)-1)
% WW2_dtrend{k}=detrend(Vertical_WS2_corr(Tranches1(i):Tranches1(i+1)));
% W2_mean_seq{k}=mean(Vertical_WS2_corr(Tranches1(i):Tranches1(i+1)));
% Fs=100;
% L_all_W2_detrend{k}=length(WW2_dtrend{k});
% n_all_W2_detrend{k}=2^nextpow2(L_all_W2_detrend{k});
% f_all_W2_detrend{k} = Fs/2*linspace(0,1,n_all_W2_detrend{k}/2+1);
% %SW2_all_W2_detrend{k}=(abs(fft(WW2_dtrend{k}(1:cell2mat(n_all_W2_detrend(1,k))/2+1))).^2);
% SW2_all_W2_detrend{k}=(abs(fft(WW2_dtrend{k})).^2);
% 
% legendes{k} =  sprintf('W sequence n°%s', num2str((i+1)/2));
% titres{k} =  sprintf('Spectral density of W "" for sequence n°%s', num2str((i+1)/2));
% % 
% figure('Name','Spectre W_p_detrend "S(f)" WITH DETREND')
% loglog(cell2mat(f_all_W2_detrend(1,k)),2*[SW2_all_W2_detrend{1,k}(1:cell2mat(n_all_W2_detrend(1,k))/2+1)]./(L_all_W2_detrend{k}.^2)./f_all_W2_detrend{1,k}(2),'r-',cell2mat(f_all_W2_detrend(1,k)),2*10^4./(L_all_W2_detrend{k}.^2)./f_all_W2_detrend{1,k}(2)*cell2mat(f_all_W2_detrend(1,k)).^(-5/3),'k-');
% %loglog(cell2mat(f_all_W2_detrend(1,k)),2*[SW2_all_W2_detrend{1,k}(1:cell2mat(n_all_W2_detrend(1,k))/2+1)]./(L_all_W2_detrend{k}.^2)./f_all_W2_detrend{1,k}(2),'r-',cell2mat(f_all_W2_detrend(1,k)),cell2mat(f_all_W2_detrend(1,k)).^(-5/3),'k-');
% %loglog(cell2mat(f_all_W2_detrend(1,k)),[SW2_all_W2_detrend{1,k}(1:cell2mat(n_all_W2_detrend(1,k))/2+1)],'r-',cell2mat(f_all_W2_detrend(1,k)),cell2mat(f_all_W2_detrend(1,k)).^(-5/3),'k-');
% %yticks([10^(-8),10^(-7),10^(-6),10^(-5),10^(-4),10^(-3),10^(-2),10^(-1),10^(0),10^(1),10^(2)]);
% %legend(legendes{k},'-5/3 slope','Location','northeast');
% xlabel ( 'f(Hz)');
% ylabel ('S_w(f) (m^2.s^-1) ');
% ax=gca;
% ax.FontSize=14;
% legend(legendes{k},'-5/3 slope','Location','northeast');
% filename1=sprintf('Spectre_W_{p}_%s.png',num2str((i+1)/2-7));
% filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_W',filename1);
% saveas(gcf,filename2)
% 
% %title(titres{k});
% 
% figure('Name','W ')
% plot(t_100Hz_3004(Tranches1(i):Tranches1(i+1)),Vertical_WS2_corr(Tranches1(i):Tranches1(i+1)));
% % loglog(cell2mat(f_all_W2_detrend(1,k)),2*cell2mat(f_all_W2_detrend(1,k))'.*[SW2_all_W2_detrend{1,k}(1:cell2mat(n_all_W2_detrend(1,k))/2+1)]./(L_all_W2_detrend{k}.^2)./f_all_W2_detrend{1,k}(2),'r-',cell2mat(f_all_W2_detrend(1,k)),cell2mat(f_all_W2_detrend(1,k)).^(-2/3),'k-');
% %legend(legendes{k},'Location','southwest');
% xlabel ( 'time ');
% ylabel ('W en m.s^-1 ');
% ax=gca;
% ax.FontSize=14;
% legend(legendes{k},'Location','northeast');
% filename1=sprintf('W_{p}_%s.png',num2str((i+1)/2-7));
% filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_W',filename1);
% saveas(gcf,filename2)
% 
% % figure('Name','Spectre fS(f) W "fS(f)" WITH DETREND')
% % loglog(cell2mat(f_all_W2_detrend(1,k)),2*cell2mat(f_all_W2_detrend(1,k))'.*[SW2_all_W2_detrend{1,k}(1:cell2mat(n_all_W2_detrend(1,k))/2+1)]./(L_all_W2_detrend{k}.^2)./f_all_W2_detrend{1,k}(2),'r-',cell2mat(f_all_W2_detrend(1,k)),2*[SW2_all_W2_detrend{1,k}(20)]./(L_all_W2_detrend{k}.^2)./f_all_W2_detrend{1,k}(2).*cell2mat(f_all_W2_detrend(1,k)).^(-2/3),'k-');
% % % loglog(cell2mat(f_all_W2_detrend(1,k)),2*cell2mat(f_all_W2_detrend(1,k))'.*[SW2_all_W2_detrend{1,k}(1:cell2mat(n_all_W2_detrend(1,k))/2+1)]./(L_all_W2_detrend{k}.^2)./f_all_W2_detrend{1,k}(2),'r-',cell2mat(f_all_W2_detrend(1,k)),cell2mat(f_all_W2_detrend(1,k)).^(-2/3),'k-');
% % %legend(legendes{k},'slope -2/3','Location','southwest');
% % xlabel ( 'f ');
% % ylabel ('f*S_w(f) en m^2.s^-2 ');
% % title(titres{k});
% % ax=gca;
% % ax.FontSize=14;
% 
% variance_WW2_detrend{k,1}=std([WW2_dtrend{1,k}]).^2;
% variance_WW2_detrend{k,2}=2*sum([SW2_all_W2_detrend{1,k}(1:cell2mat(n_all_W2_detrend(1,k))/2+1)])/([L_all_W2_detrend{1,k}].^2);%(**)
% variance_WW2_detrend{k,3}=sum([SW2_all_W2_detrend{1,k}])/([L_all_W2_detrend{1,k}].^2);%(**)
% k=k+1;
% 
% end


%%  Vertical ground speed derived from altitude


clear n i k; 

k=1;

for i=1:2:(length(Tranches1)-1)
WW_dtrend{k}=detrend(Vertical_WS_corr(Tranches1(i):Tranches1(i+1)));
W_mean_seq{k}=mean(Vertical_WS_corr(Tranches1(i):Tranches1(i+1)));
Fs=100;
L_all_W_detrend{k}=length(WW_dtrend{k});
n_all_W_detrend{k}=2^nextpow2(L_all_W_detrend{k});
f_all_W_detrend{k} = Fs/2*linspace(0,1,n_all_W_detrend{k}/2+1);
%SW_all_W_detrend{k}=(abs(fft(WW_dtrend{k}(1:cell2mat(n_all_W_detrend(1,k))/2+1))).^2);
SW_all_W_detrend{k}=(abs(fft(WW_dtrend{k})).^2);

legendes{k} =  sprintf('W sequence n°%s', num2str((i+1)/2));
titres{k} =  sprintf('Spectral density of W "" for sequence n°%s', num2str((i+1)/2));
% 
figure('Name','Spectre W_detrend "S(f)" WITH DETREND')
loglog(cell2mat(f_all_W_detrend(1,k)),2*[SW_all_W_detrend{1,k}(1:cell2mat(n_all_W_detrend(1,k))/2+1)]./(L_all_W_detrend{k}.^2)./f_all_W_detrend{1,k}(2),'r-',cell2mat(f_all_W_detrend(1,k)),2*10^4./(L_all_W_detrend{k}.^2)./f_all_W_detrend{1,k}(10)*cell2mat(f_all_W_detrend(1,k)).^(-5/3),'k-');
%loglog(cell2mat(f_all_W_detrend(1,k)),2*[SW_all_W_detrend{1,k}(1:cell2mat(n_all_W_detrend(1,k))/2+1)]./((length(f_all_W_detrend{1,k})).^2)./f_all_W_detrend{1,k}(2),'r-',cell2mat(f_all_W_detrend(1,k)),2*10^4./(L_all_W_detrend{k}.^2)./f_all_W_detrend{1,k}(20)*cell2mat(f_all_W_detrend(1,k)).^(-5/3),'k-');
xlabel ( 'f(Hz)');
ylabel ('S_w(f) (m^2.s^-1) ');
ax=gca;
ax.FontSize=14;
legend(legendes{k},'-5/3 slope','Location','northeast');
filename1=sprintf('Spectre_W_{alt}_%s.png',num2str((i+1)/2));
filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_W',filename1);
saveas(gcf,filename2)

%title(titres{k});

figure('Name','W ')
plot(t_100Hz_3004(Tranches1(i):Tranches1(i+1)),Vertical_WS_corr(Tranches1(i):Tranches1(i+1)));
% loglog(cell2mat(f_all_W_detrend(1,k)),2*cell2mat(f_all_W_detrend(1,k))'.*[SW_all_W_detrend{1,k}(1:cell2mat(n_all_W_detrend(1,k))/2+1)]./(L_all_W_detrend{k}.^2)./f_all_W_detrend{1,k}(2),'r-',cell2mat(f_all_W_detrend(1,k)),cell2mat(f_all_W_detrend(1,k)).^(-2/3),'k-');
%legend(legendes{k},'Location','southwest');
xlabel ( 'time ');
ylabel ('W en m.s^-1 ');
ax=gca;
ax.FontSize=14;
legend(legendes{k},'Location','northeast');
filename1=sprintf('W_{alt}_%s.png',num2str((i+1)/2));
filename2=fullfile('C:\Users\alas\Documents\Momenta_Matlab\Script\Vol5\Spectra_W',filename1);
saveas(gcf,filename2)

% figure('Name','Spectre fS(f) W "fS(f)" WITH DETREND')
% loglog(cell2mat(f_all_W_detrend(1,k)),2*cell2mat(f_all_W_detrend(1,k))'.*[SW_all_W_detrend{1,k}(1:cell2mat(n_all_W_detrend(1,k))/2+1)]./(L_all_W_detrend{k}.^2)./f_all_W_detrend{1,k}(2),'r-',cell2mat(f_all_W_detrend(1,k)),2*[SW_all_W_detrend{1,k}(20)]./(L_all_W_detrend{k}.^2)./f_all_W_detrend{1,k}(2).*cell2mat(f_all_W_detrend(1,k)).^(-2/3),'k-');
% % loglog(cell2mat(f_all_W_detrend(1,k)),2*cell2mat(f_all_W_detrend(1,k))'.*[SW_all_W_detrend{1,k}(1:cell2mat(n_all_W_detrend(1,k))/2+1)]./(L_all_W_detrend{k}.^2)./f_all_W_detrend{1,k}(2),'r-',cell2mat(f_all_W_detrend(1,k)),cell2mat(f_all_W_detrend(1,k)).^(-2/3),'k-');
% %legend(legendes{k},'slope -2/3','Location','southwest');
% xlabel ( 'f ');
% ylabel ('f*S_w(f) en m^2.s^-2 ');
% title(titres{k});
% ax=gca;
% ax.FontSize=14;

variance_WW_detrend{k,1}=std([WW_dtrend{1,k}]).^2;
variance_WW_detrend{k,2}=2*sum([SW_all_W_detrend{1,k}(1:cell2mat(n_all_W_detrend(1,k))/2+1)])/([L_all_W_detrend{1,k}].^2);%(**)
variance_WW_detrend{k,3}=sum([SW_all_W_detrend{1,k}])/([L_all_W_detrend{1,k}].^2);%(**)
k=k+1;

end
