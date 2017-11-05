function my_write_vol_nii(vol1,V,prefix,ending)
%- write data -------------------
% S. Mohammadi 11/02/2014

[pth,fname,ext] = spm_fileparts(V.fname);

dt        = [spm_type('float32'),spm_platform('bigend')];
dm        = V(1).dim;
Ni        = nifti;
Ni.mat    = V(1).mat;
Ni.mat0   = V(1).mat;
% Ni.descrip= sprintf('Averaged %s images, robust fitted', nam1{ii});

if(numel(size(vol1))==3)
    if(~exist('ending'))
        Ni.dat    = file_array(fullfile(pth,[prefix fname '.nii']),dm,dt, 0,1,0);
    else
        Ni.dat    = file_array(fullfile(pth,[prefix fname ending '.nii']),dm,dt, 0,1,0);
    end
    create(Ni);
    spm_progress_bar('Init',dm(3),Ni.descrip,'planes completed');
    for p=1:size(vol1,3)
        Ni.dat(:,:,p) = vol1(:,:,p);
        spm_progress_bar('Set',p);
    end
elseif(numel(size(vol1))==4)
    if(~exist('ending'))
        Ni.dat    = file_array(fullfile(pth,[prefix fname '.nii']),size(vol1),dt, 0,1,0);
    else
        Ni.dat    = file_array(fullfile(pth,[prefix fname ending '.nii']),size(vol1),dt, 0,1,0);
    end
    create(Ni);
    spm_progress_bar('Init',size(vol1,4),Ni.descrip,'volumeses completed');
    for p=1:size(vol1,4)
        Ni.dat(:,:,:,p) = vol1(:,:,:,p);
        spm_progress_bar('Set',p);
    end
end
spm_progress_bar('Clear');

   
% 
% 
% if(~exist('ending'))
%     V.fname=[pth filesep prefix fname ext];
% else
%     V.fname=[pth filesep prefix fname ending ext];
% end
% V=rmfield(V,'pinfo');
% spm_write_vol(V, vol1);
% clear tmp1;
