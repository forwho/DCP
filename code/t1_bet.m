function t1_bet(bet_path,filename,path,th)
dcm2nii_cmd = strcat(bet_path, '\', 'dcm2nii');
blank=32;
system(strcat(dcm2nii_cmd, blank, '-n n -s y -m n', blank, filename));
t1_temp=dir([path,'*img']);
t1_filename=[path,t1_temp(1).name];
bet_cmd=strcat(bet_path,'\','bet');
file_save=strcat(path,'b3D');
system(strcat(bet_cmd,blank,t1_filename,blank,file_save,blank,'-f',blank,num2str(th)));
strcat(dcm2nii_cmd, blank, '-n y -g n -m n', blank, 'b3D.img')
system(strcat(dcm2nii_cmd, blank, '-n y -g n -m n', blank, 'b3D.img'));
movefile fb3D.nii b3D.nii
end