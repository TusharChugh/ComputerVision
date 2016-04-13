function template = tl_pos(template_images_pos)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
% output:
%     template - [16 x 16 x 9] matrix

if nargin < 1
    load('template_images_pos.mat');
end

n_bins = 9;
template = zeros(16,16,n_bins);

for i = 1 : size(template_images_pos,2)
    template = template + hog(template_images_pos{i});
end

template = template./size(template_images_pos,2);


end