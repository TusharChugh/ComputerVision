function [wordMap] = getVisualWords(I, filterBank, dictionary)

filter_Response = extractFilterResponses(I, filterBank);
euc_distance = pdist2(filter_Response, dictionary');
[~, wordMap] = min(euc_distance');
wordMap = reshape(wordMap, size(I, 1), size(I, 2));
%imagesc(wordmap);
end