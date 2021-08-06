clear;
clc;
close all;
Tscores = readtable('./Data/T8.csv');
Participants = unique(Tscores.Participant);
Sessions = unique(Tscores.Session);
Tscores = sortrows(Tscores,{'Participant','Session','ViewOrder'});
rows = Tscores.Participant == Participants(1) & strcmp(Tscores.Session,Sessions(1));
Tmat = Tscores.Scores(rows,:);
rows = Tscores.Participant == Participants(1) & strcmp(Tscores.Session,Sessions(2));
T = Tscores.Scores(rows,:);
Tmat = [Tmat T];

for i = 2:size(Participants)
    for j = 1:size(Sessions)
       rows =  Tscores.Participant == Participants(i) & strcmp(Tscores.Session,Sessions(j));
       T = Tscores.Scores(rows,:);
       Tmat =[Tmat T];
    end
end

imagesc(Tmat);
colorbar;
xlabel('Participant Number');
ylabel('Stimuli by view order');

%Stacked sessions
Tscores = readtable('./Data/T8.csv');
Participants = unique(Tscores.Participant);
Sessions = unique(Tscores.Session);
Tscores = sortrows(Tscores,{'Participant','Session','ViewOrder'});
rows = Tscores.Participant == Participants(1);
Tmat = Tscores.Scores(rows,:);

for i = 2:size(Participants)
       rows =  Tscores.Participant == Participants(i);
       T = Tscores.Scores(rows,:);
       Tmat =[Tmat T];
end

imagesc(Tmat);
colorbar;
xlabel('Participant Number');
ylabel('Stimuli by view order');