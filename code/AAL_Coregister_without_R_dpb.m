
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
%
%by duanfei @ BNU
%             2013-8-27
function AAL_Coregister_without_R_dpb(folderpath,aalpath,MNI152path)

    %third step path consitent
    aal1024path=strcat(aalpath,'\','aal1024.nii,1');
    aal90path=strcat(aalpath,'\','aal90.nii,1');
    partition_cell = {};
    global AAL_1024_FLAG;
    global AAL_90_FLAG;
    global PARTITION_TEMPLATE;
    if AAL_1024_FLAG==1,
        partition_cell=[partition_cell;aal1024path];
    end
    if AAL_90_FLAG==1,
        partition_cell=[partition_cell;aal90path];
    end
    if exist(PARTITION_TEMPLATE,'file')
        partition_cell=[partition_cell;PARTITION_TEMPLATE];
    end
    sun_dir = folderpath;    
    %source_folder=strcat(sun_dir,'\T1_1\co*')
    %destination_folder=strcat(sun_dir,'\AAL\')
   % copyfile( source_folder,destination_folder);  
    
    %cd('AAL');  
%     delete('b3D*');
%     delete('rb3D*');
%     
%     
   %imgstruct_3d = dir('co*.nii');
    %img_name=imgstruct_3d(1).name;
%     name_3d='b3D.img';
%     eval(['!rename ' img_name ' ' name_3d]);
%     imgstruct_3d = dir('*.hdr');
%     img_name=imgstruct_3d(1).name;
    %name_3d='b3D.nii';
   % eval(['!rename ' img_name ' ' name_3d]);
%     cd ..
    
    %First step path
    S0path=strcat(sun_dir,'\PARCELLATION\S0.nii')
    b3Dpath=strcat(sun_dir,'\PARCELLATION\b3D.nii')     %Second step path
    rb3Dpath=strcat(sun_dir,'\PARCELLATION\rb3D.nii') ;
    rb3D_mat=strcat(sun_dir,'\PARCELLATION\rb3D_sn.mat');   %needn't change(expect '\' or '/') 
    
    %first step 
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref={S0path};
    matlabbatch{1}.spm.spatial.coreg.estwrite.source={b3Dpath}; 
    spm_jobman('run',matlabbatch);
    clear matlabbatch;
    %1.S0.nii->fS0.img;2.bet fS0 fS0_mask;3.fS0_mask.img->fS0_mask.nii;4.maskT1 rb3D fS0_mask->rb3D_mask;3.
    location=mfilename('fullpath');%obtain the file's absolute path while running it
    [pathstr,name,ext] = fileparts(location);%Â·¾¶·Ö¸î 
    dcm2nii_cmd = strcat(pathstr, '\', 'dcm2nii');
    blank=32;
    system(strcat(dcm2nii_cmd, blank, '-n n -s y -m n', blank, S0path));
    t1_temp=dir([strcat(sun_dir, '\PARCELLATION\'),'fS0*']);
    t1_filename=[strcat(sun_dir, '\PARCELLATION\'),t1_temp(1).name];
    bet_cmd=strcat(pathstr,'\','bet');
    file_save=strcat(sun_dir,'\PARCELLATION\b0');
    system(strcat(bet_cmd,blank,t1_filename,blank,file_save,blank,'-m',blank,'-f',blank,'0.2'));
    system(strcat(dcm2nii_cmd, blank, '-n y -g n -m n', blank, strcat(sun_dir, '\PARCELLATION\b0_mask.img')));
    mask_T1(strcat(sun_dir, '\PARCELLATION\rb3D.nii'), strcat(sun_dir, '\PARCELLATION\fb0_mask.nii'));
    %second step
    matlabbatch{1}.spm.spatial.normalise.est.subj.source={rb3Dpath};
    matlabbatch{1}.spm.spatial.normalise.est.eoptions.template={MNI152path};
    %third step
    matlabbatch{2}.spm.util.defs.comp{1}.inv.comp{1}.sn2def.matname={rb3D_mat};
    matlabbatch{2}.spm.util.defs.comp{1}.inv.space={S0path};
    matlabbatch{2}.spm.util.defs.fnames=partition_cell;
    matlabbatch{2}.spm.util.defs.interp=0;  %²åÖµ
    matlabbatch{2}.spm.util.defs.savedir.saveusr={sun_dir};
    spm_jobman('run',matlabbatch);
    blank =32;
    eval(strcat('cd ',blank, sun_dir, '\PARCELLATION'));
    delete('*b0*');
    delete('*f*');
    delete('*.img');
    delete *.hdr
    cd ..
    movefile('w*.nii', 'PARCELLATION');
end
