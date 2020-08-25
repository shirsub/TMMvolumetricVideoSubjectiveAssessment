clear;
clc;
%Read data
T1 = readtable('./Data/T1_preprocessed.csv');
T2 = readtable('./Data/T2_preprocessed.csv');

%We use non-parametric tests because the score data is ordinal and the model structure is not specified a priori but we try to determine it from the data. 
%Assumptions for ANOVA:
%1. Equal interval scale3 of measurement Y
%2. Independence of measures withing each group N
%3. Normal distribution of source population ??
%4. Equal variance among groups N
%5. Homogeneity of covariates ??
%Not all conditions are satisfied so we use non parametric tests
a = 0.05;

%First test Dofs as they are unmatched we use kruskal wallis 
dofs = table2array(T1(:,{'DoF'}));
scores = table2array(T1(:,{'DMOS'}));
[p, res, stats] = kruskalwallis(scores,dofs);



