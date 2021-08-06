function scores = outlier_detection_p913(scores, content_lut, r1, r2)
% scores is a matrix, in which the first dimension (rows) indicates the
% stimuli, and the second dimension (columns) indicates the subjects
%
% content_lut is a vector indicating to which content each stimulus
% corresponds to

if nargin < 3
    r1 = 0.75;
end

if nargin < 4
    r2 = 0.80;
end

% map = zeros(size(scores,2), 1);
while 1
    x = nanmean(scores, 2);

    nSubjects = size(scores, 2);
    PLCC = zeros(nSubjects, 1);
    for j = 1:size(scores, 2) % per subject
        y = scores(:, j);
        PLCC(j) = corr(x, y, 'type', 'Pearson');
    end

    content_list = unique(content_lut);
    nContents = length(content_list);
    nStimuli = size(scores,1)./nContents;

    xReshaped = zeros(nContents, nStimuli);
    yReshaped = zeros(nContents, nStimuli, nSubjects);
    for k = 1:length(content_list)
        xReshaped(k, :) = x(content_lut == content_list(k));
        yReshaped(k, :, :) = scores(content_lut == content_list(k), :);
    end

    x_perCondition = nanmean(xReshaped, 1);

    PLCC_perCondition = zeros(nSubjects, 1);
    for j = 1:size(scores, 2) % per subject
        y_perCondition = nanmean(yReshaped(:, :, j), 1);
        PLCC_perCondition(j) = corr(x_perCondition', y_perCondition',  'type', 'Pearson');
    end

    test1 = (PLCC - r1);
    test2 = (PLCC_perCondition - r2);

    avg_test = (test1+test2)/2;
    [~, idx] = min(avg_test);
    if PLCC(idx) < r1 && PLCC_perCondition(idx) < r2
        scores(:, idx) = [];

%         offset_idx = sum(map(1:idx));
% 
%         map(idx+offset_idx) = 1;
    end

    if PLCC(idx) > r1 || PLCC_perCondition(idx) > r2 || isempty(scores)
        break;
    end

    clear LPCC LPCC2
end

% fprintf('NumOutliers = %d, ID = %d\n', sum(map == 1), find(map == 1))