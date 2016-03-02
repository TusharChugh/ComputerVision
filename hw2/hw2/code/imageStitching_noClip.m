function [panoImg] = imageStitching_noClip(img1, img2, H2to1)

desired_width = 1280; %given on piazza

img2_c = zeros(4,3);
img2_c(1,:) = [1,1,1];
img2_c(2,:) = [size(img2,2),1,1];
img2_c(3,:) = [1,size(img2,1),1];
img2_c(4,:) = [size(img2,2),size(img2,1),1];

img2_c = img2_c';

img2_cnew =  H2to1 * img2_c ;
img2_cnew = round(bsxfun(@rdivide, img2_cnew(1:2,:),img2_cnew(3,:))');

min_y = min(img2_cnew(:,2));
min_x = min(img2_cnew(:,1));

max_y = max(img2_cnew(:,2));
max_x = max(img2_cnew(:,1));

if(min_y > 0)
    min_y = 0;
end

if(min_x > 0)
    min_x = 0;
end

 out_y = max_x - min_x;
 out_x = max_y - min_y;
 out_size = [out_x out_y];
 
 %aspect_ratio =  (desired_height/out_x);
 
 desired_height = floor((out_x/out_y)*desired_width);
 aspect_ratio =  (desired_height/out_x);
 out_size = [desired_height desired_width];
  
M = [1 0 -min_x;
     0 1 -min_y;
     0 0 1/aspect_ratio];


% hold on
% scatter(img2_c(1,:),img2_c(2,:));
% scatter(img2_cnew(:,1), img2_cnew(:,2))
% hold off;

warp_im1 = warpH(img1, M, out_size);
warp_im2 = warpH(img2, M*H2to1, out_size);


mask1 = zeros(size(img1,1), size(img1,2));
mask1(1,:) = 1; mask1(end,:) = 1; mask1(:,1) = 1; mask1(:,end) = 1;
mask1 = bwdist(mask1, 'city');
mask1 = mask1/max(mask1(:));
mask1 = repmat(mask1,[1 1 3]);
m_img1 = im2double(img1).*mask1;

mask1_warped = warpH(mask1, M, out_size);
m_img1 = im2double(warp_im1).*mask1_warped;
%immask1_warped = warpH(warp_im1, M, size(img1));

% m_img1 = [m_img1 repmat(zeros(size(img1,1), sizey_img1 - size(m_img1,2)),1,1,3)];
% mask1 = [mask1 repmat(zeros(size(mask1,1), sizey_img1 - size(mask1,2)),1,1,3)];

mask2 = zeros(size(img2,1), size(img2,2));
mask2(1,:) = 1; mask2(end,:) = 1; mask2(:,1) = 1; mask2(:,end) = 1;
mask2 = bwdist(mask2, 'city');
mask2 = mask2/max(mask2(:));
mask2 = repmat(mask2,[1 1 3]);
%m_img2 = im2double(warp_im2).*mask2;

mask2_warped = warpH(mask2, M*H2to1, out_size);
m_img2 = im2double(warp_im2).*mask2_warped;
%immask2_warped = warpH(m_img2, M*H2to1, size(img2));

panoImg = imadd(im2double(m_img1), im2double(m_img2)) ./...
         imadd(im2double(mask2_warped), im2double(mask1_warped)); 

%Overlays A and B using alpha blending
%panoImg = imfuse(img1,img2_warped,'blend');
imshow(panoImg);
imwrite(panoImg, '..\results\q6_2.jpg');
end