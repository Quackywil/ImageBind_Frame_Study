
image_files = dir('*.mat'); % get all files and directories

current_directory_name = extractAfter(pwd, [fileparts(pwd) '/']); % get current full directory path and extract everything after the last slash (folder name)

for image_i = 1:numel(image_files)
    old_image_name = image_files(image_i).name; % get ith image file name as a string
    
    % Skip renaming if the image file name contains '.ds'
    if contains(old_image_name, '.DS_Store')
        continue;
    end
    
    % Extract the numeric part from the filename using regular expression
    [~, file_name, file_extension] = fileparts(old_image_name);
    match = regexp(file_name, '^(Stim\d+)', 'match');
    numeric_part_str = match{1};
    numeric_part = str2double(strrep(numeric_part_str, 'Stim', ''));
    
    number_suffix = num2str(numeric_part, '%04.f'); % convert the numeric part to a string with 4 places

    new_image_name = ['Stim' number_suffix file_name(length(numeric_part_str) + 1:end) file_extension]; % concatenate folder name, formatted numeric part, and file extension
    
    movefile(old_image_name, new_image_name); % rename the image file
end





%% Rename Files
image_files = dir('*.mat'); % get all files and directories
image_files = image_files(~[image_files.isdir]); % keep only non-directories (aka only images)

current_directory_name = extractAfter(pwd, [fileparts(pwd) '/']); % get current full directory path and extract everything after the last slash (folder name)

for image_i = 1:numel(image_files)
    old_image_name = image_files(image_i).name; % get ith image file name as a string
    
    % Extract the numeric part from the filename using regular expression
    [~, file_name, file_extension] = fileparts(old_image_name);
    match = regexp(file_name, '^(Stim\d+)', 'match');
    numeric_part_str = match{1};
    numeric_part = str2double(strrep(numeric_part_str, 'Stim', ''));
    
    number_suffix = num2str(numeric_part, '%04.f'); % convert the numeric part to string with 4 places

    new_image_name = ['Stim' number_suffix file_name(length(numeric_part_str) + 1:end) file_extension]; % concatenate folder name, formatted numeric part, and file extension
    
    movefile(old_image_name, new_image_name); % rename the image file
end



%% Rename Audio
mp3_files = dir('*.mp3'); % get all MP3 files in the current directory

for mp3_i = 1:numel(mp3_files)
    old_mp3_name = mp3_files(mp3_i).name; % get the ith MP3 file name as a string
    
    % Extract the numeric part from the filename using regular expression
    [~, file_name, file_extension] = fileparts(old_mp3_name);
    match = regexp(file_name, '^(Stim\d+)', 'match');
    numeric_part_str = match{1};
    numeric_part = str2double(strrep(numeric_part_str, 'Stim', ''));
    
    number_suffix = num2str(numeric_part, '%04.f'); % convert the numeric part to a string with 4 places

    new_mp3_name = ['Stim' number_suffix file_name(length(numeric_part_str) + 1:end) file_extension]; % concatenate the formatted numeric part and file extension
    
    movefile(old_mp3_name, new_mp3_name); % rename the MP3 file
end












%%
% Step 1: Get a list of all variable names in the workspace
allVariables = who;

% Initialize variables to hold numeric parts and variable names
variableNumbers = [];
validVariableNames = {};

% Step 2 and 3: Extract the numeric part and convert to numbers for valid variable names
for i = 1:numel(allVariables)
    numericPart = sscanf(allVariables{i}, 'Stim_%d');
    if ~isempty(numericPart)
        variableNumbers = [variableNumbers; numericPart];
        validVariableNames = [validVariableNames; allVariables{i}];
    end
end

% Step 4: Sort the variable names based on the numeric parts
[sortedNumbers, sortingIndices] = sort(variableNumbers);
sortedVariables = validVariableNames(sortingIndices);

% Step 5: Create a structure to hold the sorted variables (optional)
sortedData = struct();
for i = 1:numel(sortedVariables)
    sortedData.(sprintf('Stim_%d', sortedNumbers(i))) = eval(sortedVariables{i});
