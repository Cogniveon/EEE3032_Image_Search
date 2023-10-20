function [FEATURES]=cvpr_loadfeatures(IMAGES)

[~, DESCRIPTOR_FOLDER, DESCRIPTOR] = cvpr_config();

[~, NIMG]=size(IMAGES);

FEATURES = [];

for i=1:NIMG
    descriptor_path = [DESCRIPTOR_FOLDER, '/', DESCRIPTOR, '/', IMAGES{2, i}];
    load(descriptor_path, 'F');
    FEATURES = [FEATURES; F];
end

return;