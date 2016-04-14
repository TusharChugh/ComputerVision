function tl_detect_script

clear;
close all;
clc;

load('template_images_pos.mat');
load('template_images_neg.mat');

ndet =  6;
Itest= im2double(rgb2gray(imread('../newdata/test11.jpg')));
lambda = 15;

template = tl_pos(template_images_pos);
[x,y,score] = detect(Itest,template,ndet);
draw_detection(Itest,ndet,x,y, repmat(1, [length(x),1]));


template = tl_pos_neg(template_images_pos, template_images_neg);
[x,y,score] = detect(Itest,template,ndet);
draw_detection(Itest,ndet,x,y, repmat(1, [length(x),1]));

template = tl_lda(template_images_pos, template_images_neg, lambda);
[x,y,score] = detect(Itest,template,ndet);
draw_detection(Itest,ndet,x,y, repmat(1, [length(x),1]));

det_res = multiscale_detect(Itest, template, ndet);
draw_detection(Itest,ndet,det_res(:,1),det_res(:,2), det_res(:,3));

end

function draw_detection(Itest,ndet,x,y, scale)
% please complete this function to show the detection results
figure; clf; imshow(Itest);
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  hold on; 
  h = rectangle('Position',[x(i)-64/scale(i) y(i)-64/scale(i) 128/scale(i) 128/scale(i)],...
      'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
  hold off;
end

end