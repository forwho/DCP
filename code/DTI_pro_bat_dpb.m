function DTI_pro_bat_dpb(folderpath)
%需要设定的参数-matrix构建以及后面属性计算


%获取template的路径
%.\...\code\代码路径  
%     \templates\模板路径
global STANDARD_TEMPLATE;
global PARTITION_TEMPLATE;
global AAL_1024_FLAG;
global AAL_90_FLAG;
global T1_SKULL_FLAG;
global BET_P;
try
    cd([folderpath '/PARCELLATION']);
catch
    warndlg('T1 file don''t exit','error');
    return;
end
T1files=dir('co*');
T1file_name=T1files(1).name;
location=mfilename('fullpath');%obtain the file's absolute path while running it
[pathstr,name,ext] = fileparts(location);%路径分割 
bet_path=pathstr;
if exist('b3D.nii')
    delete b3D.nii
end
copyfile(T1file_name,'b3D.nii');
if T1_SKULL_FLAG==0,
    path=[folderpath '/PARCELLATION/'];
    t1_bet(bet_path,T1file_name,path,BET_P);
%     b3D_vol=spm_vol('b3D.nii');
%     co_vol=spm_vol(T1file_name);
%     b3D_matrix=spm_read_vols(b3D_vol);
%     b3D_vol.mat=co_vol.mat;
%     my_write_vol_nii(b3D_matrix,b3D_vol,'','');
end
if ~exist(STANDARD_TEMPLATE,'file'),
    warndlg('Can''t find the template','error');
    return;
end
if ~exist(PARTITION_TEMPLATE,'file') && AAL_1024_FLAG==0 && AAL_90_FLAG==0,
    warndlg('Can''t find the atlas','error');
    return;
end
location=mfilename('fullpath');%obtain the file's absolute path while running it
[pathstr,name,ext] = fileparts(location);%路径分割  
[pathstr,name,ext] = fileparts(pathstr);%路径分割 
pathstr=strcat(pathstr,'\','templates')
aalpath =pathstr;
clear name ext pathstr
%AAL_Coregister_without_O(folderpath,aalpath,mni152path) %90 分区 1024 分区配准
%AAL_Coregister_without_R(folderpath,aalpath,mni152path) %90 分区 1024 分区配准
AAL_Coregister_without_R_dpb(folderpath,aalpath,STANDARD_TEMPLATE);
path=[folderpath '/PARCELLATION/'];
cd(path);
waal_files=dir('w*.nii');
global RESULT_FILE
for i=1:numel(waal_files)
    chkimage_dpb(waal_files(i).name);
    if exist(RESULT_FILE)
        subname=regexp(folderpath,'\','split');
        subname=subname(end);
        [waal_files(i).name '.png']
        savefile=strcat(RESULT_FILE,'\QC\',subname,waal_files(i).name,'.png')
        copyfile([waal_files(i).name '.png'], savefile{1});
    end
end

% trk_Matrix(folderpath,0,0,90,0,0) %90脑区 fiber追踪，以及网络属性的计算
%trk_Matrix_dpb(folderpath,90,0)
% trk_Matrix(folderpath,0,0,1024,0,0) %90脑区 fiber追踪，以及网络属性的计算
%trk_Matrix_dpb(folderpath,1024,30)
end