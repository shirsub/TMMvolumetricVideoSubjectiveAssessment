clear;
clc;
close all;
%Read data
Tscores = readtable('./Data/T9.csv');
x = Tscores.MotionFrames;
[H, pValue, W] = swtest(x);
histogram(x);
hold on;
xlabel('Ratio of frames viewed with motion');
hold off;
%Scores
x = Tscores.MotionFrames;
g = Tscores.Scores;
boxplot(x,g);
hold on;
xlabel('Subjective Scores');
ylabel('Ratio of Frames Viewed on the Move');
hold off;
%Bitrates
x = Tscores.MotionFrames;
g = Tscores.Bitrates;
boxplot(x,g);
hold on;
xlabel('Bitrate');
ylabel('Ratio of Frames Viewed on the Move');
hold off;

%Codecs
Tscores = readtable('./Data/T10.csv');
x = Tscores.Motion;
g = Tscores.Codecs;
boxplot(x,g);
hold on;
xlabel('Codecs');
ylabel('Ratio of Frames Viewed on the Move');
hold off;

%Contents
x = Tscores.MotionFrames;
g = Tscores.Contents;
boxplot(x,g);
hold on;
xlabel('Contents');
ylabel('Ratio of Frames Viewed on the Move');
hold off;

%Adaptation
Tscores = readtable('./Data/T11.csv');
x = Tscores.Motion;
g = Tscores.Playback;
boxplot(x,g);
hold on;
xlabel('Playback Category');
ylabel('Ratio of Frames Viewed on the Move');
hold off;


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
bitrateDMOS = Tscores.MotionFrames(rows,:);

for r = 2:size(Rates)
    rows = Tscores.Bitrates == Rates(r);
    dmos = Tscores.MotionFrames(rows,:);
    bitrateDMOS = [bitrateDMOS dmos];
end
[p, tbl, stats] = friedman(bitrateDMOS);
multcompare(stats);
bitratePairwise = PairwiseWilcoxonSRTest(bitrateDMOS,0.05);

%Content
Tscores = sortrows(Tscores,{'Codecs','Bitrates','Participant'});
Contents = unique(Tscores.Contents);
rows = Tscores.Contents == Contents(1);
contentDMOS = Tscores.MotionFrames(rows,:);

for r = 2:size(Contents)
    rows = Tscores.Contents == Contents(r);
    dmos = Tscores.MotionFrames(rows,:);
    contentDMOS = [contentDMOS dmos];
end
[p, tbl, stats] = friedman(contentDMOS);
multcompare(stats);
contentPairwise = PairwiseWilcoxonSRTest(contentDMOS,0.05);

%Codecs
Tscores = sortrows(Tscores,{'Contents','Bitrates','Participant'});
Codecs = unique(Tscores.Codecs);
rows = Tscores.Codecs == Codecs(1);
codecDMOS = Tscores.MotionFrames(rows,:);

for r = 2:size(Codecs)
    rows = Tscores.Codecs == Codecs(r);
    dmos = Tscores.MotionFrames(rows,:);
    codecDMOS = [codecDMOS dmos];
end
[p, tbl, stats] = friedman(codecDMOS);
multcompare(stats);
codecPairwise = PairwiseWilcoxonSRTest(codecDMOS,0.05);
%Now we ned to try the paired wilcoxon signed rank test with bonferroni
%correction
%TestT = PairwiseWilcoxonSRTest(contentDMOS);


%Scores
%Codecs
Tscores = sortrows(Tscores,{'Contents','Bitrates','Participant','Codecs'});
Scores = unique(Tscores.Scores);
rows = Tscores.Codecs == Codecs(1);
codecDMOS = Tscores.MotionFrames(rows,:);

for r = 2:size(Codecs)
    rows = Tscores.Codecs == Codecs(r);
    dmos = Tscores.MotionFrames(rows,:);
    codecDMOS = [codecDMOS dmos];
end
[p, tbl, stats] = friedman(codecDMOS);
multcompare(stats);
codecPairwise = PairwiseWilcoxonSRTest(codecDMOS,0.05);





