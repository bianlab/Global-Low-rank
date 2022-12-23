function   [dim, wei, U_arr]  =  Low_rank_appro(nim, par, pos_arr, U_arr, flag)
%LOW_RANK_APPRO Estimation of the patches in each patch group.
%   [dim,wei,U_arr]=LOW_RANK_APPRO(nim,par,pos_arr,U_arr,flag) returns the estimated 
%   patch matrix estpatchmat and the frequency matrix of each pixel in a patch.
b            =   par.win;
[h, w, ch]   =   size(nim);
N            =   h-b+1;
M            =   w-b+1;
r            =   [1:N];
c            =   [1:M]; 
X_big        =   Im2big_tensor( nim, par ); % image to patches
X_big        =   X_big';
Ys           =   zeros( size(X_big) );        
W            =   zeros( size(X_big) );
L            =   size(pos_arr,2); 
T            =   8; 

% estimate each patch
for  i  =  1 : L
    B          =   X_big(:,pos_arr(:,i)); % raw patch group
    mB         =   repmat(mean( B, 2 ), 1, size(B, 2)); % mean patch of the patch group
    B          =   B-mB; % deviation of the raw patch group
    
    % SVT for each patch group by exploiting low-rank property
    [tmp_y, tmp_w, U_arr(:,i)]   =   Weighted_SVT( double(B), par.c1, par.nSig^2, mB, flag, par.c0 );
    Ys(:, pos_arr(:,i))   =   Ys(:, pos_arr(:,i)) + tmp_y; 
    W(:, pos_arr(:,i))    =   W(:, pos_arr(:,i)) + tmp_w;
end

%  aggregate overlapped patches to the image
dim     =  zeros(h,w,ch);
wei     =  zeros(h,w,ch);
for n = 1:ch
    k      =   (n-1)*b.^2;
    for i  =  1:b
        for j  =  1:b
            k   =  k+1;
            dim(r-1+i,c-1+j,n)  =  dim(r-1+i,c-1+j,n) + reshape( Ys(k,:)', [N M]); % estimated patch matrix
            wei(r-1+i,c-1+j,n)  =  wei(r-1+i,c-1+j,n) + reshape( W(k,:)', [N M]);  % frequency matrix of each pixel in a patch
        end
    end
end
return;