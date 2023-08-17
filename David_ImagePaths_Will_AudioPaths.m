%% David: Image Path Code
clear;
clc;


filePattern = fullfile(cd, '*.mat');
theFiles = dir(filePattern);

% aud_dir = 'T:\dors\wallacelab\DavidTovar\AV_Sets\100set_FINAL\Audio';
mac_aud_dir = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Audio';


%% Iterate through files to find best image
for k = 1:length(theFiles)
    load([theFiles(k).folder '/' theFiles(k).name]);
end

%% FINAL TRY
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
    mac_best_frame = imread(best_image{l});
    mac_worst_frame = imread(worst_image{l});

    figure
    subplot(1,2,1)
    imshow(mac_best_frame)
    title(['Best Frame: ' num2str(binding_max{l})])
    subplot(1,2,2)
    imshow(mac_worst_frame)
    title(['Worst Frame: ' num2str(binding_min{l})])
    sgtitle(['Binding Difference: ' num2str(binding_diff{l})])
end


%%
for k = 1:length(theFiles)
    load([theFiles(k).folder '/' theFiles(k).name]);
    
    best_image{k} = eval([theFiles(k).name(1:end-18) '.max_binding_score_image']);
    
    % Replace backslashes (\) with forward slashes (/): Windows --> MacOS
    best_image(k) = strrep(best_image(k), '\', '/');
    best_image(k) = strrep(best_image(k), 'T:', '/Volumes');
    best_image(k) = strrep(best_image(k), '/Volumes/dors', '/Volumes/WallaceLab/dors');
    
    
    worst_image{k} = eval([theFiles(k).name(1:end-18) '.min_binding_score_image']);
    
    % Windows --> MacOS
    worst_image(k) = strrep(worst_image(k), '\', '/');
    worst_image(k) = strrep(worst_image(k), 'T:', '/Volumes');
    worst_image(k) = strrep(worst_image(k), '/Volumes/dors', '/Volumes/WallaceLab/dors');
    
    binding_score{k} = eval([theFiles(k).name(1:end-18) '.binding_scores']);
    binding_max{k} = max(binding_score{k});
    binding_min{k} = min(binding_score{k});
    binding_diff{k} = max(binding_score{k}) - min(binding_score{k});
    
    clear(theFiles(k).name(1:end-18))
    mac_best_frame = imread(mac_best_image{k});
    mac_worst_frame = imread(mac_worst_image{k});

    figure
    subplot(1,2,1)
    imshow(best_frame)
    title('Best Frame')
    subplot(1,2,2)
    imshow(worst_frame)
    title('Worst Frame')
    sgtitle(['Binding Difference: ' num2str(binding_diff(k))])
end













%%
% Initialize a structure to store the renamed variables
renamed_vars = struct();

% Load 100 different variables with names like 'Stim1__Animate_Human', 'Stim2__Animate_Nonhuman', ..., 'Stim100__Inanimate_Natural'
for variable_i = 1:100
    old_variable_name = ''; % Initialize the old variable name
    
    % Loop through all variables to find the correct one with 'StimX__' pattern
    all_variables = who;
    for j = 1:length(all_variables)
        if startsWith(all_variables{j}, ['Stim' num2str(variable_i) '_'])
            old_variable_name = all_variables{j};
            break;
        end
    end
    
    if isempty(old_variable_name)
        continue; % Move to the next variable_i if the corresponding variable doesn't exist
    end
    
    % Extract the numeric part from the variable name using regular expression
    match = regexp(['Stim' num2str(variable_i)], '^Stim(\d+)', 'tokens');
    numeric_part_str = match{1}{1};
    numeric_part = str2double(numeric_part_str);
    
    number_suffix = num2str(numeric_part, '%04.f'); % Convert the numeric part to a string with 4 places
    
    % Find the double underscores (__) in the variable name
    double_underscores = strfind(old_variable_name, '_');
    
    % Extract the words Y and Z from the variable name
    word_Y = old_variable_name(double_underscores(1) + 2:double_underscores(2) - 1);
    word_Z = old_variable_name(double_underscores(2) + 1:end);
    
    % Create the new variable name
    new_variable_name = ['Stim' number_suffix '_' word_Y '_' word_Z];
    
    % Store the renamed variable in the structure
    renamed_vars.(new_variable_name) = eval(old_variable_name);
    
    % Optionally, you can clear the old variable if needed
    clear(old_variable_name);
end





%% TRY AGAIN
for j = 1:length(theFiles)
    load([theFiles(j).folder '/' theFiles(j).name]);

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
    
    % Rename the variable
    eval([new_variable_name ' = ' old_variable_name ';']);
    
    % Optionally, you can clear the old variable if needed
    clear(old_variable_name);
end






for j = 1:length(theFiles)
    load([theFiles(j).folder '/' theFiles(j).name]);

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
    
    % Find the underscores (_) in the variable name
    underscores = strfind(old_variable_name, '_');
    
    % Extract the words Y and Z from the variable name
    word_Y = old_variable_name(underscores(1) + 1:underscores(2) - 1);
    word_Z = old_variable_name(underscores(2) + 1:end);
    
    % Create the new variable name
    new_variable_name = ['Stim' number_suffix '_' word_Y '_' word_Z];
    
    % Rename the variable
    eval([new_variable_name ' = ' old_variable_name ';']);
    
    % Optionally, you can clear the old variable if needed
    clear(old_variable_name);
end












%% Iterate through files to find best image
for j = 1:length(theFiles)
    load([theFiles(j).folder '/' theFiles(j).name]);

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
    
    % Find the underscores (_) in the variable name
    underscores = strfind(old_variable_name, '_');
    
    % Extract the words Y and Z from the variable name
    word_Y = old_variable_name(underscores(1) + 1:underscores(2) - 1);
    word_Z = old_variable_name(underscores(2) + 1:end);
    
    % Create the new variable name
    new_variable_name = ['Stim' number_suffix '_' word_Y '_' word_Z];
    
    % Rename the variable
    eval([new_variable_name ' = ' old_variable_name ';']);
    
    % Optionally, you can clear the old variable if needed
    clear(old_variable_name);


    % Extract best and worst images
    best_image{j} = eval([theFiles(j).name(1:end-18) '.max_binding_score_image']);   % - 18 --> -21

    % Replace backslashes (\) with forward slashes (/): Windows --> MacOS
    best_image(j) = strrep(best_image(j), '\', '/');
    best_image(j) = strrep(best_image(j), 'T:', '/Volumes');
    best_image(j) = strrep(best_image(j), '/Volumes/dors', '/Volumes/WallaceLab/dors');


    worst_image{j} = eval([theFiles(j).name(1:end-18) '.min_binding_score_image']);

    % Windows --> MacOS
    worst_image(j) = strrep(worst_image(j), '\', '/');
    worst_image(j) = strrep(worst_image(j), 'T:', '/Volumes');
    worst_image(j) = strrep(worst_image(j), '/Volumes/dors', '/Volumes/WallaceLab/dors');

    binding_score{j} = eval([theFiles(j).name(1:end-1) '.binding_scores']);
    binding_max{j} = max(binding_score{j});
    binding_min{j} = min(binding_score{j});
    binding_diff{j} = max(binding_score{j}) - min(binding_score{k});

    clear(theFiles(j).name(1:end-18))
end


%% Load 100 different variables with names like 'Stim1_Animate_Human', 'Stim2_Animate_Nonhuman', ..., 'Stim100_Inanimate_Natural'
for variable_i = 1:100
    old_variable_name = ''; % Initialize the old variable name
    
    % Loop through all variables to find the correct one with 'StimX_' pattern
    all_variables = who;
    for j = 1:length(all_variables)
        if startsWith(all_variables{j}, ['Stim' num2str(variable_i) '_'])
            old_variable_name = all_variables{j};
            break;
        end
    end
    
    if isempty(old_variable_name)
        continue; % Move to the next variable_i if the corresponding variable doesn't exist
    end
    
    % Extract the numeric part from the variable name using regular expression
    match = regexp(['Stim' num2str(variable_i)], '^Stim(\d+)', 'tokens');
    numeric_part_str = match{1}{1};
    numeric_part = str2double(numeric_part_str);
    
    number_suffix = num2str(numeric_part, '%04.f'); % Convert the numeric part to a string with 4 places
    
    % Find the underscores (_) in the variable name
    underscores = strfind(old_variable_name, '_');
    
    % Extract the words Y and Z from the variable name
    word_Y = old_variable_name(underscores(1) + 1:underscores(2) - 1);
    word_Z = old_variable_name(underscores(2) + 1:end);
    
    % Create the new variable name
    new_variable_name = ['Stim' number_suffix '_' word_Y '_' word_Z];
    
    % Rename the variable
    eval([new_variable_name ' = ' old_variable_name ';']);
    
    % Optionally, you can clear the old variable if needed
    clear(old_variable_name);

    best_image{j} = eval([theFiles(j).name(1:end-18) '.max_binding_score_image']);   % - 18 --> -21

    % Replace backslashes (\) with forward slashes (/): Windows --> MacOS
    best_image(j) = strrep(best_image(j), '\', '/');
    best_image(j) = strrep(best_image(j), 'T:', '/Volumes');
    best_image(j) = strrep(best_image(j), '/Volumes/dors', '/Volumes/WallaceLab/dors');


    worst_image{j} = eval([theFiles(j).name(1:end-18) '.min_binding_score_image']);

    % Windows --> MacOS
    worst_image(j) = strrep(worst_image(j), '\', '/');
    worst_image(j) = strrep(worst_image(j), 'T:', '/Volumes');
    worst_image(j) = strrep(worst_image(j), '/Volumes/dors', '/Volumes/WallaceLab/dors');

    binding_score{j} = eval([theFiles(j).name(1:end-1) '.binding_scores']);
    binding_max{j} = max(binding_score{j});
    binding_min{j} = min(binding_score{j});
    binding_diff{j} = max(binding_score{j}) - min(binding_score{k});

    clear(theFiles(j).name(1:end-18))
end


%% Iterate through files to find best image
for k = 1:length(theFiles)
    load([theFiles(k).folder '/' theFiles(k).name]);

    best_image{k} = eval([theFiles(k).name(1:end-18) '.max_binding_score_image']);   % - 18 --> -21

    % Replace backslashes (\) with forward slashes (/): Windows --> MacOS
    best_image(k) = strrep(best_image(k), '\', '/');
    best_image(k) = strrep(best_image(k), 'T:', '/Volumes');
    best_image(k) = strrep(best_image(k), '/Volumes/dors', '/Volumes/WallaceLab/dors');


    worst_image{k} = eval([theFiles(k).name(1:end-18) '.min_binding_score_image']);

    % Windows --> MacOS
    worst_image(k) = strrep(worst_image(k), '\', '/');
    worst_image(k) = strrep(worst_image(k), 'T:', '/Volumes');
    worst_image(k) = strrep(worst_image(k), '/Volumes/dors', '/Volumes/WallaceLab/dors');

    binding_score{k} = eval([theFiles(k).name(1:end-1) '.binding_scores']);
    binding_max{k} = max(binding_score{k});
    binding_min{k} = min(binding_score{k});
    binding_diff{k} = max(binding_score{k}) - min(binding_score{k});

    clear(theFiles(k).name(1:end-18))
end

%% Will: Audio Code

mac_aud_dir = '/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Audio';
filePatternAudio = fullfile(cd, '*.mp3');
AudioFiles = dir(filePatternAudio);

% Not sure if path or audioread file is more helpful to contain in
for i = 1:length(AudioFiles)
    AudioFilesSet{i} = [AudioFiles(i).folder '/' AudioFiles(i).name]; % Windows
    %AudioFilesSetRead{i} = audioread([AudioFiles(i).folder '/' AudioFiles(i).name]); % Windows Read
    AudioFilesSet{i} = [mac_aud_dir '/' AudioFiles(i).name]; % Mac
    %mac_AudioFilesSetRead{i} = audioread([mac_aud_dir(i) '/'
    %AudioFiles(i).name]); % Mac Read
end


filePattern = fullfile(cd, '*.mat');
theFiles = dir(filePattern);

% Sort the structure array based on the numeric part of the file names
[~, sortedIndices] = sort(cellfun(@(x) str2double(x(5:8)), {theFiles.name}));

% Iterate through the sorted files to find the best image
for k = sortedIndices
    load(fullfile(theFiles(k).folder, theFiles(k).name));
end


%%
% Initialize a structure to store the renamed variables
renamed_vars = struct();

% Load 100 different variables with names like 'Stim1__Animate_Human', 'Stim2__Animate_Nonhuman', ..., 'Stim100__Inanimate_Natural'
for variable_i = 1:100
    old_variable_name = ''; % Initialize the old variable name
    
    % Loop through all variables to find the correct one with 'StimX__' pattern
    all_variables = who;
    for j = 1:length(all_variables)
        if startsWith(all_variables{j}, ['Stim' num2str(variable_i) '_'])
            old_variable_name = all_variables{j};
            break;
        end
    end
    
    if isempty(old_variable_name)
        continue; % Move to the next variable_i if the corresponding variable doesn't exist
    end
    
    % Extract the numeric part from the variable name using regular expression
    match = regexp(['Stim' num2str(variable_i)], '^Stim(\d+)', 'tokens');
    numeric_part_str = match{1}{1};
    numeric_part = str2double(numeric_part_str);
    
    number_suffix = num2str(numeric_part, '%04.f'); % Convert the numeric part to a string with 4 places
    
    % Find the double underscores (__) in the variable name
    double_underscores = strfind(old_variable_name, '__');
    
    % Extract the words Y and Z from the variable name
    word_Y = old_variable_name(double_underscores(1) + 2:double_underscores(2) - 1);
    word_Z = old_variable_name(double_underscores(2) + 1:end);
    
    % Create the new variable name
    new_variable_name = ['Stim' number_suffix '__' word_Y '_' word_Z];
    
    % Store the renamed variable in the structure
    renamed_vars.(new_variable_name) = eval(old_variable_name);
    
    % Optionally, you can clear the old variable if needed
    clear(old_variable_name);
end

