
%Snippet to compare cwipc-naive and cwipc-adaptive scores to see if
%adaptive playback has a statistically significant effect overall. 
%We need to stack all the scores in a single column and create a separate
%vector indicating if the score was from an adaptive or a naive playback of
%the content

clear;
clc;
close all;
Tscores = readtable('./Data/T4_preprocessed.csv');
codecs = unique(Tscores.Codecs);

Tscores = sortrows(Tscores,{'Codecs','Contents','Bitrates','Participant'});
%Naive CWIPCC
rows = Tscores.Codecs == 3;
Tmat = Tscores.DMOS(rows,:);
T1 = ones(size(Tmat,1),1);
T1v2 = repmat('MPEG Anchor: Naive   ',size(Tmat,1),1);
rows = Tscores.Codecs == 4 | Tscores.Codecs == 6 | Tscores.Codecs == 8;
T = Tscores.DMOS(rows,:);
T2 = zeros(size(T,1),1);
T2v2 = repmat('MPEG Anchor: Adaptive',size(T,1),1);
Tmat = [Tmat; T];
Tvec = [T1;T2];
Tvec2 = [T1v2;T2v2];
%[p, tbl, stats] = kruskalwallis(Tmat,Tvec);
[p, tbl, stats] = kruskalwallis(Tmat,Tvec2);


%Naive CWIPCC + VPCC
rows = Tscores.Codecs == 3 | Tscores.Codecs==2;
Tmat = Tscores.DMOS(rows,:);
T1 = ones(size(Tmat,1),1);
rows = Tscores.Codecs == 4 | Tscores.Codecs == 6 | Tscores.Codecs == 8;
T = Tscores.DMOS(rows,:);
T2 = zeros(size(T,1),1);
Tmat = [Tmat; T];
Tvec = [T1;T2];
[p, tbl, stats] = kruskalwallis(Tmat,Tvec);
