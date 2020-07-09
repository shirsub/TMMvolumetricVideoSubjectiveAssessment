clear;
clc;
addpath('./Data');
addpath('./Functions');
r1 = 0.75;
r2 = 0.8;
T1 = readtable('./Data/T1.csv');
T2 = readtable('./Data/T2.csv');

%Remove outliers T1
[T1_new, removedParticipants, n] = removeOutliers(T1,r1,r2);
fprintf('Removed %d participants from T1\n',n);


%Remove outliers T2
[T2_new, removedParticipants, n] = removeOutliers(T2,r1,r2);
fprintf('Removed %d participants from T2\n',n);

%Check distribution of scores using shapiro wilk test from https://nl.mathworks.com/matlabcentral/fileexchange/13964-shapiro-wilk-and-shapiro-francia-normality-tests
%T1 = readtable('./Data/T1_final.csv');
%T2 = readtable('./Data/T2_final.csv');
%T1
x = T1_new.Scores;
[H, pValue, W] = swtest(x);
if (H)
    fprintf('T1 Shapiro Wilk Test Outcome True: W = %f , pvalue = %f\n',W,pValue);
else
    fprintf('T1 Shapiro Wilk Test Outcome False: W = %f , pvalue = %f\n',W,pValue);
end;

%T2
x = T2_new.Scores;
[H, pValue, W] = swtest(x);
if (H)
    fprintf('T2 Shapiro Wilk Test Outcome True: W = %f , pvalue = %f\n',W,pValue);
else
    fprintf('T2 Shapiro Wilk Test Outcome False: W = %f , pvalue = %f\n',W,pValue);
end;

%Get Differential scores
T1_new = getDifferentialScores(T1_new);
T2_new = getDifferentialScores(T2_new);
writetable(T1_new,'./Data/T1_preprocessed.csv');
writetable(T2_new,'./Data/T2_preprocessed.csv');

%Get DMOS plot data
T1_plotdata = dmosplots(T1_new,0.95,true);
T2_plotdata = dmosplots(T2_new,0.95,true);
writetable(T1_plotdata,'./Data/T1_DMOS_PlotData.csv');
writetable(T2_plotdata,'./Data/T2_DMOS_plotData.csv');



