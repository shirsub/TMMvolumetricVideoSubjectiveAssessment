clear;
clc;
T1 = readtable('./Data/T1_Objective.csv');
T2 = readtable('./Data/T2_Objective.csv');

%Direct correl values - DO NOT USE 
%XXXShishir x and y are flipped - ToDo Refactor
resT1 = single.empty;
%resT2 = cell2table(cell(2,6));
resT2 = single.empty;
for i = 12:17
    x1 = table2array(T1(:,8));
    y1 = table2array(T1(:,i));
    x2 = table2array(T2(:,8));
    y2 = table2array(T2(:,i));
    c1 = corr(x1,y1,'type','Pearson');
    c2 = corr(x1,y1,'type','Spearman');
    resT1 = [resT1 c1];
    resT1 = [resT1 c2];
    c1 = corr(x2,y2,'type','Pearson');
    c2 = corr(x2,y2,'type','Spearman');
    resT2 = [resT2 c1];
    resT2 = [resT2 c2];
end
resT1 = reshape(resT1,[2,6]);
resT2 = reshape(resT2,[2,6]);
T1out = array2table(resT1,'VariableNames',{'PCQM','p2point','p2plane','YPSNR','UPSNR','VPSNR'});
T2out = array2table(resT2,'VariableNames',{'PCQM','p2point','p2plane','YPSNR','UPSNR','VPSNR'});
strs = {'Pearson','Spearman'};
strs = reshape(strs,[2,1]);
strs = table(strs,'VariableNames',{'CorrType'});
T1out = [strs T1out];
T2out = [strs T2out];

%Cubic
%DMOS
y1 = table2array(T1(:,8));
%Objective Metric
x1 = table2array(T1(:,12));
test = corr(x1,y1,'type','Pearson');
p = polyfit(x1,y1,3);
y_fit = polyval(p,x1);
test2 = corr(x1,y_fit,'type','Pearson');

%logistic




    

