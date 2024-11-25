clear, clc

load W8diag1.mat % input diagnostic test
load W8cycle1.mat % input cycle test

xhat = [0; 0.6]; % initial vRc and soc estimate
R0hat = 0.01; % initial R0 estimate

[soc,ocv,Q] = SOC_OCV(W8diag1); % find Q, OCV, SOC from diagnostic test
[R0,R1,C,ocvRLS,errorvdisest,z,tdis,vdis,curdis,vdisest] = parameterest(W8cycle1,Q); % find parameter from cycle test
[zest,R0est] = SPKF(Q,R0,R1,C,vdis,curdis,soc,ocv,xhat,R0hat); % SPKF function

R0 = R0*ones(length(R0est),1);
errorvdisest; % error between measurement and estimation voltage
errorsoc = rmse(zest(:,2),z); % error between soc real and estimation
errorR0 = rmse(R0est,R0); % error between R0 real and estimation

% figure of true and estimate Voltage
figure(1)
plot(tdis/3600,vdis,'-r',tdis/3600,vdisest','-b')
xlabel('Time [h]'); ylabel('Voltage [V]'); legend('True Voltage','Voltage estimation')
xlim([-inf inf]); ylim([-inf inf]); title('Voltage estimation using SPKF')
fontsize(gcf,scale=1.5)

% figure of true and estimate SOC
figure(2)
plot(tdis/3600,z,'-r',tdis/3600,zest(:,2),'-b')
xlabel('Time [h]'); ylabel('SOC'); legend('True SOC','SOC estimation')
xlim([-inf inf]); ylim([-inf inf]); title('SOC estimation using SPKF')
fontsize(gcf,scale=1.5)

% figure of true and estimate R0
figure(3)
plot(tdis/3600,R0,'-r',tdis/3600,R0est,'-b')
xlabel('Time [h]'); ylabel('R0 [ohm]'); legend('True R0','R0 estimation')
xlim([-inf inf]); ylim([0 0.05]); title('R0 estimation using SPKF')
yticks(0:0.01:0.05);
fontsize(gcf,scale=1.5)
