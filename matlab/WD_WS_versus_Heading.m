%% North wind speed versus heading for the different parts of the flight
figure('Name','North wind speed versus heading; 1st part of flight: Hippodrome BOREAL')
plot(cell2mat(Heading_mean(1:6,3)),cell2mat(WindSpeed_North_SBG_mean(1:6)),'ob'); hold on;
plot(cell2mat(Heading_mean(1:6,3)),cell2mat(WindSpeed_North_SBG_mean_corr(1:6)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} North wind speed (m.s^{-1})');
%title('\fontsize{16} North wind speed');
%xlim([150 360])
std_VN_corr_part1=std(cell2mat(WindSpeed_North_SBG_mean_corr(1:6)));
std_VN_part1=std(cell2mat(WindSpeed_North_SBG_mean(1:6)));

figure('Name','North wind speed versus heading; 2nd part of flight: Parallel to the axis joining T1 and T3')
plot(cell2mat(Heading_mean(7:22,3)),cell2mat(WindSpeed_North_SBG_mean(7:22)),'ob'); hold on;
plot(cell2mat(Heading_mean(7:22,3)),cell2mat(WindSpeed_North_SBG_mean_corr(7:22)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} North wind speed (m.s^{-1})');
%title('\fontsize{16} North wind speed');
%xlim([150 360])
std_VN_corr_part2=std(cell2mat(WindSpeed_North_SBG_mean_corr(7:22)));
std_VN_part2=std(cell2mat(WindSpeed_North_SBG_mean(7:22)));

figure('Name','North wind speed versus heading; 3rd part of flight: Oblique orientation to the wind turbines')
plot(cell2mat(Heading_mean(23:38,3)),cell2mat(WindSpeed_North_SBG_mean(23:38)),'ob'); hold on;
plot(cell2mat(Heading_mean(23:38,3)),cell2mat(WindSpeed_North_SBG_mean_corr(23:38)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} North wind speed (m.s^{-1})');
%title('\fontsize{16} North wind speed');
%xlim([150 360])
std_VN_corr_part3=std(cell2mat(WindSpeed_North_SBG_mean_corr(23:38)));
std_VN_part3=std(cell2mat(WindSpeed_North_SBG_mean(23:38)));

figure('Name','North wind speed versus heading; 4th part of flight: In the axis of turbines')
plot(cell2mat(Heading_mean(39:50,3)),cell2mat(WindSpeed_North_SBG_mean(39:50)),'ob'); hold on;
plot(cell2mat(Heading_mean(39:50,3)),cell2mat(WindSpeed_North_SBG_mean_corr(39:50)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} North wind speed (m.s^{-1})');
%title('\fontsize{16} North wind speed');
%xlim([150 360])
std_VN_corr_part4=std(cell2mat(WindSpeed_North_SBG_mean_corr(39:50)));
std_VN_part4=std(cell2mat(WindSpeed_North_SBG_mean(39:50)));

figure('Name','North wind speed versus heading; 5th part of flight: Parallel to the axis joining T1 and T3')
plot(cell2mat(Heading_mean(53:68,3)),cell2mat(WindSpeed_North_SBG_mean(53:68)),'ob'); hold on;
plot(cell2mat(Heading_mean(53:68,3)),cell2mat(WindSpeed_North_SBG_mean_corr(53:68)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} North wind speed (m.s^{-1})');
%title('\fontsize{16} North wind speed');
%xlim([150 360])
std_VN_corr_part5=std(cell2mat(WindSpeed_North_SBG_mean_corr(53:68)));
std_VN_part5=std(cell2mat(WindSpeed_North_SBG_mean(53:68)));

figure('Name','North wind speed versus heading; 6th part of flight: Oblique orientation to the wind turbines')
plot(cell2mat(Heading_mean(69:84,3)),cell2mat(WindSpeed_North_SBG_mean(69:84)),'ob'); hold on;
plot(cell2mat(Heading_mean(69:84,3)),cell2mat(WindSpeed_North_SBG_mean_corr(69:84)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} North wind speed (m.s^{-1})');
%title('\fontsize{16} North wind speed');
%xlim([160 360])
std_VN_corr_part6=std(cell2mat(WindSpeed_North_SBG_mean_corr(69:84)));
std_VN_part6=std(cell2mat(WindSpeed_North_SBG_mean(69:84)));

figure('Name','North wind speed versus heading; 7th part of flight: In the axis of turbines')
plot(cell2mat(Heading_mean(85:98,3)),cell2mat(WindSpeed_North_SBG_mean(85:98)),'ob'); hold on;
plot(cell2mat(Heading_mean(85:98,3)),cell2mat(WindSpeed_North_SBG_mean_corr(85:98)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{17} Heading angle (degrees)');
ylabel ('\fontsize{17}\fontsize{17} North wind speed (m.s^{-1})');
%title('\fontsize{17} North wind speed');
%xlim([170 370])
std_VN_corr_part7=std(cell2mat(WindSpeed_North_SBG_mean_corr(85:98)));
std_VN_part7=std(cell2mat(WindSpeed_North_SBG_mean(85:98)));


%% East wind speed versus heading for the different parts of the flight
figure('Name','East wind speed versus heading; 1st part of flight: Hippodrome BOREAL')
plot(cell2mat(Heading_mean(1:6,3)),cell2mat(WindSpeed_East_SBG_mean(1:6)),'ob'); hold on;
plot(cell2mat(Heading_mean(1:6,3)),cell2mat(WindSpeed_East_SBG_mean_corr(1:6)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} East wind speed (m.s^{-1})');
%title('\fontsize{16} East wind speed');
%xlim([150 360])
std_VN_corr_part1=std(cell2mat(WindSpeed_East_SBG_mean_corr(1:6)));
std_VN_part1=std(cell2mat(WindSpeed_East_SBG_mean(1:6)));

figure('Name','East wind speed versus heading; 2nd part of flight: Parallel to the axis joining T1 and T3')
plot(cell2mat(Heading_mean(7:22,3)),cell2mat(WindSpeed_East_SBG_mean(7:22)),'ob'); hold on;
plot(cell2mat(Heading_mean(7:22,3)),cell2mat(WindSpeed_East_SBG_mean_corr(7:22)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} East wind speed (m.s^{-1})');
%title('\fontsize{16} East wind speed');
%xlim([150 360])
std_VN_corr_part2=std(cell2mat(WindSpeed_East_SBG_mean_corr(7:22)));
std_VN_part2=std(cell2mat(WindSpeed_East_SBG_mean(7:22)));

figure('Name','East wind speed versus heading; 3rd part of flight: Oblique orientation to the wind turbines')
plot(cell2mat(Heading_mean(23:38,3)),cell2mat(WindSpeed_East_SBG_mean(23:38)),'ob'); hold on;
plot(cell2mat(Heading_mean(23:38,3)),cell2mat(WindSpeed_East_SBG_mean_corr(23:38)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} East wind speed (m.s^{-1})');
%title('\fontsize{16} East wind speed');
%xlim([150 360])
std_VN_corr_part3=std(cell2mat(WindSpeed_East_SBG_mean_corr(23:38)));
std_VN_part3=std(cell2mat(WindSpeed_East_SBG_mean(23:38)));

figure('Name','East wind speed versus heading; 4th part of flight: In the axis of turbines')
plot(cell2mat(Heading_mean(39:50,3)),cell2mat(WindSpeed_East_SBG_mean(39:50)),'ob'); hold on;
plot(cell2mat(Heading_mean(39:50,3)),cell2mat(WindSpeed_East_SBG_mean_corr(39:50)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} East wind speed (m.s^{-1})');
%title('\fontsize{16} East wind speed');
%xlim([150 360])
std_VN_corr_part4=std(cell2mat(WindSpeed_East_SBG_mean_corr(39:50)));
std_VN_part4=std(cell2mat(WindSpeed_East_SBG_mean(39:50)));

figure('Name','East wind speed versus heading; 5th part of flight: Parallel to the axis joining T1 and T3')
plot(cell2mat(Heading_mean(53:68,3)),cell2mat(WindSpeed_East_SBG_mean(53:68)),'ob'); hold on;
plot(cell2mat(Heading_mean(53:68,3)),cell2mat(WindSpeed_East_SBG_mean_corr(53:68)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} East wind speed (m.s^{-1})');
%title('\fontsize{16} East wind speed');
%xlim([150 360])
std_VN_corr_part5=std(cell2mat(WindSpeed_East_SBG_mean_corr(53:68)));
std_VN_part5=std(cell2mat(WindSpeed_East_SBG_mean(53:68)));

figure('Name','East wind speed versus heading; 6th part of flight: Oblique orientation to the wind turbines')
plot(cell2mat(Heading_mean(69:84,3)),cell2mat(WindSpeed_East_SBG_mean(69:84)),'ob'); hold on;
plot(cell2mat(Heading_mean(69:84,3)),cell2mat(WindSpeed_East_SBG_mean_corr(69:84)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} East wind speed (m.s^{-1})');
%title('\fontsize{16} East wind speed');
%xlim([160 360])
std_VN_corr_part6=std(cell2mat(WindSpeed_East_SBG_mean_corr(69:84)));
std_VN_part6=std(cell2mat(WindSpeed_East_SBG_mean(69:84)));

figure('Name','East wind speed versus heading; 7th part of flight: In the axis of turbines')
plot(cell2mat(Heading_mean(85:98,3)),cell2mat(WindSpeed_East_SBG_mean(85:98)),'ob'); hold on;
plot(cell2mat(Heading_mean(85:98,3)),cell2mat(WindSpeed_East_SBG_mean_corr(85:98)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{17} Heading angle (degrees)');
ylabel ('\fontsize{17}\fontsize{17} East wind speed (m.s^{-1})');
%title('\fontsize{17} East wind speed');
%xlim([170 370])
std_VN_corr_part7=std(cell2mat(WindSpeed_East_SBG_mean_corr(85:98)));
std_VN_part7=std(cell2mat(WindSpeed_East_SBG_mean(85:98)));

%% Horizontal wind speed versus heading for the different parts of the flight
figure('Name','Horizontal wind speed versus heading; 1st part of flight: Hippodrome BOREAL')
plot(cell2mat(Heading_mean(1:6,3)),cell2mat(Windspeed_mean(1:6)),'ob'); hold on;
plot(cell2mat(Heading_mean(1:6,3)),cell2mat(Windspeed_corr_mean(1:6)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} Horizontal wind speed (m.s^{-1})');
%title('\fontsize{16} Horizontal wind speed');
%xlim([150 360])
std_VN_corr_part1=std(cell2mat(Windspeed_mean(1:6)));
std_VN_part1=std(cell2mat(Windspeed_mean(1:6)));

figure('Name','Horizontal wind speed versus heading; 2nd part of flight: Parallel to the axis joining T1 and T3')
plot(cell2mat(Heading_mean(7:22,3)),cell2mat(Windspeed_mean(7:22)),'ob'); hold on;
plot(cell2mat(Heading_mean(7:22,3)),cell2mat(Windspeed_corr_mean(7:22)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} Horizontal wind speed (m.s^{-1})');
%title('\fontsize{16} Horizontal wind speed');
%xlim([150 360])
std_VN_corr_part2=std(cell2mat(Windspeed_mean(7:22)));
std_VN_part2=std(cell2mat(Windspeed_mean(7:22)));

figure('Name','Horizontal wind speed versus heading; 3rd part of flight: Oblique orientation to the wind turbines')
plot(cell2mat(Heading_mean(23:38,3)),cell2mat(Windspeed_mean(23:38)),'ob'); hold on;
plot(cell2mat(Heading_mean(23:38,3)),cell2mat(Windspeed_corr_mean(23:38)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} Horizontal wind speed (m.s^{-1})');
%title('\fontsize{16} Horizontal wind speed');
%xlim([150 360])
std_VN_corr_part3=std(cell2mat(Windspeed_mean(23:38)));
std_VN_part3=std(cell2mat(Windspeed_mean(23:38)));

figure('Name','Horizontal wind speed versus heading; 4th part of flight: In the axis of turbines')
plot(cell2mat(Heading_mean(39:50,3)),cell2mat(Windspeed_mean(39:50)),'ob'); hold on;
plot(cell2mat(Heading_mean(39:50,3)),cell2mat(Windspeed_corr_mean(39:50)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} Horizontal wind speed (m.s^{-1})');
%title('\fontsize{16} Horizontal wind speed');
%xlim([150 360])
std_VN_corr_part4=std(cell2mat(Windspeed_mean(39:50)));
std_VN_part4=std(cell2mat(Windspeed_mean(39:50)));

figure('Name','Horizontal wind speed versus heading; 5th part of flight: Parallel to the axis joining T1 and T3')
plot(cell2mat(Heading_mean(53:68,3)),cell2mat(Windspeed_mean(53:68)),'ob'); hold on;
plot(cell2mat(Heading_mean(53:68,3)),cell2mat(Windspeed_corr_mean(53:68)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} Horizontal wind speed (m.s^{-1})');
%title('\fontsize{16} Horizontal wind speed');
%xlim([150 360])
std_VN_corr_part5=std(cell2mat(Windspeed_mean(53:68)));
std_VN_part5=std(cell2mat(Windspeed_mean(53:68)));

figure('Name','Horizontal wind speed versus heading; 6th part of flight: Oblique orientation to the wind turbines')
plot(cell2mat(Heading_mean(69:84,3)),cell2mat(Windspeed_mean(69:84)),'ob'); hold on;
plot(cell2mat(Heading_mean(69:84,3)),cell2mat(Windspeed_corr_mean(69:84)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16} Horizontal wind speed (m.s^{-1})');
%title('\fontsize{16} Horizontal wind speed');
%xlim([160 360])
std_VN_corr_part6=std(cell2mat(Windspeed_mean(69:84)));
std_VN_part6=std(cell2mat(Windspeed_mean(69:84)));

figure('Name','Horizontal wind speed versus heading; 7th part of flight: In the axis of turbines')
plot(cell2mat(Heading_mean(85:98,3)),cell2mat(Windspeed_mean(85:98)),'ob'); hold on;
plot(cell2mat(Heading_mean(85:98,3)),cell2mat(Windspeed_corr_mean(85:98)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{17} Heading angle (degrees)');
ylabel ('\fontsize{17}\fontsize{17} Horizontal wind speed (m.s^{-1})');
%title('\fontsize{17} Horizontal wind speed');
%xlim([170 370])
std_VN_corr_part7=std(cell2mat(Windspeed_mean(85:98)));
std_VN_part7=std(cell2mat(Windspeed_mean(85:98)));

%% Wind direction versus heading for the different parts of the flight
figure('Name','Wind direction versus heading; 1st part of flight: Hippodrome BOREAL')
plot(cell2mat(Heading_mean(1:6,3)),cell2mat(WD_SBG_mean(1:6)),'ob'); hold on;
plot(cell2mat(Heading_mean(1:6,3)),cell2mat(WD_SBG_corr_mean(1:6)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16}Wind direction (m.s^{-1})');
%title('\fontsize{16}Wind direction');
%xlim([150 360])
std_VN_corr_part1=std(cell2mat(WD_SBG_mean(1:6)));
std_VN_part1=std(cell2mat(WD_SBG_mean(1:6)));

figure('Name','Wind direction versus heading; 2nd part of flight: Parallel to the axis joining T1 and T3')
plot(cell2mat(Heading_mean(7:22,3)),cell2mat(WD_SBG_mean(7:22)),'ob'); hold on;
plot(cell2mat(Heading_mean(7:22,3)),cell2mat(WD_SBG_corr_mean(7:22)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16}Wind direction (m.s^{-1})');
%title('\fontsize{16}Wind direction');
%xlim([150 360])
std_VN_corr_part2=std(cell2mat(WD_SBG_mean(7:22)));
std_VN_part2=std(cell2mat(WD_SBG_mean(7:22)));

figure('Name','Wind direction versus heading; 3rd part of flight: Oblique orientation to the wind turbines')
plot(cell2mat(Heading_mean(23:38,3)),cell2mat(WD_SBG_mean(23:38)),'ob'); hold on;
plot(cell2mat(Heading_mean(23:38,3)),cell2mat(WD_SBG_corr_mean(23:38)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16}Wind direction (m.s^{-1})');
%title('\fontsize{16}Wind direction');
%xlim([150 360])
std_VN_corr_part3=std(cell2mat(WD_SBG_mean(23:38)));
std_VN_part3=std(cell2mat(WD_SBG_mean(23:38)));

figure('Name','Wind direction versus heading; 4th part of flight: In the axis of turbines')
plot(cell2mat(Heading_mean(39:50,3)),cell2mat(WD_SBG_mean(39:50)),'ob'); hold on;
plot(cell2mat(Heading_mean(39:50,3)),cell2mat(WD_SBG_corr_mean(39:50)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16}Wind direction (m.s^{-1})');
%title('\fontsize{16}Wind direction');
%xlim([150 360])
std_VN_corr_part4=std(cell2mat(WD_SBG_mean(39:50)));
std_VN_part4=std(cell2mat(WD_SBG_mean(39:50)));

figure('Name','Wind direction versus heading; 5th part of flight: Parallel to the axis joining T1 and T3')
plot(cell2mat(Heading_mean(53:68,3)),cell2mat(WD_SBG_mean(53:68)),'ob'); hold on;
plot(cell2mat(Heading_mean(53:68,3)),cell2mat(WD_SBG_corr_mean(53:68)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16}Wind direction (m.s^{-1})');
%title('\fontsize{16}Wind direction');
%xlim([150 360])
std_VN_corr_part5=std(cell2mat(WD_SBG_mean(53:68)));
std_VN_part5=std(cell2mat(WD_SBG_mean(53:68)));

figure('Name','Wind direction versus heading; 6th part of flight: Oblique orientation to the wind turbines')
plot(cell2mat(Heading_mean(69:84,3)),cell2mat(WD_SBG_mean(69:84)),'ob'); hold on;
plot(cell2mat(Heading_mean(69:84,3)),cell2mat(WD_SBG_corr_mean(69:84)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{16} Heading angle (degrees)');
ylabel ('\fontsize{16}\fontsize{16}Wind direction (m.s^{-1})');
%title('\fontsize{16}Wind direction');
%xlim([160 360])
std_VN_corr_part6=std(cell2mat(WD_SBG_mean(69:84)));
std_VN_part6=std(cell2mat(WD_SBG_mean(69:84)));

figure('Name','Wind direction versus heading; 7th part of flight: In the axis of turbines')
plot(cell2mat(Heading_mean(85:98,3)),cell2mat(WD_SBG_mean(85:98)),'ob'); hold on;
plot(cell2mat(Heading_mean(85:98,3)),cell2mat(WD_SBG_corr_mean(85:98)),'or'); hold on;
ylabel('Wind speed (m^{-1})')
legend('\fontsize{12} Without correction','\fontsize{12} Corrected','Location','best');
xlabel ( '\fontsize{17} Heading angle (degrees)');
ylabel ('\fontsize{17}\fontsize{17}Wind direction (m.s^{-1})');
%title('\fontsize{17}Wind direction');
%xlim([170 370])
std_VN_corr_part7=std(cell2mat(WD_SBG_mean(85:98)));
std_VN_part7=std(cell2mat(WD_SBG_mean(85:98)));

