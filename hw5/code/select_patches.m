function select_patches()

file_path = '../data/test';
no_positives = 5;
no_negatives = 100;
patch_size = 128;
out_size = [patch_size, patch_size];

%load('template_images_pos.mat');
template_images_pos = cell(1,5);
rect = zeros(1, 4, no_positives);

for i = 1:no_positives
    I = imread(strcat(file_path, int2str(i - 1), '.jpg'));
    im_train = im2double(rgb2gray(I));
    h = figure;
    imshow(im_train);
    rect(:,:,i) = getrect(h);
    im_template = imcrop(im_train,rect(:,:,i));
    imshow(im_template);
    template_images_pos{i} = imresize(im_template, out_size);
end

i = 0;
while i ~= no_negatives
    I = imread(strcat(file_path, int2str(floor(i/20)), '.jpg'));
    im_train = im2double(rgb2gray(I));
    
    numInMat = numel(im_train);
    ind = randperm(numInMat, 1);
    [r, c] = ind2sub( size(im_train), ind);
    left = r - patch_size/2;
    right = r + patch_size/2;
    down = c - patch_size/2;
    up = c + patch_size/2;
    rect_temp = rect(:,:,floor(i/20) + 1);
    rect_x = [rect_temp(1), rect_temp(1)+patch_size, rect_temp(1), rect_temp(1)+patch_size];
    rect_y = [rect_temp(2), rect_temp(2)+patch_size, rect_temp(2), rect_temp(2)+patch_size];
    if (left <= 0) || right > (size(im_train,1)) ||...
            inpolygon(left,c, rect_x, rect_y ) ||...
            inpolygon(right,c, rect_x, rect_y)
        continue;
    elseif (down <= 0) || up > (size(im_train,2)) ||...
            inpolygon(r,down, rect_x, rect_y) ||...
            inpolygon(r,up, rect_x, rect_y) 
        continue;
    end
    rect_patch = [down, left, patch_size - 1, patch_size - 1];
    im_template = imcrop(im_train,rect_patch);
    
    if (size(im_template) == [128, 128])
        i = i + 1;
        template_images_neg{i} = im_template;
    end
    
end


save('template_images_pos.mat','template_images_pos')
save('template_images_neg.mat','template_images_neg')


end

