% Extra credit.  You can leave this untouched if you're not doing the EC.
clear;
close all;
clc;


load(fullfile('..','data','carseq.mat')); % variable name = frames. 
%load(fullfile('..','data','sylvseq.mat'));
%Visualize First frame to test
%imshow(frames(:,:,1))

%Create matrix of zeros of size equal to number of frames x4 (2 points of
%rectangle
rects = zeros(size(frames,3),4);

%Coordinated of the rectangle given in the question (top left and bottom
%right corners)
rect =[60, 117, 146, 152]; %for car
%rect =[102, 62, 156, 108]; %for syl
rects(1,:) = rect;
%Required Solution
result_frames =[1, 100, 200, 300, 400];
h = figure;
%%
%%Computer the template with zero warp
%1. Get the rectangle for the given coordinates
[X,Y] = meshgrid(rect(1):rect(3), rect(2):rect(4));

%2. The default grid points cover the rectangular region, X=1:n and Y=1:m, where [m,n] = size(V)
T = interp2(im2double(frames(:,:,1)),X,Y); 

for i = 2:size(frames,3)
    %Call LucasKanade function
    [u, v] = LucasKanade_TemplateCorrection(T, frames(:,:,i), rect);
    %equally add the offset in x and y direction both the points

    rect = rect + [u, v, u, v];  

    %Add to the resulting nx4 vector
    rects(i, :) = rect;
    
    %Visualize image with rectangle
    imshow(frames(:,:,i));
    hold on;
    rectangle('Position', [rect(1),rect(2),(rect(3)...
        -rect(1)),(rect(4)-rect(2))]...
        , 'LineWidth', 3, 'EdgeColor', 'y');
    hold off;
    pause(0.001) 
end


for i = 1:length(result_frames)
    frameid = result_frames(i);
    %Show image
    subplot(1,length(result_frames),i);
    imshow(frames(:,:,frameid)); title(frameid);
    
    % Draw rectangle
    subimage = rectangle('Position', [rects(frameid,1),rects(frameid,2),(rects(frameid, 3)...
        -rects(frameid,1)),(rects(frameid,4)-rects(frameid ,2))]...
        , 'LineWidth', 3, 'EdgeColor', 'y');
end

% save the rects and figure
saveas(h,'../results/1.3_trackedframes-wcrt.jpg');

save(fullfile('..','results','carseqrects-wcrt.mat'), 'rects');

