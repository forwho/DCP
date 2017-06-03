function dpb_convert(path)
if  isdir('DTI_DATA') %判断路径是否存在,若存在先删除
    rmdir('DTI_DATA','s')
end
if isdir('PARCELLATION') %判断路径是否存在,若存在先删除
    rmdir('PARCELLATION','s')
end
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
        cat=0; %default cat=0
        cat=dicm2nii_bvec(i-2);
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

  