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

% Set the keys you want to detect
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');

results = struct('Trial', [], 'Response', []);


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
[AudioFilesSet, best_image, worst_image] = load_audio_image_files(ImageFiles, AudioFiles, audio_image_dir, script_dir);

dataMatrix = create_dataMatrix(AudioFilesSet, best_image, worst_image);

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


% Load the two images into MATLAB

for trialNumber = 1:length(dataMatrix)

    % Read in best and worst ImageBind frame
    best_image = imread(dataMatrix{trialNumber, 2});
    worst_image = imread(dataMatrix{trialNumber, 3});


    % Create textures from the images
    best_texture = Screen('MakeTexture', window, best_image);
    worst_texture = Screen('MakeTexture', window, worst_image);


    % Draw the textures on the screen
    Screen('DrawTexture', window, best_texture, [], image1Rect);
    Screen('DrawTexture', window, worst_texture, [], image2Rect);

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

    % Log the result
    results(trialNumber).Trial = trialNumber;
    results(trialNumber).Response = response;
end

% Stop audio playback and close the audio handle
PsychPortAudio('Stop', pahandle);
PsychPortAudio('Close', pahandle);

% Close the Psychtoolbox window
sca;

% Save the results to a .mat file
filename = strcat(participantID, '_results.mat');
save(filename, 'results');