clear, clc

load W8diag1.mat
load W8cycle1.mat

[soc,ocv,Q] = SOC_OCV(W8diag1); % find Q, OCV, SOC from diagnostic test
[R0,R1,C,ocvRLS,errorvdisest,z,tdis,vdis,curdis] = parameterest(W8cycle1,Q); % find parameter from cycle test
[zest,R0est] = SPKF(Q,R0,R1,C,vdis,curdis,soc,ocv); % SPKF function

R0 = R0*ones(length(R0est),1);
errorsoc = rmse(zest(:,2),z);
errorR0 = rmse(R0est,R0);

figure(1)
plot(tdis/3600,z,'-r',tdis/3600,zest(:,2),'-b')

figure(2)
plot(tdis/3600,R0,'-r',tdis/3600,R0est,'-b')
