function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q2.6 - Todo:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q2_6.mat
%
%           Explain your methods and optimization in your writeup

if nargin == 0
    load('..\data\some_corresp.mat');
    im1 = imread('..\data\im1.png');
    im2 = imread('..\data\im2.png');
    x1 = size(im1,1)/3;
    y1 = size(im1,2)/3;
    load('q2_1.mat');
end

im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

N = 14;
alpha = 4;
w = gausswin(N, alpha);
w = w*w';
%mesh(w);

%imshow(im1);
patch = im1(ceil(y1) - N/2: ceil(y1) + N/2 -1, ceil(x1) - N/2: ceil(x1) + N/2 -1);

%imshow(patch);

L = F*[x1;y1;1];
normValue = sqrt(L(1)^2 + L(2)^2);
L = L/normValue;
result = w .* double(patch);

%imshow(result,[]);

minD = -1;
for y2t= N:1:size(im1,1)-N
     x2t = -1*(L(2)*y2t + L(3))/L(1);
     if ceil(x2t) - N/2 < 1 || ceil(x2t) + N/2 > size(im1,2)
         continue;
     end
     patch2 = im2(ceil(y2t) - N/2: ceil(y2t) + N/2 -1, ceil(x2t) - N/2: ceil(x2t) + N/2 -1);  
     result2 = w .* double(patch2);
     D_all = sqrt(sum(sum((result-result2).^2))); 
     D_point = sqrt(sum(sum(([x1, y1]-[x2t, y2t]).^2)));
     D = D_all + 0.7*D_point;
     if D < minD || minD == -1
         minD = D;
         x2 = ceil(x2t);
         y2 = ceil(y2t);
     end
end
end

