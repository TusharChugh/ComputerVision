clear;
close all;
clc;

Itest= im2double(rgb2gray(imread('../data/test6.jpg')));
%template = tl_pos;
%template = tl_pos_neg
template = tl_lda;

% find top 5 detections in Itest
ndet = 1;
[x,y,score] = detect(Itest,template,ndet);

%display top ndet detections
figure; clf; imshow(Itest);
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  hold on; 
  h = rectangle('Position',[x(i)-64 y(i)-64 128 128],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
  hold off;
end