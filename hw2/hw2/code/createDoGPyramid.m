function [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels)

%DoG is sifferential of gaussian
%Here we subtract two gaussian convultion of images with different values
%of sigma
%Sigma 2 higher is prefered over sigma 1
%Here output is RxCxL (row, column, levels)

for i=1:length(levels) - 1
    DoGPyramid(:,:,i) = GaussianPyramid(:,:,i+1)- GaussianPyramid(:,:,i);
end
DoGLevels = levels(2:length(levels));
end