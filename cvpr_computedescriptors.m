%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_computedescriptors.m
%% Skeleton code provided as part of the coursework assessment
%% This code will iterate through every image in the MSRCv2 dataset
%% and call a function 'extractRandom' to extract a descriptor from the
%% image.  Currently that function returns just a random vector so should
%% be changed as part of the coursework exercise.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
% clear all;
addpath('./core/utils');
addpath('./core/extractors');

[DATASET_FOLDER, DESCRIPTOR_FOLDER, DESCRIPTOR, DISTANCE_FN, USE_PCA, CATEGORIES, NUM_RESULTS, RGB_HIST_BINS, SPACIAL_GRID, EDGE_BINS, EDGE_THRESHOLD] = cvpr_config();

if ~exist([DESCRIPTOR_FOLDER '/' DESCRIPTOR], 'dir')
    mkdir([DESCRIPTOR_FOLDER '/' DESCRIPTOR])
end

IMAGES = LoadImages(DATASET_FOLDER);
[~, NIMG]=size(IMAGES);

for i = 1:NIMG
    fprintf('Processing file %d/%d - %s\n', i, NIMG, IMAGES{1, i});
    tic;
    img=double(imread(IMAGES{1, i}))./256;
    descriptor_path = [DESCRIPTOR_FOLDER, '/', DESCRIPTOR, '/', IMAGES{2, i}];

    switch DESCRIPTOR
        case 'Random'
            F = extractRandom(img);
        case 'MeanColor'
            F = extractMeanColor(img);
        case 'RGBHistogram'
            F = extractRGBHistogram(img, RGB_HIST_BINS);
        case 'SpacialMeanColor'
            F = extractSpacialMeanColor(img, SPACIAL_GRID);
        case 'SpacialColorHistogram'
            F = extractSpacialColorHistogram(img, SPACIAL_GRID, RGB_HIST_BINS);
        case 'SpacialColorTextureHistogram'
            F = extractSpacialColorTextureHistogram(img, SPACIAL_GRID, RGB_HIST_BINS, EDGE_BINS, EDGE_THRESHOLD);
        case 'SIFT'
            F = extractSIFT(img, 50);
        case 'CNN'
            F = extractCNN(img);
        otherwise
            F = extractRandom(img);
    end
    
    save(descriptor_path, 'F');
    toc;
end
