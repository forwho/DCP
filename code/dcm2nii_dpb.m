function dcm2nii_dpb(varargin)

    if nargin < 1
        disp('ERROR! dcm2nii_dpb.m need at least one Function Parameter! ');
        return;
    end    
    
    path=varargin{1};
    Path=dir(path);
    cd(path)    
    
    Scan_S=1;
    Scan_E=size(Path,1);    
    
    if nargin == 2 || nargin == 3
        S_folder_name=varargin{2};
        folder_ID=1;
        while(~strcmp(S_folder_name,Path(folder_ID).name))
            folder_ID=folder_ID+1;
            %没有找到提示错误，退出
           if(folder_ID == Scan_E+1)
                disp('ERROR! The start folder name is wrong! please check it!')
                return
          end
        end    
        Scan_S=folder_ID;
    end
    
    if nargin ==3
        if isnumeric(varargin{3})==1  %if the varargin{3} is number
            
            if Scan_S+varargin{3} < Scan_E
                Scan_E=Scan_S+varargin{3};
            else
                Scan_E=Scan_E;
            end
            
        else
            E_folder_name=varargin{3};
            folder_ID=1;
            while(~strcmp(E_folder_name,Path(folder_ID).name))
            folder_ID=folder_ID+1;
            %没有找到提示错误，退出
           if(folder_ID == Scan_E+1)
                disp('ERROR! The end folder name is wrong! please check it!')
                return
           end
        end    
        Scan_E=folder_ID;
        end
    end         
     
    if Scan_S > Scan_E
        temp=Scan_S;
        Scan_S=Scan_E;
        Scan_E=temp;
        clear temp;
    end
    
    for i=Scan_S:Scan_E
        if (Path(i).name=='.')
            continue;
        end
        if (strcmp(Path(i).name , '..'))
            continue;
        end

        if(Path(i).isdir==1)
            Path(i).name
            cd(Path(i).name);%进入个体内的子目录进行数据转换
            dicm_individual_convert();
            cd ..%转换为一个个体，退出个体目录
        end
    end
end
