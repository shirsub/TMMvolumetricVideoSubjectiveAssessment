function Raligned = ArtAnova(Arg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   INPUT: Arg: Arg should be a n * 3 matrix
%          columns of Arg:
%         ------------------ 1- first categorical variable 
%         ------------------ 2- 2nd categorical variable
%         ------------------ 3- dependent variable
%   This function is used to do aligned rank transform for a data with
%   heavy tail --> TO SEE MAIN EFFECT AND INTERACTION EFFECT 
%   using Analysis of variance..
%   This is an approach used when the data has non-normal distribution
%   Reference:
%   Wobbrock, J.O., Findlater, L., Gergle, D. and Higgins, J.J. (2011). 
%   The Aligned Rank Transform for nonparametric factorial analyses using only ANOVA procedures. 
%   Proceedings of the ACM Conference on Human Factors in Computing Systems (CHI '11). 
%   Vancouver, British Columbia (May 7-12, 2011). New York: ACM Press, pp. 143-146. Honorable Mention Paper. 
%   http://faculty.washington.edu/wobbrock/pubs/chi-11.06.pdf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   by: AbuAli Amin 
%       www.aminbros.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r1 = Arg(:,1);
r2 = Arg(:,2);
R = Arg(:,3);
q1 = unique(r1);
q2 = unique(r2);
if isnumeric(q1)
    q1 = cellstr(num2str(q1));r1 = cellstr(num2str(r1));
end
if isnumeric(q2)
    q2 = cellstr(num2str(q2));r2 = cellstr(num2str(r2));
end
Z = zeros(size(R));
Yaligned1 = zeros(size(R));
Yaligned2 = zeros(size(R));
Yaligned3 = zeros(size(R));
mu = nanmean(R);
for i = 1:size(q1,1)
    ME1 = nanmean(R(strcmp(r1,q1{i}))) - mu;
    for j = 1:size(q2,1)
        Z(strcmp(r1,q1{i}) & strcmp(r2,q2{j})) = R(strcmp(r1,q1{i}) & strcmp(r2,q2{j})) - nanmean(R(strcmp(r1,q1{i}) & strcmp(r2,q2{j})));
        ME2 = nanmean(R(strcmp(r2,q2{j}))) - mu;
        ME12 = nanmean(R(strcmp(r1,q1{i}) & strcmp(r2,q2{j}))) - mu;
        MEI = ME12 - ME1 - ME2 + mu; 
        Yaligned1(strcmp(r1,q1{i}) & strcmp(r2,q2{j})) = Z(strcmp(r1,q1{i}) & strcmp(r2,q2{j})) + ME1;
        Yaligned2(strcmp(r1,q1{i}) & strcmp(r2,q2{j})) = Z(strcmp(r1,q1{i}) & strcmp(r2,q2{j})) + ME2;
        Yaligned3(strcmp(r1,q1{i}) & strcmp(r2,q2{j})) = Z(strcmp(r1,q1{i}) & strcmp(r2,q2{j})) + MEI;
    end
end

R1 = tiedrank(Yaligned1);
R2 = tiedrank(Yaligned2);
R3 = tiedrank(Yaligned3);
Raligned = [R1,R2,R3];
