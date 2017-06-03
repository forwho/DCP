%cat =0 not a dti dataset
%cat =1 a dti dataset
%cat =2 UNKNOW DATASET    
%cat=3 T1 dataset

%需要设定的参数：剥头皮的f值
%现在只支持IMA格式-需扩展
function cat=dicm2nii_bvec(file_num)
%dicm2nii convert
mkdir('../PARCELLATION')
path=pwd;
dicomstruct = [dir('*.IMA'),dir('*dcm')];% 支持IMA格式的文件和XXXX格式文件
if numel(dicomstruct)==0   %没有IMA文件，UNKNOW DATASET    
    fprintf('UNKNOW DATASET \n');
    cat=2;
    return;    
end
%dicm2nii(path,path,'nii');
%转换前删除之前转换的文件，只留下dcm数据

delete *nii;

%删除old bvec和old bval
if exist('bvec')
    delete bvec
end
if exist('bval')
    delete bval
end
delete *bval
delete *bvec
%dcm2nii.exe 和bet.exe 文件所在文件夹路径
% dcm2nii_path='T:\matlabcode\code';% The path of dcm2nii.exe
% bet_path='T:\matlabcode\code'; %The path of bet.exe
location=mfilename('fullpath');%obtain the file's absolute path while running it
[pathstr,name,ext] = fileparts(location);%路径分割 
dcm2nii_path=pathstr;
bet_path=pathstr;
dcm_path=path;
dcm2nii_cmd(dcm2nii_path,dcm_path); %use dcm2nii.exe to convert .IMA or .DICOM to .img

%判断，如果是T1项，进行剥头皮处理
path=strcat(path,'\');
t1_temp=dir([path,'co*nii']);
num_t1=length(t1_temp);

if num_t1>=1    
    
%     global T1_SKULL_FLAG;
%     
%     if T1_SKULL_FLAG == 0
%         t1_filename=[path,t1_temp(1).name];
%         global BET_P
%         t1_bet(bet_path,t1_filename,path,BET_P);%可以设定剥头皮的f参数
%         fprintf('It is a T1 DATASET\n');
% 
%         %将剥头皮后的文件uint8格式修改为single
%         %data=spm_read_vols(spm_vol('b3D.hdr'));
%         %data_single=single(data);
%         %clear data;
%         %b=load_untouch_nii(t1_temp.name);
%         %K=make_nii(data_single);
%         %clear data_single;
%         %K.hdr=b.hdr;
%         %clear b;
%         %K.untouch=1;
%         %save_untouch_nii(K,'b3D2.nii');
%         %clear K;
%         %clear num_t1;  
%     end
    t1_filename=t1_temp(1).name;
    [' ../PARCELLATION/' t1_filename]
    copyfile(t1_filename,['../PARCELLATION/' t1_filename]);
    delete *.nii
    cat=3;
    return;
end

%判断是否为DTI数据，如果是DTI数据，使用spm再次进行转换
%如果不是DTI数据，直接返回即可
%通过dcm2nii 转换DTI数据产生的bvec文件判断
%creat bvec for dtk
temp1=dir([path,'*.bvec']);
num_temp1=length(temp1);
if length(temp1)==0
    fprintf('NOT a DTI DATASET\n');
    cat=0;
    return;
end

%使用spm对DTI进行转换
global DTI_SPM_FLAG;

%如果是DTIset，删除dcm2nii 转换的文件，用spm 转换
%只对DTI数据用SPM进行转换，有助于后面的配准工作

if DTI_SPM_FLAG == 1
    if exist('bvec')
        delete bvec
    end
    if exist('bval')
        delete bval
    end
    delete *nii;
    dicm2nii_spm(file_num);
end

%如果spm转换失败，重行用dcm2nii转换
dicomstruct = [dir('*.nii')];
if numel(dicomstruct)==0
    dcm2nii_cmd(dcm2nii_path,dcm_path); %use dcm2nii.exe to convert .IMA or .DICOM to .img  
end

fprintf('THIS is a DTI DATASET\n');
for i1=1:num_temp1
    filename=[path,temp1(i1).name];
    temp=dlmread(filename,'');
    dlmwrite('bvec_dtk',temp','-append');  %fsl-style
    cat=1;
end
temp = dlmread('bvec_dtk');
dlmwrite('bvec', temp');
delete bvec_dtk
delete(temp1.name);
%creat bval for dtk
temp1=dir([path,'*.bval']);
num_temp1=length(temp1);
for i1=1:num_temp1
    filename=[path,temp1(i1).name];
    temp=dlmread(filename,'');
    dlmwrite('bval_dtk',temp','-append'); 
end
temp = dlmread('bval_dtk');
dlmwrite('bval', temp');
delete bval_dtk
delete(temp1.name);
end