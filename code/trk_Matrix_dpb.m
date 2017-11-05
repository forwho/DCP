function trk_Matrix_dpb(path,num,count)

%    if(num ~= 90 || num ~= 1024)
%        display_str=strcat(path,':fiber tracking wrong!');
%        disp(display_str);
%        return;
%    end
   %voxelsize = 2;
   global FN_FLAG;
   global FA_FLAG;
   global LENGTH_FLAG;
   global THRESHOLD_CUSTOME;
   threshold_custome = num2str(THRESHOLD_CUSTOME);
   global THRESHOLD_90;
   threshold_90 = num2str(THRESHOLD_90);
   global THRESHOLD_1024;
   threshold_1024 = num2str(THRESHOLD_1024);
   global INIT_ANGLE; 
   init_angle = num2str(INIT_ANGLE);
   global INIT_L_FA;
   init_l_fa = num2str(INIT_L_FA);
   global INIT_SEED;
   init_seed = num2str(INIT_SEED);
   dir_folder = path;
   Fibers={};
   %trkPath=fullfile(dir_folder,'\DTI_DATA\track_tmp.trk');
   trkPath=fullfile(dir_folder,['\DTI_DATA\dti_' init_angle '_' init_l_fa '_' init_seed '.trk']);
   if (num==1024)
    Templetpath=fullfile(dir_folder,'\PARCELLATION\waal1024.nii');
    trknetPath=[dir_folder,['\PARCELLATION\waal1024.nii_dti_', init_angle,'_',init_l_fa,'_',init_seed,'.trk']];
   end
    
   if(num==90)
     Templetpath=fullfile(dir_folder,'\PARCELLATION\waal90.nii');
     trknetPath=[dir_folder,'\PARCELLATION\waal90.nii_dti_', init_angle,'_',init_l_fa,'_',init_seed,'.trk'];
   end
   global PARTITION_TEMPLATE;
   [path name ext]=fileparts(PARTITION_TEMPLATE);
   if (num==0)
     Templetpath=fullfile(dir_folder,['\PARCELLATION\w' name ext]);
     trknetPath=[dir_folder '\PARCELLATION\w' name ext '_dti_', init_angle,'_',init_l_fa,'_',init_seed,'.trk'];
   end
   %trk_SPath=fullfile(dir_folder,'\DTI_DATA\dti.trk');
   %[header_s ~] = trk_read(trk_SPath,0);
   %[header tracks] = trk_read(trkPath,header_s.n_count);
   [header tracks] = trk_read(trkPath);
   voxelsize = header.voxel_size;
   for ii=1:length(tracks)
      Fibers{ii} = tracks(1,ii).matrix/ voxelsize(1);
   end
   FA_Path=fullfile(dir_folder,'\DTI_DATA\dti_fa.nii');
   VF = spm_vol(FA_Path);
   FA = spm_read_vols(VF);
   V = spm_vol(Templetpath);
   Atlas = spm_read_vols(V);
   [XLim YLim ZLim] = size(Atlas);
   RN = max(max(max(Atlas)));
   Matrix_FNum = zeros(RN,RN);    %分区fiber的个数
   Matrix_Voxel = zeros(RN,RN);   %分区voxel个数
   Matrix_FA= zeros(RN,RN);     %分区fiber平均FA值
   Matrix_Length = zeros(RN,RN);  %分区fiber平均长度
   Matrix_Length_inv= zeros(RN,RN);
   Matrix_FA_Length_inv= zeros(RN,RN);
   nettracnum = 1; 
   for i2 = 1:length(Fibers)
        pStart = floor(Fibers{i2}(1,:)+1);
        pEnd = floor(Fibers{i2}(end,:)+1);
        pStart(2) = YLim+1-pStart(2);
        pEnd(2) = YLim+1-pEnd(2); 
        if pStart(1)>0 && pStart(1)<=XLim &&  pStart(2)>0 && pStart(2)<=YLim && pStart(3)>0 && pStart(3)<=ZLim && pEnd(1)>0 && pEnd(1)<=XLim && pEnd(2)>0 && pEnd(2)<=YLim && pEnd(3)>0 && pEnd(3)<=ZLim
            m = Atlas(pStart(1),pStart(2),pStart(3));
            n = Atlas(pEnd(1),pEnd(2),pEnd(3));
                if m >0 && n > 0 && m ~= n && m <= RN && n <= RN
                    %FN
                    if FN_FLAG==1,
                        Matrix_FNum(m,n) = Matrix_FNum(m,n) + 1;
                        Matrix_FNum(n,m) = Matrix_FNum(n,m) + 1;
                    end
                    tracksnetwork(1,nettracnum) = tracks(1,i2);
                    nettracnum = nettracnum+1;
                    Lengthtempone = [0];
                    FAtempone = [0];                 %计算FN并将用到的fiber写入到一个新的trk文件
                    for j=1:size(Fibers{i2},1)
                         point(j,:)=floor(Fibers{i2}(j,:)+1);
                         point(j,2) = YLim+1-point(j,2);
                         if point(j,1)>0 && point(j,1)<=XLim &&  point(j,2)>0 && point(j,2)<=YLim && point(j,3)>0 && point(j,3)<=ZLim
                             %FA
                             if FA_FLAG==1,
                                 Matrix_FA(m,n)=Matrix_FA(m,n)+FA(point(j,1),point(j,2),point(j,3));
                                 Matrix_FA(n,m)=Matrix_FA(n,m)+FA(point(j,1),point(j,2),point(j,3));
                                 Matrix_Voxel(m,n)=Matrix_Voxel(m,n)+1;
                                 Matrix_Voxel(n,m)=Matrix_Voxel(n,m)+1;
                                 FAtempone = FAtempone+FA(point(j,1),point(j,2),point(j,3));
                             end   
                             %Length
                             if LENGTH_FLAG==1,
                                 if(j>1)
                                     Lengthtemp = pdist([Fibers{i2}(j,:);Fibers{i2}(j-1,:)]);  
                                     Lengthtempone = Lengthtempone+Lengthtemp;
                                     Matrix_Length(m,n) = Matrix_Length(m,n) + Lengthtemp;
                                     Matrix_Length(n,m) = Matrix_Length(n,m) + Lengthtemp;
                                 end
                             end
                         end
                    end
                end     
        end
    end
    for il=1:RN
        for jl=1:RN
            if Matrix_Voxel(il,jl)~=0
                if FA_FLAG==1,
                     Matrix_FA(il,jl) = Matrix_FA(il,jl)./Matrix_Voxel(il,jl);
                end
                if LENGTH_FLAG==1,
                     Matrix_Length(il,jl) = Matrix_Length(il,jl)./Matrix_FNum(il,jl);
                end
            end
        end
    end

    header.n_count = nettracnum-1;
    trk_write(header,tracksnetwork,trknetPath)
        %save (MatrixPath,'Matrix_FNum','Matrix_FA','Matrix_Length','Matrix_Length_inv','Matrix_FA_Length_inv')    

 
   if (num==1024)
       %解决配准出错-模板无法读取数据导致RN=0，或者其它值时return
       if(RN<1024)
           Print_string='Something Wrong!';
           save Wrong_Matrix_1024 Print_string;
           return;
       end
      %save 1024_Matrixendin2mi_aal_wmmask_45_8.mat Matrix
      if FN_FLAG==1,
      Matrix_FNum(Matrix_FNum<=count)=0;
      str=['save MATRIX\Matrix_FNum_1024_' threshold_1024 '_' init_angle '_' init_l_fa '_' init_seed '.mat Matrix_FNum'];
      eval(str);
     dlmwrite(['MATRIX\Matrix_FNum_1024_' threshold_1024 '_' init_angle '_' init_l_fa '_' init_seed '.txt'],Matrix_FNum,'delimiter', '\t','precision','%.6f') 
      end
      if FA_FLAG==1,
      %Matrix_FA(Matrix_FNum<=count)=0;
      str=['save MATRIX\Matrix_FA_1024_' threshold_1024 '_' init_angle '_' init_l_fa '_' init_seed '.mat Matrix_FA'];
      eval(str);
    dlmwrite(['MATRIX\Matrix_FA_1024_' threshold_1024 '_' init_angle '_' init_l_fa '_' init_seed '.txt'],Matrix_FA,'delimiter', '\t','precision','%.6f') 
      end
      if LENGTH_FLAG==1,
      %Matrix_Length(Matrix_FNum<=count)=0;
      str=['save MATRIX\Matrix_Length_1024_' threshold_1024 '_' init_angle '_' init_l_fa '_' init_seed '.mat Matrix_Length'];
      eval(str);
      dlmwrite(['MATRIX\Matrix_Length_1024_' threshold_1024 '_' init_angle '_' init_l_fa '_' init_seed '.txt'],Matrix_Length,'delimiter', '\t','precision','%.6f') 
      end
      temp=strcat(path,'_1024');
      %network_properties_fornki(Matrix,500,temp)
   end
   if(num==90)
       %解决配准出错-模板无法读取数据导致RN=0，或者其它值时return
       if(RN<90)
           Print_string='Something Wrong!';
           save Wrong_Matrix_90 Print_string;
           return;
       end
      %save Matrixendin2mi_aal_wmmask_45_8.mat Matrix
      if FN_FLAG==1,
      Matrix_FNum(Matrix_FNum<=count)=0;
      Matrix_FNum=Matrix_FNum(1:90,1:90);
      str=['save MATRIX\Matrix_FNum_90_' threshold_90 '_' init_angle '_' init_l_fa '_' init_seed '.mat Matrix_FNum'];
      eval(str);
      
      dlmwrite(['MATRIX\Matrix_FNum_90_' threshold_1024 '_' init_angle '_' init_l_fa '_' init_seed '.txt'],Matrix_FNum,'delimiter', '\t','precision','%.6f') 
      end
      if FA_FLAG==1,
      %Matrix_FA(Matrix_FNum<=count)=0;
      Matrix_FA=Matrix_FA(1:90,1:90);
      str=['save MATRIX\Matrix_FA_90_' threshold_90 '_' init_angle '_' init_l_fa '_' init_seed '.mat Matrix_FA'];
      eval(str);
      dlmwrite(['MATRIX\Matrix_FA_90_' threshold_1024 '_' init_angle '_' init_l_fa '_' init_seed '.txt'],Matrix_FA,'delimiter', '\t','precision','%.6f') 
      end
      if LENGTH_FLAG==1,
      %Matrix_Length(Matrix_FNum<=count)=0;
      Matrix_Length=Matrix_Length(1:90,1:90);
      str=['save MATRIX\Matrix_Length_90_' threshold_90 '_' init_angle '_' init_l_fa '_' init_seed '.mat Matrix_Length'];
      eval(str);
     dlmwrite(['MATRIX\Matrix_Length_90_' threshold_1024 '_' init_angle '_' init_l_fa '_' init_seed '.txt'],Matrix_Length,'delimiter', '\t','precision','%.6f') 
      end
      temp=strcat(path,'_90');
