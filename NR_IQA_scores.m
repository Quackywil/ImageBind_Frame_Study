function [good_brisque, bad_brisque, good_niqe, bad_niqe, good_piqe, bad_piqe, IQA_scores] = NR_IQA_scores(AudioFilesSet, best_image, worst_image)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

good_brisque = cell(1,100);
bad_brisque = cell(1,100);

good_niqe = cell(1,100);
bad_niqe = cell(1,100);

good_piqe = cell(1,100);
bad_piqe = cell(1,100);

for j = 1:length(AudioFilesSet)
    % Read the image form the current image directory
    best_image_read = imread(best_image{j});
    worst_image_read = imread(worst_image{j});


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

IQA_scores = vertcat(good_brisque, bad_brisque, good_niqe, bad_niqe, good_piqe, bad_piqe);

end