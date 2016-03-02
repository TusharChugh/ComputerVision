im = imread('..\data\model_chickenbroth.jpg');

im = im2double(im);
if size(im,3)==3
    im= rgb2gray(im);
end
[locs, desc] = briefLite(im);

% k = sqrt(2);
% sigma0 = 1;
% levels= [-1 0 1 2 3 4];
% th_contrast= 0.03;
% th_r = 12;
% patchWidth = 9;
% nbits = 256;
% 
% [locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r);
% 
% [compareX, compareY] = makeTestPattern(patchWidth, nbits)
% [locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, levels, compareX, compareY)


% GaussianPyramid = createGaussianPyramid(img, sigma0, k, levels);
% [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels);
% [PrincipalCurvature] = computePrincipalCurvature(DoGPyramid);
% [locsDoG] = getLocalExtrema(DoGPyramid, DoGLevels,PrincipalCurvature, th_contrast, th_r);
% size(locsDoG)