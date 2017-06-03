function subsample_by_2(ref_vol,sub_vol)
    rV=spm_vol(ref_vol);
    sV=rV;
    sV.fname=sub_vol;
    sV.mat=sV.mat*2;
    sV.mat(4,1:4)=rV.mat(4,1:4);
    sV.mat(1:4,4)=rV.mat(1:4,4);
    sV.dim=floor((sV.dim+1)/2);
    r_vol=spm_read_vols(rV);
    rz=3;
    for z=2:sV.dim(3),
        ry=3;
        for y=2:sV.dim(2),
            rx=3;
            for x=2:sV.dim(1), 
                tem_vol(x,y,z)=0.125*r_vol(rx,ry,rz)+0.0625*(r_vol(rx+1,ry,rz)+r_vol(rx-1,ry,rz)+r_vol(rx,ry+1,rz)+r_vol(rx,ry-1,rz)+r_vol(rx,ry,rz+1)+r_vol(rx,ry,rz-1))+...
                0.0312*(r_vol(rx+1,ry+1,rz)+r_vol(rx+1,ry-1,rz)+r_vol(rx-1,ry+1,rz)+r_vol(rx-1,ry-1,rz)+r_vol(rx+1,ry,rz+1)+r_vol(rx+1,ry,rz-1)+r_vol(rx-1,ry,rz+1)+r_vol(rx-1,ry,rz-1)+...
                r_vol(rx,ry+1,rz+1)+r_vol(rx,ry+1,rz-1)+r_vol(rx,ry-1,rz+1)+r_vol(rx,ry-1,rz-1)+...
                0.0156*(r_vol(rx+1,ry+1,rz+1)+r_vol(rx+1,ry+1,rz-1)+r_vol(rx+1,ry-1,rz+1)+r_vol(rx+1,ry-1,rz-1)+r_vol(rx-1,ry+1,rz+1)+r_vol(rx-1,ry+1,rz-1)+...
                r_vol(rx-1,ry-1,rz-1)+r_vol(rx-1,ry-1,rz+1)));
                rx=rx+2;
                if x==32 && y==26 && z==9,
                    rx
                    ry
                    rz
                end
            end
            ry=ry+2;
        end
        rz=rz+2;
    end
    my_write_vol_nii(tem_vol,sV,'','');
end