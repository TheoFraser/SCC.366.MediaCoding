
load('Dxf.mat', 'Dxf');
load('Dyf.mat', 'Dyf');



figure(1);
subplot(1,2,1);
imagesc(Dxf);
colormap gray;
title('Dx f')
axis image off;
subplot(1,2,2);
imagesc(Dyf);
colormap gray;
axis image off;
title('Dy f')

% Calculate the combinations of derivative images Qxxf, Qxyf, and Qyyf
% Qxxf is obtained by element-wise multiplication of the x-derivative image (Dxf) with itself.
Qxxf = Dxf .* Dxf;
% Qxyf is obtained by element-wise multiplication of the x-derivative image (Dxf) with the y-derivative image (Dyf).
Qxyf = Dxf .* Dyf;
% Qyyf is obtained by element-wise multiplication of the y-derivative image (Dyf) with itself.
Qyyf = Dyf .* Dyf;


figure(2);
subplot(1,3,1);
imagesc(Qxxf);
colormap gray;
axis image off;
title('Qxx f')

subplot(1,3,2);
imagesc(Qxyf);
colormap gray;
axis image off;
title('Qxy f')

subplot(1,3,3);
imagesc(Qyyf);
colormap gray;
axis image off;
title('Qyy f')

%%% missing lines from here
% Create a 7x7 Gaussian filter with standard deviation 1 using my own 
% function guassianFiltering.
smooth = gaussianFiltering([7 7], 1);
% This applies the guassian filter smooth to the derivatives images Qxxf, 
% Qxyf and Qyyf using imfilter with the padding option replicate and using 
% convolution
SQxxf = imfilter(Qxxf, smooth, "conv", "replicate");
SQxyf = imfilter(Qxyf, smooth, 'conv', 'replicate');
SQyyf = imfilter(Qyyf, smooth,'conv', 'replicate');
%%% missing lines till here

save SQf.mat SQxxf SQxyf SQyyf;

figure(3);
subplot(1,3,1);
imagesc(SQxxf);
colormap gray;
axis image off;
title('S[Qxx f]')

subplot(1,3,2);
imagesc(SQxyf);
colormap gray;
axis image off;
title('S[Qxy f]')

subplot(1,3,3);
imagesc(SQyyf);
colormap gray;
axis image off;
title('S[Qyy f]')


function gaussianFilter = gaussianFiltering(N, sigma)
    % Input validation
    if(~isscalar(sigma))
        error("Sigma needs to be scalar")
    end 
    if(~isnumeric(N))
        error("N needs to be a number")
    end
    if(length(N) > 2)
        error("N cant have a length greater than 2")
    end 
    if(any(mod(N,1)))
        error("N needs to be a integer")
    end
    if(length(N) > 2)
        error("N cant have a length greater than 2")
    end 
    if(~all(N > 0))
        error("All values in N must be positive")
    end 
    if(sigma <= 0)
        error("sigma must be greater than zero")
    end
    if(any(mod(N, 2) == 0))
        error("All values in N must be not be even")
    end
    if(any(N == 1))
        error("N cant be 1")
    end

    % Generate row and column indices
    % This creates an array called row which has the values from 
    % negative N(1)/2 to N(1)/2 if N(1) is odd both values are rounded 
    % down with the function floor.
    row = -floor(N(1)/2) : floor(N(1)/2);

    % Sets the variable col to row
    col = row;
    
    % If N has a length of 2 then col is set to the values from negative
    % N(2)/1 to N(2)/2 and if N(2) is odd both values are rounded down with
    % the function floor.
    if(length(N) == 2)
        col = -floor(N(2)/2) : floor(N(2)/2);
    end

    % Define the X and Y vectors for meshgrid with col and row.
    [X, Y] = meshgrid(col, row);
    
    % Generate a 2D Gaussian kernel based on meshgrid coordinates and a given sigma
    gaussianKernel = exp(-(X.^2 + Y.^2) / (2 * sigma^2));
    
    % Normalize the Gaussian kernel to ensure the sum of all elements is 1
    gaussianFilter = gaussianKernel / sum(gaussianKernel, 'all');
    
end
