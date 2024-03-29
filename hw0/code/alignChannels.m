function [rgbResult] = alignChannels(red, green, blue)
% alignChannels - Given 3 images corresponding to different channels of a 
%       color image, compute the best aligned result with minimum 
%       aberrations
% Args:
%   red, green, blue - each is a matrix with H rows x W columns
%   corresponding to an H x W image
% Returns:
%   rgb_output - H x W x 3 color image output, aligned as desired

%% Write code here
%Add the image and visualize the misalignment
imcombine(:,:,1)= red;
imcombine(:,:,2)= green;
imcombine(:,:,3) = blue;

figure;
subplot(1,5,1);
subimage(red), title('Red');

subplot(1,5,2);
subimage(green), title('Green');

subplot(1,5,3);
subimage(blue), title('Blue');imcombine(:,:,1)= red;
imcombine(:,:,2)= green;
imcombine(:,:,3) = blue;

figure;
subplot(1,5,1);
subimage(red), title('Red');

subplot(1,5,2);
subimage(green), title('Green');

subplot(1,5,3);
subimage(blue), title('Blue');

subplot(1,5,4);
subimage(imcombine), title('combine');

%Capture the subsection from red image around the center
m = floor(size(red,1)/2 - size(red,1)/5);
n = floor(size(red,1)/2 + size(red,1)/5);

p = floor(size(red,2)/2 - size(red,2)/5);
q = floor(size(red,2)/2 + size(red,2)/5);

imred_template = red(m:n,p:q);

subplot(1,5,5);
subimage(imred_template), title('red_m');

%Do template matching with blue and green images
%Using normalized cross correlation
c = normxcorr2(imred_template,green);
figure, surf(c), shading flat;
[maxValue rawindex] = max(c(:));
[g_xindex, g_yindex] = ind2sub(size(c),rawindex);


c = normxcorr2(imred_template,blue);
%figure, surf(c), shading flat;
[maxValue rawindex] = max(c(:));
[b_xindex, b_yindex] = ind2sub(size(c),rawindex);

%Empty array for new images
imgreen_n = zeros(size(green));
imblue_n = zeros(size(blue));

%Calculate the value the images are misalighned by
%and shift the images
shiftx = n - g_xindex ;
shifty = q - g_yindex;
imgreen_n = circshift(grnormxcorr2een, [shiftx,shifty]);

shiftx = n - b_xindex;
shifty = q - b_yindex;
imblue_n = circshift(blue, [shiftx,shifty]);

%combine the images
imcombine_n(:,:,1)= red;
imcombine_n(:,:,2)= imgreen_n;
imcombine_n(:,:,3) = imblue_n;

%visualize the new image
imshow(imcombine_n);

%return the image
rgbResult = imcombine_n;

end