%Script to remove outliers based on ITU P.913 Annex A
%https://www.itu.int/rec/T-REC-P.913-201603-I/en 
%Read Data
clear;
clc;
r1 = 0.75;
r2 = 0.8;
T1 = readtable('T1.csv');
T2 = readtable('T2.csv');
%XXXShishir Debug test to match old results - ToDo Remove
%rows = T1.DoF == 3;
%T1(rows,:) = [];
%Outlier Treatment T1
rawData = T1;
participantList = unique(rawData.Participant);
participantList = sortrows(participantList,1);
%Get stimuli scores table
rows = rawData.Codecs > 1;
stimuliScores = rawData(rows,:);
%Get hidden reference scores
rows = rawData.Codecs == 1;
HRScores = rawData(rows,:);
outlierFlag = true;
%Compute correlation per participant and log outliers
while(outlierFlag)
    participantR1Coeffs = array2table(zeros(size(participantList)));
    participantR2Coeffs = array2table(zeros(size(participantList)));
    %Compute R1 and R2 coefficients for every participant
    for participant = 1:size(participantList)
        %R1 computation
        rows = stimuliScores.Participant == participantList(participant);
        x = stimuliScores(rows,:);
        rows = stimuliScores.Participant ~= participantList(participant);
        y_t = stimuliScores(rows,:);
        y = varfun(@mean,y_t,'InputVariables','Scores','GroupingVariables',{'Contents','Codecs','Bitrates'});
        x = sortrows(x,{'Participant','Contents','Codecs','Bitrates'});
        y = sortrows(y,{'Contents','Codecs','Bitrates'});
        r1_coeff=corrcoef(x.Scores,y.mean_Scores);
        participantR1Coeffs{participant,1}=r1_coeff(1,2);
        %R2 Computation
        rows = HRScores.Participant == participantList(participant);
        x = HRScores(rows,:);
        rows = HRScores.Participant ~= participantList(participant);
        y_t = HRScores(rows,:);
        y = varfun(@mean,y_t,'InputVariables','Scores','GroupingVariables',{'Contents','Codecs','Bitrates'});
        x = sortrows(x,{'Participant','Contents','Codecs','Bitrates'});
        y = sortrows(y,{'Contents','Codecs','Bitrates'});
        r2_coeff=corrcoef(x.Scores,y.mean_Scores);
        %XXX_Shishir Debug Info
        if isnan(r2_coeff(1,2))
            test = r2_coeff;
            test2 = x.Scores;
            test3 = y.mean_Scores;
            %disp('FoundNan');
        end
        participantR2Coeffs{participant,1}=r2_coeff(1,2);
    end
    %Check for outliers
    if (min(participantR1Coeffs{:,1}) < r1) && min(participantR2Coeffs{:,1}) < r2
       %Compute outlier score as mean deviation from the r1 and r2 limits
       tr1 = r1 - participantR1Coeffs{:,1};
       tr2 = r2 - participantR2Coeffs{:,1};
       %ToDo XXXShishir Refactor - Simplify: Participants need to fall below both r1
       %and r2 in order to qualify as outliers
       tr1(tr1<0)=-2;
       tr2(tr2<0)=-2;
       participantOutlierScores = (tr1 + tr2)/2;
       if max(participantOutlierScores) < 0
           outlierFlag=false;
           break;
       else
           outlier = find(participantOutlierScores==max(participantOutlierScores));
           outlierParticipant = participantList(outlier,1);
           %Remove participant from dataset
           participantList(outlier,:)=[];
           rows = stimuliScores.Participant == outlierParticipant;
           stimuliScores(rows,:) = [];
           rows = HRScores.Participant == outlierParticipant;
           HRScores(rows,:) = [];
           fprintf('Removed P%d as an outlier\n',outlierParticipant);
       end
    else
        outlierFlag=false;
    end
    %XXXShishir Debug Info - remove
    %outlierFlag = false;
end


