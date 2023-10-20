function [IMAGES]=cvpr_loadimages(DATASET_FOLDER)

all_files = dir(fullfile([DATASET_FOLDER,'/Images/*.bmp']));
IMAGES=cell(3,0);

% Loop through all files
for filenum=1:length(all_files)
    fname=all_files(filenum).name;
    split_string = split(fname, '_');

    % Store image full path
    IMAGES{1,filenum} = ([DATASET_FOLDER, '/Images/', fname]);
    % Store image descriptor name (used by cvpr_loadfeatures later)
    IMAGES{2,filenum} = [fname(1:end-4),'.mat'];
    % Store image category
    IMAGES{3,filenum} = str2double(split_string(1));
end

return;