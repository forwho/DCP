function dcm2nii_cmd(dcm2nii_path,path)
dcm_cmd=strcat(dcm2nii_path,'\','dcm2nii');
blank=32;
system(strcat(dcm_cmd,blank,'-g n',blank,path));
end