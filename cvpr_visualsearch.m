%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch_pca.m

close all;
% clear all;
addpath('./core/utils');

% Clean the results folder (search output, PR graphs, confusion matrix, etc)
rmdir_status = rmdir('./results/*', 's');

[DATASET_FOLDER, DESCRIPTOR_FOLDER, DESCRIPTOR, DISTANCE_FN, USE_PCA, CATEGORIES, NUM_RESULTS] = cvpr_config();

%% 1) Load all the descriptors into "FEATURES"
%% each row of FEATURES is a descriptor (is an image)

IMAGES = LoadImages(DATASET_FOLDER);
FEATURES = LoadFeatures(IMAGES);

% number of images in collection
[~, NIMG]=size(IMAGES);

%% 2) Pick an image at random to be the query

[QUERYSET, category_histogram] = RandomQueryset(IMAGES);

% Fix query to a non-random array for research purposes
QUERYSET = [320; 379; 384; 434; 445; 500; 526; 559; 584; 4; 52; 68; 124; 156; 166; 205; 216; 241; 277; 348];

% queryimg=floor(rand()*NIMG);
% QUERYSET = 134;

pr_values_at_n = zeros([2, size(QUERYSET)]);
all_pr_values = zeros([2, size(QUERYSET)]);
mean_pr_values = zeros(length(QUERYSET), 2, NIMG);
confusion_matrix = zeros(length(category_histogram));

fprintf('Running visual search for %d iterations\n', length(QUERYSET));
for imgindex = 1:size(QUERYSET)
    queryimg = QUERYSET(imgindex);

    fprintf('Searching for image %d/%d - %s (%s)\n', imgindex, length(QUERYSET), string(IMAGES{1, queryimg}), CATEGORIES(IMAGES{3, queryimg}));
    tic;

    if USE_PCA
    
        %% 3) Compute eigen model of the FEATURES matrix for PCA
        
        E = EigenModel(FEATURES);
        E = EigenDeflate(E, 0.983);
        
        %% 4) Project the FEATURES into lower dimension
        
        FEATURES=FEATURES-repmat(E.org,size(FEATURES,1),1);
        FEATURES=((E.vct')*(FEATURES'))';
    
    end
    
    %% 5) Compute the distance of images to the query
    dst = cell(NIMG, 2);
    for i=1:NIMG
        candidate=FEATURES(i,:);
        query=FEATURES(queryimg,:);
    
        switch DISTANCE_FN
            case 'random'
                distance = cvpr_compare(query, candidate, 'random');
            case 'l1'
                distance = cvpr_compare(query, candidate, 'l1');
            case 'euclidean'
                distance = cvpr_compare(query, candidate, 'euclidean');
            case 'mahalanobis'
                distance = cvpr_compare(query, candidate, 'mahalanobis', E);
            otherwise
                distance = cvpr_compare(query, candidate, 'euclidean');
        end

        dst{i, 1} = distance;
        dst{i, 2} = double(i);
    end
    dst = cellfun(@double, dst, 'UniformOutput', false);
    dst = cell2mat(dst);
    dst = sortrows(dst, 1);

    %% 6) Calculate PR

    % Row 1-precision, Row 2-recall, Row 3-correctAtN
    pr_values = zeros(3, NIMG);

    queryimg = dst(1,2);
    query_category = IMAGES{3, queryimg};

    for i = 1:NIMG
        rows = dst(1:i, :);

        correct_results = 0;
        incorrect_results = 0;
        
        if i > 1
            for n = 1:i-1
                result_category = IMAGES{3, rows(n, 2)};
                if query_category == result_category
                    correct_results = correct_results + 1;
                else
                    incorrect_results = incorrect_results + 1;
                end
            end
        end

        result_category = IMAGES{3, rows(i, 2)};

        if query_category == result_category
            correct_results = correct_results + 1;
            pr_values(3, i) = 1;
        else
            incorrect_results = incorrect_results + 1;
        end


        precision = correct_results / i;
        recall = correct_results / category_histogram(query_category);
    
        if i == NUM_RESULTS
            pr_values_at_n(1, imgindex) = precision;
            pr_values_at_n(2, imgindex) = recall;
        end

        pr_values(1, i) = precision;
        pr_values(2, i) = recall;
    end

    mean_pr_values(imgindex, 1, :) = pr_values(1, :);
    mean_pr_values(imgindex, 2, :) = pr_values(2, :);

    all_pr_values(1, imgindex) = sum(pr_values(1,:) .* pr_values(3,:)) / category_histogram(query_category);
    all_pr_values(2, imgindex) = mean(pr_values(2,:));

    fprintf('Average precision: %.2f\n', all_pr_values(1, imgindex));
    fprintf('Average recall: %.2f\n', all_pr_values(2, imgindex));

    % Limit results
    dst=dst(1:NUM_RESULTS,:);
    
    %% 7) Calculate confusion matrix
    for i = 1:NUM_RESULTS
        confusion_matrix(IMAGES{3, dst(i, 2)}, imgindex) = confusion_matrix(IMAGES{3, dst(i, 2)}, imgindex) + 1;
    end
    

    %% 8) Visualise the results
    if ~exist(strcat('./results', '/', CATEGORIES(IMAGES{3, queryimg}), '_', string(queryimg)), 'dir')
        mkdir(strcat('./results', '/', CATEGORIES(IMAGES{3, queryimg}), '_', string(queryimg)))
    end
    
    % Search output
    search_output = figure('Visible','off');
    montage(IMAGES(1, dst(:,2)), 'Size', [1 NaN]);
    saveas(search_output, strcat('./results', '/', CATEGORIES(IMAGES{3, queryimg}), '_', string(queryimg), '/', 'search_output'), 'jpg');

    % Individual PR graph
    pr_graph = figure('Visible','off');
    plot(pr_values(2, :), pr_values(1, :));
    hold on;
    title('PR Curve');
    xlabel('Recall');
    ylabel('Precision');
    saveas(pr_graph, strcat('./results', '/', CATEGORIES(IMAGES{3, queryimg}), '_', string(queryimg), '/', 'pr_graph'), 'jpg');
    hold off;

    toc;
end
    
% Confusion Matrix
confusion_matrix_output = figure('Visible','off');
cm = confusionchart(confusion_matrix, CATEGORIES, 'Normalization', 'column-normalized');
cm_title = 'Confusion Matrix - ';
cm_title = [cm_title, DESCRIPTOR, '/', DISTANCE_FN, ' '];
if USE_PCA
    cm_title = [cm_title, 'with PCA'];
end
cm.Title = cm_title;
xlabel('Query Classification');
ylabel('Ground Truth');
saveas(confusion_matrix_output, strcat('./results', '/', 'confusion_matrix'), 'jpg');

% Mean PR graph
mean_recall = reshape(mean(mean_pr_values(:, 2, :)), [1, NIMG]);
mean_precision = reshape(mean(mean_pr_values(:, 1, :)), [1, NIMG]);
meanpr_graph = figure('Visible','off');
plot(mean_recall, mean_precision);
hold on;
title('Mean PR Curve');
xlabel('Recall');
ylabel('Precision');
saveas(meanpr_graph, strcat('./results', '/', 'mean_pr_graph'), 'jpg');
hold off;

% Mean Average Precision
map = mean(pr_values_at_n(1,:));
fprintf('Mean average precision for %d images: %.2f\n', length(QUERYSET), map);

% Save PR stats for reference
save(strcat('./results', '/', 'stats.mat'), 'map', 'QUERYSET', 'all_pr_values');
