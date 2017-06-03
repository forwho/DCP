function blur1(source,target,resel_size)
    sV=spm_vol(source);
    xdim=abs(ceil(sV.mat(1,1)));
    ydim=abs(ceil(sV.mat(2,2)));
    zdim=abs(ceil(sV.mat(3,3)));
    bmaskx=make_blur_mask(resel_size,xdim);
    bmasky=make_blur_mask(resel_size,ydim);
    bmaskz=make_blur_mask(resel_size,zdim);
    convolve_separable(sV,target,bmaskx,bmasky,bmaskz);
end
function bmask=make_blur_mask(resel_size,dim)
    if abs(dim)<1e-8,
        return;
    end
    sampling_ratio=resel_size/dim;
    if sampling_ratio<1.1,
        return;
    end
    sigma=0.85*(sampling_ratio/2.0);
    if sigma<0.5,
        return;
    end
    n=(floor(sigma-0.001))*2+3;
    midn=floor(n/2)+1;
    for i=1:n,
        bmask(i)=exp(-((i-midn)^2/((sigma^2)*0.4)));
    end
    bmask=bmask/sum(bmask);
end
function convolve_separable(sV,target,bmaskx,bmasky,bmaskz)
   midz=floor((length(bmaskz)-1)/2)+1;
   midy=floor((length(bmasky)-1)/2)+1;
   midx=floor((length(bmaskx)-1)/2)+1;
   s_mat=spm_read_vols(sV);
   for z=1:sV.dim(3),
       for y=1:sV.dim(2),
           for x=1:sV.dim(1),
               val=0;
               for mx=1:length(bmaskx),
                   val=val+s_mat(min(max(x+mx-midx,1),sV.dim(1)),y,z)*bmaskx(mx);
               end
               result(x,y,z)=val/2.5;
               for my=1:length(bmasky),
                   val=val+s_mat(x,min(max(1,y+my-midy),sV.dim(2)),z)*bmaskx(my);
               end
               result(x,y,z)=val/2.5;
               for mz=1:length(bmaskz),
                   val=val+s_mat(x,y,min(max(1,z+mz-midz),sV.dim(3)))*bmaskz(mz);
               end
               result(x,y,z)=val/2.5;
           end
       end
   end
   sV.fname=target;
   my_write_vol_nii(result,sV,'','');
end