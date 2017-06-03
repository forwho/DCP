function rotmat=decompose(affmat)
    aff3=affmat(1:3,1:3);
    x=affmat(1:3,1);
    y=affmat(1:3,2);
    z=affmat(1:3,3);
    sx=norm(x);
    sy=sqrt(dot(y,y)-(dot(x,y)^2)/(sx*sx));
    a=dot(x,y)/(sx*sy);
    x0=x/sx;
    y0=y/sy-a*x0;
    sz=sqrt(dot(z,z)-(dot(x0,z))^2-(dot(y0,z))^2);
    b=dot(x0,z)/sz;
    c=dot(y0,z)/sz;
    params(7)=sx;params(8)=sy;params(9)=sz;
    scales=zeros(3,3);scales(1,1)=sx;scales(2,2)=sy;scales(3,3)=sz;
    skew=[1 a b 0; 0 1 c 0; 0 0 1 0; 0 0 0 1];
    params(10)=a;params(11)=b;params(12)=c;
    rotmat=aff3*inv(scales)*inv(skew(1:3,1:3));
end