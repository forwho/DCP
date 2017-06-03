function arrange_DTI()
if  isdir('DTI_DATA') %判断路径是否存在,若存在先删除
    rmdir('DTI_DATA','s')
end
  mkdir DTI_DATA
  DTI_folder_struct = dir('DTI_*');
  
  %需要几个DTI数据集，需要根据实际情况设定,
  % function arrange_DTI( dti_set)
  %if dti_set >0
  %   num=dti_set;
  %else
  %   num=numel(DTI_folder_struct);
  %  for i =1:num;
    global DTI_SPM_FLAG;
    %比较不同session的dim
    %dim_init=[0 0 0];
    dim_compare_flag=0;
    
    %
    %使用spm转换DTI数据,img 格式，并且需要将img merge成4D文件
    if DTI_SPM_FLAG == 1
        for i =1:numel(DTI_folder_struct)
            if strcmp(DTI_folder_struct(i).name,'DTI_DATA')%避免拷贝DTI_DATA
               continue;
            end
            cd(DTI_folder_struct(i).name); 
            
            %比较不同session的dim
            imgstruct_beforecopy = dir('*.nii');
            img_name=imgstruct_beforecopy(1).name
            t=spm_vol(img_name);
            if dim_compare_flag==1
                temp_dim=t.dim
                compare_result=sum(sum(temp_dim-dim_init));
                if compare_result ~= 0
                    dim_error='dim is not compareable between sessions,the DTI dataset only use first session or the compareable session';
                    dlmwrite('../DTI_DATA/dim_error', dim_error,'\t');
                    cd ..
                    continue; %和前一次的dim不同，continue，不拷贝img文件
                end
            else 
                dim_init=t.dim;
                dim_compare_flag=1;
            end
            clear imgstruct_beforecopy
            
            %可以使用move移动
            movefile('*nii','../DTI_DATA');       
            
            %因为DTI_DATA文件夹每次都要开始删除重新创建，所以可以用-append
            %bvec
            bvec_temp=dlmread('bvec')';
            dlmwrite('../DTI_DATA/bvec_dtk', bvec_temp,'-append'); 
            delete bvec
            %bval
            bval_temp=dlmread('bval')';
            dlmwrite('../DTI_DATA/bval_dtk', bval_temp,'-append'); 
            delete bval
            delete *.mat
            cd .. %个体内level       
        end % i =1:numel(DTI_folder_struct)
        
      cd DTI_DATA;
           %convert bvec from dtk style to fsl style
           bvec_fsl=dlmread('bvec_dtk')';
           dlmwrite('bvec.txt', bvec_fsl,'\t'); 
           
           bval_fsl=dlmread('bval_dtk')';
           dlmwrite('bval.txt', bval_fsl,'\t'); 


%         if ACID_EDDY_FLAG == 1
%             %涡流与头动矫正
%             pre_convert_3d();
%             eddy_correct_fd();
%             merger3d_4d('r*.nii');
%             
%             delete('*.img');
%             delete('*.hdr');  
%         else
%             %将img转换为4D文件，并删除中间的img和hdr文件
% %             matlabbatch = {};
% %             imgstruct = dir('*.img');
% %             for i =1:numel(imgstruct);
% %                 imgcells{i} =[imgstruct(i).name];
% %             end  
% %             matlabbatch{1}.spm.util.cat.vols=imgcells;
% %             spm_jobman('run',matlabbatch);
% % 
% %             %delete r*.nii
% %             %delete *.mat
% %             delete *img;
% %             delete *hdr;  
%              % pre_convert_3d();
%               merger3d_4d();
%               delete('*.img');
%               delete('*.hdr');
%   
%         end
%         %eddy_correct_flag==1
%         %rename the 4D nifti 
%         imgstruct_4d = dir('*.nii');
%         img_name=imgstruct_4d(1).name;
%         name_4d='DTI_4D.nii';
%         eval(['!rename ' img_name ' ' name_4d]);
       dti_files=dir('*.nii');
       first_file_v=spm_vol(dti_files(1).name);
       mat = spm_read_vols(first_file_v);
       [x,y,z,t]=size(mat);
       for i=2:numel(dti_files),
           eve_mat=spm_read_vols(spm_vol(dti_files(i).name));
           mat = cat(4,mat,eve_mat);
           delete(dti_files(i).name);
       end
       VG=first_file_v(1);
       VG.fname='DATA_4D.nii';
       my_write_vol_nii(mat,VG,'','');
       delete(dti_files(1).name);
       cd ..;  %cd DTI_DATA 退出DTI_DATA
       
    else %DTI_SPM_FLAG
        %没有使用spm 对DTI转换，直接拷贝dcm2nii 转换结果以及bval和bvec文件
         for i =1:numel(DTI_folder_struct)
            if strcmp(DTI_folder_struct(i).name,'DTI_DATA')
               continue;
            end
            cd(DTI_folder_struct(i).name); 
            
            %比较不同session的dim
            imgstruct_beforecopy = dir('*.nii');
            img_name=imgstruct_beforecopy(1).name
            t=spm_vol(img_name);
            if dim_compare_flag==1
                temp_dim=t.dim
                compare_result=sum(sum(temp_dim-dim_init));
                if compare_result ~= 0
                    dim_error='dim is not compareable between sessions,the DTI dataset only use first session or the compareable session';
                    dlmwrite('../DTI_DATA/dim_error', dim_error,'\t');
                    cd ..
                    continue; %和前一次的dim不同，continue，不拷贝img文件
                end
            else 
                dim_init=t.dim;
                dim_compare_flag=1;
            end
            clear imgstruct_beforecopy
            movefile('*nii', '../DTI_DATA');       

            %bvec
            bvec_temp=dlmread('bvec')';
            dlmwrite('../DTI_DATA/bvec_dtk', bvec_temp,'-append'); 
            delete bvec

            %bval
            bval_temp=dlmread('bval')';
            dlmwrite('../DTI_DATA/bval_dtk', bval_temp,'-append'); 
            delete bval
            cd .. %个体内level       
        end % i =1:numel(DTI_folder_struct)
        
      cd DTI_DATA;
           %convert bvec from dtk style to fsl style
           bvec_fsl=dlmread('bvec_dtk')';
           dlmwrite('bvec.txt', bvec_fsl,'\t'); 
           
           bval_fsl=dlmread('bval_dtk')';
           dlmwrite('bval.txt', bval_fsl,'\t'); 

%         if ACID_EDDY_FLAG == 1
%             %涡流与头动矫正
%             pre_convert_3d();
%             eddy_correct_fd();
%             merger3d_4d('r*.nii');
%         else
%             pre_convert_3d();
%             merger3d_4d();            
%         end
%             %rename the 4D nifti
%             imgstruct_4d = dir('*.nii');
%             img_name=imgstruct_4d(1).name;
%    	        name_4d='DTI_4D.nii';
%             eval(['!rename ' img_name ' ' name_4d]);
       dti_files=dir('*.nii');
       first_file_v=spm_vol(dti_files(1).name);
       mat = spm_read_vols(first_file_v);
       [x,y,z,t]=size(mat);
       for i=2:numel(dti_files),
           eve_mat=spm_read_vols(spm_vol(dti_files(i).name));
           mat = cat(4,mat,eve_mat);
           delete(dti_files(i).name);
       end
       VG=first_file_v(1);
       VG.fname='DATA_4D.nii';
       my_write_vol_nii(mat,VG,'','');
       delete(dti_files(1).name);
       cd ..;  %cd DTI_DATA 退出DTI_DATA  
       
    end %spm_convert_flag==1
end