function  par  =  Set_parameters_NLR(rate)
%SET_PARAMETERS_NLR Parameter configuration of the NLR
%   par=Set_parameters_NLR(rate) returns the parameters as a structure for given rate.
par.win        =    6;                 % size of the patch
par.nblk       =    par.win^2;         % number of patches in a group
par.iters      =    1;                 % number of low rank iteration for one matching
par.step       =    min(6, par.win-1); % step of the key patch grid
par.K          =    200;               % maximum number of iteration
par.K0         =    3;                 % accommodation coefficient for weighted SVT
par.c0         =    0.49;              % threshold for weighted SVT
 
if rate<=0.05
    par.nSig       =   4.66;           % threshold for weighted SVT
    par.c0         =   0.6;            % threshold for warm start step
    par.c1         =   2.2;            % threshold for weighted SVT
    
elseif rate<=0.1
    par.nSig       =   3.25;
    par.c1         =   1.55;
    
elseif rate<=0.15
    par.nSig       =   2.65;
    par.c1         =   1.35;
    
elseif rate<=0.2
    par.nSig       =   2.35;
    par.c1         =   1.32;
    
elseif rate<=0.25
    par.nSig       =   2.1;
    par.c1         =   1.15;
    
    
elseif rate<=0.3
    par.nSig       =   1.8;
    par.c1         =   0.9;
    
else
    par.nSig       =   1.4;
    par.c1         =   0.75;
end    