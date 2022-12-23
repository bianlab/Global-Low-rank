function  [pos_arr]   =  Block_matching(im, par)
%Block_MATCHING Matching of patches with non-local similarity.
%   [pos_arr] = Block_matching(im,par) returns the indexes of the patches with similarity
nframe    =   size(im,3);
S         =   60; % size of the search window
f         =   par.win; % size of the patch
f2        =   nframe * f^2;
s         =   par.step; % step of the key patch grid
N         =   size(im,1)-f+1; 
M         =   size(im,2)-f+1; 
r         =   [1:s:N]; % indexes of row grid
r         =   [r r(end)+1:N]; % residual steps
c         =   [1:s:M]; % indexes of column grid
c         =   [c c(end)+1:M]; % residual steps
L         =   N*M; % total number of patches
X         =   zeros(L, f2, 'single');

% splite the whole image into patches
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

I     =   (1:L); 
I     =   reshape(I, N, M); % indexes of all the patches in the image
N1    =   length(r);
M1    =   length(c);
pos_arr   =  zeros(par.nblk, N1*M1 );  % indexes of the similar patches

% indexes of similar patches within search window for each key patch
for  i  =  1 : N1
    for  j  =  1 : M1

        row     =   r(i); % index of row grid
        col     =   c(j); % index of col grid
        off     =  (col-1)*N + row; % index of key patch
        off1    =  (j-1)*N1 + i;    % grid index of key patch

        rmin    =   max( row-S, 1 ); % index of the top of search window
        rmax    =   min( row+S, N ); % index of the button of search window
        cmin    =   max( col-S, 1 ); % index of the left of search window
        cmax    =   min( col+S, M ); % index of the right of search window
         
        idx     =   I(rmin:rmax, cmin:cmax); % indexes of the neighbors of the key patch
        idx     =   idx(:);
        B       =   X(idx, :);        
        v       =   X(off, :);        
        % ell_2 distance
        dis     =   (B(:,1) - v(1)).^2;
        for k = 2:f2
            dis   =  dis + (B(:,k) - v(k)).^2;
        end
        dis     =   dis./f2;
        [~,ind]   =  sort(dis); % sort distance in descending order
        pos_arr(:, off1)  =  idx(ind(1:par.nblk), : ); % indexes of the most similar para.patchnum patches of neighbors
    end
end
