function [R0,R1,C,ocvRLS,errorvdisest,z,tdis,vdis,curdis] = parameterest(W8cycle,Q)

t = W8cycle(:,2);
step = W8cycle(:,4);
v = W8cycle(:,6);
cur = -W8cycle(:,7);
chgAh = W8cycle(:,8);
disAh = W8cycle(:,9);

ind = find(step == 14);
tdis = t(ind);
vdis = v(ind);
curdis = cur(ind);
datalength = length(vdis);

z = 0.8 - cumsum(curdis)/Q/3600*0.1;

a = [ones(datalength-1,1) vdis(1:datalength-1) curdis(2:datalength) curdis(1:datalength-1)];

NA = 4;
x = zeros(NA,1); P = 100*eye(NA,NA);
for k=1:datalength-1
   AA = a;
   bb = vdis(2:datalength);
   [x,K,P] = rlse_online(AA(k,:),bb(k,:),x,P);
   ocv(k) = x(1)/(1-x(2));
   R0(k) = (x(4)-x(3))/(1+x(2));
   RC(k) = (x(2)+1)/(2-2*x(2));
   R1(k) = -(x(3)+2*RC(k)*x(3)+R0(k)+2*R0(k)*RC(k));
   C(k) = RC(k)/R1(k);
end

ocvRLS = [v(ind(1)-1) ocv];
R0 = mean(R0); 
R1 = mean(R1);
C = mean(C);

RC = exp(-0.1/(R1*C));
vdisest = ocv(1);
vrc = 0;

for i = 1:datalength-1
    vrc = RC*vrc + (1-RC)*curdis(i+1);
    vdisest(i+1) = ocvRLS(i+1)' - vrc*R1 - R0*curdis(i+1);
end

errorvdisest = rmse(vdisest',vdis);

end
