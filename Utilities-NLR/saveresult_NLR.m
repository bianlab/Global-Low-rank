function saveresult_NLR(vours, k, psnr_ours, ssim_ours, par)
%SAVERESULT_NLR Save all the images.
algorithm = '\NLR';
resultdir = par.resultdir;
num_pic = par.number;
dir = sprintf('%s%s',resultdir,algorithm);
foldername = [par.name,'_',par.type,'_',num2str(num_pic),'(第',num2str(k),'次循环）','_win_',num2str(par.win),'_nSig_',num2str(par.nSig),'_psnr_',num2str(mean(psnr_ours(k,:))),'_ssim_',num2str(mean(ssim_ours(k,:)))];
mkdir(dir,foldername); 
% save image
save([dir,'\',foldername,'\Our(第',num2str(k),'次循环）'],...
    'vours');
for i = 1:size(vours,3)
    imwrite((vours(:,:,i)./255),[dir,'\',foldername,'\',...
        par.name,'_',par.type,'_',num2str(num_pic),'_',num2str(i),'.png'])
end