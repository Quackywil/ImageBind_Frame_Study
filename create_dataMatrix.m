% function [trialOrder] = create_dataMatrix(AudioFilesSet, best_image, worst_image, img_key, binding_max, binding_min, binding_diff, IQA_scores)
% 

% TEST FOR GITHUB

% trialStruc = vertcat(AudioFilesSet, best_image, worst_image, img_key, binding_max, binding_min, binding_diff, IQA_scores);
% trialStruc = trialStruc';
% rng('shuffle')
% order = randperm(length(trialStruc));
% trialOrder = trialStruc(order, :);
% % resp = zeros(length(trialOrder), 1);
% % keypress = zeros(length(trialOrder), 1);
% % dataMatrix = horzcat(trialOrder, resp, keypress);
% 
% end
% 



% function [dataMatrix] = create_dataMatrix(ID_cell, AudioFilesSet, best_image, worst_image, img_key, binding_max, binding_min, binding_diff, IQA_scores)
% 
% trialStruc = vertcat(ID_cell,  AudioFilesSet, best_imag    e, worst_image, img_key, binding_m        ax, binding_min, binding_diff, IQA_scores);
% % Concatenate the matrices horizontally (along columns)
% %trialStruc = horzcat(trialStruc, trialStruc);
% %trialStruc = horzcat(trialStruc_doubled, trialStruc);
% 
% % Transpose the matrix to maintain the same row-wise order
% trialStruc = trialStruc';
% rng('shuffle');
% order = randperm(size(trialStruc, 1));
% dataMatrix = trialStruc     (order, :);
% 
% end


% function [dataMatrix] = create_dataMatrix(ID_cell, AudioFilesSet, best_image, worst_image, img_key, binding_max, binding_min, binding_diff, IQA_scores)
%     % Combine the input matrices into a trial structure
%     trialStruc = vertcat(ID_cell, AudioFilesSet, best_image, worst_image, img_key, binding_max, binding_min, binding_diff, IQA_scores);
%     
%     % Transpose the trial structure to maintain row-wise order
%     trialStruc = trialStruc';
%     
%     rng('shuffle');
%     
%     % Randomly permute the indices for the first set of trials (100 trials)
%     order_set1 = randperm(size(trialStruc, 1));
%     dataMatrix_set1 = trialStruc(order_set1, :);
%     
%     % Randomly permute the indices for the second set of trials (100 trials)
%     order_set2 = randperm(size(trialStruc, 1));
%     dataMatrix_set2 = trialStruc(order_set2, :);
%     
%     % Concatenate the two sets of trials to get the final dataMatrix (200 trials)
%     dataMatrix = vertcat(dataMatrix_set1, dataMatrix_set2);
% end


function [dataMatrix] = create_dataMatrix(ID_cell, AudioFilesSet, best_image, worst_image, img_key, binding_max, binding_min, binding_diff, IQA_scores)
    % Combine the input matrices into a trial structure
    trialStruc = vertcat(ID_cell, AudioFilesSet, best_image, worst_image, img_key, binding_max, binding_min, binding_diff, IQA_scores);
    
    % Transpose the trial structure to maintain row-wise order
    trialStruc = trialStruc';
    
    rng('shuffle');
    
    numIterations = 10;  % Number of iterations
    
    % Initialize an empty matrix to store the final dataMatrix
    dataMatrix = [];
    
    for iteration = 1:numIterations
        % Randomly permute the indices for the trials
        order = randperm(size(trialStruc, 1));
        dataMatrixIteration = trialStruc(order, :);
        
        % Concatenate the current iteration's dataMatrix to the main dataMatrix
        dataMatrix = vertcat(dataMatrix, dataMatrixIteration);
    end
end
