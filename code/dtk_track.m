function dtk_track() 
    
%     bvec --> bvec.old
%     bvec_old_name='bvec';
%     bvec_new_name='bvec.old';
%     eval(['!rename ' bvec_old_name ' ' bvec_new_name]);
%     bvec_fsl->bvec （convert to dtk style）
     
    
    
    
 
    % 下面的代码直接加在 生成4D文件后，涡流矫正
    
    %添加函数获取dtk fiber tracking 是需要的参数
    global INIT_BVAL;
    bval=INIT_BVAL;
    
    global INIT_ANGLE;
    angle=INIT_ANGLE;
    
    global INIT_INVERT;
    invert=INIT_INVERT;
    
    global INIT_L_FA;
    fa_low=INIT_L_FA;
    
    global INIT_H_FA;
    fa_high=INIT_H_FA;
    
    global INIT_SEED;
    seed=INIT_SEED;
    
    global INIT_SWAP;
    swap=INIT_SWAP;    
    
    dtk_code(angle,invert,fa_low,fa_high,seed,swap);% bval, degree, invert,low_fa,high_fa,seed,filter       
  
    cd ..;     
    %准备配准时用的SO.nii
  %  copyfile('DTI_DATA/dti_adc.nii', 'PARCELLATION/dti_adc.nii');      
end