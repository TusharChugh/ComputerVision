function im3 = generatePanorama(im1, im2)
nIter = 1000;
tol = 5;

img1 = im2double(im1);
if size(im1,3)==3
    img1= rgb2gray(im1);
end

img2 = im2double(im2);
if size(im2,3)==3
    img2= rgb2gray(im2);
end
% img1= imread('../data/incline_L.png');
% img2= imread('../data/incline_R.png');
[locs1, desc1] = briefLite(img1);
[locs2, desc2] = briefLite(img2);
    
matches = briefMatch(desc1, desc2);
bestH = ransacH(matches, locs1, locs2, nIter, tol)
im3 = imageStitching(im1, im2, bestH);
im3 = imageStitching_noClip(im1, im2, bestH);

end