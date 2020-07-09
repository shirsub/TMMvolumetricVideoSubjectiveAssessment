%Script to plot MOS and DMOS based on ITU P.913
%https://www.itu.int/rec/T-REC-P.913-201603-I/en with 95% confidence
%intervals
%XXXShishir ToDo: modify to function, fix chart options
%Outlier Treatment T1
function[Tout] = dmosplots(Tin,conf,dmos)

Codecs = unique(Tin.Codecs);
Rates = unique(Tin.Bitrates);
Contents = unique(Tin.Contents);
DoFs = unique(Tin.DoF);
Tout = table('Size',[size(Codecs,1) + size(Rates,1) + size(Contents,1) + size(DoFs,1), 10],'VariableNames',["DoF","Content","Codec","Rate","DMOS","CILow","CIHigh","HRScore","HRCILow","HRCIHigh"],'VariableTypes',["int32","int32","int32","int32","double","double","double","double","double","double"]);
nout = 1;
for dof = 1:size(DoFs)
    for content = 1:size(Contents)
       for rate = 1:size(Rates)
           for codec = 1:size(Codecs)
               rows = Tin.Codecs == Codecs(codec) & Tin.Bitrates == Rates(rate) & Tin.Contents == Contents(content) & Tin.DoF == DoFs(dof);
               series = Tin(rows,:);
               nd = height(series) - 1;
               if dmos == true
                   scores = series.DMOS;
               else
                   scores = series.Scores;
               end
               avgscore = mean(scores);
               stderrscores = std(scores)/sqrt(height(series));
               alpha = 1 - conf;
               clLow = alpha/2;
               clHigh = 1 - alpha/2;
               clValues = tinv([clLow clHigh], nd);
               cl = avgscore + clValues*stderrscores;
               %Assign to Tout
               Tout.DoF(nout) = dof;
               Tout.Content(nout) = content;
               Tout.Codec(nout) = codec;
               Tout.Rate(nout) = rate;
               Tout.DMOS(nout) = avgscore;
               Tout.CILow(nout) = cl(1);
               Tout.CIHigh(nout) = cl(2);
               %Calculate average HR score along with CIs
               %Recalculating this for every bit rate is redundant but done
               %for testing/validation
               %XXXShishir Todo: Optimize later after testing
               scores = series.HRScores;
               avgscore = mean(scores);
               stderrscores = std(scores)/sqrt(height(series));
               alpha = 1 - conf;
               clLow = alpha/2;
               clHigh = 1 - alpha/2;
               clValues = tinv([clLow clHigh], nd);
               cl = avgscore + clValues*stderrscores;
               Tout.HRScore(nout) = avgscore;
               Tout.HRCILow(nout) = cl(1);
               Tout.HRCIHigh(nout) = cl(2);
               nout = nout + 1;
           end
       end
    end
end