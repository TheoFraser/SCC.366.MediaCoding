
extractHOGFeatures = extractHOGFeatures_cw(imread("cameraman.tif"));

function extractedHOGFeatures = extractHOGFeatures_cw (inputImage)
    % Check if the input image is in color, convert to grayscale if needed
    if(size(inputImage, 3) == 3) % Check if the image has 3 channels (RGB)
        inputImage = rgb2gray(inputImage); % Convert to grayscale
    end
    [height, width] = size(inputImage);
    %height = size(inputImage, 1); % Get the height of the image
    %width = size(inputImage, 2); % Get the width of the image
    % Adjust the image size to be a multiple of 8 for HOG computation
    if mod(height, 8) ~= 0 || mod(width, 8) ~= 0 % Check if dimensions are not multiples of 8
        height = floor(height / 8) * 8; % Make height a multiple of 8
        width = floor(width / 8) * 8; % Make width a multiple of 8
        inputImage = imresize(inputImage, [height, width]); % Resize the image
    end
    size(inputImage)
    % Sobel filter for computing gradients in X and Y directions
    gX = [-1, 0, 1; -2, 0, 2; -1, 0, 1]; % Sobel filter in X direction
    gY = gX'; % Transpose for Sobel filter in Y direction
    
    % apply the sobel filter gX to input image using convolution
    gXimg = imfilter(double(inputImage), gX, 'conv', 'same', 'replicate'); 
    % apply the sobel filter gY to input image using convolution
    gYimg = imfilter(double(inputImage), gY, 'conv', 'same', 'replicate'); % Convolve image with Sobel filter in Y direction
    % Compute gradient magnitudes and directions
    gMag = abs(gXimg) + abs(gYimg); % Compute gradient magnitude
    gDir = atan2d(gYimg, gXimg); % Compute gradient direction
    index = find(gDir < 0); % Find indices where direction is negative
    gDir(index) = gDir(index) + 180; % Adjust negative directions
 
    % Divide the image into sub-divisions and compute histograms
    subDivisions = 8; % Number of sub-divisions
    numSubDivisionsRows = floor(height / subDivisions); % Number of sub-divisions along rows
    numSubDivisionsCols = floor(width / subDivisions); % Number of sub-divisions along columns
    
    % Create arrays of sub-divisions along each dimension
    subDivisionsRows = ones(1, numSubDivisionsRows) * subDivisions;
    subDivisionsCols = ones(1, numSubDivisionsCols) * subDivisions;
    
    % Create cell arrays of gradient magnitudes and directions
    outM = mat2cell(gMag, subDivisionsRows, subDivisionsCols);
    outD = mat2cell(gDir, subDivisionsRows, subDivisionsCols);
    
    % Define bin edges for histogram computation
    binEdges = [0, 20, 40, 60, 80, 100, 120, 140, 160]; % Bin edges for histogram
    % Initialize histogram matrix
    hist = zeros(size(outD, 1), size(outD, 2), 9); % 3D matrix to store histograms

    % Compute histograms for each sub-division
    for k = 1:size(outD, 1)
        for z = 1:size(outD, 2)
            hist(k, z, :) = calculateHist(binEdges, outD{k, z}, outM{k, z}); % Compute histogram
        end
    end

    % Concatenate histograms to form the final feature vector
    hist2 = zeros(size(outD, 1) - 2 + 1, size(outD, 1) - 2 + 1, 36); % 3D matrix for concatenated histograms
    for k = 1:(size(outD, 1) - 2 + 1)
        for z = 1:(size(outD, 2) - 2 + 1)
            hist2(k, z, 1:9) = hist(k, z, 1:9); % Copy the first row of each histogram
            hist2(k, z, 10:18) = hist(k, z + 1, 1:9); % Copy the second row of each histogram
            hist2(k, z, 19:27) = hist(k + 1, z, 1:9); % Copy the third row of each histogram
            hist2(k, z, 28:36) = hist(k + 1, z + 1, 1:9); % Copy the fourth row of each histogram
        end
    end
    
    % Reshape and normalize the feature vector
    extractedHOGFeatures = reshape(hist2, 1,[]); % Reshape to a 1D vector
    extractedHOGFeatures = normalize(extractedHOGFeatures); % Normalize the feature vector
end


% Function to calculate a histogram given bin edges, gradient directions, and magnitudes
function hist = calculateHist(binEdges, x, y)
    hist = zeros(9, 1); % Initialize histogram
    for i = 1:size(x, 1)
        for j = 1:size(x, 2)
            % Find the bin index for the current gradient direction
            indices = find(binEdges > x(i, j)); % Find indices where bin edges are greater than the gradient direction
            if(isempty(indices)) %If the gradient direction is bigger than 160
                firstIndex = 9; % Set firstIndex to the last bin
                previousIndex = 1; % Set previous index to the first bin
                firstValue = (double(x(i, j)) - binEdges(firstIndex)) / 20; % Compute the contribution to the last bin
                secondValue = 1 - firstValue; % The rest goes to the first bin
            else
                firstIndex = indices(1);% firstIndex is equal to the first bin that is bigger than the gradient direction
                previousIndex = firstIndex - 1; % set previous index to the index before firstIndex
                firstValue = (binEdges(firstIndex) - double(x(i, j))) / 20; % Compute the contribution to the first bin
                secondValue = (double(x(i, j)) - binEdges(previousIndex)) / 20; % Compute the contribution to the previous bin
            end
            firstValue = firstValue * double(y(i, j)); % multiply firstValue by the gradient magnitudes
            secondValue = secondValue * double(y(i, j)); % multiply secondValue by the gradient magnitudes
            
            % Update the histogram values
            hist(firstIndex) = hist(firstIndex) + firstValue; % add firstValue to the histogram
            hist(previousIndex) = hist(previousIndex) + secondValue; % add secondValue to the histogram 
        end
    end
end






