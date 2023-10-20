%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch_pca.m

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

%% 3) Compute eigen model of the FEATURES matrix for PCA

E = EigenModel(FEATURES);
E = EigenDeflate(E, 0.986);

%% 4) Project the FEATURES into lower dimension

PCA_FEATURES=FEATURES-repmat(E.org,size(FEATURES,1),1);
PCA_FEATURES=((E.vct')*(PCA_FEATURES'))';

%% 5) Compute the distance of images to the query
dst=[];
for i=1:NIMG
    candidate=PCA_FEATURES(i,:);
    query=PCA_FEATURES(queryimg,:);
    distance=cvpr_compare(query, candidate, "mahalanobis", E);
    dst=[dst; [distance i]];
end
dst=sortrows(dst,1);

%% 6) Visualise the results
% Limit results
SHOW=10;
dst=dst(1:SHOW,:);
montage(IMAGES(1, dst(:,2)), 'Size', [1 NaN]);
