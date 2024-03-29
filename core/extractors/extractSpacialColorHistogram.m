function F = extractSpacialColorHistogram(img, GRID_SIZE, Q)
  % Note img is a normalised RGB image i.e. colours range [0,1] not [0,255].
  arguments
    img
    GRID_SIZE = [5 5]
    Q = 4
  end
  [rows, columns, numberOfColorChannels] = size(img);

  numBandsHorizontally = GRID_SIZE(1);
  numBandsVertically = GRID_SIZE(2);

  topRows = round(linspace(1, rows+1, numBandsVertically + 1));
  leftColumns = round(linspace(1, (columns./numberOfColorChannels)+1, numBandsHorizontally + 1));

  F = [];
  for row = 1 : length(topRows) - 1
    rowA = topRows(row);
    rowB = topRows(row + 1) - 1;
    for col = 1 : length(leftColumns) - 1
      colA = leftColumns(col);
      colB = leftColumns(col + 1) - 1;

      subImage = img(rowA : rowB, colA : colB, :);

      rgbHist = extractRGBHistogram(subImage, Q);
      
      F = [F rgbHist];
    end
  end
return;