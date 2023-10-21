function [FEATURES]=LoadFeatures(IMAGES)

[~, DESCRIPTOR_FOLDER, DESCRIPTOR] = cvpr_config();

[~, NIMG]=size(IMAGES);

FEATURES = cell(NIMG);

for i=1:NIMG
    descriptor_path = [DESCRIPTOR_FOLDER, '/', DESCRIPTOR, '/', IMAGES{2, i}];
    load(descriptor_path, 'F');
    FEATURES{i} = F;
end

FEATURES = cell2mat(FEATURES);
return;