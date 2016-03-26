%This file loads q2_1.mat and q2_5.mat
%Before running this please make sure that you run eightPoint.M and findM2.m
%as there are some other functions like ransacF which can generate q2_1.mat

clear;
clc;
close all;

load('..\data\intrinsics.mat');
load('..\data\templeCoords.mat');
load('..\data\some_corresp.mat');
load('q2_1.mat');
load('q2_5.mat');

im1 = imread('..\data\im1.png');
im2 = imread('..\data\im2.png');

% M = max(size(im1)); 
% 
% F = eightpoint(pts1, pts2, M);

x2 = zeros(size(x1));
y2 = zeros(size(y1));

for i=1:size(x1,1)
    [x2(i), y2(i)] = epipolarCorrespondence( im1, im2, F, x1(i), y1(i));
end

M1 = [1 0 0 0; 0 1 0 0; 0 0 1 0];
[P, ~] = triangulate(K1*M1, [x1 y1], K2*M2,[x2 y2]);

scatter3(P(:,1),P(:,2),P(:,3),'filled');
save('q2_7.mat', 'F', 'M1', 'M2');
