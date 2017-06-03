function dicm_individual_convert()

path= pwd;
Path=dir(path);

j=1;%DTI数据集个数指示
k=1;%T1项数据集个数指示
for i=3:size(Path,1)
    if (Path(i).name=='.')
        continue;
    end
    if (strcmp(Path(i).name , '..'))
        continue;
    end
    %如果是文件夹，进入文件夹内
    if(Path(i).isdir==1)
        
        cd(Path(i).name);%进入文件夹内
         cat=0 %default cat=0
%         cat=dicm2nii_bvec();
        cd .. % 转换后跳出文件夹
        
        
        %对DTI DATASET文件夹进行重命名
        if cat==1
           old_name = Path(i).name;
           c=9;
           new_name=strcat('DTI_',int2str(j));
           j=j+1;
           rename_str=strcat('!ren ',c,old_name,c,new_name);
           eval(rename_str);
        end
        
         if cat==3
           old_name = Path(i).name;
           c=9;
           new_name=strcat('T1_',int2str(k));
           k=k+1;
           rename_str=strcat('!ren ',c,old_name,c,new_name);
           eval(rename_str);
        end        
    end   
end
 %如果有DTI DATASET，让DTI 所有数据考到DTI_DATA文件件里，包括data ,bvec,bval，
 if(j>1)
       arrange_DTI();
 end
  if(k>1)
       arrange_T1();
  end
  
  
  %step3:
  %dtk 纤维追踪
  dtk_track_flag=1  % debug
  if dtk_track_flag == 1
    dtk_track();
  end 
  
%配准  matrix构建
matrix_flag=1
if matrix_flag ==1
    DTI_pro_bat_dpb(path)
end   
end