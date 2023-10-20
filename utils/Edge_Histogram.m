function F = Edge_Histogram(mag, angle, bins, threshold)
  arguments
    mag
    angle
    bins = 7
    threshold = 0.9
  end
  
  [rows, columns] = size(angle);

  edges = [];
  for i = 1:rows
    for j = 1:columns
      if mag(i,j) > threshold
        val = angle(i,j) / (2*pi);
        val = floor(val * bins);
        edges = [edges val];
      end
    end
  end

  if size(edges, 2) == 0
    F = zeros(1, bins);
  else
    F = histcounts(edges, 'NumBins', bins, 'Normalization', 'probability');
  end
end