function template = tl_pos_neg(template_images_pos, template_images_neg)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
%     template_images_neg - a cell array, each one contains [16 x 16 x 9] matrix
% output:
%     template - [16 x 16 x 9] matrix 

if nargin < 2
    load('template_images_pos.mat');
    load('template_images_neg.mat');
end

average_temp_pos = tl_pos(template_images_pos);


n_bins = 9;
average_temp_neg = zeros(16,16,n_bins);

for i = 1 : size(template_images_neg,2)
    average_temp_neg = average_temp_neg + hog(template_images_neg{i});
end


average_temp_neg = average_temp_neg./size(template_images_neg,2);

template = average_temp_pos - average_temp_neg;

end