function [compareX, compareY] = makeTestPattern(patchWidth, nbits)

%Mostly patchwidth =9 and nbits = 256
%Using Uniform Distribution
%CompareX nbitsx1

bit_m1 = rand(nbits,1);
bit_m2 = rand(nbits,1);


p_2 = patchWidth^2;
compareX = floor(p_2*bit_m1) + 1;
compareY = floor(p_2*bit_m2) + 1;

save('testPattern.mat','compareX','compareY');
end