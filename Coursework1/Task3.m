gaussianFilter = gaussianFiltering([9,9],1);
%h = exp(-(x.^2 + y.^2) / (2 * sigma^2)) / sum(exp(-(x(:).^2 + y(:).^2) / (2 * sigma^2)));



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
    
    % Generate a reference Gaussian filter using MATLAB's fspecial function
    g1 = fspecial('gaussian', N, sigma);
    
    % Create a 3D plot to compare the generated Gaussian filter with the reference
    figure(3)
    
    % Plot the reference Gaussian filter in the first subplot
    subplot(1, 2, 1), surf(g1)
    title('MATLAB Gaussian Filter')
    
    % Plot the generated Gaussian filter in the second subplot
    subplot(1, 2, 2), surf(gaussianFilter)
    title('Generated Gaussian Filter')
    
    % Add a title to the entire figure for clear comparison
    sgtitle('Comparison of Gaussian Filters')
end