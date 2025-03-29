DataDir = './Data/';

FeatureFileName1 = sprintf('%sQuerySIFTFeatures.mat',DataDir);
FeatureFileName2 = sprintf('%sTargetSIFTFeatures.mat',DataDir);

load(FeatureFileName1,'FeatureDescriptors');
Img1FeatureDescriptors = FeatureDescriptors;

load(FeatureFileName2,'FeatureDescriptors');
Img2FeatureDescriptors = FeatureDescriptors;

[FeatureDescriptorSize,NumFeatures1] = size(Img1FeatureDescriptors);
[FeatureDescriptorSize,NumFeatures2] = size(Img2FeatureDescriptors);

%%% calculate SSDs
% Initialize a matrix to store the Sum of Squared Differences (SSD) 
% between features
SSDMatrix = zeros(NumFeatures1,NumFeatures2);
% Calculate SDDs between each pair of features from query and target images
for i = 1:NumFeatures1
    for j = 1:NumFeatures2
        % Call the SDD function to compute the Sum of Squared Differences
        SSDMatrix(i, j) = SDD(Img1FeatureDescriptors(:, i), Img2FeatureDescriptors(:,j));
    end
end
    %%% missing lines from here
    %%% .....
    %%% missing lines till here
%%% calculate SSDs

save SIFTSSDMatrix.mat SSDMatrix;


function distance = SDD(a,b)
    distance = sum((a-b).^2);
end
