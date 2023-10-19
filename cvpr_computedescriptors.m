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

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = './MSRC_ObjCategImageDatabase_v2';

%% Create a folder to hold the results...
OUT_FOLDER = './descriptors';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.

%% - random : returns an array of random features
%% - meanColor : returns the mean r,g,b values for the given img
%% - globalRGBHistogram : returns a histogram of color values with the given number of bins (default: 4)
%% - spacialMeanColor : returns an array of mean colors in a spacial grid of N x N cells (N is 16 by default)
%% - spacialRGBHistogram : returns a histogram of color values in a spacial grid of N x N cells (N is 16 by default)
DESCRIPTOR='spacialRGBHistogram';

if ~exist([OUT_FOLDER '/' DESCRIPTOR], 'dir')
    mkdir([OUT_FOLDER '/' DESCRIPTOR])
end

allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    fout=[OUT_FOLDER,'/',DESCRIPTOR,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    
    switch DESCRIPTOR
        case 'random'
            F = extractRandom(img);
        case 'meanColor'
            F = extractMeanColor(img);
        case 'globalRGBHistogram'
            F = extractRGBHistogram(img);
        case 'spacialMeanColor'
            F = extractSpacialMeanColor(img);
        case 'spacialRGBHistogram'
            F = extractSpacialRGBHistogram(img);
        otherwise
            F = extractRandom(img);
    end
    
    save(fout,'F');
    toc
end
