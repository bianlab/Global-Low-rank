function  X  =  Im2big_tensor( im, par )
%IM2BIG_TENSOR Splite the whole image into patches.
%   X = Im2big_tensor(im,par) returns the overlapped patches 
f        =   par.win;
N        =   size(im,1)-f+1;
M        =   size(im,2)-f+1;
L        =   N*M;
nframe   =   size(im,3);
f2       =   nframe * f^2;
X        =   zeros(L, f2, 'single');

for n = 1:nframe  
    k    =  0 + (n-1)*f^2;
    for i  = 1:f
        for j  = 1:f
            k    =  k+1;
            blk  =  im(i:end-f+i,j:end-f+j,n);
            X( : ,k ) =  blk(:);
        end
    end
end