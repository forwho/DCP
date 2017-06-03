function dpb_eddy()
   delete('dti*');
   delete('eddy*');
   delete('r*.nii');
   delete('*.mat');
   location = mfilename('fullpath');
   [pathstr,name,ext] = fileparts(location);
   system([pathstr '\bneddy -i DATA_4D.nii -o eddy_DTI_4D -ref 0']);
%    delete('*-*.nii'); 
%    pre_convert_3d();%img 4D或者3D转换成 nii 3D
%    eddy_correct_fd();%对若干个3D nii进行校正,产生前缀r的文件
%    imgstruct = dir('rDATA_4D*.nii');
%    for i =1:numel(imgstruct);
%        imgcells{i} =[imgstruct(i).name];
%        blur1(imgcells{i},imgcells{i},8);
%    end  
%    merger3d_4d('r*.nii');% 将r*前缀的3D nii文件合并成4D，同时删除其它nii文件
%    %删除img文件；
%    eddy_img = dir('eddy*.nii');
%    eval(['!rename ' char(eddy_img(1).name) ' eddy_DTI_4D.nii'] )
%    delete('*-*.nii'); 
   rotate_bvec();
end