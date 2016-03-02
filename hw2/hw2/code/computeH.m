function [H2to1] = computeH(p1,p2)

A = zeros(2*size(p1,2), 9);
for i = 1:size(p1,2)
  A = [A; [-p2(1,i)' -p2(2,i)' -ones(size(p2(2,i)')) zeros(size(p2(2,i)')) zeros(size(p2(2,i)')) zeros(size(p2(2,i)')) ...
        p1(1,i)'.*p2(1,i)' p1(1,i)'.*p2(2,i)' p1(1,i)';
        zeros(size(p2(2,i)')) zeros(size(p2(2,i)')) zeros(size(p2(2,i)')) -p2(1,i)' -p2(2,i)' -ones(size(p2(2,i)'))...
        p1(2,i)'.*p2(1,i)' p1(2,i)'.*p2(2,i)' p1(2,i)']];
end 
    [U S V] = svd(A);
     
    H2to1 = reshape(V(:,end), [3,3])';
end