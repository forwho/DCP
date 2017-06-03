function merger3d_4d(varargin)
% Function to merge 3d niftis into one 4d nifti
% S.Mohammadi 11/02/2014

% get volume
res_hold=-7;%default res_hold=-7
if nargin == 1
    prefix=varargin{1};
end

if  nargin == 2
   prefix=varargin{1};
   res_hold=varargin{2};
end

if nargin >0
    imgstruct = dir(prefix);   
else
    imgstruct = [dir('r*.nii'),dir('r*.img')];    
end
% 增加判断是否有数据，可能有的数据集没有DTI数据集
if numel(imgstruct)==0
    return;% 没有DTI数据
end
for i =1:numel(imgstruct);
   imgcells{i} =[imgstruct(i).name];
end  
rP=char(imgcells);
path=pwd;
rP=strcat(rP,',1');
clc
rP=strcat(path,'\',rP)

in_vols=rP;
V   = spm_vol(in_vols);
VG  = V(1); 
% define indices
dm  = VG.dim;
d4  = size(V,1);
vol = zeros([dm d4]);
% resample volume
for j=1:d4
    for p=1:dm(3)                
        M = inv(spm_matrix([0 0 -p 0 0 0 1 1 1])*inv(VG.mat)*V(j).mat);
        vol(:,:,p,j) = spm_slice_vol(V(j),M,dm(1:2),res_hold);
    end
%     Matrix = vol(:,:,:,j);
%     for l=2:dm(1)-1,
%         for m=2:dm(2)-1,
%             for n=2:dm(3)-1,
%                 temp=[Matrix(l-1,m-1,n-1) Matrix(l,m-1,n-1) Matrix(l+1,m-1,n-1) Matrix(l-1,m,n-1) Matrix(l,m,n-1) Matrix(l+1,m,n-1) Matrix(l-1,m+1,n-1) Matrix(l,m+1,n-1) Matrix(l+1,m+1,n-1) Matrix(l-1,m-1,n) Matrix(l,m-1,n) Matrix(l+1,m-1,n) Matrix(l-1,m,n) Matrix(l,m,n) Matrix(l+1,m,n) Matrix(l-1,m+1,n) Matrix(l,m+1,n) Matrix(l+1,m+1,n) Matrix(l-1,m-1,n+1) Matrix(l,m-1,n+1) Matrix(l+1,m-1,n+1) Matrix(l-1,m,n+1) Matrix(l,m,n+1) Matrix(l+1,m,n+1) Matrix(l-1,m+1,n+1) Matrix(l,m+1,n+1) Matrix(l+1,m+1,n+1)];
%                 temp=sort(temp);
%                 if Matrix(l,m,n)==temp(1),
%                     Matrix(l,m,n)=temp(14);
%                 end
%             end
%         end
%     end
%     vol(:,:,:,j)=Matrix;
end
%delete('*.nii');
my_write_vol_nii(vol,VG,'eddy','_4D');