clear;
clc;
close all;

load(fullfile('..','data','sylvseq.mat'));
load(fullfile('..','data','sylvbases.mat'));
% load(fullfile('..','data','bookSequence.mat'));
% load(fullfile('..','data','bookBases.mat'));


%Create matrix of zeros of size equal to number of frames x4 (2 points of
%rectangle
rects = zeros(size(frames,3),4);

%for old function
rects1 = zeros(size(frames,3),4);

%Coordinated of the rectangle given in the question (top left and bottom
%right corners)
%rect =[60, 117, 146, 152]; %for car
rect =[102, 62, 156, 108]; %for syl
rect1 =[102, 62, 156, 108]; %for syl
% rect =[247, 102, 285, 161]; %for book
% rect1 =[247, 102, 285, 161]; %for book
rects(1,:) = rect;
rects1(1,:) = rect1;
%Required Solution
result_frames =[1, 100, 200, 300, 400];
h = figure;
% frames = frames(:,:,1:4:end);
for i = 2:size(frames,3)
    %Call LucasKanade function basis and original
    [u, v] = LucasKanadeBasis(frames(:,:,i-1), frames(:,:,i), rect, bases);
    [u1, v1] = LucasKanade(frames(:,:,i-1), frames(:,:,i), rect1);
    %equally add the offset in x and y direction both the points
    rect = rect + [u, v, u, v];  
    rect1 = rect1 + [u1, v1, u1, v1];  
    %Add to the resulting nx4 vector
    rects(i, :) = rect;
    rects1(i, :) = rect1;
    %Visualize image with rectangle
    imshow(frames(:,:,i));
    hold on;
    rectangle('Position', [rect(1),rect(2),(rect(3)...
        -rect(1)),(rect(4)-rect(2))]...
        , 'LineWidth', 3, 'EdgeColor', 'y');
    rectangle('Position', [rect1(1),rect1(2),(rect1(3)...
        -rect1(1)),(rect1(4)-rect1(2))]...
        , 'LineWidth', 1.5, 'EdgeColor', 'g');
    
    hold off;
    pause(0.0001) 
end
% 
% %for old function
% for i = 2:size(frames,3)
%     %Call LucasKanade function
%     [u1, v1] = LucasKanade(frames(:,:,i-1), frames(:,:,i), rect1);
%     %equally add the offset in x and y direction both the points
%     rect1 = rect1 + [u1, v1, u1, v1];  
%     %Add to the resulting nx4 vector
%     rects1(i, :) = rect1;
%     
%     %Visualize image with rectangle
%     imshow(frames(:,:,i));
%     hold on;
%     rectangle('Position', [rect1(1),rect1(2),(rect1(3)...
%         -rect1(1)),(rect1(4)-rect1(2))]...
%         , 'LineWidth', 3, 'EdgeColor', 'y');
%     hold off;
%     pause(0.001) 
% end



for i = 1:length(result_frames)
    frameid = result_frames(i);
    %Show image
    subplot(1,length(result_frames),i);
    imshow(frames(:,:,frameid)); title(frameid);
    
    % Draw rectangle
    subimage = rectangle('Position', [rects(frameid,1),rects(frameid,2),(rects(frameid, 3)...
        -rects(frameid,1)),(rects(frameid,4)-rects(frameid ,2))]...
        , 'LineWidth', 3, 'EdgeColor', 'y');
    subimage = rectangle('Position', [rects1(frameid,1),rects1(frameid,2),(rects1(frameid, 3)...
        -rects1(frameid,1)),(rects1(frameid,4)-rects1(frameid ,2))]...
        , 'LineWidth', 1, 'EdgeColor', 'g');
end

% save the rects and figure
saveas(h,'../results/1.3_trackedframes.jpg');

save(fullfile('..','results','sylvseqrects.mat'), 'rects');
