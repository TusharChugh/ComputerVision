function [filterBank] = createFilterBank() 
% Code to generate reasonable filter bank

gaussianScales = [1 2 4 8 sqrt(2)*8];
logScales      = [1 2 4 8 sqrt(2)*8];
dxScales       = [1 2 4 8 sqrt(2)*8];
dyScales       = [1 2 4 8 sqrt(2)*8];
gaborScales1    = [1 2 4 8 sqrt(2)*8];
gaborScales2    = [1 2 4 8 sqrt(2)*8];
gaborScales3    = [1 2 4 8 sqrt(2)*8];
gaborScales4    = [1 2 4 8 sqrt(2)*8];

% filterBank = cell(numel(gaussianScales) + numel(logScales) + numel(dxScales)...
%     + numel(dyScales) + numel(gaborScales1) + numel(gaborScales2) + numel(gaborScales3 ) ...
%     + numel(gaborScales4),1);

filterBank = cell(20,1);

idx = 0;
% 
% for scale = gaussianScales
%     idx = idx + 1;
%     filterBank{idx} = fspecial('gaussian', 2*ceil(scale*2.5)+1, scale);
% end
% %imagesc(filterBank{5});
% for scale = logScales
%     idx = idx + 1;
%     filterBank{idx} = fspecial('log', 2*ceil(scale*2.5)+1, scale);
% end
% % imagesc(filterBank{10});
% % surf(filterBank{5});
% % surf(filterBank{10});
% for scale = dxScales
%     idx = idx + 1;
%     f = fspecial('gaussian', 2*ceil(scale*2.5) + 1, scale);
%     f = imfilter(f, [-1 0 1], 'same');
%     filterBank{idx} = f;
% end
% %imagesc(filterBank{11});
% for scale = dyScales
%     idx = idx + 1;
%     f = fspecial('gaussian', 2*ceil(scale*2.5) + 1, scale);
%     f = imfilter(f, [-1 0 1]', 'same');
%     filterBank{idx} = f;
% end

for scale = gaborScales1
    idx = idx + 1;
    filterBank{idx} = gabor_fn(scale, 0, 4, 0, 0.5);
end

for scale = gaborScales2
    idx = idx + 1;
    filterBank{idx} = gabor_fn(scale, pi/4, 4, 0, 0.5);
end

for scale = gaborScales3
    idx = idx + 1;
    filterBank{idx} = gabor_fn(scale, pi/2, 4, 0, 0.5);
end

for scale = gaborScales4
    idx = idx + 1;
    filterBank{idx} = gabor_fn(scale,(-pi/4), 4, 0, 0.5);
end

%imagesc(filterBank{37})
figure 
for i=1:20
        subplot(2,10, i);imagesc(filterBank{i});
end

return;
