function det_res = multiscale_detect(image, template, ndet)
% input:
%     image - test image.
%     template - [16 x 16x 9] matrix.
%     ndet - the number of return values.
% output:
%      det_res - [ndet x 3] matrix
%                column one is the x coordinate
%                column two is the y coordinate
%                column three is the scale, i.e. 1, 0.7 or 0.49 ..

if nargin < 3
    image= im2double(rgb2gray(imread('../data/test1.jpg')));
    template = tl_pos;
    ndet = 1;
end

% final_x = zeros(ndet,1);
% final_y = zeros(ndet,1);
% final_scale = zeros(ndet,1);
% final_score = zeros(ndet,1);
final_x= [];
final_y = [];
final_scale =[];
final_score= [];
det_res = [];

scale = 0.7;
im_copy = image;
i = 0;

while (size(template,1) < size(im_copy,1) && size(template,2) < size(im_copy,2))
%     if ndet_count == ndet
%         break;
%     end
    [x,y,score] = detect(im_copy,template,ndet);
    x = floor(x ./(power(scale,i)));
    y = floor(y ./(power(scale,i)));
    
%     for j = 1:length(final_x)
%         for k = 1:length(x)
%             dist = pdist2([final_x(j), final_y(j)], [x(k), y(k)]);
%             if dist < 128
%                 x(k) = [];
%                 y(k) = [];
%                 score(k) = [];
%                 break;
%             end
%         end
%     end
    
    final_x = [final_x; x];
    final_y = [final_y; y];
    final_scale = [final_scale; repmat(power(scale,i), [length(x), 1])];
    final_score = [final_score; score];
    
    i = i + 1;
    im_copy = imresize(image, (power(scale,i)));
    
end

[~, index] = sort(final_score, 'descend');

for i = 1:length(index)
    if size(det_res,1) == ndet
        break;
    end
    
    is_not_close = true;
    for j = 1:size(det_res,1)
        dist = pdist2([final_x(index(i)), final_y(index(i))], [det_res(j,1), det_res(j,2)]);
        if dist < 128
            is_not_close = false;
            break;
        end
    end
    
    if (is_not_close)
         det_res = [det_res; final_x(index(i)), final_y(index(i)), final_scale(index(i))];
    end
        
end

% for i = 1:ndet
%     if i > length(final_x)
%         break;
%     end
%     det_res = [det_res; final_x(index(i)), final_y(index(i)), final_scale(index(i))];
% end

end
