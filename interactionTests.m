clear;
clc;
addpath('./Data');
addpath('./Functions');
T1 = readtable('./Data/T1_preprocessed.csv');
T2 = readtable('./Data/T2_preprocessed.csv');

%Linear mixed effects model for T1 and T2
lmet1 = fitlme(T1,'DMOS~Bitrates+(Bitrates|DoF)+(Bitrates|Contents)');
lmet2 = fitlme(T2,'DMOS~Bitrates+(Bitrates|Codecs)+(Bitrates|Contents)');

%Full Linear model for comparison
fullLMT1 = fitlme(T1,'DMOS~Bitrates+DoF+Codecs+Contents');
fullLMT2 = fitlme(T2,'DMOS~Bitrates+DoF+Codecs+Contents');

%Comparing the models
LMET1_compare = compare(lmet1,fullLMT1);
LMET2_compare = compare(lmet2,fullLMT2);

%ANOVA on LMEs
LMEstatsT1 = anova(lmet1);
LMEstatsT2 = anova(lmet2);

%ARTAnova T1
%Bitrate vs DoF
brdof = T1(:,{'Bitrates','DoF','DMOS'});
res = ArtAnova(table2array(brdof));


