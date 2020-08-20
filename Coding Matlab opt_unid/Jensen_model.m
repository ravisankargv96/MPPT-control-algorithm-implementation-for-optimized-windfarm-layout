function Vel = Jensen_model(ds)
K=0.084;
for row=1:size(ds,1)
    count=1;
    while(count<5)
        j=ds(row,count);
        if(j==ds(row,1))
            upS=ds(row,1);
        else
            upS=ds(row,1:count-1);
        end
        for i=upS
            Bx = Pos(1,i); By = Pos(2,i)+abs(Pos(2,j)-Pos(2,i));
            Ax = Pos(1,j); Ay = Pos(2,j); 
            Br = (dia+2*K*abs(Pos(2,j)-Pos(2,i)))/2; Ar = dia/2; 
            defVexp(i,j) = (ai(i)*(Ar/Br)^2 ...
                *(Area_overlap(Bx,By,Ax,Ay,Br,Ar)/(pi*Ar^2)))^2;
        end
        count=count+1;
    end
end

defV = 2*sqrt(sum(defVexp,1));

for i= 1:numel(ds)
    for t= time
        Vel(i,t) = V(t)*(1-defV(i));
    end
end
