%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch_pca.m

close all;
% clear all;
addpath('./utils');

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = './MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = './descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
DESCRIPTOR='spacialColorTextureHistogram';


%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)
ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    thesefeat=[];
    % replace .bmp with .mat
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR,'/',fname(1:end-4),'.mat'];
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end

%% 2) Pick an image at random to be the query
NIMG=size(ALLFEAT,1);             % number of images in collection
% queryimg=floor(rand()*NIMG);    % index of a random image
queryimg = 1;

[ALLFEATPCA, E] = Eigen_PCA(ALLFEAT', 'keepn', 3);
ALLFEATPCA = ALLFEATPCA';

%% 3) Compute the distance of image to the query
dst=[];
for i=1:NIMG
    candidate=ALLFEATPCA(i,:);
    query=ALLFEATPCA(queryimg,:);
    thedst=cvpr_compare(query,candidate, "mahalanobis", E);
    dst=[dst ; [thedst i]];
end
dst=sortrows(dst,1);  % sort the results

%% 4) Visualise the results
%% These may be a little hard to see using imgshow
%% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)

% Show top 10 results
SHOW=10;
dst=dst(1:SHOW,:);
outdisplay=[];
for i=1:size(dst,1)
    img=imread(ALLFILES{dst(i,2)});
    img=img(1:2:end,1:2:end,:); % make image a quarter size
    img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
    outdisplay=[outdisplay img];
end
figure;
imshow(outdisplay);
axis off;