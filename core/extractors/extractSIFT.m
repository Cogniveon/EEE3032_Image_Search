function F = extractSIFT(img, N)
    arguments
        img
        % Number of keypoints
        N = 50
    end
    
    I = rgb2gray(img);
    
    points = detectSIFTFeatures(I);
    
    strongest_points = selectStrongest(points, N);
    
    [features, ~] = extractFeatures(I, strongest_points);
    
    % Limit the features to N descriptors
    if size(features, 1) > N
        features = features(1:N, :);
    end
    
    F = zeros(1, 128 * N); % Initialize with zeros

    % Concatenate the descriptors
    num_features = size(features, 1);
    if num_features > 0
        F(1, 1:(num_features * 128)) = features(:); % Fill with SIFT descriptors
    end
return;