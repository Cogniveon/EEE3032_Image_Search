function F = extractSpacialColorHistogram(img, M, N)
  % Note img is a normalised RGB image i.e. colours range [0,1] not [0,255].
  arguments
    img
    M = 5
    N = 5
  end
  [rows, columns, numberOfColorChannels] = size(img);
  F = [];

  numBandsHorizontally = M;
  numBandsVertically = N;

  topRows = round(linspace(1, rows+1, numBandsVertically + 1));
  leftColumns = round(linspace(1, (columns./numberOfColorChannels)+1, numBandsHorizontally + 1));

  for row = 1 : length(topRows) - 1
    rowA = topRows(row);
    rowB = topRows(row + 1) - 1;
    for col = 1 : length(leftColumns) - 1
      colA = leftColumns(col);
      colB = leftColumns(col + 1) - 1;

      subImage = img(rowA : rowB, colA : colB, :);

      rgbHist = extractRGBHistogram(subImage);
      
      F = [F rgbHist];
    end
  end
return;