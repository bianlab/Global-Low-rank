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
    for num_pic = [4]         % number of coded frames in this test
        opt.type   =  type; 
        opt.number =  num_pic; 
        opt.resultdir = resultdir;
        datapath = sprintf('%s/%s_%s_%d.mat',datasetdir,opt.name,...
            opt.type,num_pic); 
        if exist(datapath,'file')
            load(datapath,'meas','mask','orig','m');
        else
            error('File %s does not exist, please check dataset directory!',...
                datapath);
        end
%% [1] GAP-TV reconstruction
       [rgaptv,psnr_gaptv,ssim_gaptv,tgaptv]  = func_GAPTV(mask,meas,orig);
       save(['./results/GAPTV_' opt.name '_' opt.type '_' num2str(opt.number) '.mat'], "rgaptv");
%% [2] NLR reconstruction
        addpath(genpath('./utilities-NLR')); 
        rates = 1/num_pic;
        par = Set_parameters_NLR(rates);
        L = fieldnames(opt);
        for i = 1:length(L)
            par.(L{i}) = opt.(L{i});
        end 
        [rnlr, psnr_nlr, ssim_nlr] = func_NLR(par, mask, m, orig, rgaptv);
        save(['./results/NLR_' opt.name '_' opt.type '_' num2str(opt.number) '.mat'], "rnlr");
%% [2] GLR reconstruction
        addpath(genpath('./utilities-GLR')); 
        rates = 1/num_pic;
        par = Set_parameters_GLR(rates);
        L = fieldnames(opt);
        for i = 1:length(L)
            par.(L{i}) = opt.(L{i});
        end 
        [rglr, psnr_glr, ssim_glr] = func_GLR(par, mask, m, orig, rgaptv);
        save(['./results/GLR_' opt.name '_' opt.type '_' num2str(opt.number) '.mat'], "rglr");
    end
end





