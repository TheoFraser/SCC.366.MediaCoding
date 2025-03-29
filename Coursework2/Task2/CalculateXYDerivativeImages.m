InputImage = imread('Neuschwanstein.png'); % Try to replace 'Neuschwanstein.png' with other images as well

% Sobel operator for edge detection
sobelX = [-1, 0, 1; -2, 0, 2; -1, 0, 1];  % Sobel filter for the x-direction
sobelY = sobelX';  % Transpose of the Sobel filter for the y-direction

% Apply the Sobel filters to the input image to compute the x and y 
% derivatives. I applied the sobel filter using imfilter with the padding 
% option replicate and using convolution.
Dxf = imfilter(double(InputImage), sobelX, "conv", "replicate");
Dyf = imfilter(double(InputImage), sobelY, "conv", "replicate");

% Display the x-derivative image
imagesc(Dxf);
colormap gray;
axis image off;
title('X-Derivative');

% Display the y-derivative image
figure;
imagesc(Dyf);
colormap gray;
axis image off;
title('Y-Derivative');

save Dxf.mat Dxf
save Dyf.mat Dyf