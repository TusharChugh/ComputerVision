function [h] = getImageFeatures(wordMap, dictionarySize)
h = hist(wordMap(:), 1:dictionarySize);
h = (h / norm(h, 1))';
end