function distance = SDD(a,b)
% calculate squared differences between vectors a and b
    squaredDistance = (a-b).^2;
    % Sum the squared differences to obtain the squared Euclidean distance
    distance = sum(squaredDistance);
end