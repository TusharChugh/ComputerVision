%Load Files
load('../dat/traintest.mat','train_imagenames','train_labels');
load('dictionary.mat','filterBank','dictionary');

%Declare Variables and initialize
layerNum = 3;
trainSize = length(train_imagenames);
dictionarySize = length(dictionary);
train_features = zeros(dictionarySize*(4^(layerNum)-1)/3, trainSize);

for i = 1:trainSize
    img_path = ['../dat/', strrep(train_imagenames{i}, '.jpg', '.mat')];
    load(img_path);
    train_features(:,i) = getImageFeaturesSPM(layerNum, wordMap, dictionarySize);
end

%Save the file
save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels');
fprintf('Vision.mat saved');
