function [QUERYSET, category_histogram]=RandomQueryset(IMAGES)

category_histogram = histcounts(cell2mat(IMAGES(3,:)));

[~, NUM_OF_CATEGORIES] = size(category_histogram);

QUERYSET = [];
for i = 1:NUM_OF_CATEGORIES
    category_images = find([IMAGES{3, :}] == i);

    % random image from category
    QUERYSET = [QUERYSET category_images(floor(rand()*category_histogram(i)))];
end
return;