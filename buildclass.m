%This function takes a dataset (country,year,indicator), associated
%classes, and number of trials and builds an LDA classifier. It outputs the
%average cva for each year
function [crossvals] = buildclass(indicators,percentiles,trials)
    %delete the NaNs
    for i = 1:size(indicators,3),
        [row col] = find(isnan(indicators(:,:,i)));
        row = unique(row);
        percentiles(row,:) = [];
        indicators(row,:,:) = [];
    end
    %fraction of dataset to test
    testfrac = 0.2;
    cvatotal = 0;
    crossvals = NaN(1,size(indicators,2));
    ind_row = size(indicators,1);
    for i = 1:size(indicators,2),
        %select data for current year
        current_year = squeeze(indicators(:,i,:));
        for k = 1:trials,
            %randomly select indices for testing and training
            permuted = randperm(ind_row);
            test = permuted(1:floor(ind_row*testfrac));
            train = permuted(ceil((ind_row*testfrac)):end);
            %build the classifier
            predictedclasses = classify(current_year(test,:), current_year(train,:),percentiles(train));
            %track cross-validated accuracy to be averaged
            cvatotal = cvatotal + mean(predictedclasses == percentiles(test)');
        end
        %average cva for n trials
        crossvals(i) = cvatotal/trials;
        cvatotal = 0;
end