%      network_properties_fornki(Matrix,500,temp);
   end 
   if(num==0)
       %解决配准出错-模板无法读取数据导致RN=0，或者其它值时return
      %save Matrixendin2mi_aal_wmmask_45_8.mat Matrix
      if FN_FLAG==1,
      Matrix_FNum(Matrix_FNum<=count)=0;
      str=['save MATRIX\Matrix_FNum_' threshold_custome '_' init_angle '_' init_l_fa '_' init_seed '.mat Matrix_FNum'];
      eval(str);
     dlmwrite(['MATRIX\Matrix_FNum_' threshold_1024 '_' init_angle '_' init_l_fa '_' init_seed '.txt'],Matrix_FNum,'delimiter', '\t','precision','%.6f') 
      end
      if FA_FLAG==1,
      %Matrix_FA(Matrix_FNum<=count)=0;
      str=['save MATRIX\Matrix_FA_' threshold_custome '_' init_angle '_' init_l_fa '_' init_seed '.mat Matrix_FA'];
      eval(str);
     dlmwrite(['MATRIX\Matrix_FA_' threshold_1024 '_' init_angle '_' init_l_fa '_' init_seed '.txt'],Matrix_FA,'delimiter', '\t','precision','%.6f') 
      end
      if LENGTH_FLAG==1,
      %Matrix_Length(Matrix_FNum<=count)=0;
      str=['save MATRIX\Matrix_Length_' threshold_custome '_' init_angle '_' init_l_fa '_' init_seed '.mat Matrix_Length'];
      eval(str);
     dlmwrite(['MATRIX\Matrix_Length_' threshold_1024 '_' init_angle '_' init_l_fa '_' init_seed '.txt'],Matrix_Length,'delimiter', '\t','precision','%.6f') 
      end
      temp=strcat(path,'');
