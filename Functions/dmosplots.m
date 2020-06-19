%Script to plot MOS and DMOS based on ITU P.913
%https://www.itu.int/rec/T-REC-P.913-201603-I/en with 95% confidence
%intervals
%XXXShishir ToDo: modify to function, fix chart options
%Read Data
clear;
clc;
%XXXShishir ToDo replace with csv after outlier removal
T1 = readtable('./Data/T1_final.csv');
T2 = readtable('./Data/T2_final.csv');
%Outlier Treatment T1
rawData = T1;
rows = rawData.Codecs==1;
HRScores = rawData(rows,:);
rows = rawData.Codecs~=1;
stimuliScores = rawData(rows,:);
CombinedScores = join(stimuliScores,HRScores,'Keys',{'Participant','Contents'});
%Use outer join to test, results should be identical if everything else is
%correct
%CombinedScoresTest = outerjoin(stimuliScores,HRScores,'Keys',{'Participant','Contents'});
CombinedScores = removevars(CombinedScores,{'DoF_HRScores','Bitrates_HRScores','Codecs_HRScores'});
DMOS = CombinedScores.Scores_stimuliScores - CombinedScores.Scores_HRScores + 5;
CombinedScores = [CombinedScores,array2table(DMOS)];
CombinedScores.Properties.VariableNames([2 4 5 6 7]) = {'DoF' 'Codecs' 'Bitrates' 'Scores' 'HRScores'};
%mosStimuli = varfun(@mean,CombinedScores,'InputVariables','Scores_stimuliScores','GroupingVariables',{'Contents','Codecs','Bitrates'});
%mosHR = varfun(@mean,CombinedScores,'InputVariables','Scores_HRScores','GroupingVariables',{'Contents','Codecs','Bitrates'});
%dmosStimuli = varfun)@mean,'InputVariables',



