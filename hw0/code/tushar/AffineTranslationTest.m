clear
close all
clc
im = imread('../data/mug.jpg');
% Convert to grayscale
im_gray = rgb2gray(im);

% Create a figure. 

figure(1);
% Subplot splits the display ( doc subplot )
subplot(2,2,1); 
imshow(im_gray);
title('original');
tx = 10;
ty =10;
%A = [1 0 tx; 0 1 ty; 0 0 1];
%A = [cosd(45) sind(45) tx; -sind(45) cosd(45) ty; 0 0 1];
A = [0.692820323027551,0.400000000000000,-16.9615242270663;-0.400000000000000,0.692820323027551,60.7179676972449;0,0,1]
%A = [cosd(45) -sind(45) 0; sind(45) cosd(45) 0; 0 0 1];
%newimage = int8(zeros(size(im_gray)));

flatimg = reshape(im_gray,[numel(im_gray) 1]);
[x y] = ind2sub(size(im_gray),[1:size(flatimg)]);
% x = x - size(im_gray,1)/2;
% y = y - size(im_gray,2)/2;
req_matrix = [x; y; ones(size(x))];

temp = A * req_matrix;
temp = temp(1:2,:);
% temp(1,:) = temp(1,:) + size(im_gray,1)/2;
% temp(2,:) = temp(2,:) + size(im_gray,2)/2;
temp(1,(temp(1,:)<1)) = max(size(im_gray))+1 ;
temp(2,(temp(2,:)<1)) = min(size(im_gray))+1 ;
%temp(temp(1,:)<1) = min(size(im_gray)) ;
%temp = [temp; flatimg'] ; 
temp = uint16(temp);
idx = sub2ind([max(temp(1,:)) max(temp(2,:))],temp(1,:),temp(2,:));
newimage = uint8(zeros(max(temp(1,:)) * max(temp(2,:)),1));
newimage(idx) = flatimg;
newimage = reshape(newimage, [max(temp(1,:)) max(temp(2,:))]);
%values = reshape(temp(3,:),size(im_gray));
%newimage(temp(1,:), temp(2,:)) = values;
% newimage(req_matrix(

% for i=1:size(im_gray,1)
%     for j =1:size(im_gray,2)
%       temp =  [i j 1];[i j 1];
%       sol = temp*A;
%       if (round(sol(1)) > 0 && round(sol(2))>0)
%       newimage(round(sol(1)),round(sol(2))) = im_gray(i,j);
%       end
%     end
% end

subplot(2,2,2); 
imshow(newimage(1:size(im_gray,1), 1:size(im_gray,2)));
title('transformed');