function [panoImg] = imageStitching(img1, img2, H2to1)
[sizex_img1 sizey_img1 z] = size(img1);
sizey_img1 = 1700;
%img1 = [img1 repmat(zeros(size(img1,1), sizey_img1 - size(img1,2)),1,1,3)];
%width of the warped image should be large to accomodate
img2_warped = warpH(img2, H2to1, [sizex_img1, sizey_img1]);

imshow(img2_warped);

mask1 = zeros(size(img1,1), size(img1,2));
mask1(1,:) = 1; mask1(end,:) = 1; mask1(:,1) = 1; mask1(:,end) = 1;
mask1 = bwdist(mask1, 'city');
mask1 = mask1/max(mask1(:));
mask1 = repmat(mask1,[1 1 3]);
m_img1 = im2double(img1).*mask1;

m_img1 = [m_img1 repmat(zeros(size(img1,1), sizey_img1 - size(m_img1,2)),1,1,3)];
mask1 = [mask1 repmat(zeros(size(mask1,1), sizey_img1 - size(mask1,2)),1,1,3)];

mask2 = zeros(size(img2,1), size(img2,2));
mask2(1,:) = 1; mask2(end,:) = 1; mask2(:,1) = 1; mask2(:,end) = 1;
mask2 = bwdist(mask2, 'city');
mask2 = mask2/max(mask2(:));
mask2 = repmat(mask2,[1 1 3]);
m_img2 = im2double(img2).*mask2;

mask2_warped = warpH(mask2, H2to1, [sizex_img1, sizey_img1]);
immask2_warped = warpH(m_img2, H2to1, [sizex_img1, sizey_img1]);

panoImg = imadd(im2double(m_img1),im2double(immask2_warped)) ./...
         imadd(mask1,mask2_warped); 

%Overlays A and B using alpha blending
%panoImg = imfuse(img1,img2_warped,'blend');
imshow(panoImg);
imwrite(img2_warped, '..\results\q5_1.jpg');
save('..\results\q5_1.mat','H2to1');

end