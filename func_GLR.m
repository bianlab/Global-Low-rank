function [vours,PSNR,SSIM] = func_GLR(par,mask,m,orig,rec_im0)
% [0] environment configuration
addpath(genpath('./utilities-GLR')); 
% [1] parameters
par.nrol   = size(orig,1);
par.ncol   = size(orig,2);
par.picks  = mask;
par.y      = m;    
par.ori_im = orig; 
rec_im0    = double(rec_im0);
% [2] apply GLR for reconstruction
[vours,PSNR,SSIM]      =   GLR_Reconstruction( par, 255.*rec_im0); 
end