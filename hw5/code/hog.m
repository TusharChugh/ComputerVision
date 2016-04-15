function ohist = hog(I)
%
% compute orientation histograms over 8x8 blocks of pixels
% orientations are binned into 9 possible bins
%
% I : grayscale image of dimension HxW
% ohist : orinetation histograms for each block. ohist is of dimension (H/8)x(W/8)x9
% TODO

% normalize the histogram so that sum over orientation bins is 1 for each block
%   NOTE: Don't divide by 0! If there are no edges in a block (ie. this counts sums to 0 for the block) then just leave all the values 0. 
% TODO

%just to make testing easier
if nargin < 1
    I = imread('..\data\test8.jpg');
    I = rgb2gray(I);
    I = im2double(I);
end

%Total number of bins
n_bins = 9;
%Number of blocks 8x8
n_blocks = 8;
%Initialize ohist to zeros
out_size = ceil(size(I)./n_blocks);
ohist = zeros(out_size(1), out_size(2), n_bins);


%Inititalize min and max angle for the first bin
min_angle = -180;
max_angle = - 180 + 2*180/n_bins;

%Get magnitude and orientations of gradients
[mag, ori] = mygradient(I);

%Set threshold to 10% of the maximum value
thresh = 0.1 * max(mag(:));

%Find indices bigger than threshold
mag_thresh = mag  > thresh;

for i = 1:n_bins
    
    %Find indices which lie in the bin
    ori_bin = ori >= min_angle & ori <= max_angle;
    
    %Find indices which satisfy both the above criteria's
    thresh_inbin= mag_thresh & ori_bin;
    
    %Collect up pixels in each 8x8 block and put them in colums of
    %thresh_inbin
    spatial_block = im2col(thresh_inbin, [n_blocks n_blocks], 'distinct');
    
    %Sum every column
    spatial_block = sum(spatial_block);    
    
    ohist(:,:,i) = reshape(spatial_block, out_size(1), out_size(2));
    %imagesc( ohist(:,:,i))
    %Update min and max angle for the bin
    min_angle = min_angle + 2*180/n_bins;
    max_angle = max_angle + 2*180/n_bins;
end

%Normalize
ohist = bsxfun(@rdivide, ohist,sum(ohist,3));
k = find(isnan(ohist))';
ohist(k) = 0;

V = hogdraw( ohist );
colormap jet;
imagesc(V);

end



