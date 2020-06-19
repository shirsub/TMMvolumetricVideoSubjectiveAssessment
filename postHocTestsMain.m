clear;
clc;
%Read data
T1 = readtable('./Data/T1_preprocessed.csv');
T2 = readtable('./Data/T2_preprocessed.csv');

%We use non-parametric tests because the score data is ordinal and the model structure is not specified a priori but we try to determine it from the data. 
%Wilcoxon Signed Rank Test
%XXXShishir ToDo hypothesis testing to check view condition, codec,
%pairwise sequences and bitrate
p = signrank(T1.Scores);
