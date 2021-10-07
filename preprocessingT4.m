clear;
clc;
addpath('./Data');
addpath('./Functions');
r1 = 0.75;
r2 = 0.8;
%T4 = readtable('./Data/T4.csv');
T4 = readtable('./Data/T8.csv');

%Remove outliers T4
[T4_new, removedParticipants, n] = removeOutliers(T4,r1,r2);

x = T4_new.Scores;
%Check distribution of scores
[H, pValue, W] = swtest(x);

%Get Differential scores
T4_new2 = getDifferentialScores(T4_new);
writetable(T4_new2,'./Data/T8_preprocessed.csv');

%XXXShishir Test: Remove DoFs for validation plots
%Get DMOS plot data
%T3_plotdata = dmosplots(T3_new,0.95,true);
T4_plotdata = dmosplots(T4_new2,0.95,false);
writetable(T4_plotdata,'./Data/T4_DMOS_PlotData.csv');

%Make plots T1
T4_plotdata = readtable('./Data/T4_DMOS_PlotData.csv');
Contents = unique(T4_plotdata.Content);
DoFs = unique(T4_plotdata.DoF);
for dof = 1:size(DoFs)
    for content = 1:size(Contents)
        %makePlot(T3_plotdata,DoFs(dof),Contents(content),3);
        %makePlotAllCodecs(T3_plotdata,DoFs(dof),Contents(content),3);
        makePlotExpCodecs(T4_plotdata,DoFs(dof),Contents(content),4);
    end
end



%Reformat the scores data to use the new ITU P913 outlier detection script
%from Vaggelis
%The new scores matrix has the sorted stimuli list as rows, sorted
%participant number over the columns, we also need a separate vector that maps the sorted stimuli list to the source content
%





