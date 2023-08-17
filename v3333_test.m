%% TEST ITERATED CODE BLOCK
% Will
% Frame Study: How well do participants bind static images with 2-second
% audio sample? Do participants' responses reflect ImageBind embeddings?

clear;
close all;
clc;

KbName('UnifyKeyNames')
KbQueueCreate();

%% Input Participant ID
participantID = input('Participant ID: ', 's');


% Set Standardized Volume
% volume = SoundVolume(.2);    % This function is not working...


% Set the keys you want to detect
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');


% May change this later. May instead just add to a column of dataMatrix.
results = struct('Trial', [], 'Response', [], 'BestImage_Key', []);


%% Directories
% mac_aud_dir = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Audio';
audio_image_dir = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Audio';
script_dir = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Code';
cd(audio_image_dir)

% Image files
filePattern = fullfile(audio_image_dir, '*.mat');
ImageFiles = dir(filePattern);

% Audio files
filePatternAudio = fullfile(audio_image_dir, '*.mp3');
AudioFiles = dir(filePatternAudio);

%% Load Audio and Image Path
cd(script_dir)
[AudioFilesSet, best_image, worst_image, binding_max, binding_min, binding_diff] = load_audio_image_files(ImageFiles, AudioFiles, audio_image_dir, script_dir);

dataMatrix = create_dataMatrix(AudioFilesSet, best_image, worst_image, binding_diff, binding_max, binding_min);

% Select Screen Background Color: Gray
grayLevel = 128;
backgroundColor = [grayLevel grayLevel grayLevel];

% Define the text prompt (this will be constant for every trial).
promptText = 'Which image best represents the audio message?';
textSize = 50;  % Adjust the text size as needed

% Define text properties
textColor = [255 255 255];  % White color
textFont = 'Arial';

AssertOpenGL;

% Select Primary Screen (this will be the screen that displays experiment)
screens= Screen('Screens');
primaryScreen = max(screens);

% Open a Psychtoolbox window
window = PsychImaging('OpenWindow', primaryScreen, backgroundColor);

% Determine the screen size
screenSize = Screen('Rect', window);
screenWidth = screenSize(3);
screenHeight = screenSize(4);

% Calculate the dimensions and positions of the images
imageWidth = floor(screenWidth / 4);  % Adjust the width as needed
imageHeight = floor(screenHeight / 2);  % Adjust the height as needed

spaceBetweenImages = floor(screenWidth / 8);  % Adjust the space as needed

% Calculate the positions for each image
image1Rect = [screenWidth / 2 - spaceBetweenImages - imageWidth, ...
    (screenHeight - imageHeight) / 2, ...
    screenWidth / 2 - spaceBetweenImages, ...
    (screenHeight + imageHeight) / 2];

image2Rect = [screenWidth / 2 + spaceBetweenImages, ...
    (screenHeight - imageHeight) / 2, ...
    screenWidth / 2 + spaceBetweenImages + imageWidth, ...
    (screenHeight + imageHeight) / 2];


% If ERROR, put back into loop after draw texture
% Get the size of the text bounding box
[textBounds, ~] = Screen('TextBounds', window, promptText);
textWidth = textBounds(3) - textBounds(1);
textHeight = textBounds(4) - textBounds(2);

% Calculate the position to center the text above the images
textX = screenWidth / 2 - textWidth / 2;
textY = (screenHeight - imageHeight) / 2 - textHeight - 20;  % Adjust the vertical position as needed

% Open PsychPortAudio audio handle
fs = 48000;
numChannels = 2;
InitializePsychSound(1);  % Initialize PsychPortAudio
pahandle = PsychPortAudio('Open', [], [], 0, fs, numChannels);

% Initialize the variable to count the correct responses
numCorrectResponses = 0;

% Load the two images into MATLAB

