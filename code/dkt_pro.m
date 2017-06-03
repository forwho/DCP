function dkt_pro(folderpath,angle,invert,fa_low,fa_high,seed,filter)
%在纤维追踪前需进行涡流矫正和头动矫正+++未实现
%需要设定纤维追踪的参数
%bval 可以从文件中读取
Paths = dir(folderpath);
for SuN = 3:length(Paths)
    SuN;
    if (Paths(SuN).name=='.')
        continue;
    end
    if (strcmp(Paths(SuN).name , '..'))
        continue;
    end
    
    temp = Paths(SuN).name; %folder name
    if(Paths(SuN).isdir ~= 1)
        continue;
    end
    cd(temp);
    if  ~isdir('DTI_DATA') %判断路径是否存在，若不存在，跳过该文件夹
     continue;
    end
    
    cd('DTI_DATA'); 
    %bvec --> bvec.old
%     bvec_old_name='bvec';
%     bvec_new_name='bvec.old';
%     eval(['!rename ' bvec_old_name ' ' bvec_new_name]);
    %bvec_fsl->bvec （convert to dtk style）
    bvec_fsl=dlmread('bvec_fsl_rot')';
    % bvec_fsl=dlmread('bvec_fsl')';
    dlmwrite('bvec_dtk', bvec_fsl,'\t');     
    % 下面的代码直接加在 生成4D文件后，涡流矫正
    bval=1000;
%     angel=45;
%     invert=''y;
%     fa_low=0.1;
%     fa_high=1;
%     seed=1;
%     filter=1;% 大与1，不进行filter
    dtk_code(bval,angle,invert,fa_low,fa_high,seed,filter);% bval, degree, invert,low_fa,high_fa,seed,filter       
    %准备配准时用的SO.nii
    cd ..;
    %mkdir ALL
    copyfile('DTI_DATA/dti_b0.nii', 'AAL/S0.nii');
    copyfile('DTI_DATA/dti_adc.nii', 'AAL/dti_adc.nii');
    %返回data的根目录
    cd(folderpath);    
end