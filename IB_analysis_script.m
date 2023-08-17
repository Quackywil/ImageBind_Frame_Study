    %% ImageBind Analysis Script (How perceptually relevant are IB's embedding binding to human AV binding?)

clear;
close all;
clc;


% Get directory for participant responses
participant_dir = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Code/Participant_Data';
cd(participant_dir);   

% Get00  a list of all participant files in the directory
files = dir(fullfile(participant_dir, '*.mat'));

% Loop through the files and load each .mat file
for i = 1:length(files)
    load([files(i).name]);
end

%% Create Master Data Matrix
master_dataMatrix = vertcat(T0001_results, T0002_results, T0003_results, T0004_results, T0005_results, T0006_results, T0007_results, T0008_results);


%% Across Participants: How perceptually relevant are IB's embeddings binding to an individual participant's AV binding?
% Extract binding differences and correct responses
binding_differences = cell2mat(master_dataMatrix(:, 6));
correct_responses = cell2mat(master_dataMatrix(:, 17));

% Find unique binding differences
unique_binding_differences = unique(binding_differences);

% Initialize arrays to store x and y values for the scatter plot
x_values = zeros(size(unique_binding_differences));
y_values = zeros(size(unique_binding_differences));

% Calculate average correct responses for each unique binding difference
for i = 1:length(unique_binding_differences)
    binding_diff = unique_binding_differences(i);
    matching_indices = (binding_differences == binding_diff);
    y_values(i) = mean(correct_responses(matching_indices));
    x_values(i) = binding_diff;
end

% Create the scatter plot
figure;
scatter(x_values, y_values);
xlabel('Binding Differences');
ylabel('Average Correct Responses');
title('Scatter Plot: Average Correct Responses vs. Binding Differences');

% Set the directory where you want to save the figure
save_directory = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Code/Participant_Data/Figures';

% Create the full path for the figure file
filename = 'master_bindingdiff_vs_avg_correct.png';
full_path = fullfile(save_directory, filename);

% Save the figure as a PNG file
saveas(gcf, full_path);
disp(['Figure saved as: ' full_path]);


%% W/in Participants: How perceptually relevant are IB's embeddings binding to an individual participant's AV binding?
participant_ID = 'T0001';

% Filter data for the specific participant
participant_data = master_dataMatrix(strcmp(master_dataMatrix(:, 1), participant_ID), :);

% Extract binding differences and correct responses for the specific participant
binding_differences = cell2mat(participant_data(:, 6));
correct_responses = cell2mat(participant_data(:, 17));

% Find unique binding differences for the participant
unique_binding_differences = unique(binding_differences);

% Initialize arrays to store x and y values for the scatter plot
x_values = zeros(size(unique_binding_differences));
y_values = zeros(size(unique_binding_differences));

% Calculate average correct responses for each unique binding difference
for i = 1:length(unique_binding_differences)
    binding_diff = unique_binding_differences(i);
    matching_indices = (binding_differences == binding_diff);
    y_values(i) = mean(correct_responses(matching_indices));
    x_values(i) = binding_diff;
end

% Create the scatter plot
figure;
scatter(x_values, y_values);
xlabel('Binding Differences');
ylabel('Average Correct Responses');
title(['Scatter Plot: Average Correct Responses vs. Binding Differences (Participant ' participant_ID ')']);

% Set the directory where you want to save the figure
save_directory = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Code/Participant_Data/Figures/Individual_Participants';

% Create the full path for the figure file
filename = strcat(participant_ID, '_bindingdiff_vs_avg_correct.png');
full_path = fullfile(save_directory, filename);

% Save the figure as a PNG file
saveas(gcf, full_path);
disp(['Figure saved as: ' full_path]);

% Extract binding differences and convert to numeric
% binding_diffs = participant_ID(:, 6);
% binding_diffs_numeric = cell2mat(binding_diffs);


%% Histogram (How much % time do participants match responses with IB best frame)?
% Initialize arrays to store participant IDs and their corresponding accuracies
participant_ids = unique(master_dataMatrix(:, 1));
participant_accuracies = zeros(size(participant_ids));

% Calculate accuracy for each participant
for i = 1:length(participant_ids)
    participant_id = participant_ids(i);
    participant_responses = master_dataMatrix(strcmp(master_dataMatrix(:, 1), participant_id), 17);
    participant_correct_answers = cell2mat(participant_responses);
    participant_accuracies(i) = sum(participant_correct_answers) / numel(participant_correct_answers) * 100;
end

% Remove NaN accuracies (participants with no responses)
participant_accuracies(isnan(participant_accuracies)) = [];

% Create the histogram
figure;
histogram(participant_accuracies); % By default, MATLAB will determine the number of bins
xlabel('Percentage of Correct Responses');
ylabel('Number of Participants');
title('Percentage of Correct Responses Histogram');
xlim([0, 100]); % Set the x-axis range to 0-100
ylim([0, 10]); % Set the y-axis range to 0-10

% Set the directory where you want to save the figure
save_directory = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Code/Participant_Data/Figures';

% Create the full path for the figure file
filename = 'master_num_participants_vs_percent_correct_histogram.png';
full_path = fullfile(save_directory, filename);

% Save the figure as a PNG file

saveas(gcf, full_path);
disp(['Figure saved as: ' full_path]);


%% Will & David: Inter-Rater Reliability

% Assuming your master_dataMatrix is already loaded

% Extract participant IDs and responses
participantIDs = cell2mat(master_dataMatrix(:, 1));
responses = cell2mat(master_dataMatrix(:, 17));

% Initialize correlation results array
correlationResults = zeros(8,1);

% Loop through each participant for which you want to correlate
for targetParticipant = 1:8
    % Exclude the target participant from the group
    groupIndices = 1:8;
    groupIndices(groupIndices == targetParticipant) = [];
    
    % Calculate the average of the group's responses
    groupAverage = mean(responses(:, groupIndices), 2);
    
    % Get the responses of the target participant
    targetResponses = mean(responses(:, targetParticipant), 2);
    
    % Calculate the correlation between target participant and group average
    correlation = corr(targetResponses, groupAverage);
    
    % Store the correlation result
    correlationResults(targetParticipant) = correlation;
end

% Display or analyze correlation results as needed
disp(correlationResults);











% Assuming your master_dataMatrix is already loaded

% Extract participant IDs and responses
participantIDs = cell2mat(master_dataMatrix(:, 1));
responses = cell2mat(master_dataMatrix(:, 17));

% Initialize correlation results array
correlationResults = zeros(8, 1);

% Loop through each participant for which you want to correlate
for targetParticipant = 1:8
    % Exclude the target participant from the group
    groupIndices = 1:8;
    groupIndices(groupIndices == targetParticipant) = [];
    
    % Calculate the average of the group's responses
    groupAverage = mean(responses(:, groupIndices), 2);
    targetResponses = responses(:, targetParticipant);
    
    % Calculate the correlation between target participant and group average
    correlation = corr(targetResponses, groupAverage);
    
    % Store the correlation result
    correlationResults(targetParticipant) = correlation;
end

% Display or analyze correlation results as needed
disp(correlationResults);
mean(responses(:, groupIndices), 2);
    
    % Get the responses 

% Assuming your master_dataMatrix is already loaded

% Extract participant IDs and responses
participantIDs = cell2mat(master_dataMatrix(:, 1));
responses = cell2mat(master_dataMatrix(:, 17));

% Initialize correlation results array
correlationResults = zeros(8, 1);

% Loop through each participant for which you want to correlate
for t     argetParticipant = 1:8
    % Identify the indices of participants to average (excluding the target)
    groupIndices = 1:8;
    groupIndices(groupIndices == targetParticipant) = [];
    
    % Calculate the average of the group's responses
    groupAverage = mean(responses(:, groupIndices), 2);
    
    % Get the responses of the target participant
    targetResponses = responses(:, targetParticipant);
    
    % Calculate the correlation between target participant and group average
    correlation = corr(targetResponses, groupAverage);
    
    % Store the correlation result
    correlationResults(targetParticipant) = correlation;
end

% Display or analyze correlation results as needed
disp(correlationResults);


% Assuming your master_dataMatrix is already loaded

% Extract participant IDs and responses
participantIDs = cell2mat(master_dataMatrix(:, 1));
responses = cell2mat(master_dataMatrix(:, 17));

% Initialize correlation results array
correlationResults = zeros(8, 1);

% Loop through each participant for which you want to correlate
for targetParticipant = 1:8
    % Exclude the target participant from the group
    groupIndices = 1:8;
    groupIndices(groupIndices == targetParticipant) = [];
    
    % Calculate the average of the group's responses
    groupAverage = mean(responses(:, groupIndices), 2);
    
    % Get the responses of the target participant
    targetResponses = responses(:, targetParticipant);
    
    % Calculate the correlation between target participant and group average
    correlation = corr(targetResponses, groupAverage);
    
    % Store the correlation result
    correlationResults(targetParticipant) = correlation;
end

% Display or analyze correlation results as needed
disp(correlationResults);











%% IQA Analyses     % Do I reverse the order of x-axis and y-axis
% Extract Data
full_brisque_scores = participant_data(:, 9:10);
full_niqe_scores = participant_data(:, 11:12);
full_piqe_scores = participant_data(:, 13:14);

% Convert cell arrays to numeric arrays
full_brisque_scores = cell2mat(full_brisque_scores);
full_niqe_scores = cell2mat(full_niqe_scores);
full_piqe_scores = cell2mat(full_piqe_scores);

% Calculate the correlation coefficients
correlation_matrix = corrcoef([full_brisque_scores', full_niqe_scores', full_piqe_scores']);

% Extract the correlation coefficients
correlation_brisque_niqe = correlation_matrix(1, 2);
correlation_brisque_piqe = correlation_matrix(1, 3);
correlation_niqe_piqe = correlation_matrix(2, 3);

% Display the correlation coefficients
fprintf('Correlation between BRISQUE and NIQE: %.2f\n', correlation_brisque_niqe);
fprintf('Correlation between BRISQUE and PIQE: %.2f\n', correlation_brisque_piqe);
fprintf('Correlation between NIQE and PIQE: %.2f\n', correlation_niqe_piqe);



% Scatter plot for full_brisque_scores vs. full_niqe_scores
subplot(1, 3, 1); % Create a 1x3 subplot grid and select the first subplot
scatter(full_brisque_scores, full_niqe_scores);
xlabel('Full BRISQUE Scores');
ylabel('Full NIQE Scores');
title('Full BRISQUE Scores vs. Full NIQE Scores');

% Save the first scatter plot to a specific directory
saveas(gcf, 'path_to_directory/scatter_brisque_niqe.png'); 


% Scatter plot for full_brisque_scores vs. full_piqe_scores
subplot(1, 3, 2); % Select the second subplot
scatter(full_brisque_scores, full_piqe_scores);
xlabel('Full BRISQUE Scores');
ylabel('Full PIQE Scores');
title('Full BRISQUE Scores vs. Full PIQE Scores');

% Save the second scatter plot to a specific directory
saveas(gcf, 'path_to_directory/scatter_brisque_piqe.png'); % Replace 'path_to_directory' with the desired directory


% Scatter plot for full_niqe_scores vs. full_piqe_scores
subplot(1, 3, 3); % Select the third subplot
scatter(full_niqe_scores, full_piqe_scores);
xlabel('Full NIQE Scores');
ylabel('Full PIQE Scores');
title('Full NIQE Scores vs. Full PIQE Scores');

% Save the third scatter plot to a specific directory
saveas(gcf, 'path_to_directory/scatter_niqe_piqe.png'); % Replace 'path_to_directory' with the desired directory



%% Binding Score vs. IQA
% Max Binding Score vs. Max IQA; Min Binding Score vs. Min IQA

brisque_max = participant_data(:, 9);
brisque_min = participant_data(:, 10);
niqe_max = participant_data(:, 11);
niqe_min = participant_data(:, 12);
piqe_max = participant_data(:, 13);
piqe_min = participant_data(:, 14);
binding_max = participant_data(:, 7);
binding_min = participant_data(:, 8);

% Convert cell arrays to numeric arrays
brisque_max = cell2mat(brisque_max);
brisque_min = cell2mat(brisque_min);
niqe_max = cell2mat(niqe_max);
niqe_min = cell2mat(niqe_min);
piqe_max = cell2mat(piqe_max);
piqe_min = cell2mat(piqe_min);
binding_max = cell2mat(binding_max);
binding_min = cell2mat(binding_min);

% Scatter plot for binding_diff_max vs brisque_max
figure;
scatter(binding_max, brisque_max);
xlabel('Binding Max');
ylabel('BRISQUE Max');
title('Binding Max vs. BRISQUE Max');

% Scatter plot for binding_max vs niqe_max
figure;
scatter(binding_max, niqe_max);
xlabel('Binding Max');
ylabel('NIQE Max');
title('Binding Max vs. NIQE Max');

% Scatter plot for binding_max vs piqe_max
figure;
scatter(binding_max, piqe_max);
xlabel('Binding Max');
ylabel('PIQE Max');
title('Binding Max vs. PIQE Max');

% Scatter plot for binding_min vs brisque_min
figure;
scatter(binding_min, brisque_min);
xlabel('Binding Min');
ylabel('BRISQUE Min');
title('Binding Min vs. BRISQUE Min');

% Scatter plot for binding_min vs niqe_min
figure;
scatter(binding_min, niqe_min);
xlabel('Binding Min');
ylabel('NIQE Min');
title('Binding Min vs. NIQE Min');

% Scatter plot for binding_min vs piqe_min
figure;
scatter(binding_min, piqe_min);
xlabel('Binding Min');
ylabel('PIQE Min');
title('Binding Min vs. PIQE Min');






%% Binding Difference vs. Image Quality Difference






%%   Leave-One-Out Cross-Validation
participant_ids = unique(master_dataMatrix(:, 1));
participant_accuracies = zeros(size(participant_ids));

% Calculate accuracy for each participant
for i = 1:length(participant_ids)
    participant_id = participant_ids(i);
    participant_responses = master_dataMatrix(strcmp(master_dataMatrix(:, 1), participant_id), 17);
    participant_correct_answers = cell2mat(participant_responses);
    participant_accuracies(i) = sum(participant_correct_answers) / numel(participant_correct_answers) * 100;
end
participant_ids = unique(master_dataMatrix(:, 1));
participant_accuracies = zeros(size(participant_ids));

% Calculate accuracy for each participant
for i = 1:length(participant_ids)
    participant_id = participant_ids(i);
    participant_responses = master_dataMatrix(strcmp(master_dataMatrix(:, 1), participant_id), 17);
    participant_correct_answers = cell2mat(participant_responses);
    participant_accuracies(i) = sum(participant_correct_answers) / numel(participant_correct_answers) * 100;
end







%% Unique Participants

% binding_diffs = master_dataMatrix(:, 6);
% binding_diffs_numeric = cell2mat(binding_diffs);
% % Extract answers correct/incorrect for individual participant
% correct_answers_numeric = cell2mat(correct_answers); % Convert to numeric for mean calculation
% accuracy = mean(correct_answers_numeric) * 100; % Calculate the mean and accuracy

% correct_answers = master_dataMatrix(:, 17);
% correct_answers_numeric = cell2mat(correct_answers);
% % B/n Participant Analysis (Combined data matrix)
% participants = {'T0000_results','T0001_results', 'T0002_results', 'T0003_results'};
% 
% % correct_answers = participant_ID(:, 18);     % Repeats...
% % correct_answers_numeric = cell2mat(correct_answers);
% % num_correct_answers = sum(correct_answers_numeric);











% Assuming you have binding_diffs_numeric and correct_answers_numeric as your data

% Create a new figure (optional)
figure;

% Scatter plot
scatter(binding_diffs_numeric, correct_answers_numeric);

% Add labels and title
xlabel('Binding Differences');
ylabel('Correct Answers');
title('Participant Data: Binding Differences vs Correct Answers');

% Optionally, you can adjust the appearance of the plot:
grid on; % Display grid lines.

% Calculate regression coefficients (line of best fit)
coefficients = polyfit(binding_diffs_numeric, correct_answers_numeric, 1);
slope = coefficients(1);
intercept = coefficients(2);

% Calculate predicted values for the regression line
predicted_correct_answers = slope * binding_diffs_numeric + intercept;

% Plot the regression line on top of the scatter plot
hold on;
plot(binding_diffs_numeric, predicted_correct_answers, 'r'); % 'r' for red color (you can choose any color you like)
hold off;

%%
% Assuming you have binding_diffs_numeric and correct_answers_numeric as your data

% Convert correct_answers_numeric to logical (0 = incorrect, 1 = correct)
correct_logical = logical(correct_answers_numeric);

% Perform logistic regression
mdl = fitglm(binding_diffs_numeric, correct_logical, 'Distribution', 'binomial');

% Display the logistic regression results
disp(mdl);

% Get the coefficients and p-values
coefficients = mdl.Coefficients.Estimate;
p_values = mdl.Coefficients.pValue;

% Optionally, you can calculate odds ratios to interpret the effects of the predictor
odds_ratios = exp(coefficients);

% Display coefficients, p-values, and odds ratios
disp('Coefficients:');
disp(coefficients);

disp('P-values:');
disp(p_values);

disp('Odds Ratios:');
disp(odds_ratios);


% Assuming you have binding_diffs_numeric and correct_answers_numeric as your data

% Convert correct_answers_numeric to logical (0 = incorrect, 1 = correct)
correct_logical = logical(correct_answers_numeric);

% Perform logistic regression
mdl = fitglm(binding_diffs_numeric, correct_logical, 'Distribution', 'binomial');

% Get the coefficients from the model
coefficients = mdl.Coefficients.Estimate;

% Calculate the predicted probabilities using the logistic function
binding_diffs_range = linspace(min(binding_diffs_numeric), max(binding_diffs_numeric), 100);
logit = coefficients(1) + coefficients(2) * binding_diffs_range;
predicted_probs = 1 ./ (1 + exp(-logit));

% Create the logistic regression graph
figure;
scatter(binding_diffs_numeric, correct_logical);
hold on;
plot(binding_diffs_range, predicted_probs, 'r', 'LineWidth', 2);
hold off;

% Add labels and title
xlabel('Binding Differences');
ylabel('Probability of Correct Answer');
title('Logistic Regression: Binding Differences vs Probability of Correct Answer');

% Optionally, you can adjust the appearance of the plot:
grid on; % Display grid lines.
legend('Data', 'Logistic Regression', 'Location', 'Best');


%%


% % Create the scatter plot
% figure; % Create a new figure (optional)
% scatter(binding_diffs_numeric, correct_answers_numeric);
% 
% % Add labels and title
% xlabel('Binding Differences');
% ylabel('Correct Answers');
% title('Participant Data: Binding Differences vs Correct Answers');
% 
% % Optionally, you can adjust the appearance of the plot:
% grid on; % Display grid lines








rater_1_ratings = T0000_results{9};
rater_2_ratings = T0001_results{9};

% Should I have each participant's responses make up a new matrix
% 'responseMatrix'? 
% This would guarantee...

% Read in participants data folder
load('T0002.mat')
load('T0003.mat')


% participantID = T0001_results;




binding_diff = T0001_results(:, 5);
correct_ans = T0001_results(:, 10);
   




%% Analysis 2: Histogram (How much % time matching? How much w/in participants matching with stimuli?)
% ppt







%% Analysis 3: How much do participant's responses agree with one another?
% Statistics and ML Toolbox

% Sample data (replace these arrays with your own data)
% correct_answers_numeric;


% Calculate the differences and the mean of ratings
differences = rater1_numeric - rater2_numeric;
mean_ratings = (rater1_numeric + rater2_numeric) / 2;

% Create the Bland-Altman plot
figure;
scatter(mean_ratings, differences, 'filled');
hold on;
hline = refline(0, 0);
hline.Color = 'r';
hold off;

% Add labels and title
xlabel('Mean of Ratings (Rater 1 and Rater 2)');
ylabel('Differences (Rater 1 - Rater 2)');
title('Inter-Rater Reliability (Bland-Altman Plot)');

% Adjust plot appearance
grid on;
box on;
legend('Differences', 'Mean Difference', 'Location', 'Best');

%% Sample data (replace these arrays with your own data)
rater1 = T0000_results(:,9);
rater2 = T0001_results(:,10);

% Convert to numeric for plotting
rater1_numeric = cell2mat(rater1);
rater2_numeric = cell2mat(rater2);

% Create the scatter plot
figure;
scatter(rater1_numeric, rater2_numeric, 'filled');

% Add a diagonal line for reference (perfect agreement)
hold on;
x = min([rater1_numeric, rater2_numeric]):max([rater1_numeric, rater2_numeric]);
plot(x, x, 'r--');
hold off;

% Add labels and title
xlabel('Rater 1 Ratings');
ylabel('Rater 2 Ratings');
title('Inter-Rater Reliability (Scatter Plot)');

% Adjust plot appearance
grid on;
box on;
legend('Data', 'Perfect Agreement', 'Location', 'Best');




%% Sample data (replace these arrays with your own data)
rater1 = T0000_results(:,9);
rater2 = T0001_results(:,10);

% Convert to numeric for plotting
rater1_numeric = cell2mat(rater1);
rater2_numeric = cell2mat(rater2);

% Create the scatter plot
figure;
scatter(rater1_numeric, rater2_numeric, 'filled');

% Add a diagonal line for reference (perfect agreement)
hold on;
x = min([rater1_numeric, rater2_numeric]):max([rater1_numeric, rater2_numeric]);
plot(x, x, 'r--');

% Add a line of best fit (linear regression)
coefficients = polyfit(rater1_numeric, rater2_numeric, 1);
y_fit = polyval(coefficients, x);
plot(x, y_fit, 'b-');
hold off;

% Add labels and title
xlabel('Rater 1 Ratings');
ylabel('Rater 2 Ratings');
title('Inter-Rater Reliability (Scatter Plot)');

% Adjust plot appearance
grid on;
box on;

% Add legend
legend('Data', 'Perfect Agreement', 'Line of Best Fit', 'Location', 'Best');




for i = 1:length(files)
    load([files(i).name]);

    % Analysis 1: Participant vs. Participant of IB matching (X: Binding Diffs; Y: Correct/Not)
    

    % Analysis 2: Histogram (How much % time matching? How much w/in participants matching with stimuli? How much across participants?)


    % Analysis 3: How much do participant's responses agree with one another?

end
