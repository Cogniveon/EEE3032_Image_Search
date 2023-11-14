function [DATASET_FOLDER, DESCRIPTOR_FOLDER, DESCRIPTOR, DISTANCE_FN, USE_PCA, CATEGORIES, NUM_RESULTS, RGB_HIST_BINS, SPACIAL_GRID, EDGE_BINS, EDGE_THRESHOLD]=cvpr_config()

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = './MSRC_ObjCategImageDatabase_v2/Images';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = './descriptors';

%% and within that folder, another folder to hold the descriptors
%% we are interested in working with

%% - Random : returns an array of random features
%% - MeanColor : returns the mean r,g,b values for the given img
%% - RGBHistogram : returns a histogram of color values with the given number of bins (default: 4)
%% - SpacialMeanColor : returns an array of mean colors in a spacial grid of N x N cells (N is 16 by default)
%% - SpacialColorHistogram : returns a histogram of color values in a spacial grid of N x N cells (N is 16 by default)
%% - SpacialColorTextureHistogram : returns a histogram of edge and color values in a spacial grid of N x N cells (N is 16 by default)
%% - SIFT : returns a descriptor using the SIFT algorithm
%% - CNN : returns a descriptor using AlexNET
DESCRIPTOR='CNN';

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

NUM_RESULTS = 10;

RGB_HIST_BINS = 4;
SPACIAL_GRID = [3 3];
EDGE_BINS = 7;
EDGE_THRESHOLD = 0.09;

return;