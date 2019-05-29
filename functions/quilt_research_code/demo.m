% **************************************************************************
% (C) 2001 Mitsubishi Electric Research Laboratories, all rights reserved.
% This program in source or executable form may be used for research only.
% Commercial use of this program in source or executable form is strictly
% prohibited. If copied, this copyright notice must appear with the
% program.
% **************************************************************************

clear; clc; close all;
addpath(genpath(pwd))

% echo on
% 
% % synthesize things
% tile = im2double(imread('btile.tif'));
% out = synthfun(tile,30,1);
% pause;
% 
% bricks = im2double(imread('col-br.tif'));
% out = synthfun(bricks,40,1);
% pause;
% 
% 
% % Bill in rice
% bill = im2double(imresize(imread('bill.jpg'),2,'bilinear'));
% rice = im2double(imread('rice.jpg'));
% out = simplexferfun(rice,bill,20,1);
% pause;

% Potato in orange
potato = im2double(imread('newpotato.jpg'));
orange = im2double(imread('neworange.jpg'));
potato_mask = rgb2gray(potato)<0.05;
orange_mask = rgb2gray(orange)<0.1;
% figure(4)
% imshow(potato_mask)
% figure(5)
% imshow(orange_mask)
% out = simplexferfun(orange,potato,30,3,orange_mask,potato_mask);
% figure(6)
% imshow(out)

% echo off
%read texture image
textureimg = im2double(imread('sourceImg\TexImg1.bmp'));
synthimg = im2double(imread('sourceImg\TexImg2.bmp'));
textureimg2 = textureimg<0;
synthimg2 = synthimg<0;
figure(4)
imshow(textureimg2)
figure(5)
imshow(synthimg2)
synthresult = simplexferfun(textureimg, synthimg, 30, 3, textureimg2, synthimg2);
figure(6)
imshow(synthresult)
