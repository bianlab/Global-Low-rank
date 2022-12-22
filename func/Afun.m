function  y  =  Afun(x, eta, par, n)
pattern = par.picks(:,:,n);
y       = reshape(x,size(pattern)).*pattern;
y       =   y(:) + eta*x;  
return;