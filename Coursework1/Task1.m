img = imread("pout.tif");

transformedImage = piecewiseLinearTransform(2,img, [20,50; 20,50]);

function transformedImage = piecewiseLinearTransform(numPoints, inputImage, pointsArray)
    
    % Extract x and y coordinates from the 'pointsArray'.
    x = pointsArray(1,:);
    y = pointsArray(2,:);

    % Convert the input image to double precision for mathematical operations.
    inputImage = double(inputImage);
    
    % Calculate gradients for each segment of the piecewise linear transformation.
    gradient1 = (y(1) - 0) / (x(1) - 0);
    gradient2 = (y(2) - y(1)) / (x(2) - x(1));
    gradient3 = (255 - y(2)) / (255 - x(2));
    
    % Create binary masks for different regions based on x-coordinate values.
    imageValues1 = (inputImage <= x(1)) .* inputImage;
    imageValues2 = ((inputImage > x(1)) & (inputImage <= x(2))) .* inputImage;
    imageValues3 = (inputImage > x(2)) .* inputImage;
    
    % Apply the piecewise linear transformation to each region separately.
    im1 = gradient1 .* imageValues1;
    im2 = y(1) + ((imageValues2 - x(1)) .* gradient2);
    im3 = y(2) + ((imageValues3 - x(2)) .* gradient3);
    
    % Combine the transformed regions to get the final transformed image.
    transformedImage = cast(im1 + im2 + im3, 'uint8');
    
    % Display the original and transformed images side by side.
    figure(1)
    subplot(1,3,1), imshow(uint8(inputImage)), title("Original image");
    subplot(1,3,2), imshow(transformedImage), title("Transformed Image");
end

