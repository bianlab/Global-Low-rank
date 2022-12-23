function [vours,PSNR,SSIM] = func_NLR(par,mask,m,orig,rec_im0)
% [0] parameters
par.nrol   =  size(orig,1);
par.ncol   =  size(orig,2);
par.picks  =  mask;
par.y      =  m;    
par.ori_im =  orig;
rec_im0    =  double(rec_im0);
% [1] apply NLR for reconstruction
fprintf('NLR start ...')
[vours,PSNR,SSIM]   =   NLR_Reconstruction( par, 255.*rec_im0); 
end