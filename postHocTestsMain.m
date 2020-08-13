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
%Friedman rank test
%Convert scores to ranks in rows, put the variable being considered acros
%columns, the test result indicates if the columns are different
%Things to test: Codec, bitrate, DoF, Content
Tin = T1;
Codecs = unique(Tin.Codecs);
Rates = unique(Tin.Bitrates);
Contents = unique(Tin.Contents);
DoFs = unique(Tin.DoF);

%Codecs
%T = rows2vars(Tin,'VariableNamesSource','Codecs','DataVariables','DMOS');
for 