    

%% Thank you message
thankYouMessage = 'Thank you for participating in the experiment! Have a good day!';
thankYouTextSize = 50;  % Adjust the text size as needed
thankYouTextColor = [255 255 255];  % White color

% Get the size of the thank you text bounding box
[thankYouTextBounds, ~] = Screen('TextBounds', window, thankYouMessage);
thankYouTextWidth = thankYouTextBounds(3) - thankYouTextBounds(1);
thankYouTextHeight = thankYouTextBounds(4) - thankYouTextBounds(2);

% Calculate the position to center the thank you message on the screen
thankYouTextX = screenWidth / 2 - thankYouTextWidth / 2;
thankYouTextY = screenHeight / 2 - thankYouTextHeight / 2;

% Draw the thank you message on the screen
Screen('TextFont', window, textFont);
Screen('TextSize', window, thankYouTextSize);
DrawFormattedText(window, thankYouMessage, 'center', 'center', thankYouTextColor);

% Flip the screen to display the thank you message
Screen('Flip', window);

% Wait for 3 seconds
WaitSecs(5);

% Stop audio playback and close the audio handle
PsychPortAudio('Stop', pahandle);
PsychPortAudio('Close', pahandle);

% Close the Psychtoolbox window
sca;

% Extract the 'CorrectAnswers' field into a separate array
%correctAnswersArray = [results.CorrectAnswers];

% Calculate the total number of correct responses (number of ones)
% numCorrectResponses = sum(correctAnswersArray);
%numCorrectResponses = sum(dataMatrix{CorrectAnswers});
%disp(['Total correct responses: ', num2str(dataMatrix(,9))]);

% Save the 'results' variable with the desired variable name
%variableName = dataMatrix;

% Create the variable name by concatenating the participant ID with '_results'
variableName = strcat(participantID, '_results');

% Assign the 'dataMatrix' to the new variable name
eval([variableName, ' = dataMatrix;']);

% Save the results variable to a .mat file
filename = strcat(participantID, '_results.mat');
save_dir = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Code/Participant_Data';
save(fullfile(save_dir, filename), variableName);

