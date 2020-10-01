function [fitobject,resnorm,residual,exitflag,output,lambda,jacobian,beta,R,J,CovB,MSE,ErrorModelInfo] = fitLogistic(x,y,xscale,yscale,mysign,restricted)
% Logistic fitting following:
%  y = a + (b-a) / (1 + exp(-c*(x-d)))
% or
%  y = a + b / (1 + exp(-c*(x-d)))
% x and y must be row vectors

if isempty(xscale)
    xscale = [-Inf Inf];
else
    dxscale = xscale(2) - xscale(1);
    xscale(1) = xscale(1) - dxscale/2;
    xscale(2) = xscale(2) + dxscale/2;
end
if isempty(mysign)
    mysign = sign(corr(x,y));
end

%% Matlab fit

if ~restricted
    % y = a + b / (1 + exp(-c*(x-d)))
    
%     disp('a')
    fun = @(p,x) p(1) + p(2) ./ (1 + exp(-p(3)*(x-p(4))));
    f = fittype('a + b ./ (1 + exp(-c*(x-d)))');
    if mysign == 1
        lb = [min(yscale) 0                       0   xscale(1)];
        ub = [max(yscale) max(yscale)-min(yscale) Inf xscale(2)];
    else
        lb = [min(yscale) 0                       -Inf xscale(1)];
        ub = [max(yscale) max(yscale)-min(yscale)  0   xscale(2)];
    end

    % p0
    epsilon = (max(yscale) - min(yscale)) / 100;
    a0 = min(y);
    b0 = max(y) - a0;
    u = x;
    v = log((max(yscale) + 2*epsilon) ./ (y - (min(yscale) - epsilon)) - 1);
%     min(v)
%     max(v)
%     keyboard
    fitobject0 = fit(u,v,'poly1');
    c0 = -fitobject0.p1;
    d0 = fitobject0.p2 / c0;
    p0 = [a0 b0 c0 d0];
    
else
    % y = a + (b-a) / (1 + exp(-c*(x-d)))
    
%     disp('b')
    delta = 0.2*(max(yscale) - min(yscale));
    
    fun = @(p,x) p(1) + (p(2)-p(1)) ./ (1 + exp(-p(3)*(x-p(4))));
    f = fittype('a + (b-a) ./ (1 + exp(-c*(x-d)))');
    if mysign == 1
        lb = [min(yscale)       max(yscale)-delta 0   xscale(1)];
        ub = [min(yscale)+delta max(yscale)       Inf xscale(2)];
    else
        lb = [min(yscale)       max(yscale)-delta -Inf xscale(1)];
        ub = [min(yscale)+delta max(yscale)        0   xscale(2)];
    end
    
    % p0
    epsilon = (max(yscale) - min(yscale)) / 100;
    a0 = min(y);
    b0 = max(y);
    u = x;
    v = log((max(yscale) - min(yscale) + 2*epsilon) ./ (y - min(yscale) + epsilon) - 1);
    fitobject0 = fit(u,v,'poly1');
    c0 = -fitobject0.p1;
    d0 = fitobject0.p2 / c0;
    p0 = [a0 b0 c0 d0];
end

options = optimset('MaxIter', 10000, 'Display', 'off');
[p,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(fun,p0,x,y,lb,ub,options);
fitobject = cfit(f,p(1),p(2),p(3),p(4));
[beta,R,J,CovB,MSE,ErrorModelInfo] = nlinfit(x,y,fun,p);

y_hat = feval(fitobject, x);
if isnan(corr(y, y_hat, 'type', 'spearman'))
    [fitobject,resnorm,residual,exitflag,output,lambda,jacobian,beta,R,J,CovB,MSE,ErrorModelInfo] = fitLogistic(x,y,xscale,yscale,-mysign,restricted);
end
