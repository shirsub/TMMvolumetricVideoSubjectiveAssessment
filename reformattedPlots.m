%Make plots pre Test
T4_plotdata = readtable('./Data/prepilot-plots.csv');
Contents = unique(T4_plotdata.Content);
DoFs = unique(T4_plotdata.DoF);
makePlotAllCodecs(T4_plotdata,DoFs(dof),1,3,1.25);




%Make plots Experiment
T4_plotdata = readtable('./Data/experiment-plots.csv');
Contents = unique(T4_plotdata.Content);
DoFs = unique(T4_plotdata.DoF);
makePlotExpCodecs(T4_plotdata,DoFs(dof),1,4,1.25);

