% This function should compare F1 to F2 - i.e. compute the distance
% between the two descriptors
function dst=cvpr_compare(F1, F2, norm, E)
arguments
  F1
  F2
  norm {mustBeMember(norm,["random","euclidean","l1","mahalanobis"])} = "euclidean"
  E = []
end

if norm == "random"
  dst=rand();
elseif norm == "euclidean"
  dst=sqrt(sum((F1-F2).^2));
elseif norm == "l1"
  dst=sum(abs(F1-F2));
elseif norm == "mahalanobis"
  x=(F1-F2).^2;
  x=x./(E.val');
  dst=sqrt(sum(x));
end
return;
