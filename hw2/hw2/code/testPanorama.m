im1= imread('../data/incline_L.png');
im2= imread('../data/incline_R.png');

img1 = im2double(im1);
if size(im1,3)==3
    img1= rgb2gray(im1);
end

img2 = im2double(im2);
if size(im2,3)==3
    img2= rgb2gray(im2);
end

[locs1, desc1] = briefLite(img1);
[locs2, desc2] = briefLite(img2);
matches = briefMatch(desc1, desc2);

save('locsandmatch.mat', 'locs1','locs2','desc1','desc2','matches'); 

p1 = locs1(matches(:,1),1:2)';
p2 = locs2(matches(:,2),1:2)';
H2to1 = computeH(p1,p2);
imageStitching(im1, im2, H2to1)