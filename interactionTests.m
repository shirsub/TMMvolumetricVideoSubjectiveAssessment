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
%[pbrdofrest1, tablebrdofrest1, statsbrdofrest1] = anova2(res);
c1 = table2array(brdof(:,1));
c2 = table2array(brdof(:,2));
[pbrdofrest1, tablebrdofrest1, statsbrdofrest1] = anovan(res(:,3),{c1,c2});

%Bitrate vs codec
brcodec = T1(:,{'Bitrates','Codecs','DMOS'});
res = ArtAnova(table2array(brcodec));
c1 = table2array(brcodec(:,1));
c2 = table2array(brcodec(:,2));
[pbrcodecrest1, tablebrcodecrest1, statsbrcodecrest1] = anovan(res(:,3),{c1,c2});

%Bitrate vs content
brcontent = T1(:,{'Bitrates','Contents','DMOS'});
res = ArtAnova(table2array(brcontent));
%[pbrcontentrest1,tablebrcontentrest1,statsbrcontentrest1] = anova2(res);
c1 = table2array(brcontent(:,1));
c2 = table2array(brcontent(:,2));
[pbrcontentrest1, tablebrcontentrest1, statsbrcontentrest1] = anovan(res(:,3),{c1,c2});

%Content vs codec
contentcodec = T1(:,{'Contents','Codecs','DMOS'});
res = ArtAnova(table2array(contentcodec));
%[pcontentcodecrest1, tablecontentcodecrest1,statscontentcodecrest1] = anova2(res);
c1 = table2array(contentcodec(:,1));
c2 = table2array(contentcodec(:,2));
[pcontentcodecrest1, tablecontentcodecrest1,statscontentcodecrest1] = anovan(res(:,3),{c1,c2});

%Content vs DoF
contentdof = T1(:,{'Contents','DoF','DMOS'});
res = ArtAnova(table2array(contentdof));
c1 = table2array(contentdof(:,1));
c2 = table2array(contentdof(:,2));
[pcontentdofrest1,tablecontentdofrest1,statscontentdofrest1] = anovan(res(:,3),{c1,c2});


%codec vs DoF
codecdof = T1(:,{'Codecs','DoF','DMOS'});
res = ArtAnova(table2array(codecdof));
c1 = table2array(codecdof(:,1));
c2 = table2array(codecdof(:,2));
[pcodecdofrest1,tablecodecdofrest1,statscodecdofrest1] = anovan(res(:,3),{c1,c2})





%ARTAnova T2
%Bitrate vs DoF
brdof = T2(:,{'Bitrates','DoF','DMOS'});
res = ArtAnova(table2array(brdof));
%[pbrdofrest1, tablebrdofrest1, statsbrdofrest1] = anova2(res);
c1 = table2array(brdof(:,1));
c2 = table2array(brdof(:,2));
[pbrdofrest2, tablebrdofrest2, statsbrdofrest2] = anovan(res(:,3),{c1,c2});

%Bitrate vs codec
brcodec = T2(:,{'Bitrates','Codecs','DMOS'});
res = ArtAnova(table2array(brcodec));
c1 = table2array(brcodec(:,1));
c2 = table2array(brcodec(:,2));
[pbrcodecrest2, tablebrcodecrest2, statsbrcodecrest2] = anovan(res(:,3),{c1,c2});

%Bitrate vs content
brcontent = T2(:,{'Bitrates','Contents','DMOS'});
res = ArtAnova(table2array(brcontent));
%[pbrcontentrest1,tablebrcontentrest1,statsbrcontentrest1] = anova2(res);
c1 = table2array(brcontent(:,1));
c2 = table2array(brcontent(:,2));
[pbrcontentrest2, tablebrcontentrest2, statsbrcontentrest2] = anovan(res(:,3),{c1,c2});

%Content vs codec
contentcodec = T2(:,{'Contents','Codecs','DMOS'});
res = ArtAnova(table2array(contentcodec));
%[pcontentcodecrest1, tablecontentcodecrest1,statscontentcodecrest1] = anova2(res);
c1 = table2array(contentcodec(:,1));
c2 = table2array(contentcodec(:,2));
[pcontentcodecrest2, tablecontentcodecrest2,statscontentcodecrest2] = anovan(res(:,3),{c1,c2});

%Content vs DoF
contentdof = T2(:,{'Contents','DoF','DMOS'});
res = ArtAnova(table2array(contentdof));
c1 = table2array(contentdof(:,1));
c2 = table2array(contentdof(:,2));
[pcontentdofrest2,tablecontentdofrest2,statscontentdofrest2] = anovan(res(:,3),{c1,c2});


%codec vs DoF
codecdof = T2(:,{'Codecs','DoF','DMOS'});
res = ArtAnova(table2array(codecdof));
c1 = table2array(codecdof(:,1));
c2 = table2array(codecdof(:,2));
[pcodecdofrest2,tablecodecdofrest2,statscodecdofrest2] = anovan(res(:,3),{c1,c2})