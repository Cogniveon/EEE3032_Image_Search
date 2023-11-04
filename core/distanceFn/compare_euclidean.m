function dst = compare_euclidean(F1, F2)
    dst = sqrt(sum((F1-F2).^2));
return;