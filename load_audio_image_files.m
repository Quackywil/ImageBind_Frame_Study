function [AudioFilesSet, best_image, worst_image, binding_max, binding_min, binding_diff] = load_audio_image_files(theFiles, AudioFiles, audio_image_dir, script_dir)
%% Iterate through files to find best image
cd(audio_image_dir)

%% Iterate through files to find best image
for k = 1:length(theFiles)
    load([theFiles(k).folder '/' theFiles(k).name]);
end

%% Rename variables for appropriate ordering
for j = 1:length(theFiles)

    old_variable_name = ''; % Initialize the old variable name
    
    % Loop through all variables to find the correct one with 'StimX_' pattern
    all_variables = who;
    for k = 1:length(all_variables)
        if startsWith(all_variables{k}, ['Stim' num2str(j) '_'])
            old_variable_name = all_variables{k};
            break;
        end
    end
    
    if isempty(old_variable_name)
        continue; % Move to the next variable_i if the corresponding variable doesn't exist
    end
    
    % Extract the numeric part from the variable name using regular expression
    match = regexp(['Stim' num2str(j)], '^Stim(\d+)', 'tokens');
    numeric_part_str = match{1}{1};
    numeric_part = str2double(numeric_part_str);
    
    number_suffix = num2str(numeric_part, '%04.f'); % Convert the numeric part to a string with 4 places
    
    % Find the first underscore (_) in the variable name
    first_underscore = strfind(old_variable_name, '_');
    
    % Extract the words Y and Z from the variable name
    word_Y = old_variable_name(first_underscore(1) + 1:first_underscore(2) - 1);
    word_Z = old_variable_name(first_underscore(2) + 1:end);
    
    % Create the new variable name with only one underscore after the numbers
    new_variable_name = ['Stim' number_suffix '_' word_Y '_' word_Z];
    
    % Optionally, you can clear the old variable if needed
    eval([new_variable_name ' = ' old_variable_name ';']);
    clear(old_variable_name);
end


%% FINAL TRY AGAIN

for l = 1:length(theFiles)

    best_image{l} = eval([theFiles(l).name(1:end-18) '.max_binding_score_image']);

    % Replace backslashes (\) with forward slashes (/): Windows --> MacOS
    best_image(l) = strrep(best_image(l), '\', '/');
    best_image(l) = strrep(best_image(l), 'T:', '/Volumes');
    best_image(l) = strrep(best_image(l), '/Volumes/dors', '/Volumes/WallaceLab/dors');


    worst_image{l} = eval([theFiles(l).name(1:end-18) '.min_binding_score_image']);

    % Windows --> MacOS
    worst_image(l) = strrep(worst_image(l), '\', '/');
    worst_image(l) = strrep(worst_image(l), 'T:', '/Volumes');
    worst_image(l) = strrep(worst_image(l), '/Volumes/dors', '/Volumes/WallaceLab/dors');

    binding_score{l} = eval([theFiles(l).name(1:end-18) '.binding_scores']);
    binding_max{l} = max(binding_score{l});
    binding_min{l} = min(binding_score{l});
    binding_diff{l} = max(binding_score{l}) - min(binding_score{l});

    clear(theFiles(l).name(1:end-18))
end



% for k = 1:length(theFiles)
%     load([theFiles(k).folder '/' theFiles(k).name]);
%     
%     best_image{k} = eval([theFiles(k).name(1:end-18) '.max_binding_score_image']);
%     
%     % Replace backslashes (\) with forward slashes (/): Windows --> MacOS
%     best_image(k) = strrep(best_image(k), '\', '/');
%     best_image(k) = strrep(best_image(k), 'T:', '/Volumes');
%     best_image(k) = strrep(best_image(k), '/Volumes/dors', '/Volumes/WallaceLab/dors');
%     
%     
%     worst_image{k} = eval([theFiles(k).name(1:end-18) '.min_binding_score_image']);
%     
%     % Windows --> MacOS
%     worst_image(k) = strrep(worst_image(k), '\', '/');
%     worst_image(k) = strrep(worst_image(k), 'T:', '/Volumes');
%     worst_image(k) = strrep(worst_image(k), '/Volumes/dors', '/Volumes/WallaceLab/dors');
%     
%     binding_score{k} = eval([theFiles(k).name(1:end-18) '.binding_scores']);
%     binding_max{k} = max(binding_score{k});
%     binding_min{k} = min(binding_score{k});
%     binding_diff{k} = max(binding_score{k}) - min(binding_score{k});
%     
%     clear(theFiles(k).name(1:end-18))
%     %mac_best_frame = imread(mac_best_image{k});
%     %mac_worst_frame = imread(mac_worst_image{k});
%     
% %     figure
% %     subplot(1,2,1)
% %     imshow(best_frame)
% %     title('Best Frame')
% %     subplot(1,2,2)
% %     imshow(worst_frame)
% %     title('Worst Frame')
% %     sgtitle(['Binding Difference: ' num2str(binding_diff(k))])
% end


%% Audio Code

% Not sure if path or audioread file is more helpful to contain in
for i = 1:length(AudioFiles)
    AudioFilesSet{i} = [AudioFiles(i).folder '/' AudioFiles(i).name]; % Windows
    %AudioFilesSetRead{i} = audioread([AudioFiles(i).folder '/' AudioFiles(i).name]); % Windows Read
    AudioFilesSet{i} = [audio_image_dir '/' AudioFiles(i).name]; % Mac
    %mac_AudioFilesSetRead{i} = audioread([mac_aud_dir(i) '/'
    %AudioFiles(i).name]); % Mac Read
end

cd(script_dir)

end