function PC = gretna_parcoeff(matrix, module)
% PARCOEFF:   calculate the participant coefficients of each node
% Input:
%      matrix: the connectivity matrix 
%      module: the modular structure of the matrix
% Output:
%      PC: a vector of participant coefficients

% PC = parcoeff(A,M), where A is a 90*90 matrix, and M is
% {[1:18],[19:50),(51:90]};

% written by Jinhui Wang, ICBL, BNU, 14/11/2008

matrix = matrix - diag(diag(matrix));
matrix = abs(matrix);
N = length(matrix);
ver_deg = sum(matrix);
num_mod = length(module);

for ver = 1:N
    if ver_deg(ver) == 0
        PC.original(ver) = 0;
    else
        for i = 1:num_mod
            withinmod(i) = sum(matrix(ver,module{i}));
        end
        withinmod = (withinmod./ver_deg(ver)).^2;
        PC.original(ver) = 1 - sum(withinmod);
    end
end

if num_mod ~= 1
    PC_max = (num_mod - 1)/num_mod;
    PC.normalized = PC.original/PC_max; % The normaized PC value ensure the comparability between subjects since the possible different number of modules
else
    PC.normalized = PC.original;
end