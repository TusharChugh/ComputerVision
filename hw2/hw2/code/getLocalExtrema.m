function [locsDoG] = getLocalExtrema(DoGPyramid, DoGLevels,PrincipalCurvature, th_contrast, th_r)

locsDoG =[];
%Number of neighbours in the x-y direction (image)                               
size_space = 2;
%Number of neighbours in z direction (levels)
size_scale = 2;

[img_x img_y levels] = size(DoGPyramid);

% for z = 1:levels
%   reg_max = imregionalmax(DoGPyramid(:,:,z));
%   [i,j] = ind2sub([img_x, img_y], find(reg_max));
%   l = [];
%   l(1:length(i)) = DoGLevels(z);
%   if (abs(DoGPyramid(i,j,z)) > th_contrast)
%     if (abs(PrincipalCurvature(i,j,z)) <= th_r)
%         locsDoG = [locsDoG; j i l'];
%     end
%   end
% end

pyramidnew = zeros(img_x + size_space, img_y + size_space, levels + size_scale);

%Get start x,y locations to copy the image
pyramidnew_startx = floor(size_space/2) + 1;
pyramidnew_starty = floor(size_space/2) + 1 ;
pyramidnew_startz = floor(size_scale/2) + 1 ;

%Get end x,y locations to copy the image
pyramidnew_endx = pyramidnew_startx + img_x - 1;
pyramidnew_endy = pyramidnew_starty + img_y - 1 ;
pyramidnew_endz = pyramidnew_startz + levels - 1 ;

% copy the image
pyramidnew(pyramidnew_startx : pyramidnew_endx, pyramidnew_starty : pyramidnew_endy, pyramidnew_startz : pyramidnew_endz)  = DoGPyramid;

index = floor(size_space/2);
index_z = floor(size_scale/2);

for z = 1:levels
    for j = 1:img_y
        for i = 1:img_x
        space_neighbours = pyramidnew(pyramidnew_startx + i -1 - index : pyramidnew_starty + i -1 + index ,...
            pyramidnew_starty + j -1 - index: pyramidnew_starty + j -1 + index, pyramidnew_startz +z - index_z);
        
        scale_neighbours = [pyramidnew(pyramidnew_startx + i - 1,pyramidnew_starty + j -1,pyramidnew_startz +z -1 - index_z)...
                            pyramidnew(pyramidnew_startx + i - 1,pyramidnew_starty + j -1,pyramidnew_startz +z - index_z)...
                            pyramidnew(pyramidnew_startx + i - 1,pyramidnew_starty + j -1,pyramidnew_startz +z +1 - index_z)];

        max_space = max(nonzeros(space_neighbours(:)));
        max_scale = max(nonzeros(scale_neighbours(:)));
        if size(max_space,1)<1
            max_space = 0;
        end
        
        if size(max_scale,1)<1
            max_scale = 0;
        end
        
        
         if ((DoGPyramid(i,j,z) == max_space) && (DoGPyramid(i,j,z) == max_scale))
             if (abs(DoGPyramid(i,j,z)) > th_contrast)
                  if (abs(PrincipalCurvature(i,j,z)) <= th_r)
                      locsDoG = [locsDoG; j i DoGLevels(z)];
                   end
              end
         end
        end
    end
end

end
