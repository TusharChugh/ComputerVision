function mask = SubtractDominantMotion(image1, image2)

% if nargin < 2
%     %only for testing
%     load(fullfile('..','data','aerialseq.mat'));
%     image1 = frames(:,:,1);
%     image2 = frames(:,:,2);
% end

M = LucasKanadeAffine(image1, image2);
warpimg = warpH(image1, M, [size(image2,1) size(image2,2)]);
% figure;
%      subplot(1,4,1);
%     imshow(image1);
%      subplot(1,4,2);
%     imshow(image2);
%      subplot(1,4,3);
%     imshow(warpimg);
% compute difference between images
deltaImg = abs(image2 - warpimg) ;
deltaImg(deltaImg < 20) = 0;

mask = deltaImg;
se = strel('disk',13);
mask = imdilate(mask, se);
se = strel('disk',7);
mask = imerode(mask, se);
mask = double(mask);
mask = mask - bwareaopen(mask, 50);
end
