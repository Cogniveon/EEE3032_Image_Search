%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch.m
%% Skeleton code provided as part of the coursework assessment
%%
%% This code will load in all descriptors pre-computed (by the
%% function cvpr_computedescriptors) from the images in the MSRCv2 dataset.
%%
%% It will pick a descriptor at random and compare all other descriptors to
%% it - by calling cvpr_compare.  In doing so it will rank the images by
%% similarity to the randomly picked descriptor.  Note that initially the
%% function cvpr_compare returns a random number - you need to code it
%% so that it returns the Euclidean distance or some other distance metric
%% between the two descriptors it is passed.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
% clear all;
addpath('./utils');

[DATASET_FOLDER, DESCRIPTOR_FOLDER, DESCRIPTOR] = cvpr_config();

%% 1) Load all the descriptors into "FEATURES"
%% each row of FEATURES is a descriptor (is an image)

IMAGES = cvpr_loadimages(DATASET_FOLDER);
FEATURES = cvpr_loadfeatures(IMAGES);


%% 2) Pick an image at random to be the query

% number of images in collection
[~, NIMG]=size(IMAGES);

% index of a random image
% queryimg=floor(rand()*NIMG);
queryimg = 1;

%% 3) Compute the distance of image to the query
dst=[];
for i=1:NIMG
    candidate=FEATURES(i,:);
    query=FEATURES(queryimg,:);
    thedst=cvpr_compare(query,candidate);
    dst=[dst ; [thedst i]];
end
dst=sortrows(dst,1);

%% 4) Visualise the results
% Limit results
SHOW=10;
dst=dst(1:SHOW,:);
montage(IMAGES(1, dst(:,2)), 'Size', [1 NaN]);
