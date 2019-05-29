% =========================================================================
% An example code for the algorithm proposed in
%
%   Hang Zhou, Kejiang Chen, Weiming Zhang and Nenghai Yu.
%   "Comments on "Steganography Using Reversible Texture Synthesis"", TIP 2017.
%
%
% Written by Hang Zhou @ EEIS USTC
% November, 2015.
% =========================================================================

clear; clc; close all;
addpath(genpath(pwd));

fprintf('Conduct texture image recovery and message extraction:\n');

%% Single image
singlesynth(2);

%% Batch processing
% imgnum = 12*84*2;
% parpool('local', 32)
% parfor i = 1:imgnum
%     singlesynth(i);
% end
% poolobj = gcp('nocreate');
% delete(poolobj);

fprintf('Finish. \n');

