function [PrincipalCurvature] = computePrincipalCurvature(DoGPyramid)

PrincipalCurvature =zeros(size(DoGPyramid,1), size(DoGPyramid,2), size(DoGPyramid,3));

for i =1:size(DoGPyramid,3)
    [dx dy] = gradient(DoGPyramid(:,:,i));
    [dxx dyx] = gradient(dx);
    [dxy dyy] = gradient(dy);
    H = [dxx dxy; dyx dyy];
    
    %R = (trace(H).^2)./det(H); H not square so it os not working
    R = ((dxx + dyy).^2)./(dxx.*dyy - dyx.*dxy);
    %Theshold R > theta_r is implements in getLocalExtrema function
    PrincipalCurvature(:,:,i) = R;
end

end