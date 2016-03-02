% Load mat files
load('vision.mat')
load('../dat/traintest.mat', 'test_imagenames', 'test_labels', 'mapping');

%Initialize the variables
num_classes = 8
C = zeros(num_classes);
predicted_indexes = zeros(1, length(test_labels));
for m = 1:length(test_labels)
    i = test_labels(m);
    img_path = ['../dat/', test_imagenames{m}];
    predicted_class = guessImage(img_path);
    predict_index = strfind(mapping, predicted_class);
    j = find(~(cellfun(@isempty, predict_index)));
    predicted_indexes(m) =  j;
    C(i,j) = C(i,j) + 1;
    m
end

accuracy = trace(C) / sum (C(:)) * 100
imagesc(C)

