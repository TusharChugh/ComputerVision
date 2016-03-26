function [ F ] = ransacF( pts1, pts2, M )
% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.X - Extra Credit:
%     Implement RANSAC
%     Generate a matrix F from some '../data/some_corresp_noisy.mat'
%          - using sevenpoint
%          - using ransac

%     In your writeup, describe your algorith, how you determined which
%     points are inliers, and any other optimizations you made

%Taken reference from Learning Computer Vision with OpenCV book

nIter = 30;
error_thresh = 1e-3;

pts1_c = [pts1  ones(size(pts1,1),1)];
pts2_c = [pts2  ones(size(pts2,1),1)];

max_Count = 0;

for i = 1:nIter
    i
    indexes = randperm(size(pts1,1),7);
    
    p1 = pts1(indexes, :);
    p2 = pts2(indexes, :);
    
    F_temp = sevenpoint(p1, p2, M);
    
    for j = 1:size(F_temp,2)
        %Sampson error
%         for k = 1:size(pts,1))
%         distances = [pts2(j,:)';1]'*F{j}*[pts1(j,:)';1];
%         distances = distances^2 / sum(pts2(j,1:2).^2 + pts1(j,1:2).^2);
%         end
        Fx1 = F_temp{j} * pts1_c';
        Fx2 = F_temp{j} * pts2_c';
        denom = Fx1(1,:).^2 + Fx1(2,:).^2 + Fx2(1,:).^2 + Fx2(2,:).^2;
        num = abs(diag(pts1_c * F_temp{j}' * pts2_c'));
        error = num./denom';
        error = num;
        inliners = (error < error_thresh);
        
        if max_Count < sum(inliners)
            max_Count = sum(inliners);
            disp(max_Count);
            F = F_temp{j};
        end
    end
end
disp(max_Count);
disp(F);
im1 = imread('..\data\im1.png');
im2 = imread('..\data\im2.png');
displayEpipolarF(im1,im2,F);