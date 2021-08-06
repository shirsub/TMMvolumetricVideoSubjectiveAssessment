clear;
clc;
addpath('./Data');
addpath('./Functions');
r1 = 0.75;
r2 = 0.8;
T3 = readtable('./Data/T3.csv');

%XXXshishir filter out P5 for testing
rows = T3.Participant~=5;
T3 = T3(rows,:);

%Get Differential scores
T3_new = getDifferentialScores(T3);
writetable(T3_new,'./Data/T3_preprocessed.csv');

%XXXShishir Test: Remove DoFs for validation plots
%Get DMOS plot data
%T3_plotdata = dmosplots(T3_new,0.95,true);
T3_plotdata = dmosplots(T3_new,0.95,false);
writetable(T3_plotdata,'./Data/T3_DMOS_PlotData.csv');

%Make plots T1
Contents = unique(T3_plotdata.Content);
DoFs = unique(T3_plotdata.DoF);
for dof = 1:size(DoFs)
    for content = 1:size(Contents)
        %makePlot(T3_plotdata,DoFs(dof),Contents(content),3);
        %makePlotAllCodecs(T3_plotdata,DoFs(dof),Contents(content),3);
        makePlotExpCodecs(T3_plotdata,DoFs(dof),Contents(content),3);
    end
end



