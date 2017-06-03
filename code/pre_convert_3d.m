function  pre_convert_3d()

   path=pwd
   imgstruct = dir('DATA_4D.nii');
    for i =1:numel(imgstruct);
        path_4d=strcat(path,'\',imgstruct(i).name);
        convert4d_3d_dpb(path_4d)%将img 4D文件转换为3D nii 文件
    end 
    
    % 删除4D img 文件
    %for i =1:numel(imgstruct);
      % delete(imgstruct(i).name);
   % end 
    %delete('*hdr')
end
