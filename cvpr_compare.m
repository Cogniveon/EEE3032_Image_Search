% This function should compare F1 to F2 - i.e. compute the distance
% between the two descriptors
function dst=cvpr_compare(F1, F2, norm)
arguments
  F1
  F2
  norm {mustBeMember(norm,["random","euclidean"])} = "euclidean"
end

if norm == "random"
  dst=rand();
elseif norm == "euclidean"
  dst=sqrt(sum((F1-F2).^2));
end
return;
