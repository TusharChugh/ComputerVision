function [compareX, compareY] = makeTestPattern(patchWidth, nbits)

%Mostly patchwidth =9 and nbits = 256
%Using Uniform Distribution
%CompareX nbitsx1
sig = power(patchWidth,4)/25;
mean = [40 40];
cov_mat = [sig 0; 0 sig];
value = abs(int16(mvnrnd(mean, cov_mat, nbits)));

index = find(value == 0);
value(index) = 1;

index = find(value > 81);
value(index) = 81;

compareX = value(:,1);
compareY = value(:,2);

save('testPattern.mat','compareX','compareY');
end