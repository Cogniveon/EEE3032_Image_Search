%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch_pca.m

close all;
% clear all;
addpath('./utils');
delete('./results/*')

[DATASET_FOLDER, DESCRIPTOR_FOLDER, DESCRIPTOR, DISTANCE_FN, USE_PCA, CATEGORIES] = cvpr_config();

%% 1) Load all the descriptors into "FEATURES"
%% each row of FEATURES is a descriptor (is an image)

IMAGES = LoadImages(DATASET_FOLDER);
FEATURES = LoadFeatures(IMAGES);

% number of images in collection
[~, NIMG]=size(IMAGES);

%% 2) Pick an image at random to be the query
[QUERYSET, category_histogram] = RandomQueryset(IMAGES);
% index of a random image
% queryimg=floor(rand()*NIMG);
% queryimg = 1;

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
    
    % Limit results
    SHOW=10;
    dst=dst(1:SHOW,:);
    
    %% 6) Visualise the results
    if ~exist(['./results' '/' 'searchResults'], 'dir')
        mkdir(['./results' '/' 'searchResults'])
    end
    
    f = figure('Visible','off');
    montage(IMAGES(1, dst(:,2)), 'Size', [1 NaN]);
    saveas(f, strcat('./results', '/', 'searchResults/', CATEGORIES(IMAGES{3, queryimg}), '_', string(queryimg)), 'jpg');
end
