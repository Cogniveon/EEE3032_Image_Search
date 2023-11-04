function dst = compare_mahalanobis(F1, F2, E)
    x = (F1 - F2).^2;
    x = x ./ (E.val');
    dst = sqrt(sum(x));
return;