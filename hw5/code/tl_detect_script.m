function tl_detect_script

clear;
close all;
clc;
md = 0;


if (md == 1)
    load('template_images_pos.mat');
    load('template_images_neg.mat');
    load('template_images_pos1.mat');
    load('template_images_neg1.mat');
else
    load('template_images_pos.mat');
    load('template_images_neg.mat');
end

ndet =  1;
Itest= im2double(rgb2gray(imread('../data/test13.jpg')));
lambda = 15;

template = tl_pos(template_images_pos);
[x,y,score] = detect(Itest,template,ndet);
draw_detection(Itest,ndet,x,y, repmat(1, [length(x),1]),  repmat(0, [length(x),1]));


template = tl_pos_neg(template_images_pos, template_images_neg);
[x,y,score] = detect(Itest,template,ndet);
draw_detection(Itest,ndet,x,y, repmat(1, [length(x),1]),  repmat(0, [length(x),1]));

template = tl_lda(template_images_pos, template_images_neg, lambda);
[x,y,score] = detect(Itest,template,ndet);
draw_detection(Itest,ndet,x,y, repmat(1, [length(x),1]),  repmat(0, [length(x),1]));

det_res = multiscale_detect(Itest, template, ndet);
draw_detection(Itest,ndet,det_res(:,1),det_res(:,2), det_res(:,3),  repmat(0, [length(x),1]));

if (md == 1)
    template1 = tl_lda(template_images_pos1, template_images_neg1, lambda);
    det_res = mixturemodel_detect(Itest, template,template1, ndet);
    draw_detection(Itest,ndet,det_res(:,1),det_res(:,2), det_res(:,3), det_res(:,4));
end

end

function draw_detection(Itest,ndet,x,y, scale, templateID)
% please complete this function to show the detection results
figure; clf; imshow(Itest);
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  hold on;
  
  if templateID(i) == 1
      Itest = insertText(Itest,[x(i)-64/scale(i) y(i)-64/scale(i)], 'walking', 'FontSize', 48);
       imshow(Itest);
  elseif templateID(i) == 2
      Itest = insertText(Itest,[x(i)-64/scale(i) y(i)-64/scale(i)], 'cycle', 'FontSize', 48);
       imshow(Itest);
  end

  h = rectangle('Position',[x(i)-64/scale(i) y(i)-64/scale(i) 128/scale(i) 128/scale(i)],...
      'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
  hold off;
end

end