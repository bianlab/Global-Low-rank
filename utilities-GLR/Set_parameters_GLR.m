function  par  =    Set_parameters_GLR(rate)
%SET_PARAMETERS_GLR Parameter configuration of the GLR
%   par=Set_parameters_GLR(rate) returns the parameters as a structure for given rate.
par.win        =    8;              % size of the patch
par.nblk       =    par.win^2;      % number of patches in a group
par.threshold  =    0.003;          % threshold for edge extraction
par.scale      =    1;              % ratio for reduce interference
par.iters      =    1;              % number of low rank iteration for one matching              
par.K          =    200;            % maximum number of iteration
par.K0         =    3;              % accommodation coefficient for weighted SVT
par.c0         =    0.49;           % threshold for weighted SVT

    
if rate<=0.05
    par.nSig       =   12;        %  threshold for weighted SVT
    par.c1         =   2.2;         %  threshold for weighted SVT
    
elseif rate<=0.1
    par.nSig       =   12;
    par.c1         =   1.55;
    
elseif rate<=0.15
    par.nSig       =   10;
    par.c1         =   1.35;
    
elseif rate<=0.2
    par.nSig       =   10;
    par.c1         =   1.32;
    
elseif rate<=0.25
    par.nSig       =   8;
    par.c1         =   1.15;
    
elseif rate<=0.3
    par.nSig       =   8;
    par.c1         =   0.9;
    
else
    par.nSig       =   6;
    par.c1         =   0.75;
end