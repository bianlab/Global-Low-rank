function [vgaptv,psnr_gaptv,ssim_gaptv,tgaptv]  = func_GAPTV(mask,meas,orig)
% [0] environment configuration
addpath(genpath('./utilities-GAPTV')); 
num_pixel = size(mask,1); num_pic = size(mask,3);

% [1] load dataset
para.number =  num_pic; % number of frames in the dataset

para.nframe =   1; % number of coded frames in this test
para.MAXB   = 255;

[nrow,ncol,nmask] = size(mask);
nframe = para.nframe; % number of coded frames in this test
MAXB = para.MAXB;

% [2] apply GAP-Denoise for reconstruction
para.Mfunc  = @(z) A_xy(z,mask);
para.Mtfunc = @(z) At_xy_nonorm(z,mask);
para.Phisum = sum(mask.^2,3); 
para.Phisum(para.Phisum==0) = 1;

% common parameters
para.lambda   =     1; % correction coefficiency
para.acc      =     1; % enable GAP-acceleration
para.flag_iqa = false; % disable image quality assessments in iterations


%% GAP-TV
  para.denoiser = 'tv'; % TV denoising
  para.maxiter  = 40; % maximum iteration
  para.tvweight =  5; % weight for TV denoising
  para.tviter   =  5; % number of iteration for TV denoising
  
[vgaptv,psnr_gaptv,ssim_gaptv,tgaptv] = ...
    gapdenoise_cacti(mask,meas,orig,[],para);

fprintf('GAP-%s mean PSNR %2.2f dB, mean SSIM %.4f, total time % 4.1f s.\n',...
    upper(para.denoiser),mean(psnr_gaptv),mean(ssim_gaptv),tgaptv);
end