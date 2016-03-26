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

nIter = 20;
error = 1e-12;

pts1_c = [pts1  ones(size(pts1,1),1)];
pts2_c = [pts2  ones(size(pts2,1),1)];

maxInliners = [];

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
       % distance = num./denom';
        distance = num;
        inliners = (distance < error);
        
        if sum(maxInliners) < sum(inliners)
            disp(sum(inliners));
            maxInliners = inliners;
            F = F_temp{j};
        end
    end
end

