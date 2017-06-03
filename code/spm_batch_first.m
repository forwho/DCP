%notification��
%              
%the directory 	arrange like this
%               root/subject1/S0.nii
%                            /b3D.nii 
%                    subject2/S0.nii
%                            /b3D.nii
%
%Some directory should be changed
%         1 init_dir:this directory is the 'root' directory
%         2 MNI152path and aalpath should contain MNI152_T1_1mm_brain.nii
%         and aal.img(or all.nii)
%
%Linux or Windows
%         when use this in linux system,all directory should replace the
%         '\'by '/'
%
%by duanfei @ BNU
%             2013-8-27

clc
clear
init_dir='/data/s7/duanfei/a011/'
Paths = dir(init_dir)
 load('first_step.mat')
for SuN = 3:length(Paths)
    SuN
    temp = Paths(SuN).name
    if(Paths(SuN).isdir ~= 1)
        continue;
    end
    dir_folder = strcat(init_dir,temp)
    %First step path       
    
    S0path=strcat(dir_folder,'/AAL/S0.nii')
    b3Dpath=strcat(dir_folder,'/AAL/b3D.nii,1')    
   
    %first step 
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref={S0path};
    matlabbatch{1}.spm.spatial.coreg.estwrite.source= {b3Dpath};

   
    spm_jobman('run',matlabbatch);
    cd(dir_folder)
    cd AAL
    
    system('fslmaths rb3D.nii -mas mask.nii.gz rmb3D.nii')
    system('fslchfiletype NIFTI rmb3D.nii.gz rmb3D.nii')
    system('rm rmb3D.nii.gz')
    cd ../..

end

clear 
init_dir='/data/s7/duanfei/a011/'
MNI152path=strcat('/data/s7/duanfei/spm/','MNI152_T1_1mm_brain.nii,1');    
%third step path consitent
aalpath=strcat('/data/s7/duanfei/spm/','AAL1024.nii,1');
aalpath2=strcat('/data/s7/duanfei/spm/','aal.img,1');
Paths = dir(init_dir)
load('spm_bath.mat')
for SuN = 3:length(Paths)
    SuN
    temp = Paths(SuN).name
    if(Paths(SuN).isdir ~= 1)
        continue;
    end
    dir_folder = strcat(init_dir,temp)    
    
    
    %Second step path
    rb3Dpath=strcat(dir_folder,'/AAL/rmb3D.nii,1');    %needn't change(expect '\' or '/')  
    %third step path
    rb3D_mat=strcat(dir_folder,'/AAL/rmb3D_sn.mat');   %needn't change(expect '\' or '/') 
    %aal_save_path='F:\Data\Data_P\MCI_P\MCI02\';
   
    
    S0path=strcat(dir_folder,'/AAL/S0.nii')
    %second step
    matlabbatch{1}.spm.spatial.normalise.est.subj.source={rb3Dpath};
    matlabbatch{1}.spm.spatial.normalise.est.eoptions.template={MNI152path};

    %third step
    matlabbatch{2}.spm.util.defs.comp{1}.inv.comp{1}.sn2def.matname={rb3D_mat};
    matlabbatch{2}.spm.util.defs.comp{1}.inv.space={S0path};
    matlabbatch{2}.spm.util.defs.fnames={aalpath;aalpath2};    
    matlabbatch{2}.spm.util.defs.interp=0  %��ֵ
    matlabbatch{2}.spm.util.defs.savedir.saveusr={dir_folder}
    spm_jobman('run',matlabbatch);

end
