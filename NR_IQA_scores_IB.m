% IQA Scores
% Initialize cell arrays to store IQA scores
IQA_scores = cell(6, 100);

for i = 1:length(AudioFilesSet)
    % Read the image from the current image directory
    best_image_read = imread(best_image{i});
    worst_image_read = imread(worst_image{i});

    % Calculate the NR-IQA scores for each image
    best_brisque = brisque(best_image_read);
    worst_brisque = brisque(worst_image_read);

    best_niqe = niqe(best_image_read);
    worst_niqe = niqe(worst_image_read);

    best_piqe = piqe(best_image_read);
    worst_piqe = piqe(worst_image_read);

    % Store NR-IQA scores in the cell array
    IQA_scores{1, i} = best_brisque;
    IQA_scores{2, i} = worst_brisque;

    IQA_scores{3, i} = best_niqe;
    IQA_scores{4, i} = worst_niqe;

    IQA_scores{5, i} = best_piqe;
    IQA_scores{6, i} = worst_piqe;
end

% Save the cell array to a .mat file
save(fullfile('/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Code', 'NR_IQA_scores.mat'), 'IQA_scores');








%%%
good_brisque = cell(1,100);
bad_brisque = cell(1,100);

good_niqe = cell(1,100);
bad_niqe = cell(1,100);

good_piqe = cell(1,100);
bad_piqe = cell(1,100);

for i = 1:length(AudioFilesSet)
    % Read the image form the current image directory
    best_image_read = imread(best_image{i});
    worst_image_read = imread(worst_image{i});


    % Calculate the NR-IQA scores for each image
    best_brisque = brisque(best_image_read);
    worst_brisque = brisque(worst_image_read);

    best_niqe = niqe(best_image_read);
    worst_niqe = niqe(worst_image_read);

    best_piqe = piqe(best_image_read);
    worst_piqe = piqe(worst_image_read);


    % Store NR-IQA scores in a cell array
    good_brisque{j} = best_brisque;
    bad_brisque{j} = worst_brisque;

    good_niqe{j} = best_niqe;
    bad_niqe{j} = worst_niqe;

    good_piqe{j} = best_piqe;
    bad_piqe{j} = worst_piqe;
end

IQA_scores = [good_brisque, bad_brisque, good_niqe, bad_niqe, good_piqe, bad_piqe];

save(fullfile('/Volumes/WallaceLab/dors/wallacelab/DavidTovar/AV_Sets/100set_FINAL/Code', 'NR_IQA_scores.mat'));




