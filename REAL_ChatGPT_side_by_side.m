%%
% 1. Display Images (Good & Bad Images) - Side-by-Side
% 2. Display Audio (Separately)
% 3. Display Audio with Images
% Trial Number

%%
% Load the two images into MATLAB
trial_best_image = imread(best_image{TrialNumber});
trial_worst_image = imread(worst_image{TrialNumber});

% Define the text prompt
promptText = 'Which image best represents the audio message?';
textSize = 50;  % Adjust the text size as needed

% Select Primary Screen
screens= Screen('Screens');
primaryScreen = min(screens);

% Select Background Color Gray
grayLevel = 128;
backgroundColor = [grayLevel grayLevel grayLevel];

% Open a Psychtoolbox window
window = PsychImaging('OpenWindow', primaryScreen, backgroundColor);

% TRIAL LOOP
numTrials = length(theFiles);
for TrialNumber = 1:numTrials

    
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

    % Create textures from the images
    texture1 = Screen('MakeTexture', window, image1);
    texture2 = Screen('MakeTexture', window, image2);

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
    audioFile = %'/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Audio/Stim1_Animate_Human.mp3';
    [aud, fs] = audioread(audioFile);
    audioData = aud';
    numChannels = size(audioData, 1);
    audioLength = size(audioData, 2);

    % Open PsychPortAudio audio handle
    % audio_devices = PsychPortAudio('GetDevices')
    % for i = 1:length(audio_devices)
    %   Write code to pick which audio device you want the audio to play from.
    %   For example, you could determine your preferred audio output device
    %   based on number of output channels, size of sampling rate, or by the 
    %   name of the device (all specified in audio_devices).
    % end
    PsychPortAudio('Close');
    InitializePsychSound(1);  % Initialize PsychPortAudio
    pahandle = PsychPortAudio('Open', [], [], 0, fs, numChannels);

    % Load audio data into the audio buffer
    PsychPortAudio('FillBuffer', pahandle, audioData);

    % Start audio playback and record the start time
    PsychPortAudio('Start', pahandle, 1, 0, 1);
    startTime = GetSecs;

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























%%
% Load the audio file
audioFile = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Audio/Stim1_Animate_Human.mp3';
[aud, fs] = audioread(audioFile);

% Create an audio player object
audioPlayer = audioplayer(aud, fs);

% Start audio playback
play(audioPlayer);

% Wait for the audio to finish playing
while isplaying(audioPlayer)
    KbWait;
end

% Close the audio player
stop(audioPlayer);

% Wait for a key press or a specified duration
KbWait;

% Close the Psychtoolbox window
sca;

%%
% Load the two images into MATLAB
image1 = imread('0001.png');
image2 = imread('0045.png');

screens= Screen('Screens');
primaryScreen = max(screens);

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

spaceBetweenImages = floor(screenWidth / 64);  % Adjust the space as needed
padding = 40;  % Adjust the padding as needed

% Calculate the positions for each image with padding
image1Rect = [screenWidth / 4 - imageWidth - spaceBetweenImages - padding, ...
    (screenHeight - imageHeight) / 2 - padding, ...
    screenWidth / 4 - spaceBetweenImages + padding, ...
    (screenHeight + imageHeight) / 2 + padding];

image2Rect = [screenWidth * 3 / 4 + spaceBetweenImages - padding, ...
    (screenHeight - imageHeight) / 2 - padding, ...
    screenWidth * 3 / 4 + imageWidth + spaceBetweenImages + padding, ...
    (screenHeight + imageHeight) / 2 + padding];

% Create textures from the images
texture1 = Screen('MakeTexture', window, image1);
texture2 = Screen('MakeTexture', window, image2);

% Draw the textures on the screen
Screen('DrawTexture', window, texture1, [], image1Rect);
Screen('DrawTexture', window, texture2, [], image2Rect);

Screen('Flip', window);  % Update the display

% Wait for a key press or a specified duration
KbWait;

% Close the Psychtoolbox window
sca;










%%
% Load the two images into MATLAB
image1 = imread('0001.png');
image2 = imread('0045.png');


screens= Screen('Screens');
primaryScreen = max(screens);

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

spaceBetweenImages = floor(screenWidth / 64);  % Adjust the space as needed

% Calculate the positions for each image
image1Rect = [screenWidth / 4 - imageWidth - spaceBetweenImages, ...
    (screenHeight - imageHeight) / 2, ...
    screenWidth / 4 - spaceBetweenImages, ...
    (screenHeight + imageHeight) / 2];

image2Rect = [screenWidth * 3 / 4 + spaceBetweenImages, ...
    (screenHeight - imageHeight) / 2, ...
    screenWidth * 3 / 4 + imageWidth + spaceBetweenImages, ...
    (screenHeight + imageHeight) / 2];

% Create textures from the images
texture1 = Screen('MakeTexture', window, image1);
texture2 = Screen('MakeTexture', window, image2);

% Draw the textures on the screen
Screen('DrawTexture', window, texture1, [], image1Rect);
Screen('DrawTexture', window, texture2, [], image2Rect);

Screen('Flip', window);  % Update the display

% Wait for a key press or a specified duration
KbWait;

% Close the Psychtoolbox window
sca;













%%














% window = PsychImaging('OpenWindow', 1, backgroundColor);





% Load the two images into MATLAB
image1 = imread('0001.png');
image2 = imread('0045.png');


screens= Screen('Screens');
primaryScreen = max(screens);

grayLevel = 128;
backgroundColor = [grayLevel grayLevel grayLevel];



% Open a Psychtoolbox window
window = PsychImaging('OpenWindow', primaryScreen, backgroundColor);

% Determine the screen size and calculate image positions
screenSize = Screen('Rect', window);
imageWidth = floor(screenSize(3) / 2);
imageHeight = screenSize(4);

% Create textures from the images
texture1 = Screen('MakeTexture', window, image1);
texture2 = Screen('MakeTexture', window, image2);

% Draw the textures on the screen
Screen('DrawTexture', window, texture1, [], [0 0 imageWidth imageHeight]);
Screen('DrawTexture', window, texture2, [], [imageWidth 0 screenSize(3) imageHeight]);

Screen('Flip', window);  % Update the display

% Wait for a key press or a specified duration
KbWait;

% Close the Psychtoolbox window
sca;