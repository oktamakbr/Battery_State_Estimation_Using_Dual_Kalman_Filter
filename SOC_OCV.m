% This code is used for estimating SOC and OCV relationship, cell capacity
% [Q]

function [soc,ocv,Q] = SOC_OCV(W8diag)

% step 1 = rest
% step 2 = cc charge
% step 3 = cv charge
% step 4 = rest
% step 5 = cc discharge
% step 6 = rest

time = W8diag(:,2);
step = W8diag(:,4);
v = W8diag(:,6);
cur = -W8diag(:,7);
chgAh = W8diag(:,8);
disAh = W8diag(:,9);

ind = find(step == 5);
ocvraw = v(ind);
timedis = time(ind);
dis = cumsum(cur(ind)/3600);
Q = disAh(end);

socraw = 1 - dis/Q;
soc = 0:0.01:1;

ocv = interp1(socraw,ocvraw,soc);
ocv(1) = v(ind(end));
ocv(end) = v(ind(1)-1);


end
