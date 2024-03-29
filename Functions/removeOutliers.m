%Function to remove outliers based on ITU P.913 Annex A
%https://www.itu.int/rec/T-REC-P.913-201603-I/en 
%PVS - Processed Video Sequence - Degraded video sequences
%HRC - Hypothetical Reference Circuit - Fixed combination of encoder + bitrate + netwrok condition+ decoder
function[Tout,removedParticipants,n] = removeOutliers(Tin,r1,r2)

%XXXShishir Debug test to match old results - ToDo Remove
%rows = Tin.DoF == 3;
%Tin(rows,:) = [];
%Outlier Treatment T1
participantList = unique(Tin.Participant);
participantList = sortrows(participantList,1);
%Get PVS scores table
Tpvs = Tin;
Tout = Tin;
n = 0;
removedParticipants = [];
%Get HRC scores table
Thrc = varfun(@mean,Tin,'InputVariables','Scores','GroupingVariables',{'Participant','DoF','Codecs','Bitrates'});
outlierFlag = true;
%Compute correlation per participant and log outliers
while(outlierFlag)
    participantR1Coeffs = array2table(zeros(size(participantList)));
    participantR2Coeffs = array2table(zeros(size(participantList)));
    %Compute R1 and R2 coefficients for every participant
    for participant = 1:size(participantList)
        %R1 computation
        rows = Tpvs.Participant == participantList(participant);
        x = Tpvs(rows,:);
        rows = Tpvs.Participant ~= participantList(participant);
        y_t = Tpvs(rows,:);
        %XXXShishir ToDo: Averaged over DoFs - is this correct?
        y = varfun(@mean,y_t,'InputVariables','Scores','GroupingVariables',{'Contents','Codecs','Bitrates'});
        x = sortrows(x,{'Participant','Contents','Codecs','Bitrates'});
        y = sortrows(y,{'Contents','Codecs','Bitrates'});
        r1_coeff=corrcoef(x.Scores,y.mean_Scores);
        participantR1Coeffs{participant,1}=r1_coeff(1,2);
        %R2 Computation
        rows = Thrc.Participant == participantList(participant);
        x = Thrc(rows,:);
        rows = Thrc.Participant ~= participantList(participant);
        y_t = Thrc(rows,:);
        y = varfun(@mean,y_t,'InputVariables','mean_Scores','GroupingVariables',{'Codecs','Bitrates'});
        x = sortrows(x,{'Participant','Codecs','Bitrates'});
        y = sortrows(y,{'Codecs','Bitrates'});
        r2_coeff=corrcoef(x.mean_Scores,y.mean_mean_Scores);
        %XXX_Shishir Debug Info
        if isnan(r2_coeff(1,2))
            disp('Error: FoundNan in HRC correl values');
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
           rows = Tpvs.Participant == outlierParticipant;
           Tpvs(rows,:) = [];
           rows = Thrc.Participant == outlierParticipant;
           Thrc(rows,:) = [];
           rows = Tout.Participant == outlierParticipant;
           Tout(rows,:)= [];
           fprintf('Removed P%d as an outlier\n',outlierParticipant);
           n = n + 1;
           removedParticipants = [removedParticipants , outlierParticipant];
       end
    else
        outlierFlag=false;
    end
    %XXXShishir Debug Info - remove
    %outlierFlag = false;
end


