function [Pos,ai,Total_Pow]= ideal_power(Vel,time,X,Y,b)
V=Vel;a_d=1.225; ind =1:sum(b); ai=(1/3)*ones(1,sum(b)); 
Pos=[X; Y;ind]; dia=80;

for i=1:sum(b)
    for t=time
        pow(t)=1e-6*(0.5)*a_d*(0.25*pi*dia^2)...
            *(4*ai(i)*(1-ai(i))^2)*V(t)^3;
    end
    Pow(i)= mean(pow);
end
Total_Pow=sum(Pow);
end
