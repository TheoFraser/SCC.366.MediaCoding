
load('SQf.mat', 'SQxxf', 'SQxyf', 'SQyyf');

%%% missing lines from here
k = 0.04;
% Calculate the corner score matrix Rf
Rf = (SQxxf .* SQyyf) - (SQxyf .* SQxyf) - (k .* ((SQxxf + SQyyf).^2));
%%% .....
%%% missing lines till here

save Rf.mat Rf;

imagesc(Rf);
colormap gray;
axis image off;
title('R[f]')
