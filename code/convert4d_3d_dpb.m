function convert4d_3d_dpb(varargin)

%function my_read4dandwrite3dnifti(in_vols,res_hold)
% Function to splite 4d niftisinto one 3d nifti
% S.Mohammadi 11/02/2014
if nargin < 1
     disp('ERROR! convert4d_3d_dpb.m need at least one Function Parameter! ');
     return;
end   

in_vols=varargin{1};
res_hold=-7;%default res_hold=-7
if  nargin == 2
    res_hold=varargin{2};
end

% get volume
V   = spm_vol(in_vols);
VG  = V(1); 
% define indices
dm  = VG.dim;
d4  = size(V,1);
% resample volume
for j=1:d4
    vol = zeros(dm);
    for p=1:dm(3)                
        M = inv(spm_matrix([0 0 -p 0 0 0 1 1 1])*inv(VG.mat)*V(j).mat);
        vol(:,:,p) = spm_slice_vol(V(j),M,dm(1:2),res_hold);
    end
    if(j<10)
        my_write_vol_nii(vol,V(j),[],['-00' num2str(j)]);
    elseif(j>=10 && j<100)
        my_write_vol_nii(vol,V(j),[],['-0' num2str(j)]);
    elseif(j>=100 && j<1000)
        my_write_vol_nii(vol,V(j),[],['-' num2str(j)]);
    end
end