
load('Rf.mat', 'Rf');

%%% missing lines from here

% Set a threshold to determine corners
threshold = 0.1 * nanmax(Rf(:));

% Create CornerFlagImage by thresholding Rf
CornerFlagImage = Rf > threshold;

%%% missing lines till here

[PosC, PosR] = find(CornerFlagImage == 1);
imshow(InputImage);
Pos_q = [PosR, PosC];
save KeyPoints.mat Pos_q;
hold on;
plot(PosR,PosC,'r.','Markersize',15);
axis image;
hold off;
