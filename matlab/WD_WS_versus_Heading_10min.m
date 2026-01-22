%% North wind speed versus heading for the different parts of the flight

figure('Name','North wind speed versus heading; 2nd part of flight: Parallel to the axis joining T1 and T3')
plot(cell2mat(Heading_mean(17:22,3)),cell2mat(WindSpeed_North_SBG_mean(17:22)),'ob'); hold on;
plot(cell2mat(Heading_mean(17:22,3)),cell2mat(WindSpeed_North_SBG_mean_corr(17:22)),'or'); hold on;
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} North wind speed (m.s^{-1})');
%title('\fontsize{16} North wind speed');
%xlim([150 360])
std_VN_corr_part2=std(cell2mat(WindSpeed_North_SBG_mean_corr(17:22)));
std_VN_part2=std(cell2mat(WindSpeed_North_SBG_mean(17:22)));


%% East wind speed versus heading for the different parts of the flight

figure('Name','East wind speed versus heading; 2nd part of flight: Parallel to the axis joining T1 and T3')
plot(cell2mat(Heading_mean(17:22,3)),cell2mat(WindSpeed_East_SBG_mean(17:22)),'ob'); hold on;
plot(cell2mat(Heading_mean(17:22,3)),cell2mat(WindSpeed_East_SBG_mean_corr(17:22)),'or'); hold on;
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} East wind speed (m.s^{-1})');
%title('\fontsize{16} East wind speed');
%xlim([150 360])
std_VN_corr_part2=std(cell2mat(WindSpeed_East_SBG_mean_corr(17:22)));
std_VN_part2=std(cell2mat(WindSpeed_East_SBG_mean(17:22)));


%% Horizontal wind speed versus heading for the different parts of the flight

figure('Name','Horizontal wind speed versus heading; 2nd part of flight: Parallel to the axis joining T1 and T3')
plot(cell2mat(Heading_mean(17:22,3)),cell2mat(Windspeed_mean(17:22)),'ob'); hold on;
plot(cell2mat(Heading_mean(17:22,3)),cell2mat(Windspeed_corr_mean(17:22)),'or'); hold on;
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} Horizontal wind speed (m.s^{-1})');
%title('\fontsize{16} Horizontal wind speed');
%xlim([150 360])
std_VN_corr_part2=std(cell2mat(Windspeed_mean(17:22)));
std_VN_part2=std(cell2mat(Windspeed_mean(17:22)));



%% Wind direction versus heading for the different parts of the flight


figure('Name','Wind direction versus heading; 2nd part of flight: Parallel to the axis joining T1 and T3')
plot(cell2mat(Heading_mean(17:22,3)),cell2mat(WD_SBG_mean(17:22)),'ob'); hold on;
plot(cell2mat(Heading_mean(17:22,3)),cell2mat(WD_SBG_corr_mean(17:22)),'or'); hold on;
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16}Wind direction (m.s^{-1})');
%title('\fontsize{16}Wind direction');
%xlim([150 360])
std_VN_corr_part2=std(cell2mat(WD_SBG_mean(17:22)));
std_VN_part2=std(cell2mat(WD_SBG_mean(17:22)));


