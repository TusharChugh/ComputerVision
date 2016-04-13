
function [x,y,score] = detection(I,template,ndet)
%
% return top ndet detections found by applying template to the given image.
%   x,y should contain the coordinates of the detections in the image
%   score should contain the scores of the detections
%
%Get hist from image
ohist = hog(I)
[sizex, sizey, sizez] = size(ohist);

%To get the response (convolution) for all 9 orientation
final_response = zeros(sizex, sizey);

%initialize x, y and score for faster perforance
x = [];
y = [];
score = [];

%For all 9 orientations
for i = 1:sizez
    final_response = final_response + conv2(ohist(:,:,i), ...
        rot90(template(:,:,i),2),'same');
     %final_response = final_response + normxcorr2(template(:,:,i),ohist(:,:,i));
end

imagesc(final_response);
[response, index] = sort(final_response(:), 'descend');

ndet_count = 0;

for i = 1:length(index)
    if ndet_count == ndet
        break;
    end
    
    [img_ind_y, img_ind_x] = ind2sub(size(final_response),index(i));
    img_ind_x = 8 * img_ind_x;
    img_ind_y = 8 * img_ind_y;

    
    is_not_close = true;
    for j = 1:ndet_count
        dist = pdist2([x(j), y(j)], [img_ind_x, img_ind_y]);
        if dist < 128
            is_not_close = false;
            break;
        end
    end
    
    if (is_not_close)
        ndet_count = ndet_count + 1;
        x = [x; img_ind_x];
        y = [y; img_ind_y];
        score = [score; response(i)];
    end
        
end

end


