%%
% 1. Display Images (Good & Bad Images) - Side-by-Side
% 2. Display Audio (Separately)
% 3. Display Audio with Images


%%
% Load the two images into MATLAB


% Load Directory (contains audio + best & worst images)
%folderPath = 'T:\dors\wallacelab\DavidTovar\AV_Sets\100set_FINAL\Audio';
folderPath = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Audio/Stim1_Animate_Human.mp3';
theFiles = dir(fullfile(folderPath, '*.png'));  % Adjust the file extension if needed

image1 = imread('0001.png');
image2 = imread('0045.png');


% Define the text prompt
promptText = 'Which image best represents the audio recording?';
textSize = 50;  % Adjust the text size as needed

% Select Primary Screen
screens= Screen('Screens');
primaryScreen = max(screens);

% Select Background Color Gray
grayLevel = 128;
backgroundColor = [grayLevel grayLevel grayLevel];


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



% Define text properties
textColor = [255 255 255];  % White color
textFont = 'Arial';

% Draw the textures on the screen
Screen('DrawTexture', window, texture1, [], image1Rect);
Screen('DrawTexture', window, texture2, [], image2Rect);


% Get the size of the text bounding box
[textBounds, ~] = Screen('TextBounds', window, promptText);
textWidth = textBounds(3) - textBounds(1);
textHeight = textBounds(4) - textBounds(2);

% Calculate the position to center the text above the images
textX = screenWidth / 2 - textWidth / 2;
textY = (screenHeight - imageHeight) / 2 - textHeight - 20;  % Adjust the vertical position as needed

% Draw the text on the screen
Screen('TextFont', window, textFont);
Screen('TextSize', window, textSize);
DrawFormattedText(window, promptText, textX, textY, textColor);

Screen('Flip', window);  % Update the display



% Prepare audio data
audioFile = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Audio/Stim1_Animate_Human.mp3';
[aud, fs] = audioread(audioFile);
audioData = aud';
numChannels = size(audioData, 1);
audioLength = size(audioData, 2);

% Open PsychPortAudio audio handle
InitializePsychSound(1);  % Initialize PsychPortAudio
pahandle = PsychPortAudio('Open', [], [], 0, fs, numChannels);

% Load audio data into the audio buffer
PsychPortAudio('FillBuffer', pahandle, audioData);

% Start audio playback and record the start time
PsychPortAudio('Start', pahandle, 1, 0, 1);
startTime = GetSecs;

% Iterate through the image files
for k = 1:length(theFiles)
    % Load the best and worst frame images
    bestFrame = imread(fullfile(theFiles(k).folder, best_image{k}));
    worstFrame = imread(fullfile(theFiles(k).folder, worst_image{k}));
    
    % Calculate the positions for each image
    image1Rect = [screenWidth / 2 - spaceBetweenImages - imageWidth, ...
        (screenHeight - imageHeight) / 2, ...
        screenWidth / 2 - spaceBetweenImages, ...
        (screenHeight + imageHeight) / 2];
    
    image2Rect = [screenWidth / 2 + spaceBetweenImages, ...
        (screenHeight - imageHeight) / 2, ...
        screenWidth / 2 + spaceBetweenImages + imageWidth, ...
        (screenHeight + imageHeight) / 2];
    
    % Create textures from the images
    texture1 = Screen('MakeTexture', window, image1);
    texture2 = Screen('MakeTexture', window, image2);
    
    % Display the images and synchronize with audio
    while (GetSecs - startTime) < (audioLength / fs)
        % Draw the textures on the screen
        Screen('DrawTexture', window, texture1, [], image1Rect);
        Screen('DrawTexture', window, texture2, [], image2Rect);
        
        % Draw the text on the screen
        Screen('TextFont', window, textFont);
        Screen('TextSize', window, textSize);
        DrawFormattedText(window, promptText, textX, textY, textColor);
        
        Screen('Flip', window);  % Update the display
        
        % Press Key to Continue
        KbWait;  % Adjust the refresh rate if needed
    end
end
% Stop audio playback and close the audio handle
PsychPortAudio('Stop', pahandle);
PsychPortAudio('Close', pahandle);

% Close the Psychtoolbox window
sca;