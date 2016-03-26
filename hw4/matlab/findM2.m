% Q2.5 - Todo:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       4. Save the correct M2, p1, p2, R and P to q2_5.mat

clear;
clc;
close all;

load('..\data\intrinsics.mat');
load('..\data\some_corresp.mat');

im1 = imread('..\data\im1.png');
im2 = imread('..\data\im2.png');

M = max(size(im1));
 

p1 = pts1;
p2 = pts2;

F = eightpoint(pts1, pts2, M);
E = essentialMatrix(F, K1, K2);

M1 = [1 0 0 0; 0 1 0 0; 0 0 1 0];
M2s = camera2(E);

P = [];
minError = -1;
for i = 1:size(M2s,3)
    [p, error] = triangulate(K1*M1, pts1, K2*M2s(:,:,i),pts2);
    
    if error < minError || minError == -1
        minError = error;
        M2 = M2s(:,:,i);
        P = p;
    end
end

save('q2_5.mat', 'M2', 'p1', 'p2', 'P');
