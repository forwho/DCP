function my_write_data(yVol,V,prefix,A,MSK,ending)
%- write data -------------------
% S. Mohammadi 22/10/2012

vol1        = zeros(size(A));
vol1(MSK)   = yVol;
[pth,fname,ext] = fileparts(V.fname);
if(~exist('ending'))
    V.fname=[pth filesep prefix fname ext];
else
    V.fname=[pth filesep prefix fname ending ext];
end
V=rmfield(V,'pinfo');
spm_write_vol(V, vol1);
clear tmp1;
