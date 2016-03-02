function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
min_count = size(matches,1);

for i = 1:nIter
    indexes = randperm(length(matches),4);
    
    p1 = locs1(matches(indexes,1),1:2)';
    p2 = locs2(matches(indexes,2),1:2)';
    H2to1 = computeH(p1,p2);
    
    q2 = locs2(matches(:,2),1:2)';
    q2 = [q2; ones(1, size(q2,2))];
    est_q1 = H2to1*q2;
    q1 = locs1(matches(:,1),1:2)';
    est_q1 = bsxfun(@rdivide, est_q1(1:2,:),est_q1(3,:));
    dist = pdist2(q1', est_q1');
    dist = diag(dist);
    
    count = nnz(find(dist>tol));
    if count < min_count
        min_count = count;
        bestH = H2to1;
    end
end
min_count
bestH


end
