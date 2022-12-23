function [rec_im,PSNR,SSIM]  =  NLR_Reconstruction(par, rec_im)
%NLR_RECONSTRUCTION Realize reconstruction with nonlocal self-similarity
% [0] default parameter configuration
time0            =    clock;
beta             =    0.01;
cnt              =    20; 
[h, w, nframe]   =    size(rec_im);
PSNR             =    zeros(par.K,1);
SSIM             =    zeros(par.K,1);

for  k    =   1 : par.K
    % [1] calculate the patches with non-local similarity for each key patch
    [pos_arr]    =     Block_matching(rec_im, par); 

    f            =     rec_im;
    U_arr        =     zeros(nframe * par.win^4, size(pos_arr,2), 'single');
    if (k<=par.K0)  flag=0;  else  flag=1;  end        
    
    % [2] low rank approxiamtion 
    for it  =  1 : par.iters
        [rim, wei, U_arr]      =   Low_rank_appro(f, par, pos_arr, U_arr, flag );   
        rim     =    (rim+beta*f)./(wei+beta);   
        % update fidelity
        for n = 1:size(rim,3)
            rim0            =   rim(:,:,n);
            AtY             =   par.y(:,:,n);
            f0              =   f(:,:,n);
            b               =   AtY(:) + beta * rim0(:);
            [X,flag0]       =   pcg( @(x) Afun(x, beta, par, n), b, 0.5E-6, 400, [], [], f0(:)); 
            f0              =   reshape(X, h, w); 
            f(:,:,n)        =   f0;
        end
    end
  
    rec_im    =   f;
    % save and show results of psnr and ssim
    if ~isempty(par.ori_im)
      for iframe = 1:nframe
          PSNR(k,iframe)     =   psnr( rec_im(:,:,iframe)./255, par.ori_im(:,:,iframe)./255, max(max(par.ori_im(:,:,iframe)))./255 );
          SSIM(k,iframe)      =  ssim( rec_im(:,:,iframe)./255, par.ori_im(:,:,iframe)./255);
      end
      fprintf('Iteration:%d, PSNR: %.2f, SSIM %.2f \n', k, mean(PSNR(k,:)), mean(SSIM(k,:)));
      if mod(k,cnt) == 0
          saveresult_NLR(rec_im, k, PSNR, SSIM, par);
      end
    end
end
fprintf('Total elapsed time = %f min\n', (etime(clock,time0)/60) );
return;


