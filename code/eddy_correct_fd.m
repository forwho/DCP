function eddy_correct_fd() 
        imgstruct = dir('*-*.nii')
        % 增加判断是否有数据，可能有的数据集没有DTI数据集
        if numel(imgstruct)==0
            return;% 没有DTI数据
        end
        for i =1:numel(imgstruct);
            imgcells{i} =[imgstruct(i).name];
        end  
        rP=char(imgcells) %若干3D文件
        path=pwd;
        rP=strcat(rP,',1');
%         for i =1:numel(imgstruct);
%             rrP{i} = ['r' rP{i}]
%         end
%         rrP=strcat(path,'\',rrP);
%         rPG=rrP(1,:)  %第一个3D文件，即b0图像
        rP=strcat(path,'\',rP);
        PG=rP(1,:)  %第一个3D文件，即b0图像
        EC_MO_correction_dpb(PG,rP);
        %删除之前没有校正的图像，或者压缩成nii格式
        
        %ITK_correction(PG, rP);
        clear imgstruct imgcells PG rP 
end
function ITK_correction(PG, rP)
    PG_vol = spm_vol(PG);
    PG_volumes = spm_read_vols(PG_vol);
    for i=1:size(rP,1)
        temp_vol = spm_vol(rP(i,:));
        temp_volumes = spm_read_vols(temp_vol);
        correct_temp = matitk('rd', [1024,7,5,2],double(PG_volumes), double(temp_volumes));
        my_write_vol_nii(correct_temp, temp_vol,'r','');
    end
end