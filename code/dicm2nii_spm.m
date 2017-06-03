function dicm2nii_spm(file_num)
    dicomstruct = [dir('*.IMA'),dir('*dcm')];
    for i =1:numel(dicomstruct);
        dicomcells{i} =[dicomstruct(i).name];
    end
    
    %Clear the variable matlabbatch before you start filling it in again
    matlabbatch = {}; %Clear the variable matlabbatch before you start filling it in again   
    %Create the necessary elements of matlabbatch
    save_dir=pwd;
    matlabbatch{1}.spm.util.dicom.data = dicomcells';
    matlabbatch{1}.spm.util.dicom.root = 'flat';
    matlabbatch{1}.spm.util.dicom.outdir = {save_dir};  %Imported files go into the same anatomicals directory; needs the
                                                                                                      %cellstr wrapper
    matlabbatch{1}.spm.util.dicom.convopts.format = 'nii';
    matlabbatch{1}.spm.util.dicom.convopts.icedims = 0; 
    %Save the batch file (i.e., store just the variable matlabbatch in a
    %file named with the subject number, date and _dicom_import (e.g. CON2988_2011-03-10_dicom_import)  
    %Run it
    %clear dicomcells
    spm_jobman('run',matlabbatch);    
    niistruct = [dir('*.nii')];
    for j = 1:numel(niistruct);
        niicells{j} = [niistruct(j).name];
    end
    matlabbatch = {}; %Clear the variable matlabbatch before you start filling it in again   
    %Create the necessary elements of matlabbatch
    matlabbatch{1}.spm.util.cat.vols = niicells';
    matlabbatch{1}.spm.util.cat.name =strcat('data', int2str(file_num), '.nii');
    matlabbatch{1}.spm.util.cat.dtype = 4;
    spm_jobman('run',matlabbatch);
    for j = 1:numel(niistruct);
        delete(niistruct(j).name)
    end 
end
