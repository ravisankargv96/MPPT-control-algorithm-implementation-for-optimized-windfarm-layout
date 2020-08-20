function Area = Area_overlap(Bx, By, Ax, Ay, Br, Ar)
X=[Bx,By;Ax,Ay];
d= pdist(X,'euclidean');
if (d < Br + Ar)
    a= Ar^2; b=Br^2; x = (a - b + d^2)/(2 * d); z = x^2; y = sqrt(a-z);    
    if(d <= abs(Br - Ar))
        Area= pi * min(a,b);
    else
        Area = a*asin(y/Ar) + b*asin(y/Br) - y*(x + sqrt(z+b-a));
    end
else
    Area = 0;
end


