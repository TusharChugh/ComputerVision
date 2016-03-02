function [filterBank, dictionary] = getFilterBankAndDictionary(image_names)
filterBank = createFilterBank() ;
alpha = 75;
imagesCount = size(image_names,2);
%p = randperm(imagesCount,alpha);
filter_responses = [];
for i=1:imagesCount
    filterResponse = extractFilterResponses(imread(image_names{i}), filterBank);
    p = randperm(size(filterResponse,1),alpha);
    v = filterResponse(p,:);
    filter_responses = [filter_responses; v];
end
K = 200;
[~, dictionary] = kmeans(filter_responses, K, 'EmptyAction','drop');
dictionary = dictionary';
end