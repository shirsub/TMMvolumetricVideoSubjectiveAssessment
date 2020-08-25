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

%XXXShishir code cleanup removed other comparisons/models

%ARTAnova T1
%Bitrate vs DoF
brdof = T1(:,{'Bitrates','DoF','DMOS'});
res = ArtAnova(table2array(brdof));
[pbrdofrest1, tablebrdofrest1, statsbrdofrest1] = anova2(res);

%Bitrate vs codec
brcodec = T1(:,{'Bitrates','Codecs','DMOS'});
res = ArtAnova(table2array(brcodec));
[pbrcodecrest1, tablebrcodecrest1,statsbrcodecrest1] = anova2(res);

%Bitrate vs content
brcontent = T1(:,{'Bitrates','Contents','DMOS'});
res = ArtAnova(table2array(brcontent));
[pbrcontentrest1,tablebrcontentrest1,statsbrcontentrest1] = anova2(res);

%Content vs codec
contentcodec = T1(:,{'Contents','Codecs','DMOS'});
res = ArtAnova(table2array(contentcodec));
[pcontentcodecrest1, tablecontentcodecrest1,statscontentcodecrest1] = anova2(res);

%Content vs DoF
contentdof = T1(:,{'Contents','DoF','DMOS'});
res = ArtAnova(table2array(contentdof));
[pcontentdofrest1,tablecontentdofrest1,statscontentdofrest1] = anova2(res);


%codec vs DoF
codecdof = T1(:,{'Codecs','DoF','DMOS'});
res = ArtAnova(table2array(codecdof));
[pcodecdofrest1,tablecodecdofrest1,statscodecdofrest1] = anova2(res);










%ARTAnova T2
%Bitrate vs DoF
brdof = T2(:,{'Bitrates','DoF','DMOS'});
res = ArtAnova(table2array(brdof));
[pbrdofrest2, tablebrdofrest2, statsbrdofrest2] = anova2(res);

%Bitrate vs codec
brcodec = T2(:,{'Bitrates','Codecs','DMOS'});
res = ArtAnova(table2array(brcodec));
[pbrcodecrest2, tablebrcodecrest2,statsbrcodecrest2] = anova2(res);

%Bitrate vs content
brcontent = T2(:,{'Bitrates','Contents','DMOS'});
res = ArtAnova(table2array(brcontent));
[pbrcontentrest2,tablebrcontentrest2,statsbrcontentrest2] = anova2(res);

%Content vs codec
contentcodec = T2(:,{'Contents','Codecs','DMOS'});
res = ArtAnova(table2array(contentcodec));
[pcontentcodecrest2, tablecontentcodecrest2,statscontentcodecrest2] = anova2(res);

%Content vs DoF
contentdof = T2(:,{'Contents','DoF','DMOS'});
res = ArtAnova(table2array(contentdof));
[pcontentdofrest2,tablecontentdofrest2,statscontentdofrest2] = anova2(res);


%codec vs DoF
codecdof = T2(:,{'Codecs','DoF','DMOS'});
res = ArtAnova(table2array(codecdof));
[pcodecdofrest2,tablecodecdofrest2,statscodecdofrest2] = anova2(res);