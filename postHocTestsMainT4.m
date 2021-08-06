clear;
clc;
close all;
%Read data
Tscores = readtable('./Data/T4_preprocessed.csv');

%We first do a friedman test to see if there are any interesting
%differneces among groups, here we will only get a p-value and not the
%effect size
%ProTip: Feed the stats output from friedman's test to multcompare to
%visualize the results - We start with the rate points as they should make
% for a good sanity check (based on what the graphs look like)

%For friedman's test we need to stack the DMOS in columns for each level so
%for the rate points the columns of the new scores table should represent
%R1-R4
Tscores = sortrows(Tscores,{'Contents','Codecs','Participant'});
Rates = unique(Tscores.Bitrates);
rows = Tscores.Bitrates == Rates(1);
bitrateDMOS = Tscores.DMOS(rows,:);

for r = 2:size(Rates)
    rows = Tscores.Bitrates == Rates(r);
    dmos = Tscores.DMOS(rows,:);
    bitrateDMOS = [bitrateDMOS dmos];
end
[p, tbl, stats] = friedman(bitrateDMOS);
multcompare(stats);
bitratePairwise = PairwiseWilcoxonSRTest(bitrateDMOS,0.05);
%Content
Tscores = sortrows(Tscores,{'Codecs','Bitrates','Participant'});
Contents = unique(Tscores.Contents);
rows = Tscores.Contents == Contents(1);
contentDMOS = Tscores.DMOS(rows,:);

for r = 2:size(Contents)
    rows = Tscores.Contents == Contents(r);
    dmos = Tscores.DMOS(rows,:);
    contentDMOS = [contentDMOS dmos];
end
[p, tbl, stats] = friedman(contentDMOS);
multcompare(stats);
contentPairwise = PairwiseWilcoxonSRTest(contentDMOS,0.05);
%Codecs
Tscores = sortrows(Tscores,{'Contents','Bitrates','Participant'});
Codecs = unique(Tscores.Codecs);
rows = Tscores.Codecs == Codecs(1);
codecDMOS = Tscores.DMOS(rows,:);

for r = 2:size(Codecs)
    rows = Tscores.Codecs == Codecs(r);
    dmos = Tscores.DMOS(rows,:);
    codecDMOS = [codecDMOS dmos];
end
[p, tbl, stats] = friedman(codecDMOS);
multcompare(stats);
codecPairwise = PairwiseWilcoxonSRTest(codecDMOS,0.05);
%Now we ned to try the paired wilcoxon signed rank test with bonferroni
%correction
%TestT = PairwiseWilcoxonSRTest(contentDMOS);


