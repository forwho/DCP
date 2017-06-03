function dpb_reform_parcellation()
    modality=dir();
    mkdir PARCELLATION
    for i=3:length(modality),
        flag=0;
        if modality(i).isdir==1,
            cd(modality(i).name);
            nii=dir('*.nii');
            if length(nii)==1,
                vol=spm_vol(nii(1).name);
                if length(vol)==1,
                    flag=1;
                    matrix=spm_read_vols(vol);
                    if length(dir('co*nii'))==0,
                        my_write_vol_nii(matrix,vol,'co','');
                    end
                end
            else
                if length(dir('co*nii'))==1,
                    flag=1;
                end
            end
            cd ..
            if flag==1,
                t1file=dir([modality(i).name '\co*nii']);
                movefile([modality(i).name '\' t1file(1).name],'PARCELLATION');
                break
            end            
        end
    end
end