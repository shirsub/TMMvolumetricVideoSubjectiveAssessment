function[Tout] = getDifferentialScores(Tin)
rows = Tin.Codecs==1;
HRScores = Tin(rows,:);
rows = Tin.Codecs~=1;
stimuliScores = Tin(rows,:);
CombinedScores = join(stimuliScores,HRScores,'Keys',{'Participant','Contents'});
%Use outer join to test, results should be identical if everything else is
%correct
%CombinedScoresTest = outerjoin(stimuliScores,HRScores,'Keys',{'Participant','Contents'});
CombinedScores = removevars(CombinedScores,{'DoF_HRScores','Bitrates_HRScores','Codecs_HRScores'});
DMOS = CombinedScores.Scores_stimuliScores - CombinedScores.Scores_HRScores + 5;
CombinedScores = [CombinedScores,array2table(DMOS)];
CombinedScores.Properties.VariableNames([2 4 5 6 7]) = {'DoF' 'Codecs' 'Bitrates' 'Scores' 'HRScores'};
Tout = CombinedScores;
