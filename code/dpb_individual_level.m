function dpb_individual_level(handles,name)

    path= pwd;
    %step1 转换
    global DICOM2NII_FLAG;
    if DICOM2NII_FLAG == 1
        set(handles.edit19,'String',['Running ' name ' Convert']);
        dpb_convert(path);
    end
    %step2 涡流矫正
    global EDDY_FLAG;
    if EDDY_FLAG == 1,
        set(handles.edit19,'String',['Running ' name ' Eddy Current']);
       cd(path)
       dti_data=dir('DTI_DATA');
       parcellation=dir('PARCELLATION');
       if isempty(dti_data),
           dpb_reform_dti();
       end
       if isempty(parcellation)
           dpb_reform_parcellation();
       end
       cd DTI_DATA;
       dpb_eddy()
       cd ..
    end
    %step3 张量计算
    global TENSOR_FLAG;
    if TENSOR_FLAG == 1,
        set(handles.edit19,'String',['Running ' name ' Tensor Calculator']);
        cd(path)
        tensor_calc();
    end
    %step4:
    %dtk 纤维追踪
    global DTK_FLAG;
    if DTK_FLAG == 1
       set(handles.edit19,'String',['Running ' name ' Tractography']);
       cd(path)
       cd DTI_DATA;
       dtk_track();
    end 

    %配准  matrix构建
    global MATRIX_FLAG;
    global AAL_1024_FLAG;
    global AAL_90_FLAG;
    global PARTITION_TEMPLATE;
    global THRESHOLD_CUSTOME;
    THRESHOLD_CUSTOME=0;
    global THRESHOLD_90;
    THRESHOLD_90=0;
    global THRESHOLD_1024;
    THRESHOLD_1024=0;
    if MATRIX_FLAG ==1
        set(handles.edit19,'String',['Running ' name ' Parcellation']);
       DTI_pro_bat_dpb(path)  
    end
    global MATRIX;
    if MATRIX == 1,
        set(handles.edit19,'String',['Running ' name ' Matrix']);
       cd(path)
       if  isdir('MATRIX') %判断路径是否存在,若存在先删除
           rmdir('MATRIX','s')
       end
       pause(1);
       mkdir MATRIX
       if AAL_1024_FLAG == 1
           count=THRESHOLD_1024;
           trk_Matrix_dpb(path,1024,count);
       end
       if AAL_90_FLAG == 1
           count=THRESHOLD_90;
           trk_Matrix_dpb(path,90,count);
       end
       if exist(PARTITION_TEMPLATE,'file'),
           count=THRESHOLD_CUSTOME;
           trk_matrix_dpb(path,0,count);
       end   
    end
    %network构建
    set(handles.edit19,'String',['Finished ' name]);


end