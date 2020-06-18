clear;
clc;
%Read data
T1 = readtable('./Data/T1_final.csv');
T2 = readtable('./Data/T2_final.csv');

%Wilcoxon Signed Rank Test
%XXXShishir ToDo hypothesis testing to check view condition, codec,
%pairwise sequences and bitrate
p = signrank(T1.Scores);
