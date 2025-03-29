function index = FindSingleCorr(A, s)
    % check if any element in A is less than the threshold s
    if any(A < s)
        % If true, sort A in ascending order and get the sorted indices
        [~, sortedA] = sort(A);
        % Check if the first element in the sorted A is significantly
        % smaller than the second (less than 80% of the second element)
        if A(sortedA(1)) < 0.8 * A(sortedA(2))
            % If true, set index to the index of the first element in
            % sortedA
            index = sortedA(1);
        else
            % If not, set index to 0
            index = 0;
        end
    else
        % If no element in A is less than s, set index to 0
        index = 0;
    end
end