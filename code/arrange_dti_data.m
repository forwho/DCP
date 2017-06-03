function arrange_dti_data()
pwd
path= pwd;
Path=dir(path);
size(Path)

for i=1:size(Path,1)
    if (Path(i).name=='.')
        continue;
    end
    if (strcmp(Path(i).name , '..'))
        continue;
    end
    
    if(Path(i).isdir==1)
        cd(Path(i).name)
        arrange_dti();
        cd ..
    end
end

end

