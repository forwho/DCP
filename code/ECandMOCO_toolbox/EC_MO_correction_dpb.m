function EC_MO_correction_dpb(PG,rP)
% 
% Inputs:
% PG            - reference image
% rP            - source images
% IN_freeze     - transformation parameters
% dummy_write   - 0: don't write registered images
%                 1: write registred images
% dummy_disp    - display eddy current and motion parameters
% 
% S. Mohammadi (05/08/2012)


global IN_freeze VFmat InterpLength VGmat VFdim

% defaults:
InterpLength = 1;
dummy_write=1;
dummy_disp=0;


% write
freeze=[ones(1,6) 0 1 0 1 1 0];
IN_freeze = freeze;
% select the target image 
% PG      = char(cfg_getfile(1,'img',['Target Images: b0 image']));
VG      = spm_vol(PG);   %filename,dim,dt,mat,pinfo
VGmat   = VG.mat; % slicewise
        
if(size(VG,1)~=size(PG,1))
    errror('You are using 4D image(s), data must be converted into 3D');
else
    rV      = spm_vol(rP(1:size(rP,1),:));
end

mireg    = struct('VG',[],'VF',[],'PO','');
% rename target
mireg.VG = VG;
[p,n,e] = spm_fileparts(mireg.VG.fname);

% rename source(s)
mireg.VF    = rV;
VFmat       = rV(1).mat; % slicewise
VFdim       = rV(1).dim; % slicewise

% 下面的运算可以改成并行
% %%%%%%%%%%%%%% Coregister %%%%%%%%%%%%%%%%%%%%%%%%%


% matlabpool
% parfor j=1:size(mireg.VF,1),  
%     fprintf('\nSource image: ');
%     disp(mireg.VF(j).fname);
%     fprintf('\n\nTarget image: ');
%     disp(mireg.VG.fname);
%     fprintf('\n\n\n');
%     [p n e] =spm_fileparts(rP(j,:));
%     tmp = [p filesep 'mut_p2_' n '.mat'];
%     Mfiles(j,1:numel(tmp)) = [p filesep 'mut_p2_' n '.mat'];
%     params(:,j) = spm_coreg_freeze_v01(mireg.VG, mireg.VF(j));
% end
%  matlabpool close
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%%%%% Coregister %%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:size(mireg.VF,1),  
    fprintf('\nSource image: ');
    disp(mireg.VF(j).fname);
    fprintf('\n\nTarget image: ');
    disp(mireg.VG.fname);
    fprintf('\n\n\n');
    [p n e] =spm_fileparts(rP(j,:));
    tmp = [p filesep 'mut_p2_' n '.mat'];
    Mfiles(j,1:numel(tmp)) = [p filesep 'mut_p2_' n '.mat'];
    params(:,j) = spm_coreg_freeze_v01(mireg.VG, mireg.VF(j));
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(dummy_write)
    EC_MO_write_rFiles(Mfiles,mireg,deblank(e));
end

if(dummy_disp)
    disp_ECMO(Mfiles,IN_freeze)
end
disp('All diffusion weighted images coregistered to B0')

