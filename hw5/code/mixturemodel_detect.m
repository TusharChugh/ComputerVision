function det_res = mixturemodel_detect(image, template1,template2, ndet)
% input:
%     image - test image.
%     template - [16 x 16x 9] matrix.
%     ndet - the number of return values.
% output:
%      det_res - [ndet x 3] matrix
%                column one is the x coordinate
%                column two is the y coordinate
%                column three is the scale, i.e. 1, 0.7 or 0.49 ..

Error= template1(:)-template2(:);
SquersError=Error.^2;
LeastSquersError=min(SquersError(:));

final_x= [];
final_y = [];
final_scale =[];
final_score= [];
final_x1= [];
final_y1 = [];
final_scale1 =[];
final_score1= [];
det_res = [];
template_id = [];
template_id1 = [];

scale = 0.7;
im_copy = image;
i = 0;

while (size(template1,1) < size(im_copy,1) && size(template1,2) < size(im_copy,2))
%     if ndet_count == ndet
%         break;
%     end
    [x,y,score] = detect(im_copy,template1,ndet);
    score = score./LeastSquersError;
    
    [x1,y1,score1] = detect(im_copy,template2,ndet);
    score1 = score1./LeastSquersError;
    
    x = floor(x ./(power(scale,i)));
    y = floor(y ./(power(scale,i)));
    
    x1 = floor(x1 ./(power(scale,i)));
    y1 = floor(y1 ./(power(scale,i)));
    
    final_x = [final_x; x];
    final_y = [final_y; y];
    final_scale = [final_scale; repmat(power(scale,i), [length(x), 1])];
    final_score = [final_score; score];
    template_id = [template_id; repmat(1, [length(x), 1])];
    
    final_x1 = [final_x1; x1];
    final_y1 = [final_y1; y1];
    final_scale1 = [final_scale1; repmat(power(scale,i), [length(x1), 1])];
    final_score1 = [final_score1; score1];
    template_id1 = [template_id1; repmat(2, [length(x1), 1])];
    
    i = i + 1;
    im_copy = imresize(image, (power(scale,i)));
    
end
final_x = [final_x; final_x1];
final_y = [final_y; final_y1];
final_scale = [final_scale; final_scale1];
final_score = [final_score; final_score1];
template_id = [template_id; template_id1];
    
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
         det_res = [det_res; final_x(index(i)), final_y(index(i)), final_scale(index(i)), template_id(index(i))];
    end
        
end


end
