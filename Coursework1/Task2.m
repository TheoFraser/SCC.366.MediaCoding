
imgH = imread("cameraman.tif");


[histogramEqualizedImage PDF hist]= histogramEqualization(imgH);

function [histogramEqualizedImage PDF hist] = histogramEqualization (inputImage)
    %input validation
    if size(inputImage,3) == 2 || size(inputImage,3) > 3 || size(inputImage,3) == 0
        error("Image must be RGB or greyscale")
    end
    yCbCr = 0;
    %im2double(inputImage);

    imageForHist = inputImage;

    % If an image has 3 colour channels (RGB) the image is converted to
    % YCbCr then I set the first channel of the YCbCr image to Y the
    % seccond channel to U and the final channel to V. Afterwards set yCbCr
    % to 1 and finally set imageForHist to Y

    if size(inputImage,3)==3
        YUV = rgb2ycbcr(inputImage); %convert the image to YCbCr
        Y = YUV(:,:,1); % Set Y to the first Channel of the YCbCr image
        U = YUV(:,:,2); % Set U to the second Channel of the YCbCr image
        V = YUV(:,:,3); % Set V to the third Channel of the YCbCr image 
        yCbCr = 1; % Set yCbCr to 1
        imageForHist = Y; % Set imageForHist to Y
    end

    % Compute the histogram for imageForHist and store it in hist
    hist = calculateHist(imageForHist);
    %hist = accumarray(imageForHist(:) + 1, 1, [256, 1])';

    % Calculate the probability density function of the image
    % Does this by deviding hist by numel(imageForHist). Firstly 
    % numel(imageForHist) calculates the total number of pixels in
    % imageForHist. Then it devides each element in hist by the total
    % number of pixels in imageForHist.
    PDF = hist / numel(imageForHist);

    % Calculate the cumulative distribution function. I calculated it
    % using cumsum however I have also implemented it using a for loop
    % which I have commented out. My version works by setting CDF to a 
    % matrix of zeros with the size of PDF. Then I enter a for loop which
    % incrementes i from 1 to length(PDF). In the for loop it sets the
    % variable running_sum to running_sum + PDF(i). Then it sets CDF(i) to
    % running_sum.
    CDF = cumsum(PDF);
    %CDF = zeros(size(PDF));
    %running_sum = 0;
    %for i = 1:length(PDF)
    %    running_sum = running_sum + PDF(i);
    %    CDF(i) = running_sum;
    %end


    % Performs histogram equalization. It does this by mapping each pixel
    % value of imageForHist (the greyscale image) to new values based on
    % the CDF. We add 1 to imageForHist to avoid issues with zero values.
    % Then we times by 255 and it is converted to uint8.
    histogramEqualizedImage = uint8(255 * CDF(imageForHist + 1));
    
    % Compute the histogram for histogramEqualizedImage and store it in 
    % histTransformed 
    histTransformed = calculateHist(histogramEqualizedImage);
    %histTransformed = accumarray(histogramEqualizedImage(:) + 1, 1, [256, 1])'; 


    % If yCbCr is 1 then it will concatenate histogramEqualizedImage, U and
    % V along the third dimension and convert it into a uint8 and set that
    % value to YUV. Then it will use ycbcr2rgb to convert YUV to a RGB
    % image and set that value to rgb_image. Then it will set 
    % histogramEqualizedImage to rgb_image.

    if yCbCr == 1 %If yCbCr is equal to 1
        % concatenates histogramEqualizedImage, U, V along the third 
        % dimension and convert it into type uint8
        YUV = uint8(cat(3,histogramEqualizedImage,U,V)); 
        % converts YUV to RGB image by using ycbcr2rgb
        rgb_image = ycbcr2rgb(YUV);
        % makes histogramEqualizedImage equal to rgb_image
        histogramEqualizedImage = rgb_image;
    end

    % Compute the histogram for inputImage and store it in histOriginal
    histOriginal = calculateHist(inputImage);
    %histOriginal = accumarray(inputImage(:) + 1, 1, [256, 1])'

    % This shows the original image, the image that has been equalized, the
    % histogram of the orignal image and Lastly the histogram of the 
    % equalized image.
    figure('NumberTitle', 'off', 'Name', 'Histogram Equalization');
    subplot(2,2,1), imshow(inputImage), title("original Image");
    subplot(2,2,2), imshow(histogramEqualizedImage), title("transformed image");
    subplot(2,2,3);
    % This creates a bar chart with pixel values ranging from 0 to 255 on
    % the x-axis and the corresponding frequency of each pixel value from
    % histOriginal on the y-axis. The bars has a width of 0.5 and the
    % face colour is set to blue.
    bar(0 : 255, histOriginal , 'BarWidth', 0.5, 'FaceColor', 'b'); 
    xlabel('Pixel Value'); 
    ylabel('Frequency');
    title('Histogram of Orignal Image');
    subplot(2,2,4);
    % This does the same as the bar chart above execpt the frequency of
    % each pixel is from histTransformed
    bar(0 : 255, histTransformed , 'BarWidth', 0.5, 'FaceColor', 'b'); 
    xlabel('Pixel Value'); 
    ylabel('Frequency');
    title('Histogram of transformed Image');
end

function hist = calculateHist(imageForHist)
    % This function creates a matrix of zeros with the dimensions of 1 and 
    % 255 and store it in the variable hist. Then it will increment value
    % in a for loop from 1:256. Then it it will use the find function to
    % identify the indices of each pixel of imageForHist which matches
    % value and store it in pixel_indices. Then it uses the length function
    % to calculate the number of occurences of pixel_indices and stores 
    % it in count. Then it stores count at position value in hist.

    hist = zeros(1,256);
    for value = 1:256 % loop through possible values
       %hist(value) = hist(value) + length(find(imageForHist(:)==value));
       %hist(value) = length(find(imageForHist(:)==value));

        % Use the find function to identify indices of each pixel of 
        % imageForHist that matches value.
        pixel_indices = find(imageForHist(:) == value);
        
        % Use the length function to count the number of occurrences of 
        % the pixel_indices.
        count = length(pixel_indices);
        
        % Store the count in position value in hist.
        hist(value) = count;
    end
end





