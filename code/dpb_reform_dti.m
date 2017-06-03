function dpb_reform_dti()
    modality=dir();
    for i=3:length(modality),
        if modality(i).isdir==1,
            cd(modality(i).name);
            bvec=dir('*bvec*');
            if ~isempty(bvec),
                if ~strcmp(bvec(1).name,'bvec.txt')
                    movefile(bvec(1).name,'bvec.txt');
                end
                bval=dir('*bval*');
                if ~strcmp(bval(1).name,'bval.txt')
                    movefile(bval(1).name,'bval.txt');
                end
                dti=dir('*.nii');
                if ~isempty(dti),
                    if ~strcmp(dti(1).name,'DATA_4D.nii');
                        movefile(dti(1).name,'DATA_4D.nii');
                    end
                else
                    dti=dir('*.nii.gz'),
                    if ~strcmp(dti(1).name,'DATA_4D.nii.gz');
                        movefile(dti(1).name,'DATA_4D.nii.gz');
                    end
                end
            end
            cd ..
            if ~isempty(bvec),
                if ~strcmp(modality(i).name,['DTI_' num2str(i-2)]),
                    movefile(modality(i).name,['DTI_' num2str(i-2)]);
                end
            end
        end
    end
    mkdir('DTI_DATA');
    dti=dir('DTI_*');
    matrix=[];
    if ~isempty(dti),
        for i=1:length(dti),
            if dti(i).isdir==1&&(~strcmp(dti(i).name,'DTI_DATA')),
                bvec_temp=dlmread([dti(i).name '/bvec.txt'])';
                dlmwrite('DTI_DATA/bvec_dtk', bvec_temp,'-append'); 
                bval_temp=dlmread([dti(i).name '/bval.txt'])';
                dlmwrite('DTI_DATA/bval_dtk', bval_temp,'-append');  
                cd(dti(i).name);
                data_v=spm_vol('DATA_4D.nii');
                data_m=spm_read_vols(data_v);
                matrix=cat(4,matrix,data_m);
                cd ..
            end
        end
        if ~isempty(matrix),
            cd('DTI_DATA');
            bvec_fsl=dlmread('bvec_dtk')';
            dlmwrite('bvec.txt', bvec_fsl,'\t'); 
           
            bval_fsl=dlmread('bval_dtk')';
            dlmwrite('bval.txt', bval_fsl,'\t'); 
            my_write_vol_nii(matrix,data_v(1),'','');
            cd ..
        end
    end
end