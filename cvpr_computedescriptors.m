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
addpath('./utils');
addpath('./extractors');

[DATASET_FOLDER, DESCRIPTOR_FOLDER, DESCRIPTOR] = cvpr_config();

if ~exist([DESCRIPTOR_FOLDER '/' DESCRIPTOR], 'dir')
    mkdir([DESCRIPTOR_FOLDER '/' DESCRIPTOR])
end

IMAGES = cvpr_loadimages(DATASET_FOLDER);
[~, NIMG]=size(IMAGES);

for i = 1:NIMG
    fprintf('Processing file %d/%d - %s\n', i, NIMG, IMAGES{1, i});
    tic;
    img=double(imread(IMAGES{1, i}))./256;
    descriptor_path = [DESCRIPTOR_FOLDER, '/', DESCRIPTOR, '/', IMAGES{2, i}];

    switch DESCRIPTOR
        case 'random'
            F = extractRandom(img);
        case 'meanColor'
            F = extractMeanColor(img);
        case 'globalRGBHistogram'
            F = extractRGBHistogram(img);
        case 'spacialMeanColor'
            F = extractSpacialMeanColor(img);
        case 'spacialColorHistogram'
            F = extractSpacialColorHistogram(img);
        case 'spacialColorTextureHistogram'
            F = extractSpacialColorTextureHistogram(img);
        otherwise
            F = extractRandom(img);
    end
    
    save(descriptor_path, 'F');
    toc;
end
