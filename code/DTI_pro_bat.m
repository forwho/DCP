function DTI_pro_bat(folderpath)
%需要设定的参数-matrix构建以及后面属性计算


%获取template的路径
%.\...\code\代码路径  
%     \templates\模板路径
location=mfilename('fullpath');%obtain the file's absolute path while running it
[pathstr,name,ext] = fileparts(location);%路径分割 
[pathstr,name,ext] = fileparts(pathstr);%路径分割 
pathstr=strcat(pathstr,'\','templates')
aalpath =pathstr;
mni152path =pathstr;
clear name ext pathstr
% AAL_Coregister_without_O(folderpath,aalpath,mni152path) %90 分区 1024 分区配准
%AAL_Coregister_without_R(folderpath,aalpath,mni152path) %90 分区 1024 分区配准
AAL_Coregister_without_R_dpb(folderpath,aalpath,mni152path)

trk_Matrix(folderpath,0,0,90,0,0) %90脑区 fiber追踪，以及网络属性的计算
trk_Matrix(folderpath,0,0,1024,0,0) %90脑区 fiber追踪，以及网络属性的计算
end