
function [u, v] = LucasKanade_TemplateCorrection(T, It1, rect)

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



It1 = im2double(It1);
if size(It1,3)==3
    It1= rgb2gray(It1);
end

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


%%
%%Iterate
%stop when norm(del(p)) <= mini required error
while norm(deltap) > threshold


    [X, Y] = meshgrid((round(rect(1)) : round(rect(3))) + p(1), (round(rect(2)) : round(rect(4))) +  p(2)); % way 2
    image_warped = interp2(It1, X, Y);
    image_warped(isnan(image_warped)) = 0;
    % Step 2 Compute the error image
    %If is only for testing
 
    error =  T - image_warped;

    
    
    % Step 7 Compute equation 19 (excluding hessian inverse)
    %Reshape to (LxB) x 1 vector, steepest_descent' is 2x(LxB)
    error_s = error(:); 
    result = steepest_descent' * error_s;
    
    % Step 8 Compute deltap using equation 19
    %Remember  \ operator used in PCA for machine learning (2nd way)
    deltap = H \ result;
    
    % Step 9 Update warp
    p = p + deltap;
   % M = [1 0 p(1); 0 1 p(2); 0 0 1];
   norm(deltap)
end

%% Finally return the value to u and v
u = p(1);
v = p(2);

end
