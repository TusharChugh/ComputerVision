im1 = imread('..\data\model_chickenbroth.jpg');
im2 = im1;

im1 = im2double(im1);
if size(im1,3)==3
    im1= rgb2gray(im1);
end

im2 = im2double(im2);
if size(im2,3)==3
    im2= rgb2gray(im2);
end

degree = 10;

matches_mat = zeros((360/10),1);

[locs1, desc1] = briefLite(im1);

for angle = 1:(360/degree)
    
    im = imrotate(im2,(angle-1)*10);
    [locs2, desc2] = briefLite(im);
    matches = briefMatch(desc1, desc2);
    
    matches_mat(angle*10) = size(matches,1);
end

bar(matches_mat);
    
    