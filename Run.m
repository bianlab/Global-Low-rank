clear;close all
addpath(genpath('./func')); 
% [0] load dataset
datasetdir = './data';        % dataset
resultdir  = './results';     % results
opt.name   = 'toy_noiseless'; % name of dataset 
for i = [3]                   % type of measurement
    if i == 1
        type = 'random';
    else if i == 2
        type = 'regular';
    else
        type = 'btes';
    end
    end
    for num_pic = [6]         % number of coded frames in this test
        opt.type   =  type; 
        num_pixel  =  256; 
        opt.number =  num_pic; 
        opt.resultdir = resultdir;
        datapath = sprintf('%s/%s_%s_%d.mat',datasetdir,opt.name,...
            opt.type,num_pic); 
        if exist(datapath,'file')
            load(datapath);
        else
            error('File %s does not exist, please check dataset directory!',...
                datapath);
        end

%% [1] GAP-TV reconstruction
       [rgaptv,psnr_gaptv,ssim_gaptv,tgaptv]  = func_GAPTV(mask,meas,orig);    
%% [2] GLR reconstruction
        addpath(genpath('./utilities-GLR')); 
        rates = 1/num_pic;
        par = Set_parameters_GLR(rates);
        L = fieldnames(opt);
        for i = 1:length(L)
            par.(L{i}) = opt.(L{i});
        end 
        [rglr, psnr_glr, ssim_glr] = func_GLR(par, mask, m, orig, rgaptv);
    end
end





