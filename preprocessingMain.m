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
writetable(T1_new,'./Data/T1_final.csv');

%Remove outliers T2
[T2_new, removedParticipants, n] = removeOutliers(T2,r1,r2);
fprintf('Removed %d participants from T2\n',n);
writetable(T2_new,'./Data/T2_final.csv');
