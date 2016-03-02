function [locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, levels, compareX, compareY)
    patchWidth = 9;
    window = floor(patchWidth/2);
    
    im = im2double(im);
    if size(im,3)==3
        im1= rgb2gray(im);
    end
    
    desc = [];
    locs = [];
    for i=1:length(locsDoG)
        x = locsDoG(i,1);
        y = locsDoG(i,2);
        
        if x -window > 1 && x + window < size(im,1) && y - window > 1 && window + 4 < size(im,2)

            image_patch = imcrop(im1, [(x -window), (y -window), (window*2), (window*2)]);
            image_patch = reshape(image_patch, ([1 patchWidth^2]));
            temp = image_patch(compareX(:)) < image_patch(compareY(:));
            locs = [locs; locsDoG(i,:)];
            desc = [desc; temp];
        end
    end
end