for trialNumber = 1:length(dataMatrix)
    
    % Shuffle the indices 1 and 2 to randomize the assignment
    randomIndices = randperm(2);

    % Read in best and worst ImageBind frame
    best_image = imread(dataMatrix{trialNumber, 2});
    worst_image = imread(dataMatrix{trialNumber, 3});

    % Create textures from the images
    best_texture = Screen('MakeTexture', window, best_image);
    worst_texture = Screen('MakeTexture', window, worst_image);

    % Initialize a variable to store the position of the best texture
    bestTexturePosition = 0;

    % Draw the textures on the screen based on the randomized assignment
    if randomIndices(1) == 1
        % Draw best_texture on image1Rect and worst_texture on image2Rect
        Screen('DrawTexture', window, best_texture, [], image1Rect);
        Screen('DrawTexture', window, worst_texture, [], image2Rect);

        % Log that best_texture was drawn on image1Rect (position 1)
        bestTexturePosition = 'Left';

    else
        % Draw best_texture on image2Rect and worst_texture on image1Rect
        Screen('DrawTexture', window, best_texture, [], image2Rect);
        Screen('DrawTexture', window, worst_texture, [], image1Rect);

        % Log that best_texture was drawn on image2Rect (position 2)
        bestTexturePosition = 'Right';
    end

    % Draw the text on the screen
    Screen('TextFont', window, textFont);
    Screen('TextSize', window, textSize);
    DrawFormattedText(window, promptText, textX, textY, textColor);

    % Prepare audio data
    audioFile = dataMatrix{trialNumber, 1};
    [aud, fs] = audioread(audioFile);



    audioData = aud';
    if trialNumber == 1
        numChannels = size(audioData, 1);
        audioLength = size(audioData, 2);
    end

    Screen('Flip', window, 0);  % Update the display

    % Load audio data into the audio buffer
    PsychPortAudio('FillBuffer', pahandle, audioData);

    % Start audio playback and record the start time
    PsychPortAudio('Start', pahandle, 1, 0, 1);

    startTime = GetSecs;
    
    WaitSecs(2); % Wait for audio to completely finish before entering response.
    KbQueueStart(); % Start delivering keyboard presses from the computer to the queue (created in line 10)

    while true
        [pressed, firstPress] = KbQueueCheck(); % Obtains data about keypresses since KbQueueStart
        
        if pressed && (firstPress(leftKey) || firstPress(rightKey)) % Keypress Left or Right Arrow
            break;
        end
    end
    
    % Stop listening for key presses
    KbQueueStop();

    % Process the response and move on to the next trial
    if firstPress(leftKey)
        response = 'Left';
    elseif firstPress(rightKey)
        response = 'Right';
    end

    % Log the result in a struct array 'results'
    results(trialNumber).Trial = trialNumber;
    results(trialNumber).Response = response;
    results(trialNumber).BestImage_Key = bestTexturePosition;

    % Check if the Response matches the BestImage_Key and update the 'CorrectAnswers' field
    if strcmp(results(trialNumber).Response, results(trialNumber).BestImage_Key)
        results(trialNumber).CorrectAnswers = 1; % 1 for correct
    else
        results(trialNumber).CorrectAnswers = 0; % 0 for incorrect
    end


    % Alternatively: Can store in a new column in data matrix
    dataMatrix{trialNumber, 7} = response; % Participant's responses
    dataMatrix{trialNumber, 8} = bestTexturePosition; % Best Image Key

    % Check if the Response matches the BestImage_Key and update the 'CorrectAnswers' field
    if strcmp(dataMatrix{trialNumber, 7}, dataMatrix{trialNumber, 8}) % 1 = Correct; 0 = Incorrect
        dataMatrix{trialNumber, 9} = 1; % 1 for correct
    else
        dataMatrix{trialNumber, 9} = 0; % 0 for incorrect
    end
    %dataMatrix{trialNumber, 10} = rt;
end

% Stop audio playback and close the audio handle
PsychPortAudio('Stop', pahandle);
PsychPortAudio('Close', pahandle);

% Close the Psychtoolbox window
sca;

% Extract the 'CorrectAnswers' field into a separate array
%correctAnswersArray = [results.CorrectAnswers];

% Calculate the total number of correct responses (number of ones)
% numCorrectResponses = sum(correctAnswersArray);
numCorrectResponses = sum(dataMatrix{CorrectAnswers});
disp(['Total correct responses: ', num2str(numCorrectResponses)]);

% Create the variable name by concatenating the participant ID with '_results'
variableName = strcat(participantID, '_results');

% Save the 'results' variable with the desired variable name
eval([variableName, ' = results;']);

% Save the results variable to a .mat file
filename = strcat(participantID, '_results.mat');
save(filename, variableName); % Do I want the variable to also be T0001_results, etc.?