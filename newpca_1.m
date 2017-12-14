% New work on PCA. 2017-11-14
% read and plot SO2 concentration from R. 
% SO2 unfiltered, SO2 filtered and Time.

close all,clear all,clc;
row=1,col=0; % 1st row with header corresponds to an index of 0. column 0 means the 1st column. 
dt = csvread("~/SO2conc.csv",row,col);  % ~/  means read from home directory
dt(1,:) % check if correctly imported
SO2 = dt(:,1); % 1st column refers to unfiltered SO2 concentration
Time = dt(:,2); 
SO2fil = dt(:,3); % filtered SO2 concentration

plot(Time, SO2, '-b','linewidth',2); 
xlabel('Time'); ylabel('');
title('SO2 concentration');
xlim([Time(1), Time(end)]); 
hold on;
plot(Time, SO2fil, '-r','linewidth',2);
legend('SO_{2} Unfiltered', 'SO_{2} Filtered');

%print SO2conc.pdf;
set(gcf, "papersize", [14, 9.6], "paperposition", [0 0 14 9.6]);
print SO2conc.pdf;
