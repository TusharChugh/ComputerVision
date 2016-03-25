function [ P, error ] = triangulate( M1, p1, M2, p2 )
% triangulate:
%       M1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       M2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

% Q2.4 - Todo:
%       Implement a triangulation algorithm to compute the 3d locations
%       See Szeliski Chapter 7 for ideas

% Refered to https://classes.soe.ucsc.edu/cmpe264/Fall06/Lec9.pdf
% and http://www.cs.cmu.edu/~16385/lectures/Lecture17.pdf

P = zeros(size(p1,1), 4);

%AP = 0
A = zeros(4,4);

%K1 and K2 not in memory. So it gives error. 
% Need to multiply this in find M2 and get it
%P1 = K1 * M1;
%P2 = K2 * M2;

P1 = M1;
P2 = M2;

for i = 1:size(p1,1)
    A(1,:) = p1(i,2)*P1(3,:)-P1(2,:);
    A(2,:) = P1(1,:)-p1(i,1)*P1(3,:);
    A(3,:) = p2(i,2)*P2(3,:)-P2(2,:); 
    A(4,:) = P2(1,:)-p2(i,1)*P2(3,:);
    
    %Get smallest eigen value
    [U D V] = svd(A);
    
    value = V(:,end)';
    
    P(i,:) = value/value(end);
end

%Calculate error
%Given in the paper

p1Hat = (M1 * P')';
p2Hat = (M2 * P')';

%Distance between p1 and p1Hat
error_part1 = sum((p1 - p1Hat(:,1:2)).^2);
error_part2 = sum((p2 - p2Hat(:,1:2)).^2);

error = sum(error_part1 + error_part2);

P = P(:,1:3);
end

