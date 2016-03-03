function [u, v] = LucasKanadeBasis(It, It1, rect, basis) 
%Carefull b/w basis and bases

%%Pre steps
%threshold
threshold = 0.05;

%Initialize P with some initial value
%This needs to be a column vector
p = [0; 0];
%This would be computed in the while loop 
%1,1  is only useful for the first iteration
deltap = [1; 1];

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
[X,Y] = meshgrid(round(rect(1)):round(rect(3)), round(rect(2)):round(rect(4)));

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
% syms x y p1 p2;
% sym var_p;
% var_p = [p1 p2];
% W = [x + p1; y + p2];
% JW = jacobian(W,var_p);
%%Step 5 Compute the steepest descent images (Equation 20)
rhs = 0;
deltaT =[TX(:) TY(:)];
SDQ = zeros(size(deltaT));
for i=1:size(basis,3)
    A_i = basis(:,:,i);
    Ax_delT = A_i(:).*TX(:);
    sum_Ax_delT = sum(Ax_delT(:));
    SDQ(:,1) =  SDQ(:,1) + sum_Ax_delT* A_i(:);
    
    Ay_delT = A_i(:).*TY(:);
    sum_Ay_delT = sum(Ay_delT(:));
    SDQ(:,2) =  SDQ(:,2) + sum_Ay_delT* A_i(:);
end

steepest_descent = deltaT - SDQ; %Summition

%%Step 6 Computer the Inverse Hessian matrix 
%2x2 matrix
H = steepest_descent'* steepest_descent;
%%
%%Iterate
%stop when norm(del(p)) <= mini required error
while norm(deltap) > threshold
    
    %Step 1 Warp Image
    [X, Y] = meshgrid((round(rect(1)) : round(rect(3))) + p(1), (round(rect(2)) : round(rect(4))) + p(2));
   % [X, Y] = meshgrid((rect(1) : rect(3)) + p(1), (rect(2) : rect(4)) + p(2));
    image_warped = interp2(It1, X, Y);

    % Step 2 Compute the error image
    error = T - image_warped;
    
    % Step 7 Compute equation 19 (excluding hessian inverse)
    %Reshape to (LxB) x 1 vector, steepest_descent' is 2x(LxB)
    error_s = error(:); 
    result = steepest_descent' * error_s;
    
    % Step 8 Compute deltap using equation 19
    %Remember  \ operator used in PCA for machine learning (2nd way)
    deltap = inv(H)*result;
    
    % Step 9 Update warp
    p = p + deltap;
end

%% Finally return the value to u and v
u = p(1);
v = p(2);

end

