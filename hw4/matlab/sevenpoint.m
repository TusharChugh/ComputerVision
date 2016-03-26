function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup

%For details read this https://www8.cs.umu.se/kurser/TDBD19/VT05/reconstruct-4.pdf

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
pts1_n = (T * pts1_c')';
pts2_n = (T * pts2_c')';

%Construct stack of [xx' xy' x yx' yy' y x' y' 1]
%Size Nx9
A = zeros(7, 9);
%A is rank 7
for i = 1:7
    A(i,:) = reshape(pts1_n' * pts2_n, [1,9]);
end

%Compute F
% The entries of F are the components of the
%column of V corresponding to the least s.v.
%Lease s.v is the last column
[U D V] = svd(A);

%V is 9x9
%the vectors F1 and F2 are basis vectors for the null-space of A.
%Find 2 vectors that span null space of A, F1 and F2.
F1 = reshape(V(:,end - 1), [3, 3]);
F2 = reshape(V(:,end), [3, 3]);

%Find alpha such that Determinant(alpha*F1 + (1-alpha)*F2) = 0
syms x
eqn = x*F1 + (1 - x)*F2;
alpha = roots(sym2poly (det(eqn)));


%Solution is 3rd order polynomial in alpha with at least one real solution

F = cell(1);
for i = 1:size(alpha,1)
    f = real((alpha(i) * F2 + (1 - alpha(i))*F1))';
    %Redine F
    f = refineF(f, pts1_n(:,1:2), pts2_n(:,1:2));

    %Unnormalize
    f = T' * f * T;
    
    F{i} = f;
end

%Save Variables
pts1 = pts1(:,1:2);
pts2 = pts2(:,1:2);
save('q2_2.mat','F','M' ,'pts1','pts2');

end

