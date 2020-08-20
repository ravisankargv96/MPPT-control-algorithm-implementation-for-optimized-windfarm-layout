function [ds,idx,Vel_Jen,defV] = Jensen_wake_model(V,time,Pos,ai)
K=0.084;dia=80;
% ds1=[1, 5, 9, 13;2, 6, 10, 14;3, 7, 11, 15;4, 8, 12, 16];
Turbs=size(Pos,2);
i=1;j=1;
for n=1:Turbs-1
    if(Pos(2,n)<Pos(2,n+1))
        ds{i,j}=Pos(:,n);        
        i=i+1;
    else
        ds{i,j}=Pos(:,n);
        i=1;
        j=j+1;
    end
end

if(Pos(2,Turbs)>Pos(2,Turbs-1))
    ds{i,j}=Pos(:,Turbs);
else
    i=1;j=j+1;
    ds{i,j}=Pos(:,n)
end

idx=sum(~cellfun(@isempty,ds),1); % No of turbines in a column
%% Calculating deficit velocity and storing in the array (defVexp)
for col=1:size(ds,2)
    iter_p=1;
    while(iter_p<=idx(col))
        j=ds(iter_p,col);
        if(isequal(j,ds(1,col)))
%             upS=ds(1,col);
            upS={};
        else
            upS=ds(1:iter_p-1,col);
        end
        for k=1:length(upS)
            i=upS(k);
            Bx = i{1}(1); By = i{1}(2)+abs(j{1}(2)-i{1}(2)); % change the formulae according to projection
            Ax = j{1}(1); Ay = j{1}(2); 
            Br = (dia+2*K*sqrt((j{1}(1)-i{1}(1)).^2 +(j{1}(2)-i{1}(2)).^2))/2; Ar = dia/2; 
            defVexp(i{1}(3),j{1}(3)) = (ai(i{1}(3))*(Ar/Br)^2*(Area_overlap(Bx,By,Ax,Ay,Br,Ar)/(pi*Ar^2)))^2;
        end
        iter_p=iter_p+1;
    end
end


defV = 2*sqrt(sum(defVexp,1)); % deficit velocities of each turbine are obtained (from defVexp array)
%% Each turbine velocity(38 x timesteps) is obtained for provided time steps
for i= 1:Turbs
    for t= time
        Vel_Jen(i,t) = V(t)*(1-defV(i));
    end
    sprintf('Turb: %d Jensen wake velocity',i)
end
end