%      network_properties_fornki(Matrix,500,temp);
   end 
   finish= ['finish  ' temp];
   display (sprintf(finish));
end
function trk_write(header,tracks,savePath)
%TRK_WRITE - Write TrackVis .trk files
%
% Syntax: trk_write(header,tracks,savePath)
%
% Inputs:
%    header   - Header information for .trk file [struc]
%    tracks   - Track data struc array [1 x nTracks]
%      nPoints  - # of points in each track
%      matrix   - XYZ coordinates and associated scalars [nPoints x 3+nScalars]
%      props    - Properties of the whole tract
%    savePath - Path where .trk file will be saved [char]
%
% Output files:
%    Saves .trk file to disk at location given by 'savePath'.
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: TRK_READ

% Author: John Colby (johncolby@ucla.edu)
% UCLA Developmental Cognitive Neuroimaging Group (Sowell Lab)
% Apr 2010

fid = fopen(savePath, 'w');

% Write header
fwrite(fid, header.id_string, '*char');
fwrite(fid, header.dim, 'short');
fwrite(fid, header.voxel_size, 'float');
fwrite(fid, header.origin, 'float');
fwrite(fid, header.n_scalars , 'short');
fwrite(fid, header.scalar_name', '*char');
fwrite(fid, header.n_properties, 'short');
fwrite(fid, header.property_name', '*char');
fwrite(fid, header.vox_to_ras', 'float');
fwrite(fid, header.reserved, '*char');
fwrite(fid, header.voxel_order, '*char');
fwrite(fid, header.pad2, '*char');
fwrite(fid, header.image_orientation_patient, 'float');
fwrite(fid, header.pad1, '*char');
fwrite(fid, header.invert_x, 'uchar');
fwrite(fid, header.invert_y, 'uchar');
fwrite(fid, header.invert_z, 'uchar');
fwrite(fid, header.swap_xy, 'uchar');
fwrite(fid, header.swap_yz, 'uchar');
fwrite(fid, header.swap_zx, 'uchar');
fwrite(fid, header.n_count, 'int');
fwrite(fid, header.version, 'int');
fwrite(fid, header.hdr_size, 'int');

% Check orientation
[tmp ix] = max(abs(header.image_orientation_patient(1:3)));
[tmp iy] = max(abs(header.image_orientation_patient(4:6)));
iz = 1:3;
iz([ix iy]) = [];

% Write body
for iTrk = 1:header.n_count
    % Modify orientation back to LPS for display in TrackVis
    header.dim        = header.dim([ix iy iz]);
    header.voxel_size = header.voxel_size([ix iy iz]);
    coords = tracks(iTrk).matrix(:,1:3);
    coords = coords(:,[ix iy iz]);
    if header.image_orientation_patient(ix) < 0
        coords(:,ix) = header.dim(ix)*header.voxel_size(ix) - coords(:,ix);
    end
    if header.image_orientation_patient(3+iy) < 0
        coords(:,iy) = header.dim(iy)*header.voxel_size(iy) - coords(:,iy);
    end
    tracks(iTrk).matrix(:,1:3) = coords;
    
    fwrite(fid, tracks(iTrk).nPoints, 'int');
    fwrite(fid, tracks(iTrk).matrix', 'float');
    if header.n_properties
        fwrite(fid, tracks(iTrk).props, 'float');
    end
end

fclose(fid);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%