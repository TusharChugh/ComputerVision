clear;
clc;
close all;

load(fullfile('..','data','aerialseq.mat'));

frames_capture = [30 60 90 120];

figure(1);
h = figure(2);
j =1;
for i = 2:size(frames,3)
    %Call Subtract dominant motion
    mask = SubtractDominantMotion(frames(:,:,i-1), frames(:,:,i));
    %equally add the offset in x and y direction both the points
    img = imfuse(frames(:,:,i),mask);
    figure(1);
    imshow(img);
    %Save the image
    if ismember(i, frames_capture(:))
        h = figure(2);
        subplot(1,length(frames_capture),j);
        imshow(img);title(i);
        j = j + 1;
    end  
    
end

saveas(h,'../results/3.3_cartrack.jpg');
