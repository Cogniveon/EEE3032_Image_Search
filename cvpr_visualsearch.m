%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch_pca.m

close all;
% clear all;
addpath('./utils');

% Clean the results folder (search output, PR graphs, confusion matrix, etc)
rmdir_status = rmdir('./results/*', 's');

[DATASET_FOLDER, DESCRIPTOR_FOLDER, DESCRIPTOR, DISTANCE_FN, USE_PCA, CATEGORIES] = cvpr_config();

%% 1) Load all the descriptors into "FEATURES"
%% each row of FEATURES is a descriptor (is an image)

IMAGES = LoadImages(DATASET_FOLDER);
FEATURES = LoadFeatures(IMAGES);

% number of images in collection
[~, NIMG]=size(IMAGES);

%% 2) Pick an image at random to be the query

% [QUERYSET, category_histogram] = RandomQueryset(IMAGES);

queryimg=floor(rand()*NIMG);
QUERYSET = queryimg;

avg_precision = zeros([1, size(QUERYSET)]);

for imgindex = 1:size(QUERYSET)
    queryimg = QUERYSET(imgindex);

    if USE_PCA
    
        %% 3) Compute eigen model of the FEATURES matrix for PCA
        
        E = EigenModel(FEATURES);
        E = EigenDeflate(E, 0.986);
        
        %% 4) Project the FEATURES into lower dimension
        
        FEATURES=FEATURES-repmat(E.org,size(FEATURES,1),1);
        FEATURES=((E.vct')*(FEATURES'))';
    
    end
    
    %% 5) Compute the distance of images to the query
    dst = cell(NIMG);
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
        dst{i} = [distance i];
    end
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

        pr_values(1, i) = correct_results / i;
        pr_values(2, i) = correct_results / category_histogram(query_category);
    end

    avg_precision(imgindex) = sum(pr_values(1,:) .* pr_values(3,:)) / length(QUERYSET);

    % Limit results
    SHOW=10;
    dst=dst(1:SHOW,:);
    
    %% 7) Visualise the results
    if ~exist(strcat('./results', '/', CATEGORIES(IMAGES{3, queryimg}), '_', string(queryimg)), 'dir')
        mkdir(strcat('./results', '/', CATEGORIES(IMAGES{3, queryimg}), '_', string(queryimg)))
    end

    pr_graph = figure('Visible','off');
    plot(pr_values(1, :), pr_values(2, :));
    hold on;
    title('PR Curve');
    xlabel('Recall');
    ylabel('Precision');
    saveas(pr_graph, strcat('./results', '/', CATEGORIES(IMAGES{3, queryimg}), '_', string(queryimg), '/', 'pr_graph'), 'jpg');

    
    search_output = figure('Visible','off');
    montage(IMAGES(1, dst(:,2)), 'Size', [1 NaN]);
    saveas(search_output, strcat('./results', '/', CATEGORIES(IMAGES{3, queryimg}), '_', string(queryimg), '/', 'search_output'), 'jpg');
end
