%%
%
KbName('UnifyKeyNames')


% Select Screen Background Color: Gray
grayLevel = 128;
backgroundColor = [grayLevel grayLevel grayLevel];

% Define the text prompt (this will be constant for every trial.
promptText = 'Which image best represents the audio message?';
textSize = 50;  % Adjust the text size as needed

% Define text properties
textColor = [255 255 255];  % White color
textFont = 'Arial';

% Select Primary Screen (this will be the screen that displays experiment)
screens= Screen('Screens');
primaryScreen = min(screens);

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
InitializePsychSound(1);  % Initialize PsychPortAudio
pahandle = PsychPortAudio('Open', [], [], 0, fs, 1);
%pahandle = PsychPortAudio('Open', [], [], 0, fs, numChannels);


trialStruc = vertcat(AudioFilesSet, best_image, worst_image);
trialStruc = trialStruc';
rng('shuffle')
order = randperm(length(trialStruc));
trialOrder = trialStruc(order, :);


resp = zeros(1, length(trialStruc));
keypress = zeros(1, length(trialStruc));
dataMatrix = cat(2, trialStruc, resp, keypress);



% Load the two images into MATLAB

for trialNumber = 1:length(trialOrder)

    while KbCheck; end
    keycorrect = 0;
    keyisdown = 0;
    responded = 0;
    resp = nan;
    rt = nan;

    best_image = imread(trialOrder(trialNumber, 2));
    worst_image = imread(trialOrder(trialNumber, 3));


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
    audioFile = trialOrder(trialNumber, 1);
    [aud, fs] = audioread(audioFile);
    audioData = aud';
    if trialNumber == 1
        numChannels = size(audioData, 1);
        audioLength = size(audioData, 2);
    end


    % Load audio data into the audio buffer
    PsychPortAudio('FillBuffer', pahandle, audioData);

    % Start audio playback and record the start time
    PsychPortAudio('Start', pahandle, 1, 0, 1);


    Screen('Flip', window);  % Update the display
    startTime = GetSecs;

    WaitSecs(4)

    if ~responded
        [key, secs, keycode] = KbCheck;
        WaitSecs(0.0002)
        if key
            resp = find(keycode, 1, 'last');
            rt = GetSecs - startTime;
            responded = 1;
        else
            warning('No keypress recorded.')
        end
    end
end

%%
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
    % Reading keyboard events until a valid key (69 or 70) was pressed

    right_keypress = [];
    light_keypress = [];

    % Display message 

    if ismember(resp, right_keypress)
        display('You pressed right arrow');
    elseif ismember(resp, left_keypress)
        display('You pressed left arrow');
    else
        display('Remember to respond with left or right arrow keys');
    end
end
% Stop audio playback and close the audio handle
PsychPortAudio('Stop', pahandle);
PsychPortAudio('Close', pahandle);

% Close the Psychtoolbox window
sca;