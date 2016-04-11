function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%

if nargin < 1
    I = imread('..\data\test1.jpg');
    I = rgb2gray(I);
    I = im2double(I);
end

%Create horizontal and vertical filters
h_filter = [-1, 0, 1];
v_filter = [-1, 0, 1]';

%Convolve the image with the filters
im_hfilter = imfilter(I, h_filter, 'replicate');
im_vfilter = imfilter(I, v_filter, 'replicate');

%Calculate magnitude
mag = sqrt(im_hfilter.*im_hfilter + im_vfilter.*im_vfilter);

%Calculate orientation
ori = atan2d(im_vfilter,im_hfilter);
end

%visualize the image
% imagesc(mag);
% imagesc(ori);

%imshow(im_hfilter);
%imshow(im_vfilter);




