function [filterBank] = createFilterBank() 
% Code to generate reasonable filter bank

gaussianScales = [1 2 4 8 sqrt(2)*8];
logScales      = [1 2 4 8 sqrt(2)*8];
dxScales       = [1 2 4 8 sqrt(2)*8];
dyScales       = [1 2 4 8 sqrt(2)*8];

filterBank = cell(numel(gaussianScales) + numel(logScales) + numel(dxScales) + numel(dyScales),1);

idx = 0;

for scale = gaussianScales
    idx = idx + 1;
    filterBank{idx} = fspecial('gaussian', 2*ceil(scale*2.5)+1, scale);
end
surf(filterBank{5});
for scale = logScales
    idx = idx + 1;
    filterBank{idx} = fspecial('log', 2*ceil(scale*2.5)+1, scale);
end
imagesc(filterBank{10});
surf(filterBank{1});
surf(filterBank{6});
for scale = dxScales
    idx = idx + 1;
    f = fspecial('gaussian', 2*ceil(scale*2.5) + 1, scale);
    f = imfilter(f, [-1 0 1], 'same');
    filterBank{idx} = f;
end
% surf(filterBank{11});
% surf(filterBank{15});
for scale = dyScales
    idx = idx + 1;
    f = fspecial('gaussian', 2*ceil(scale*2.5) + 1, scale);
    f = imfilter(f, [-1 0 1]', 'same');
    filterBank{idx} = f;
end
% surf(filterBank{16});
% surf(filterBank{20});

return;