%Fatigue and motion %
clear;
clc;
close all;
Tscores = readtable('./Data/T9.csv');
Participants = unique(Tscores.Participant);
Sessions = unique(Tscores.Session);
Tscores = sortrows(Tscores,{'Participant','Session','ViewOrder'});
rows = Tscores.Participant == Participants(1) & strcmp(Tscores.Session,Sessions(1));
Tmat = Tscores.MotionFrames(rows,:);
rows = Tscores.Participant == Participants(1) & strcmp(Tscores.Session,Sessions(2));
T = Tscores.MotionFrames(rows,:);
Tmat = [Tmat T];

for i = 2:size(Participants)
    for j = 1:size(Sessions)
       rows =  Tscores.Participant == Participants(i) & strcmp(Tscores.Session,Sessions(j));
       T = Tscores.MotionFrames(rows,:);
       Tmat =[Tmat T];
    end
end

imagesc(Tmat);
colorbar;
xlabel('Participant Number');
ylabel('Stimuli by view order');

%Stacked sessions
Tscores = readtable('./Data/T9.csv');
Participants = unique(Tscores.Participant);
Sessions = unique(Tscores.Session);
Tscores = sortrows(Tscores,{'Participant','Session','ViewOrder'});
rows = Tscores.Participant == Participants(1);
Tmat = Tscores.MotionFrames(rows,:);

for i = 2:size(Participants)
       rows =  Tscores.Participant == Participants(i);
       T = Tscores.MotionFrames(rows,:);
       Tmat =[Tmat T];
end

imagesc(Tmat);
colorbar;
xlabel('Participant Number');
ylabel('Stimuli by view order');



%Naive CWIPCC
Tscores = readtable('./Data/T11.csv');
rows = Tscores.Codecs == 3;
Tmat = Tscores.Motion(rows,:);
T1 = ones(size(Tmat,1),1);
rows = Tscores.Codecs == 4 | Tscores.Codecs == 6 | Tscores.Codecs == 8;
T = Tscores.Motion(rows,:);
T2 = zeros(size(T,1),1);
Tmat = [Tmat; T];
Tvec = [T1;T2];
[p, tbl, stats] = kruskalwallis(Tmat,Tvec);




% 
x = Tscores.MotionFrames;
g = Tscores.Participant;
boxplot(x,g);
hold on;
xlabel('Participants');
ylabel('Ratio of Frames Viewed on the Move');
hold off;


%%Box plot of file size and read times of the cwipc dump format vs standard
%%PLY files
Treadtimes = readtable('./Data/readtimes.csv');
x = Treadtimes.readtime;
%x = Treadtimes.filesizeMB;
g = Treadtimes.format;
boxplot(x,g);
hold on;
xlabel('Point cloud storage format');
ylabel('Readtimes in ms');
hold off;


Treadtimes = readtable('./Data/readtimes.csv');
%x = Treadtimes.readtime;
x = Treadtimes.filesizeMB;
%Treadtimes.filesizeMB = reorderlevels(Treadtimes.filesizeMB,{'SerializedBinary','PLY Binary (Open3D)','PLY ASCII (Open3D)'});
g = Treadtimes.format;
%boxplot(x,g);
boxplot(x,g,'GroupOrder',{'SerializedBinary','PLY Binary (Open3D)','PLY ASCII (Open3D)'},'Labels',{'Serialized Binary','PLY Binary','PLY ASCII'});
hold on;
xlabel('Point cloud storage format');
ylabel('File size in MB');
hold off;


%Box plot of readtimes for the 4 sequences in the dataset, the box plot of
%readtimes by format didn't make sense they were too far to see the
%variation (PLY ascii is 10 times slower)
Treadtimes = readtable('./Data/readtimesReference.csv');
x = Treadtimes.readtime;
%Treadtimes.filesizeMB = reorderlevels(Treadtimes.filesizeMB,{'SerializedBinary','PLY Binary (Open3D)','PLY ASCII (Open3D)'});
g = Treadtimes.Dataset;
%boxplot(x,g);
%boxplot(x,g,'GroupOrder',{'SerializedBinary','PLY Binary (Open3D)','PLY ASCII (Open3D)'},'Labels',{'Serialized Binary','PLY Binary','PLY ASCII'});
boxplot(x,g);
hold on;
xlabel('Point cloud sequence');
ylabel('Read time in ms');
hold off;

