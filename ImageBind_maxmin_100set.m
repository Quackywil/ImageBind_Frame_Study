%% Set Working Directory
%cd('T:\dors\wallacelab\DavidTovar\AVSets\100set_FINAL\Audio')

% Load ImageBind .mat files (1x1 structs)
filePattern = fullfile(cd, '*.mat');
theFiles = dir(filePattern);

for k = 1:length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    load(fullFileName);
    best_image = Stim1_Animate_Human.max_binding_score_image;
    worst_image = Stim1_Animate_Human.min_binding_score_image;
    best_image2 = Stim100_Inanimate_Natural.min_binding_score_image;
    worst_image2 = Stim100_Inanimate_Natural.min_binding_score_image;
end

%% David code

filePattern = fullfile(cd, '*.mat');
theFiles = dir(filePattern);

for k = 1:length(theFiles)
    load([theFiles(k).folder '/' theFiles(k).name]);
    binding_score = eval([theFiles(k).name(1:end-18) '.binding_scores']);
    best_image{k} = eval([theFiles(k).name(1:end-18) '.max_binding_score_image']);
    worst_image{k} = eval([theFiles(k).name(1:end-18) '.min_binding_score_image']);
    binding_diff(k) = max(binding_score) - min(binding_score);
    
    clear(theFiles(k).name(1:end-18))
    best_frame = imread(best_image{k});
    worst_frame = imread(worst_image{k});
    
    figure
    subplot(1,2,1)
    imshow(best_frame)
    title('Best Frame')
    subplot(1,2,2)
    imshow(worst_frame)
    title('Worst Frame')
    sgtitle(['Binding Difference: ' num2str(binding_diff(k))])
end


%% Audio Code
filePatternAudio = fullfile(, '*.mp3');
theAudioFiles = dir(filePatternAudio);


