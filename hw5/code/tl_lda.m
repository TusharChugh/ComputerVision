function template = tl_lda(template_images_pos, template_images_neg, lambda)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
%     template_images_neg - a cell array, each one contains [16 x 16 x 9] matrix
%     lambda - parameter for lda
% output:
%     template - [16 x 16 x 9] matrix 
n_bins = 9;

if nargin < 3
    load('template_images_pos.mat');
    load('template_images_neg.mat');
    lambda = 5;
end

template = zeros(16,16,n_bins);
size_covariance = size(template, 1)* size(template, 2) * size(template, 3);
covariance = zeros(size_covariance, size_covariance);

identity = eye(size_covariance, size_covariance);

average_temp_pos = tl_pos(template_images_pos);

average_temp_neg = zeros(16,16,n_bins);

for i = 1 : size(template_images_neg,2)
    average_temp_neg = average_temp_neg + hog(template_images_neg{i});
end

average_temp_neg = average_temp_neg./size(template_images_neg,2);

for i = 1 : size(template_images_neg,2)
    neg_hog = hog(template_images_neg{i});
    temp = neg_hog(:) - average_temp_neg(:);
    covariance = covariance + temp * temp';
end

covariance = covariance/size(template_images_neg,2);
covariance = covariance + lambda*identity;

temp = (average_temp_pos - average_temp_neg);

template = reshape(inv(covariance)*temp(:), size(temp));    
end