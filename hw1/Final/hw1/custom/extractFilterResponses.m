function [filterResponses] = extractFilterResponses(I, filterBank)
% CV Fall 2015 - Provided Code
% Extract the filter responses given the image and filter bank
% Pleae make sure the output format is unchanged. 
% Inputs: 
%   I:                  a 3-channel RGB image with width W and height H 
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W*H x N*3 matrix of filter responses
 

%Convert input Image to Lab
doubleI = double(I);

if ndims(doubleI) < 3
    doubleI = repmat(doubleI,1,1,3);
end
[L,a,b] = RGB2Lab(doubleI(:,:,1), doubleI(:,:,2), doubleI(:,:,3));

pixelCount = size(doubleI,1)*size(doubleI,2);

%filterResponses:    a W*H x N*3 matrix of filter responses
%filterResponses = zeros(pixelCount, length(filterBank)*3);

filterRes = [];

%for each filter and channel, apply the filter, and vectorize

% === fill in your implementation here  ===
for i=1:size(filterBank)
red_filtered = reshape(imfilter(L,filterBank{i}),size(L,1) * size(L,2),1);
green_filtered = reshape(imfilter(a,filterBank{i}),size(a,1) * size(a,2),1);
blue_filtered = reshape(imfilter(b,filterBank{i}),size(b,1) * size(b,2),1);
filterRes = [filterRes red_filtered green_filtered blue_filtered];
end

filterResponses = filterRes;

end
