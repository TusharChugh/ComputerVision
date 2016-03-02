function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)

h = zeros(dictionarySize*((power(4,layerNum)-1))/3,1);

weights = [power(2,-2), power(2,-2), power(2,-1)];

for l = layerNum:-1:1
    split_size = power(2,l-1);
    start_vector = floor(dictionarySize * ((power(4,l-1))-1)/3);
    
    cell_size = floor(size(wordMap)/split_size);
    
    for i = 1:split_size
        for j = 1:split_size
            cell_h = [cell_size(1) * (i-1) + 1 : cell_size(1)*i];
            cell_w = [cell_size(2) * (j-1) + 1 : cell_size(2)*j];
            cell = wordMap(cell_h, cell_w);
          
            start_bin = floor(start_vector + split_size*dictionarySize*(j-1) + dictionarySize*(i-1) + 1);
            end_bin = floor(start_vector + split_size*dictionarySize*(j-1) + dictionarySize*(i));
            
            image_features = getImageFeatures(cell, dictionarySize);
            h (start_bin:end_bin, 1) = image_features * weights(l);
        end
    end
end
h = h/(norm(h,1));
end