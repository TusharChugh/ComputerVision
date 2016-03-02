clear all;
close all;
clc;
imfile = load('red.mat');
imred = imfile.red;

imfile = load('blue.mat');
imblue = imfile.blue;

imfile = load('green.mat');
imgreen = imfile.green;

imcombine(:,:,1)= imred;
imcombine(:,:,2)= imgreen;
imcombine(:,:,3) = imblue;

figure;
subplot(1,5,1);
subimage(imred), title('Red');

subplot(1,5,2);
subimage(imgreen), title('Green');

subplot(1,5,3);
subimage(imblue), title('Blue');

subplot(1,5,4);
subimage(imcombine), title('combine');

m = floor(size(imred,1)/2 - size(imred,1)/5);
n = floor(size(imred,1)/2 + size(imred,1)/5);

p = floor(size(imred,2)/2 - size(imred,2)/5);
q = floor(size(imred,2)/2 + size(imred,2)/5);

imred_template = imred(m:n,p:q);

subplot(1,5,5);
subimage(imred_template), title('red_m');

c = normxcorr2(imred_template,imgreen);
figure, surf(c), shading flat;
[maxValue rawindex] = max(c(:));
[g_xindex, g_yindex] = ind2sub(size(c),rawindex);


c = normxcorr2(imred_template,imblue);
%figure, surf(c), shading flat;
[maxValue rawindex] = max(c(:));
[b_xindex, b_yindex] = ind2sub(size(c),rawindex);

imgreen_n = zeros(size(imgreen));
imblue_n = zeros(size(imblue));

shiftx = n - g_xindex ;
shifty = q - g_yindex;
imgreen_n = circshift(imgreen, [shiftx,shifty]);

shiftx = n - b_xindex;
shifty = q - b_yindex;
imblue_n = circshift(imblue, [shiftx,shifty]);

imcombine_n(:,:,1)= imred;
imcombine_n(:,:,2)= imgreen_n;
imcombine_n(:,:,3) = imblue_n;
imshow(imcombine_n);
