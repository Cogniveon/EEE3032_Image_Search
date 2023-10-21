function [QUERYSET, category_histogram]=RandomQueryset(IMAGES)

category_histogram = histcounts(cell2mat(IMAGES(3,:)));

[~, NUM_OF_CATEGORIES] = size(category_histogram);

QUERYSET = cell(NUM_OF_CATEGORIES);
for i = 1:NUM_OF_CATEGORIES
    category_images = find([IMAGES{3, :}] == i);
    % random image from category
    QUERYSET{i} = category_images(ceil(rand()*category_histogram(i)));
end
QUERYSET = cell2mat(QUERYSET);
return;