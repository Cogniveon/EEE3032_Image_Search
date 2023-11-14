function F = extractSpacialColorTextureHistogram(img, GRID_SIZE, Q, EdgeBins, EdgeThreshold)
  % Note img is a normalised RGB image i.e. colours range [0,1] not [0,255].
  arguments
    img
    GRID_SIZE = [5 5]
    Q = 4
    EdgeBins = 8
    EdgeThreshold = 0.09
  end
  [rows, columns, numberOfColorChannels] = size(img);
  F = [];

  numBandsHorizontally = GRID_SIZE(1);
  numBandsVertically = GRID_SIZE(2);

  topRows = round(linspace(1, rows+1, numBandsVertically + 1));
  leftColumns = round(linspace(1, (columns./numberOfColorChannels)+1, numBandsHorizontally + 1));

  for row = 1 : length(topRows) - 1
    rowA = topRows(row);
    rowB = topRows(row + 1) - 1;
    for col = 1 : length(leftColumns) - 1
      colA = leftColumns(col);
      colB = leftColumns(col + 1) - 1;

      subImage = img(rowA : rowB, colA : colB, :);

      % Extract color info
      colorHistogram = extractRGBHistogram(subImage, Q);

      % Extract edge info
      % subImage(:,:,1) * 0.3 + subImage(:,:,2) * 0.59 + subImage(:,:,3) * 0.11
      greyImg = rgb2gray(subImage);
      blurredGreyImg = imgaussfilt(greyImg, 1);
      [mag, angle] = Sobel(blurredGreyImg);

      edge_histogram = Edge_Histogram(mag, angle, EdgeBins, EdgeThreshold);
      
      F = [F edge_histogram colorHistogram];
    end
  end
return;