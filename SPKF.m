% This code is used for estimationg SOC and R0

function [zest,R0est] = SPKF(Q,R0,R1,C,vdis,curdis,soc,ocv,xhat,R0hat)

sigmaxhat = diag([1e0 1e-3]);
sigmaw = 3e-1; % covariance process noise
sigmav = 4e-3; % covariance sensor noise
L = length(xhat) + length(sigmaw) + length(sigmav);
h = sqrt(3);
alpha1 = (h*h-L)/(h*h);
alpha2 = 1/(2*h*h);
alpham = [alpha1; repmat(alpha2,[2*L 1])];
alphac = alpham;
SigmaR0 = 1e-5;   % initial uncertainty of R0
SigmaWR0 = 1e-10; % noise driving R0 update
alpha1R0 = (h*h-1)/(h*h);
alpha2R0 = 1/(2*h*h);
R0m = [alpha1R0; alpha2R0; alpha2R0];
R0c = R0m; % covar
RC = exp(-0.1/(R1*C));
I  = curdis;
datalength = length(vdis);

for i = 1:datalength
% step 1a (xhatminus prediction), making xhat augment
[sigmaxhata,p] = chol(sigmaxhat,'lower');
Snoise = real(chol(diag([sigmaw; sigmav]),'lower'));
if p>0
fprintf('Cholesky error.  Recovering...\n')
theAbsDiag = abs(diag(sigmaxhat));
sigmaxhata = diag(max(sqrt(theAbsDiag),sqrt(sigmaw)));
end
sigmaxhata=[real(sigmaxhata) zeros([2 2]); zeros([2 2]) Snoise];
xhat = [xhat; 0; 0]; % [VRC; SOC; W; V]
% sigmaxhata = blkdiag(real(sqrt(sigmaxhat)),sqrt(sigmaw),sqrt(sigmav));
xa = xhat(:,ones([1 2*L+1])) + h*[zeros([L 1]), sigmaxhata, -sigmaxhata]; % xhat augment
Xx(1,:) = RC*xa(1,:) + (1-RC)*(I(i) + xa(3,:))*R1; % xhat for VRC
Xx(2,:) = xa(2,:) - (I(i) + xa(3,:))/3600/Q*0.1; % xhat for SOC
Xx(2,:) = min(1.05,max(-0.05,Xx(2,:)));
xhat = Xx*alpham; % product with constant

% step 1b
Xs = Xx - xhat(:,ones([1 2*L+1]));
sigmaxhat = Xs*diag(alphac)*Xs';

% step 1c (voltage prediciton determination)
Y = interp1(soc,ocv,Xx(2,:));
Y = Y - Xx(1,:) - R0hat*I(i) + xa(4,:);
yhat = Y*alpham;

% step 2a (kalman gain determination)
Ys = Y - yhat; 
sigmay = Ys*diag(alphac)*Ys';
sigmaxy = Xs*diag(alphac)*Ys';
K = sigmaxy/sigmay;

% step 2b (new xhat estimation)
r = vdis(i) - yhat; % the difference between measurement voltage and prediction voltage)
if r^2 > 100*sigmay, K(:,1)=0.0; end
xhat = xhat + K*r;
xhat(2)=min(1.05,max(-0.05,xhat(2)));

% step 2c (new xhat covariance)
sigmaxhat = sigmaxhat - K*sigmay*K';
[~,S,V] = svd(sigmaxhat);
HH = V*S*V';
sigmaxhat = (sigmaxhat + sigmaxhat' + HH + HH')/4;

if r^2>4sigmay, % bad voltage estimate by 2-SigmaX, bump Q 
    fprintf('Bumping sigmax\n');
    sigmaxhat(2,2) = sigmaxhat(2,2)*5;
end

% **** Now, implement simple 1-state parameter-estimation SPKF to estimate R0 ****  
    % Implement SPKF for R0hat
    % Step 1a -- R0hat prediction = R0hat estimate... no code needed
    % Step 1b -- R0hat covariance update
    SigmaR0 = SigmaR0 + SigmaWR0;
    % Step 1c -- ouput estimate
    W = R0hat*[1 1 1] + h*sqrt(SigmaR0)*[0 1 -1];
    % Next line is simplified output equation
    D = interp1(soc,ocv,xhat(2,:))*[1 1 1] - W*I(i);
    D = D - xhat(1,:);
    Dhat = D*R0m;
    % Step 2a -- gain estimate 
    Ds = D - Dhat;
    Ws = W - R0hat;
    Sd = Ds*diag(R0c)*Ds' + sigmav; % linear sensor noise
    Swd = Ws*diag(R0c)*Ds';
    KR0 = Swd/Sd;
    % Step 2b -- R0 estimate measurement update
    R0hat = R0hat + KR0*(vdis(i) - Dhat);
    % Step 2c -- R0 estimatation error covariance
    SigmaR0 = SigmaR0 - KR0*Sd*KR0';
  % **** end of simple 1-state SPKF to estimate R0 **** 

zest(i,:) = xhat;
yhatstore(i,:) = yhat;
R0est(i,:) = R0hat;
end

R0true = R0*ones(datalength,1);

end
