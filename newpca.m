% New work on PCA. 2017-11-07 by Weihua Wang
% Read and plot pca results from R. 
% SO2, NO2, HCHO, IR340/675, I500, PC1, PC2, PC3, PC4, PC5 and Time should be assigned.

close all,clear all,clc;
row=1,col=0; % 1st row with header corresponds to an index of 0. column 0 means the 1st column. 
dt = csvread('~/pcadat1.csv',row,col);  % ~/  means read from home directory
dt(1,:) % check if correctly imported
HCHO = dt(:,1); % 1st column refers to HCHO concentration
NO2 = dt(:,2);
SO2 = dt(:,3);
IR340_675 = dt(:,4);
I500 = dt(:,5);
PC1 = dt(:,6);
PC2 = dt(:,7);
PC3 = dt(:,8);
PC4 = dt(:,9);
PC5 = dt(:,10);
Time = dt(:,11);

% Rescaled and standardized plots
plot(Time, SO2/50, '-b','linewidth',2); 
xlabel('Time'); ylabel('');
title('Rescaled standardized SO2/NO2/HCHO, I500, IR340/675 and PC1');
xlim([Time(1), Time(end)]); ylim([-0.4,0.6]);
hold on;
plot(Time, NO2/30, '-g','linewidth',2);
plot(Time, HCHO/50, '-k','linewidth',2);
plot(Time, IR340_675/40, '-m','linewidth',2);
plot(Time, I500/6, '-c','linewidth',2);
plot(Time, PC1/20, '-r','linewidth',2);
legend('SO2conc / 50', 'NO2conc / 30', 'HCHOconc / 50',...
'IR_{340/675} / 40', 'I500 / 6', 'PC1 / 20');

%print Newpca1.pdf;
set(gcf, 'papersize', [17, 9.6], 'paperposition', [0 0 17 9.6]);
print Newpca1.pdf;

%

plot(Time, SO2/50, '-b','linewidth',2); 
xlabel('Time'); ylabel('');
title('Rescaled standardized SO2/NO2/HCHO, I500, IR340/675 and PC2');
xlim([Time(1), Time(end)]); ylim([-0.4,0.6]);
hold on;
plot(Time, NO2/30, '-g','linewidth',2);
plot(Time, HCHO/50, '-k','linewidth',2);
plot(Time, IR340_675/40, '-m','linewidth',2);
plot(Time, I500/6, '-c','linewidth',2);
plot(Time, PC2/30, '-r','linewidth',2);
legend('SO2conc / 50', 'NO2conc / 30', 'HCHOconc / 50',...
'IR_{340/675} / 40', 'I500 / 6', 'PC2 / 30');

set(gcf, 'papersize', [17, 9.6], 'paperposition', [0 0 17 9.6]);
print Newpca2.pdf;

%

plot(Time, SO2/35, '-b','linewidth',2); 
xlabel('Time'); ylabel('');
title('Rescaled standardized SO2/NO2/HCHO, I500, IR340/675 and PC3');
xlim([Time(1), Time(end)]); ylim([-0.4,0.8]);
hold on;
plot(Time, NO2/20, '-g','linewidth',2);
plot(Time, HCHO/40, '-k','linewidth',2);
plot(Time, IR340_675/40, '-m','linewidth',2);
plot(Time, I500/6, '-c','linewidth',2);
plot(Time, PC3/40, '-r','linewidth',2);
legend('SO2conc / 35', 'NO2conc / 20', 'HCHOconc / 40',...
'IR_{340/675} / 40', 'I500 / 6', 'PC3 / 40');

set(gcf, 'papersize', [17, 9.6], 'paperposition', [0 0 17 9.6]);
print Newpca3.pdf;

%

plot(Time, SO2/40, '-b','linewidth',2); 
xlabel('Time'); ylabel('');
title('Rescaled standardized SO2/NO2/HCHO, I500, IR340/675 and PC4');
xlim([Time(1), Time(end)]); ylim([-0.4,0.8]);
hold on;
plot(Time, NO2/20, '-g','linewidth',2);
plot(Time, HCHO/35, '-k','linewidth',2);
plot(Time, IR340_675/30, '-m','linewidth',2);
plot(Time, I500/6, '-c','linewidth',2);
plot(Time, PC4/25, '-r','linewidth',2);
legend('SO2conc / 40', 'NO2conc / 20', 'HCHOconc / 35',...
'IR_{340/675} / 30', 'I500 / 6', 'PC4 / 25');

