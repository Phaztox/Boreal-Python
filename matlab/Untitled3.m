close all
clear all
% cpt100hz_th=min(cpt100hz):1:max(cpt100hz);
% time_th=cpt100hz_th*1/100;
fid=fopen('C:\Users\medp_admin\Documents\TLB\load data\Script\test_boreal_full.bin','r');
Q=fread(fid);
fclose(fid);
% Q=reshape(Q,512,length(Q)/512);
% Q=Q.';
% Q1=dec2hex(Q(4,:));
Q2=reshape(Q,1024,length(Q(:))/1024);
N=size(Q2,2);
offset1=130000;
offset2=200000;
Result = extract_data(Q2,offset1,offset2);

k=0;
ind1=0;
TPS_mort=[];
% while k<1*600*100
% % for k=9:10*60*100+10:size(Q,2)
% 
% % offset1=k+1;
% % offset2=offset1+10*60*100+10;
% % if offset2<size(Q,2)
% %     Q2=Q(:,offset1:offset2);
% % else
% %     offset2=size(Q,2);
% %     Q2=Q(:,offset1:end);
% % end
% % fid=fopen('C:\Users\medp_admin\Documents\TLB\load data\MOTUS_CRC.bin','r');
% Q=fread(fid,10*60*100*1024);
% 
% Q2=reshape(Q,1024,length(Q)/1024);
% cpt_511=Q2(512,:);
% cpt_512=Q2(513,:);
% cpt_561=Q2(562,:);
% cpt_562=Q2(563,:);
% list=1:1:length(cpt_562(:));
% ind1=ind1(end)+list;
%  
% k=k+10*60*100;
% Result = extract_data(Q2,3,0);
% % pat=Result.Pattern(:,32:51);
% % 
% % pat1=pat(:,1:2:size(pat,2));
% % pat1=pat1.';
% % pat1=pat1(:);
% % 
% % pat2=pat(:,2:2:size(pat,2));
% % pat2=pat2.';
% % 
% % pat2=pat2(:);
% % n1=find((pat1<188) & (pat1>171) & pat2<203 & pat2>186);
% % % n2=find(pat2<203 & pat2>186);
% % pat8=Result.Pattern(:,33);
% % N=n1;
% % N=sort(N);
% 
% cpt100hz1=Result.AD_NAVIGATION(:,27);
% nfin=find(cpt100hz1==cpt100hz1(end));
% cpt100hz=cpt100hz1(1:nfin(1)-1);
% numblock=Result.AD_NAVIGATION(:,1);
% d_cpt100hz=diff(cpt100hz);
% d_numblock=diff(numblock);
% tps_mort=((cpt100hz(end)-cpt100hz(1)+1)-length(cpt100hz))/(cpt100hz(end)-cpt100hz(1)+1)*100
% % 
% blockSD1=Result.AD_NAVIGATION(:,1);
% blockSD=blockSD1(1:nfin-1);
% numero_block_theo=blockSD(1)+(cpt100hz(end)-cpt100hz(1))*2;
% numero_blockSD=blockSD(end);
% tps_mort2=(numero_block_theo-numero_blockSD)./numero_block_theo*100
% tps_mort_temp=[tps_mort;tps_mort2];
% TPS_mort=[TPS_mort tps_mort_temp];
% % cpt1000hz=resample(cpt100hz,1000,100);
% 
% % time_s=cpt100hz/100;
% % time_interp=linspace(time_s(1),time_s(end),size(Result.MOTUSRAW(:,2),1));
% % t=resample(time_s,1000,100);
% 
% % time_min=time_interp/60;
% % time_min=time_min(:);
% % time_min2=time_s/60;
% 
% % plot(d_cpt100hz(1:end))
% % figure
% % plot(d_numblock(1:end))
% % n2=find(d_cpt100hz>1);
% % t=diff(cpt100hz(n2));
% % n2=find(d_cpt100hz)
% % 
% % figure(1)
% % hold on
% % plot(time_min,Result.MOTUSRAW(:,2))
% % title('Xaccl Motus')
% % figure(2)
% % hold on
% % plot(time_min,Result.MOTUSRAW(:,3))
% % title('Yaccl Motus')
% % figure(3)
% % hold on
% % plot(time_min,Result.MOTUSRAW(:,4))
% % title('Zaccl Motus')
% % figure(4)
% % hold on
% % plot(time_min,pat1(:))
% % title('Pattern1')
% % figure(5)
% % hold on
% % plot(time_min,pat2(:))
% % title('Pattern2')
% 
% % figure(6)
% % plot(time_min2,pat8)
% % title('PATTERN END BLOCK1')
% % figure(7)
% % hold on
% % plot(time_min,Result.MOTUSRAW(:,5))
% % title('Xgyro')
% % figure(8)
% % hold on
% % plot(time_min,Result.MOTUSRAW(:,6))
% % title('Ygyro')
% % figure(9)
% % hold on
% % plot(time_min,Result.MOTUSRAW(:,7))
% % title('Zgyro')
% % figure(10)
% % hold on
% % plot(time_min2,Result.MOTUSORI(:,2))
% % title('MOTUS Roll')
% % % figure(11)
% % hold on
% % plot(time_min2,Result.MOTUSORI(:,3))
% % title('MOTUS PITCH')
% % figure(12)
% % hold on
% % plot(time_min2,Result.MOTUSORI(:,4))
% % title('MOTUS HEADING')
% figure(1)
% hold on
% plot(ind1,cpt_511)
% title('cpt 511')
% figure(2)
% hold on
% plot(ind1,cpt_512)
% title('cpt 512')
% figure(3)
% hold on
% plot(ind1,cpt_561)
% title('cpt 561')
% figure(4)
% hold on
% plot(ind1,cpt_562)
% title('cpt 562')
% figure(5)
% hold on
% plot(ind1(2:end),diff(cpt100hz1))
% title('diff cpt 100hz')
% axis([1 ind1(end) -30 40])
% 
% figure(6)
% hold on
% plot(ind1(2:end),diff(blockSD1))
% title('diff numblock')
% axis([1 ind1(end) -5 10])
% % 
% % figure(5)
% % plot(Result.AD_NAVIGATION(1:nfin,13))
% % title('Yaccl Spatial')
% % 
% % figure(6)
% % plot(Result.AD_NAVIGATION(1:nfin,14))
% % title('Zaccl Spatial')
% end
% fclose(fid);
