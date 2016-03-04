function M = LucasKanadeAffine(It, It1)

% if nargin < 2
%     %only for testing
%     load(fullfile('..','data','sylvseq.mat'));
%     It = frames(:,:,1);
%     It1 = frames(:,:,2);
% end
threshold = 0.05;
%Initialize P with some initial value
%This needs to be a column vector
p = [0 0 0 0 0 0]';
%This would be computed in the while loop 
%1,1  is only useful for the first iteration
deltap = [1 1 1 1 1 1]';

M = [1 + p(1), p(3), p(5); p(2), 1 + p(4), p(6); 0, 0, 1];

%Convert both Images to double and single channel
It = im2double(It);
if size(It,3)==3
    It= rgb2gray(It);
end

It1 = im2double(It1);
if size(It1,3)==3
    It1= rgb2gray(It1);
end

%%Computer the template with zero warp
%1. Get the rectangle for the given coordinates
[X,Y] = meshgrid(1:size(It,2), 1:size(It,1));
T = It;
[TX, TY] = imgradientxy(T);
steepest_descent = [TX(:).*X(:), TY(:).*X(:), TX(:).*Y(:), TY(:).*Y(:), TX(:), TY(:)];

%%Step 6 Computer the Inverse Hessian matrix 
%2x2 matrix
H = steepest_descent'* steepest_descent;

points =  [X(:) Y(:) ones(length(X(:)),1)]';
points_copy = points;
%imshow(T);

while norm(deltap) > threshold
    %Step 1 Warp Image
    points = M*points_copy;
 
    image_warped = interp2(It1, reshape(points(1,:),size(It1)), reshape(points(2,:),size(It1)));
    image_warped(isnan(image_warped)) = 0;
    
    % Step 2 Compute the error image
    %error = T - image_warped;
    error = image_warped-T;
    error_s = error(:); 
    
    % Step 7 Compute equation 19 (excluding hessian inverse)
    %Reshape to (LxB) x 1 vector, steepest_descent' is 2x(LxB)
    result = steepest_descent' * error_s;
    
  
    
    % Step 8 Compute deltap using equation 19
    %Remember  \ operator used in PCA for machine learning (2nd way)
    deltap = H \ result;
    
    % Step 9 Update warp
    p = p - deltap;
    
    M = [1 + p(1), p(3), p(5); p(2), 1 + p(4), p(6); 0, 0, 1];
    norm(deltap);
end

end