set(gcf, 'papersize', [17, 9.6], 'paperposition', [0 0 17 9.6]);
print Newpca4.pdf;

%

plot(Time, SO2/40, '-b','linewidth',2); 
xlabel('Time'); ylabel('');
title('Rescaled standardized SO2/NO2/HCHO, I500, IR340/675 and PC5');
xlim([Time(1), Time(end)]); ylim([-0.4,0.8]);
hold on;
plot(Time, NO2/20, '-g','linewidth',2);
plot(Time, HCHO/30, '-k','linewidth',2);
plot(Time, IR340_675/20, '-m','linewidth',2);
plot(Time, I500/6, '-c','linewidth',2);
plot(Time, PC5/15, '-r','linewidth',2);
legend('SO2conc / 40', 'NO2conc / 20', 'HCHOconc / 30',...
'IR_{340/675} / 20', 'I500 / 6', 'PC5 / 15');

set(gcf, 'papersize', [17, 9.6], 'paperposition', [0 0 17 9.6]);
print Newpca5.pdf;

% Scatter plots
figure;
scatter(SO2,PC1,'.');
xlabel('SO2');ylabel('PC1');title('SO2 vs PC1');

figure;
scatter(NO2,PC1,'.');
xlabel('NO2');ylabel('PC1');title('NO2 vs PC1');

figure;
scatter(HCHO,PC1,'.');
xlabel('HCHO');ylabel('PC1');title('HCHO vs PC1');

figure;
scatter(IR340_675,PC1,'.');
xlabel('IR_{340/675}');ylabel('PC1');title('IR_{340/675} vs PC1');

figure;
scatter(I500,PC1,'.');
xlabel('I500');ylabel('PC1');title('I500 vs PC1');

%
figure;
scatter(SO2,PC2,'.');
xlabel('SO2');ylabel('PC2');title('SO2 vs PC2');

figure;
scatter(NO2,PC2,'.');
xlabel('NO2');ylabel('PC2');title('NO2 vs PC2');

figure;
scatter(HCHO,PC2,'.');
xlabel('HCHO');ylabel('PC2');title('HCHO vs PC2');

figure;
scatter(IR340_675,PC2,'.');
xlabel('IR_{340/675}');ylabel('PC2');title('IR_{340/675} vs PC2');

figure;
scatter(I500,PC2,'.');
xlabel('I500');ylabel('PC2');title('I500 vs PC2');

%
figure;
scatter(SO2,PC3,'.');
xlabel('SO2');ylabel('PC3');title('SO2 vs PC3');

figure;
scatter(NO2,PC3,'.');
xlabel('NO2');ylabel('PC3');title('NO2 vs PC3');

figure;
scatter(HCHO,PC3,'.');
xlabel('HCHO');ylabel('PC3');title('HCHO vs PC3');

figure;
scatter(IR340_675,PC3,'.');
xlabel('IR_{340/675}');ylabel('PC3');title('IR_{340/675} vs PC3');

figure;
scatter(I500,PC3,'.');
xlabel('I500');ylabel('PC3');title('I500 vs PC3');

%
figure;
scatter(SO2,PC4,'.');
xlabel('SO2');ylabel('PC4');title('SO2 vs PC4');

figure;
scatter(NO2,PC4,'.');
xlabel('NO2');ylabel('PC4');title('NO2 vs PC4');

figure;
scatter(HCHO,PC4,'.');
xlabel('HCHO');ylabel('PC4');title('HCHO vs PC4');

figure;
scatter(IR340_675,PC4,'.');
xlabel('IR_{340/675}');ylabel('PC4');title('IR_{340/675} vs PC4');

figure;
scatter(I500,PC4,'.');
xlabel('I500');ylabel('PC4');title('I500 vs PC4');

%
figure;
scatter(SO2,PC5,'.');
xlabel('SO2');ylabel('PC5');title('SO2 vs PC5');

figure;
scatter(NO2,PC5,'.');
xlabel('NO2');ylabel('PC5');title('NO2 vs PC5');

figure;
scatter(HCHO,PC5,'.');
xlabel('HCHO');ylabel('PC5');title('HCHO vs PC5');

figure;
scatter(IR340_675,PC5,'.');
xlabel('IR_{340/675}');ylabel('PC5');title('IR_{340/675} vs PC5');

figure;
scatter(I500,PC5,'.');
xlabel('I500');ylabel('PC5');title('I500 vs PC5');
