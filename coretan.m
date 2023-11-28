clear, clc

oldopts = optimset('TolFun',1e-6);
options = optimset(oldopts,'PlotFcns','optimplotfval','TolX',1e-7);

fun = @(x)x^2; % Rosenbrock's function
x0 = [9];
[x,fval] = fminsearch(fun,x0,options)

x = [1 2 3];

