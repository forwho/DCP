function arrange_T1()
  %默认应该使用一个数据集TI项，而不必所有的T1项都使用
  if isdir('PARCELLATION') %判断路径是否存在,若存在先删除
    rmdir('PARCELLATION','s')
  end
  mkdir PARCELLATION
  DTI_folder_struct = dir('T1_*');
    for i =1:numel(DTI_folder_struct);
        if strcmp(DTI_folder_struct(i).name,'DTI_DATA')
           continue;
        end
        cd(DTI_folder_struct(i).name); 
        %在配准的时候是使用的b3D2文件，复制后重命名了
        global T1_SKULL_FLAG
        if T1_SKULL_FLAG ==0
          copyfile('fb3D.nii','../PARCELLATION/b3D.nii');      
          cd ..
        else
            cd ..
            path_individual = pwd  
            source_folder=strcat(path_individual,'\T1_1\co*')
    	    destination_folder=strcat(path_individual,'\PARCELLATION\')
    	    copyfile( source_folder,destination_folder);     	  
            cd('PARCELLATION'); 
    	    imgstruct_3d = dir('*.nii');
            img_name=imgstruct_3d(1).name;
   	        name_3d='b3D.nii';
            eval(['!rename ' img_name ' ' name_3d]);
        end
        %cd ..;     
    end
end