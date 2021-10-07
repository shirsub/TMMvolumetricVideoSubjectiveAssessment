%Arrange the dependent variable into a matrix where each column representes
%different groups, make sure the rows are matched (sort by every other
%independent variable), bonferroni correction is inbuilt 
function[Tout] = PairwiseWilcoxonSRTest(Tin,a)
    if nargin == 1
        a = 0.05;
    end
    %groups = size(Tin,2);
    [obs,groups] = size(Tin);
    %Number of comparisons
    N = (groups * (groups-1))/2;
    a = a/N;
    %Format Tout
    header = {'Group1','Group2','Z','p','r','h','signrank'};
    Tout = cell2table(cell(0,7),'VariableNames', header);
    for i = 1:groups
        for j = i+1:groups
           %[p, h, stats] = signrank(Tin(:,i),Tin(:,j),'alpha',a); 
           [p, h, stats] = signrank(Tin(:,i),Tin(:,j),'alpha',a,'method','approximate'); 
           z = stats.zval;
           signedrank = stats.signedrank;
           %Each observation is a matched pair so we use obs*2 to calculate the
           %effect size
           r = abs(z)/sqrt(obs*2);
           %newrow = {i,j,z,p,r,h,signedrank};
           newrow = {i,j,round(z,3),p,round(r,3),h,round(signedrank,3)};
           Tout = [Tout;newrow];
        end
    end
end