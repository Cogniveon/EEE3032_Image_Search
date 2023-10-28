function [DATASET_FOLDER, DESCRIPTOR_FOLDER, DESCRIPTOR, DISTANCE_FN, USE_PCA, CATEGORIES]=cvpr_config()

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = './MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = './descriptors';

%% and within that folder, another folder to hold the descriptors
%% we are interested in working with

%% - random : returns an array of random features
%% - meanColor : returns the mean r,g,b values for the given img
%% - globalRGBHistogram : returns a histogram of color values with the given number of bins (default: 4)
%% - spacialMeanColor : returns an array of mean colors in a spacial grid of N x N cells (N is 16 by default)
%% - spacialColorHistogram : returns a histogram of color values in a spacial grid of N x N cells (N is 16 by default)
%% - spacialColorTextureHistogram : returns a histogram of edge and color values in a spacial grid of N x N cells (N is 16 by default)
DESCRIPTOR='spacialColorHistogram';

%% - random : returns a random distance
%% - l1 : returns F1-F2
%% - euclidean : returns sqrt((F1-F2)^2)
%% - mahalanobis : returns the mahalanobis distance (requires PCA)
DISTANCE_FN='euclidean';

USE_PCA = false;

CATEGORIES = [
    "Farm_Animal" 
    "Tree"
    "Building"
    "Plane"
    "Cow"
    "Face"
    "Car"
    "Bike"
    "Sheep"
    "Flower"
    "Sign"
    "Bird"
    "Book_Shelf"
    "Bench"
    "Cat"
    "Dog"
    "Road"
    "Water_Features"
    "Human_Figures"
    "Coast"
];

return;