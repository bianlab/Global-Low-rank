function  [X W U]   =   Weighted_SVT( Y, c1, nsig2, m, flag, c0 )
%WEIGHTED_SVT Weighted singular value thresholding.
%   [X W U]=Weighted_SVT(Y,c1,nsig2,m,flag,c0) returns the low-rank approximation 
%   under weighted singular value thresholding.
c1                =   c1*sqrt(2);
[U0,Sigma0,V0]    =   svd(full(Y),'econ'); % singular value decomposition
Sigma0            =   diag(Sigma0); 
if flag == 1
    S             =   max( Sigma0.^2/size(Y, 2) - nsig2, 0 );   
    thr           =   c1*nsig2./ ( sqrt(S) + eps );
    S             =   soft(Sigma0, thr);
else
    S             =   soft(Sigma0, c0*nsig2);
end
r                 =   sum( S>0 );   
U                 =   U0(:,1:r);
V                 =   V0(:,1:r);
X                 =   U*diag(S(1:r))*V';
if r==size(Y,1)
    wei           =   1/size(Y,1);
else
    wei           =   (size(Y,1)-r)/size(Y,1);
end
W                 =   wei*ones( size(X) );
X                 =   (X + m)*wei;
U                 =   U0(:);
return;
