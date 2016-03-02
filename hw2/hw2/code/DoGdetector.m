function [locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r)

GaussianPyramid = createGaussianPyramid(im, sigma0, k, levels);
[DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels);
PrincipalCurvature = computePrincipalCurvature(DoGPyramid);
locsDoG = getLocalExtrema(DoGPyramid, DoGLevels,PrincipalCurvature, th_contrast, th_r);

size_y = size(im,2);
% displayPyramid(DoGPyramid);
% imshow(im);
% hold on;
% plot(locsDoG(:,1),locsDoG(:,2),'g.');
%Plotting the points on all 5 images toghter
%plot(locsDoG(:,1)+locsDoG(:,3)*size_y,locsDoG(:,2),'g.');

end
