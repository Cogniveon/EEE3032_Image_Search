# EEE3032 – Computer Vision and Pattern Recognition

Coursework Assignment – Visual Search of an Image Collection

Supervised by Prof Miroslaw Bober


## Dataset

Microsoft Research (MSVC-v2) dataset of 591 images (20 classes) which can be downloaded from MSR [here](http://download.microsoft.com/download/3/3/9/339D8A24-47D7-412F-A1E8-1A415BC48A15/msrc_objcategimagedatabase_v2.zip).

## Resources

You are supplied with two skeleton MATLAB programs enabling you to start coding quickly.

1) cvpr_computedescriptors

This program will iterate through every image in the dataset and generate an image descriptor from it by calling the
supplied function “extractRandom”. As supplied, that function generates a set of random numbers instead of an image
descriptor. You should replace “extractRandom” with your own code for extracting your chosen type of image
descriptor. The descriptors are all saved into a separate folder. You can configure folder names in the code.

2) cvpr_visualsearch

This program will load in all the image descriptors computed by “cvpr_computedescriptors”. It will then pick an image
at random to use as a query. It will repeatedly call “cvpr_compare” with the query descriptor and the descriptor from
each image. Currently this function returns a random number. You should edit it to return the distance between the
features being compared. The program “cvpr_visualsearch” will visualise your top 10 results in a basic way.
Depending on the level of sophistication of your coursework solution, you might improve this.
The purpose of the skeleton code is to get you started quickly. You should be able to create a working basic visual search
system by replacing “extractRandom” with a global colour histogram (slide 4, lecture 7) and “cvpr_compare” to output
Euclidean distance between the two features it is passed. This will meet Requirement 1 (see section 6. You might then go
on to enhance the “cvpr_visualsearch” code to produce precision-recall statistics, and then try other descriptors or
distance metrics to improve performance (you can measure the improvement using your aforementioned precision-recall
code).

## Requirements

- [ ] Global colour histogram
- [ ] Evaluation methodology
- [ ] Spatial Grid (Colour and Texture)
- [ ] PCA
- [ ] Different descriptors and distance measures
- [ ] Bag of Visual Words retrieval
- [ ] Object classification using SVM
- [ ] ???