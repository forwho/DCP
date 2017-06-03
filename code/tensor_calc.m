function tensor_calc()
    if  isdir('DTI_DATA') %判断路径是否存在,若存在进入目录
        cd('DTI_DATA'); 
    else
        new_path=pwd;       
        disp_str=strcat(new_path,' did not have the folder of DTI_DATA'); 
        disp('Warning:')
        disp(disp_str)
        return;%可以返回数据，指示出错
    end
%将重写后fsl格式的bvec修改成dtk格式
    temp = dlmread('bvec_dtk');
    if size(temp, 2) ~= 3,
        dlmwrite('bvec_dtk', temp')
    end
    temp = dlmread('bval_dtk');
    if size(temp, 2) ~= 1,
        dlmwrite('bval_dtk', temp')
    end
    blank=32;

    imgstruct_4d = dir('eddy_*_4D.nii.gz');% nii or nii.gz

    nii_name=imgstruct_4d(1).name
%dti_recon
    bval_array = dlmread('bval_dtk');
    bval=bval_array(2);
    bval=int2str(bval);
%data(data_eddy.nii.gz) bvec(bvec_dtk), b0(1000)
%system(strcat(' dti_recon',blank,nii_name,blank,'dti -gm "bvec_dtk"   -b ',blank,bval,blank, '-b0 auto -iop 1 0 0 0 1 0  -p 3 -sn 1 -ot nii '));
    location=mfilename('fullpath');
    [pathstr,name,ext] = fileparts(location);%路径分割 
    system(strcat(pathstr,'\dti_recon',blank,nii_name,blank,'dti -gm "bvec_dtk " -b',blank,bval));
    copyfile('dti_b0.nii', '..\PARCELLATION/S0.nii');
end