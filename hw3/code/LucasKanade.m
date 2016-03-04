
function [u, v] = LucasKanade(It, It1, rect)

%Using Inverse Compositional Algorithm 

%%Pre steps
%threshold
threshold = 0.05;

%Initialize P with some initial value
%This needs to be a column vector
p = [0; 0];
%This would be computed in the while loop 
%1,1  is only useful for the first iteration
deltap = [1; 1];

M = [1 0 p(1); 0 1 p(2); 0 0 1];

%Convert both Images to double and single channel
It = im2double(It);
if size(It,3)==3
    It= rgb2gray(It);
end

It1 = im2double(It1);
if size(It1,3)==3
    It1= rgb2gray(It1);
end
%%
%%Computer the template with zero warp
%1. Get the rectangle for the given coordinates
[X,Y] = meshgrid(rect(1):rect(3), rect(2):rect(4));

%2. The default grid points cover the rectangular region, X=1:n and Y=1:m, where [m,n] = size(V)
T = interp2(It,X,Y); 
%imshow(T);
%%Pre-compute
%%Step 3
%Evaluate the gradient del(T) of the Template T(X)
[TX, TY] = imgradientxy(T, 'CentralDifference');
%imshow(Tx);
%imshow(Ty);
%%Step 4 Evaluate the jacobian of W/p at (x;0)
%As there is zero translation so jacobian is 2x2 identity matrix
syms x y p_1 p_2;
syms var_p;
var_p = [p_1 p_2];
W = [x + p_1; y + p_2];
JW = jacobian(W,var_p);
%%Step 5 Compute the steepest descent images (Equation 20)
deltaT= [TX(:) TY(:)];
steepest_descent = deltaT; %Jacobian is identity

%%Step 6 Computer the Inverse Hessian matrix 
%2x2 matrix
H = steepest_descent'* steepest_descent;

points =  [X(:) Y(:) ones(length(X(:)),1)]';

points_copy = points;
%%
%%Iterate
%stop when norm(del(p)) <= mini required error
while norm(deltap) > threshold
    points = M * points_copy;
    %Step 1 Warp Image
  %  [X, Y] = meshgrid((rect1(1,1) : rect1(1,2)), (rect1(2,1) :
  %  rect1(2,2))); % way 1
  %  [X_, Y_] = meshgrid((rect(1) : rect(3)) + p(1), (rect(2) : rect(4)) +
  %  p(2)); % way 2
  %The way I like
    image_warped = interp2(It1, reshape(points(1,:),size(T)), reshape(points(2,:),size(T)));

    % Step 2 Compute the error image
    %If is only for testing
    if size(T)==size(image_warped)
        error =  T - image_warped;
    else
        i =0; %Do nothing
    end
    
    
    % Step 7 Compute equation 19 (excluding hessian inverse)
    %Reshape to (LxB) x 1 vector, steepest_descent' is 2x(LxB)
    error_s = error(:); 
    result = steepest_descent' * error_s;
    
    % Step 8 Compute deltap using equation 19
    %Remember  \ operator used in PCA for machine learning (2nd way)
    deltap = H \ result;
    
    % Step 9 Update warp
    p = p + deltap;
    M = [1 0 p(1); 0 1 p(2); 0 0 1];
end

%% Finally return the value to u and v
u = p(1);
v = p(2);

end
