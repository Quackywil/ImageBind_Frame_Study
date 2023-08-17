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


% Prepare audio data
cd(script_dir)
[AudioFilesSet, best_image, worst_image, binding_max, binding_min, binding_diff] = load_audio_image_files(ImageFiles, AudioFiles, audio_image_dir, script_dir);

dataMatrix = create_dataMatrix(AudioFilesSet, best_image, worst_image, binding_diff, binding_max, binding_min);


% Read and normalize the audio files
for trialNumber = 1:length(dataMatrix)
    audioFile = dataMatrix{trialNumber, 1};
    [aud, fs] = audioread(audioFile);

    % Calculate the maximum absolute value of the audio data
    maxAmplitude = max(abs(aud));

    % Normalize the audio data by dividing by the maximum absolute value
    normalizedAudioData = aud / maxAmplitude;

    % Play the audio to check if the loudness is appropriate (optional)
    %sound(normalizedAudioData, fs);

    % You can save the normalized audio data as new audio files if needed
    %newFilename = [AudioFiles(trialNumber).folder '/' 'normalized_' AudioFiles(trialNumber).name];
    %audiowrite(newFilename, normalizedAudioData, fs, 'mp3write');
end