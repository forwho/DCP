
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
function AAL_Coregister_without_R(folderpath,aalpath,MNI152path)


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
    
    source_folder=strcat(sun_dir,'\T1_1\co*')
    destination_folder=strcat(sun_dir,'\AAL\')
    copyfile( source_folder,destination_folder);  
    
    cd(temp);
    cd('AAL')  ;  
    delete('b3D*');
    delete('rb3D*');
    imgstruct_3d = dir('*.img');
    img_name=imgstruct_3d(1).name;
    name_3d='b3D.img';
    eval(['!rename ' img_name ' ' name_3d]);
    imgstruct_3d = dir('*.hdr');
    img_name=imgstruct_3d(1).name;
    name_3d='b3D.hdr';
    eval(['!rename ' img_name ' ' name_3d]);
    cd ../..; %    cd(temp);    cd('AAL')    
    
    %First step path
    S0path=strcat(sun_dir,'\AAL\S0.nii');
    b3Dpath=strcat(sun_dir,'\AAL\b3D.img,1') ;    %Second step path
    %Second step path
  
    %third step path
    b3D_mat=strcat(sun_dir,'\AAL\b3D_sn.mat');   %needn't change(expect '\' or '/') 

    %first step 
    matlabbatch{1}.spm.spatial.coreg.estimate.ref={S0path};
    matlabbatch{1}.spm.spatial.coreg.estimate.source={b3Dpath}; 



    %second step
    matlabbatch{2}.spm.spatial.normalise.est.subj.source={b3Dpath};
    matlabbatch{2}.spm.spatial.normalise.est.eoptions.template={MNI152path};

    %third step
    matlabbatch{3}.spm.util.defs.comp{1}.inv.comp{1}.sn2def.matname={b3D_mat};
    matlabbatch{3}.spm.util.defs.comp{1}.inv.space={S0path};
    matlabbatch{3}.spm.util.defs.fnames={aal90path;aal1024path};
    matlabbatch{3}.spm.util.defs.interp=0;  %²åÖµ
    matlabbatch{3}.spm.util.defs.savedir.saveusr={sun_dir};

    spm_jobman('run',matlabbatch);
    clear matlabbatch;
    
end
end
 