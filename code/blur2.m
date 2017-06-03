function result=blur(sV_mat,resel_size)
    bmaskx=make_blur_mask(resel_size,2);
    bmasky=make_blur_mask(resel_size,2);
    bmaskz=make_blur_mask(resel_size,2);
    result=convolve_separable(sV_mat,bmaskx,bmasky,bmaskz);
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
function result=convolve_separable(sV_mat,bmaskx,bmasky,bmaskz)
   midz=floor((length(bmaskz)-1)/2)+1;
   midy=floor((length(bmasky)-1)/2)+1;
   midx=floor((length(bmaskx)-1)/2)+1;
   s_mat=sV_mat;
   [a,b,c]=size(sV_mat);
   for z=1:c,
       for y=1:b,
           for x=1:a,
               val=0;
               for mx=1:length(bmaskx),
                   val=val+s_mat(min(max(x+mx-midx,1),a),y,z)*bmaskx(mx);
               end
               result(x,y,z)=val;
               for my=1:length(bmasky),
                   val=val+s_mat(x,min(max(1,y+my-midy),b),z)*bmaskx(my);
               end
               result(x,y,z)=val;
               for mz=1:length(bmaskz),
                   val=val+s_mat(x,y,min(max(1,z+mz-midz),c))*bmaskz(mz);
               end
               result(x,y,z)=val;
           end
       end
   end
end