function T_Pow = Power_func(ai_current)
load('fixed.mat')
load('ai_prev.mat')
load('t.mat')
ai(1:3,:) = ai_prev;
ai(4,:) = ai_current;
k=size(ai,1);


K=0.084;dia=80;

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
            Br = (dia+2*K*abs(Pos(2,j)-Pos(2,i)))/2; Ar = dia/2; d_ij=count-1;            
            defVexp(i,j)= (ai(k-d_ij,i)*(Ar/Br)^2 ...
                *(Area_overlap(Bx,By,Ax,Ay,Br,Ar)/(pi*Ar^2)))^2;
        end
        count=count+1;
    end
end

defV = 2*sqrt(sum(defVexp,1));


for i=1:16
    Vel(i,t)=Vdel(i,t)*(1-defV(i));
    Pow(i,t)=(4*ai(k,i)*(1-ai(k,i))^2)*Vel(i,t)^3;
end

ai_prev(1:3,:) = ai(2:4,:);


save('ai_prev.mat', 'ai_prev');
T_Pow = -sum(Pow,'all');



