function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup
 
%Get the data in case no arguments are passed
if nargin == 0
    load('..\data\some_corresp.mat');
    im1 = imread('..\data\im1.png');
    im2 = imread('..\data\im2.png');
    M = max(max(size(im1)), max(size(im2)));
end


%Get the tranformation Matrix (Normalizing by max valye of the size of
%image : Size 3x3
T = [1/M 0 0; 0 1/M 0; 0 0 1];

%Append 1 to the last column of points
%Now it becomes Nx3
pts1_c = [pts1  ones(size(pts1,1),1)];
pts2_c = [pts2  ones(size(pts2,1),1)];

%In order to scale/normalize multiple transformation matrix to points
%Result Nx3
pts1_n = pts1_c * T;
pts2_n = pts2_c * T;



%Construct stack of [xx' xy' x yx' yy' y x' y' 1]
%Size Nx9
A = zeros(size(pts1_n,1), 9);

for i = 1:size(pts1_n,1)
    A(i,:) = reshape((pts1_n'*pts2_n), [1,9]);
end

%Compute F
% The entries of F are the components of the
%column of V corresponding to the least s.v.
%Lease s.v is the last column
[U D V] = svd(A);

%V is 9x9
F = reshape(V(:,end), [3, 3])';

%Refine F
F = refineF(F, pts1_n(:,1:2), pts2_n(:,1:2));

%Unnormalize
F = T' * F * T;

%Save Variables
save('q2_1.mat','F','M' ,'pts1','pts2');
end

