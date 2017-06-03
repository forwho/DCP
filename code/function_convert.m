function function_convert()
path= pwd;
Path=dir(path);
size(Path);

for i=1:size(Path,1)
    if (Path(i).name=='.')
        continue;
    end
    if (strcmp(Path(i).name , '..'))
        continue;
    end
    
    if(Path(i).isdir==1)
        cd(Path(i).name)
        function_convert();
        cd ..
    end    
    mkdir test;
    
end
end