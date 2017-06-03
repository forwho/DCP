%notification
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
function AAL_Coregister(folderpath,aalpath,MNI152path)


Paths = dir(folderpath);
%MNI152path=strcat(MNI152path,'\','MNI152_T1_1mm_brain.nii,1');   

MNI152path=strcat(MNI152path,'\','MNI152_T1_1mm.nii,1');  
%third step path consitent
aal1024path=strcat(aalpath,'\','aal1024.nii,1');
aal90path=strcat(aalpath,'\','aal90.nii,1');

for SuN = 3:length(Paths)
    SuN;
    temp = Paths(SuN).name;
    if(Paths(SuN).isdir ~= 1)
        break;
    end
    sun_dir = strcat(folderpath,'\',temp);
    %First step path
    S0path=strcat(sun_dir,'\AAL\S0.nii');
    b3Dpath=strcat(sun_dir,'\AAL\b3D.img,1') ;   
    %Second step path
    rb3Dpath=strcat(sun_dir,'\AAL\rb3D.img,1');    %needn't change(expect '\' or '/')  
    %third step path
    rb3D_mat=strcat(sun_dir,'\AAL\rb3D_sn.mat');   %needn't change(expect '\' or '/') 
    %aal_save_path='F:\Data\Data_P\MCI_P\MCI02\';
    %first step 
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref={S0path};
    matlabbatch{1}.spm.spatial.coreg.estwrite.source= {b3Dpath};
    spm_jobman('run',matlabbatch);
    clear matlabbatch;
    pwd
    %rb3D 加一个adc mask
    adc_path=strcat(sun_dir,'\AAL\dti_adc.nii')
    adc=spm_read_vols(spm_vol(adc_path));
    adc(find(adc>0))=1;
    rb3D_path=strcat(sun_dir,'\AAL\rb3D.hdr')
    rb3d=spm_read_vols(spm_vol(rb3D_path));
    new=rb3d .* adc;
    b=load_untouch_nii(rb3D_path);
    K=make_nii(new);
    K.hdr=b.hdr;
    K.untouch=1;
    save_untouch_nii(K,rb3D_path)
    
    
    %second step
    matlabbatch{1}.spm.spatial.normalise.est.subj.source={rb3Dpath};
    matlabbatch{1}.spm.spatial.normalise.est.eoptions.template={MNI152path};

    %third step
    matlabbatch{2}.spm.util.defs.comp{1}.inv.comp{1}.sn2def.matname={rb3D_mat};
    matlabbatch{2}.spm.util.defs.comp{1}.inv.space={S0path};
    matlabbatch{2}.spm.util.defs.fnames={aal90path;aal1024path};
    matlabbatch{2}.spm.util.defs.interp=0;  %插值
    matlabbatch{2}.spm.util.defs.savedir.saveusr={sun_dir};
    spm_jobman('run',matlabbatch);
    clear matlabbatch;
end
end