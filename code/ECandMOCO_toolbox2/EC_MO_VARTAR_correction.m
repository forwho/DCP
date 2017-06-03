function EC_MO_VARTAR_correction(PG,rP,bvalues,refN,freeze,dummy_write,dummy_disp)
% 
% Inputs:
% PG            - reference image
% rP            - source images
% IN_freeze     - transformation parameters
% dummy_write   - 0: don't write registered images
%                 1: write registred images
% dummy_disp    - display eddy current and motion parameters
% 
% S. Mohammadi (02/02/2013)

global IN_freeze VFmat InterpLength VGmat VFdim

% defaults:
InterpLength = 1;

% write
IN_freeze = freeze;

if(~exist('PG'))
    % select the target image 
    PG      = char(cfg_getfile(Inf,'IMAGE',['Target Images: b0 image']));
end
VG      = spm_vol(PG);
VGmat   = VG(1).mat; % slicewise

if(~exist('bvalues'))
    % Get bvalues
    bvalues = spm_input('Select b values for each set of images','','r','',size(PG,1)); 
end

if(size(VG,1)~=size(PG,1))
    errror('You are using 4D image(s), data must be converted into 3D');
else
    if(~exist('rP'))
        rP      = char(cfg_getfile(Inf,'IMAGE',['Source Images (all images)']));
    end
    rV      = spm_vol(rP(1:size(rP,1),:));
end

if(~exist('refN'))
    % Get bvalues
    refN    = spm_input('Select b values for each image','','r','',size(rP,1));
end

if(size(bvalues,2)~=size(PG,1))
    % Get bvalues
    error('The number of target images and bvalues for target image must be the same!') 
end


if(size(refN,2)~=size(rP,1))
    error('The number of source images and entries of the corresponding b-value vector have to be the same!')
end
refN    = refN';



mireg    = struct('VG',[],'VF',[],'PO','');
% rename target
mireg.VG = spm_vol(VG);

% rename source(s)
mireg.VF    = rV;
VFmat       = rV(1).mat; % slicewise
VFdim       = rV(1).dim; % slicewise

%%%%%%%%%%%%%% Coregister %%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:size(mireg.VF,1),  
    [p n e] =spm_fileparts(rP(j,:));
    tmp = [p filesep 'mut_p2_' n '.mat'];
    Mfiles(j,1:numel(tmp)) = [p filesep 'mut_p2_' n '.mat'];
    [a,b] = min(abs(refN(j) - bvalues));
    fprintf('\nSource image: ');
    disp(mireg.VF(j).fname);
    fprintf('\n\nTarget image: ');
    disp(mireg.VG(b).fname);
    fprintf('\n\n\n');
    params(:,j) = spm_coreg_freeze_v01(mireg.VG(b), mireg.VF(j));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(dummy_write)
    EC_MO_write_rFiles_varRef_v01(Mfiles,mireg,deblank(e),refN,bvalues);
end

if(dummy_disp)
    disp_ECMO(Mfiles,IN_freeze)
end
disp('All diffusion weighted images coregistered to B0')

