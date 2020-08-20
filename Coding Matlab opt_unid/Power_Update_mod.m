function Pow = Power_Update_mod(ds,Vdel,ai_cell,itr,t)
idx=sum(~cellfun(@isempty,ds),1); % No of turbines in a column

Turbs=sum(idx);dia=80;K=0.084;

mini=min(ai_cell{itr});maxi=max(ai_cell{itr});
% % Penalising factor on power
% if(mini<0)
%     f1=0.3;f2=0.3;
% elseif(maxi>(1/3))
%     f1=0.3;f2=0.3;
% else
%     f1=1;f2=1;
% end
f1=1;f2=1;
    
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
            Bx = i{1}(1); By = i{1}(2)+abs(j{1}(2)-i{1}(2)); m_itr=itr;
            Ax = j{1}(1); Ay = j{1}(2); 
            Br = (dia+2*K*sqrt((j{1}(1)-i{1}(1)).^2 +(j{1}(2)-i{1}(2)).^2))/2; Ar = dia/2;
            % condition if previous ai{k} are not found then modifing
            % to present ai{k}
            d_ij=iter_p-1;  
            if(m_itr-d_ij <=0)
                m_itr = 1+d_ij;
            end 
            defVexp(i{1}(3),j{1}(3)) = (ai_cell{m_itr-d_ij}(i{1}(3))*(Ar/Br)^2*(Area_overlap(Bx,By,Ax,Ay,Br,Ar)/(pi*Ar^2)))^2;
        end
        iter_p=iter_p+1;
    end
end


defV = 2*sqrt(sum(defVexp,1)); % deficit velocities of each turbine are obtained (from defVexp array)
%%

k=itr;
for i=1:Turbs
    Vel(i,t)=Vdel(i,t)*(1-defV(i));
    Pow(i,t)=(4*ai_cell{k}(i)*(1-ai_cell{k}(i))^2)*Vel(i,t)^3*(f1*f2);
end


            
