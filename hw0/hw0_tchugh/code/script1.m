% Problem 1: Image Alignment
clear;
close all;
clc;
%% 1. Load images (all 3 channels)
imfile = load('../data/red.mat');
red = imfile.red;

imfile = load('../data/blue.mat');
blue = imfile.blue;

imfile = load('../data/green.mat');
green = imfile.green;

% Red channel as 'red'
% Green channel as 'green'
% Blue channel as 'blue'

%% 2. Find best alignment
% Hint: Lookup the 'circshift' function
rgbResult = alignChannels(red, green, blue);

%% 3. Save result to rgb_output.jpg (IN THE "results" folder)
imwrite(rgbResult, 'rgb_output.jpg');