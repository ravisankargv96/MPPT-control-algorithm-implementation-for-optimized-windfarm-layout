function Pow = Power_Update(ds,Pos,Vdel,ai_cell,itr,t)
idx=sum(~cellfun(@isempty,ds),1); % No of turbines in a column
Turbs=sum(idx);
% Finding min max in ai
% min=ai(itr,1); max=ai(itr,1);
mini=min(ai_cell{itr});maxi=max(ai_cell{itr});
% for i=1:16    
%     if(ai(itr,i)<min)
%         min=ai(itr,i);
%     elseif(ai(itr,i)>max)
%         max=ai(itr,i);
%     end
% end
% Penalising factor on power
if(min<0)
    f1=0;f2=1;
elseif(max>(1/3))
    f1=1;f2=0.9*((1/3)/max);
else
    f1=1;f2=1;
end
    
%%
% 
% K=0.084;dia=80;
% 
% for row=1:size(ds,1)
%     count=1;
%     while(count<5)
%         j=ds(row,count);
%         if(j==ds(row,1))
%             upS=ds(row,1);
%         else
%             upS=ds(row,1:count-1);
%         end
%         for i=upS
%             Bx = Pos(1,i); By = Pos(2,i)+abs(Pos(2,j)-Pos(2,i)); k=itr;
%             Ax = Pos(1,j); Ay = Pos(2,j); 
%             Br = (dia+2*K*abs(Pos(2,j)-Pos(2,i)))/2; Ar = dia/2; d_ij=count-1;
%             if(k-d_ij <=0)
%                 k = 1+d_ij;
%             end
%             defVexp(i,j)= (ai(k-d_ij,i)*(Ar/Br)^2 ...
%                 *(Area_overlap(Bx,By,Ax,Ay,Br,Ar)/(pi*Ar^2)))^2;
%         end
%         count=count+1;
%     end
% end
% 
%%
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
            Bx = i{1}(1); By = i{1}(2)+abs(j{1}(2)-i{1}(2));
            Ax = j{1}(1); Ay = j{1}(2); 
            Br = (dia+2*K*sqrt((j{1}(1)-i{1}(1)).^2 +(j{1}(2)-i{1}(2)).^2))/2; Ar = dia/2; 
            defVexp(i{1}(3),j{1}(3)) = (ai_cell{k}(i{1}(3))*(Ar/Br)^2*(Area_overlap(Bx,By,Ax,Ay,Br,Ar)/(pi*Ar^2)))^2;
        end
        iter_p=iter_p+1;
    end
end


defV = 2*sqrt(sum(defVexp,1)); % deficit velocities of each turbine are obtained (from defVexp array)
%%

k=itr;
for i=1:Turbs
    Vel(i,t)=Vdel(i,t)*(1-defV(i));
    Pow(i,t)=(4*ai(k,i)*(1-ai(k,i))^2)*Vel(i,t)^3*(f1*f2);
end


            
