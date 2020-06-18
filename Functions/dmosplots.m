%Script to plot MOS and DMOS based on ITU P.913 https://www.itu.int/rec/T-REC-P.913-201603-I/en
%XXXShishir ToDo: modify tio function, fix chart options
%Read Data
clear;
clc;
%XXXShishir ToDo replace with csv after outlier removal
T1 = readtable('T1.csv');
T2 = readtable('T2.csv');
%Outlier Treatment T1
rawData = T1;
rows = rawData.Codecs==1;
HRScores = rawData(rows,:);
rows = rawData.Codecs~=1;
stimuliScores = rawData(rows,:);
CombinedScores = join(stimuliScores,HRScores,'Keys',{'Participant','Contents'});
DMOS = CombinedScores.Scores_stimuliScores - CombinedScores.Scores_HRScores + 5;
CombinedScores = [CombinedScores,array2table(DMOS)];
mosStimuli = varfun(@mean,CombinedScores,'InputVariables','Scores_stimuliScores','GroupingVariables',{'Contents','Codecs','Bitrates'});
mosHR = varfun(@mean,CombinedScores,'InputVariables','Scores_HRScores','GroupingVariables',{'Contents','Codecs','Bitrates'});
%dmosStimuli = varfun)@mean,'InputVariables',



