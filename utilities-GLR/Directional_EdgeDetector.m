function [Dx_I_p, Dx_I_n, Dy_I_p, Dy_I_n] = Directional_EdgeDetector(im, threshold)
%DIRECTIONAL_EDGEDETECTOR Extract directional edgemap.
%   [Dx_I_p,Dx_I_n,Dy_I_p,Dy_I_n]=DIRECTIONAL_EDGEDETECTOR(im,threshold) returns 
%   binary egde map of the image

% sobel operator
kernel_x = [-1, 0, 1; -2, 0, 2; -1, 0, 1];  
kernel_y = [1, 2, 1; 0, 0, 0; -1, -2, -1];
Dx_I = convn(im, kernel_x, 'same'); % extract vertical edge
Dy_I = convn(im, kernel_y, 'same'); % extract horizontal edge
% vertical positive edge
Dx_I_p = Dx_I; 
Dx_I_p(Dx_I_p<0) = 0;
Dx_I_p(abs(Dx_I_p)<=threshold) = 0;
Dx_I_p(abs(Dx_I_p)> threshold) = 1; 
% vertical negative edge
Dx_I_n = Dx_I; 
Dx_I_n(Dx_I_n>0) = 0;
Dx_I_n(abs(Dx_I_n)<=threshold) = 0;
Dx_I_n(abs(Dx_I_n)> threshold) = 1; 
% horizontal positive edge
Dy_I_p = Dy_I; 
Dy_I_p(Dy_I_p<0) = 0;
Dy_I_p(abs(Dy_I_p)<=threshold) = 0;
Dy_I_p(abs(Dy_I_p)> threshold) = 1;
% horizontal negative edge
Dy_I_n = Dy_I; 
Dy_I_n(Dy_I_n>0) = 0;
Dy_I_n(abs(Dy_I_n)<=threshold) = 0;
Dy_I_n(abs(Dy_I_n)> threshold) = 1;
return;