end

% Now, 'sortedVariables' will contain the sorted variable names,
% and 'sortedData' (optional) will be a structure with the sorted variables.




%%
% Step 1: Get a list of all variable names in the workspace
allVariables = who;

% Initialize variables to hold numeric parts and variable names
variableNumbers = [];
validVariableNames = {};

% Step 2: Extract the numeric part for valid variable names
for i = 1:numel(allVariables)
    numericPart = regexp(allVariables{i}, 'Stim_(\d+)', 'tokens', 'once');
    if ~isempty(numericPart)
        variableNumbers = [variableNumbers; str2double(numericPart{1})];
        validVariableNames = [validVariableNames; allVariables{i}];
    end
end

% Step 3: Sort the variable names based on the numeric parts
[sortedNumbers, sortingIndices] = sort(variableNumbers);
sortedVariables = validVariableNames(sortingIndices);

% Step 4: Create a structure to hold the sorted variables (optional)
sortedData = struct();
for i = 1:numel(sortedVariables)
    sortedData.(sprintf('Stim_%04d', sortedNumbers(i))) = eval(sortedVariables{i});
end

% Now, 'sortedVariables' will contain the sorted variable names,
% and 'sortedData' (optional) will be a structure with the sorted variables.











%% Reorder variables
% Step 1: Get a list of all variable names in the workspace
allVariables = who;

% Step 2 and 3: Extract the numeric part and convert to numbers
variableNumbers = cellfun(@(name) sscanf(name, 'Stim_%d'), allVariables, 'UniformOutput', false);

% Step 4: Sort the variable names based on the numeric parts
[sortedNumbers, sortingIndices] = sort(variableNumbers);
sortedVariables = allVariables(sortingIndices);

% Step 5: Create a structure to hold the sorted variables (optional)
sortedData = struct();
for i = 1:numel(sortedVariables)
    sortedData.(sprintf('Stim_%d', sortedNumbers(i))) = eval(sortedVariables{i});
end

% Now, 'sortedVariables' will contain the sorted variable names,
% and 'sortedData' (optional) will be a structure with the sorted variables.







%% Rename Variables (Try Again)
Stim0100_Inanimate_Natural = Stim100_Inanimate_Natural;
clear stim100_Inanimate_Natural;



%% Rename Variables
% Create a structure to store your variables
data = struct();

% Example data for variables Stim1, Stim2, and Stim3
data.Stim1 = rand(10, 1);
data.Stim2 = rand(5, 1);
data.Stim3 = rand(8, 1);

% Rename the fields in the structure
stim_names = fieldnames(data);
for i = 1:numel(stim_names)
    old_field_name = stim_names{i};
    match = regexp(old_field_name, '^(Stim\d+)', 'match');
    numeric_part_str = match{1};
    numeric_part = str2double(strrep(numeric_part_str, 'Stim', ''));
    number_suffix = num2str(numeric_part, '%04.f');
    new_field_name = ['Stim' number_suffix '_' old_field_name(length(numeric_part_str) + 1:end)];
    data.(new_field_name) = data.(old_field_name);
    data = rmfield(data, old_field_name);
end


% Example data: Assuming you have 100 1x1 structs with different field names
% Replace this with your actual data for each stimulus
stim_data = cell(100, 1);
for i = 1:100
    stim_data{i}.field1 = rand(1);
    stim_data{i}.field2 = rand(1);
end

% Create a new structure to store the renamed variables
renamed_stim_data = struct();

% Rename the fields in the structure and copy the data
for i = 1:100
    old_stim_name = ['Stim' num2str(i)];
    
    % Extract the numeric part from the field name using regular expression
    match = regexp(old_stim_name, '^(Stim\d+)', 'match');
    numeric_part_str = match{1};
    numeric_part = str2double(strrep(numeric_part_str, 'Stim', ''));
    
    % Format the new field name with zero-padding
    new_stim_name = ['Stim' num2str(numeric_part, '%04.f')];
    
    % Create the new field with the formatted name and copy the data
    renamed_stim_data.(new_stim_name) = stim_data{i};
end
