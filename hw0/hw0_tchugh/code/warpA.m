function [ warp_im ] = warpA( im, A, out_size )
% warp_im=warpAbilinear(im, A, out_size)
% Warps (w,h,1) image im using affine (3,3) matrix A 
% producing (out_size(1),out_size(2)) output image warp_im
% with warped  = A*input, warped spanning 1..out_size
% Uses nearest neighbor mapping.
% INPUTS:
%   im : input image
%   A : transformation matrix 
%   out_size : size the output image should be
% OUTPUTS:
%   warp_im : result of warping im by A

B = A(1:size(A,1)-1,1:size(A,2)-1);
C = A(1:size(A,1)-1,size(A,2));
C = [C(2); C(1)];
A = [B' C; 0 0 1]

%convert an image to vector of the form [x y 1]
flatimg = reshape(im,[numel(im) 1]);
[x y] = ind2sub(size(im),[1:size(flatimg)]);
req_matrix = [x; y; ones(size(x))];

%Do the transformation
temp = A * req_matrix;
temp = temp(1:2,:);

%remove negative x ,y locations
temp(1,(temp(1,:)<1)) = max(size(im))+1 ;
temp(2,(temp(2,:)<1)) = min(size(im))+1 ; 

%round of the value as pixel locations are only integers
temp = uint16(temp);

%for convert to form [x y value] 

idx = sub2ind([max(temp(1,:)) max(temp(2,:))],temp(1,:),temp(2,:));
newimage = (zeros(max(temp(1,:)) * max(temp(2,:)),1));
newimage(idx) = flatimg;

%Convert to 2D matrix
newimage1 = zeros(size(im,1), size(im,2));
newimage = reshape(newimage, [max(temp(1,:)) max(temp(2,:))]);

%Make sure that the size is correct, if not then pad zeros
m = uint16(size(newimage1)- size(newimage));
newimage = padarray(newimage,double(m));

%copy image of original size
warp_im = newimage(1:size(im,1), 1:size(im,2));
end