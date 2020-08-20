function ai =Gradient_Ascent_mod(ds,Turb_det,ai_cell,k,tstart,Tsd,Vdel)
Tst=5; st_a=1e-5; st_t=10; K=1e-4; F=size(Turb_det); 
tou=0; LocGr=false; a_d=1.225; dia=80;
count=1;
for i=1:length(Turb_det)-1
    if(Turb_det{i}(2)<Turb_det{i+1}(2))
        G(count)=i;
        count=count+1;
    end
end


ai=ai_cell{k};
if(k==1)
    ai_prev=ai_cell{k};
else
    ai_prev=ai_cell{k-1};
end

for i=G
    t=tstart;
    pow = Power_Update_mod(ds,Vdel,ai_cell,k,t);
    
    P_b(i)=pow(i,t)*Vdel(i,t)^-3;    
    ai_b(i)=ai(i);
    ai(i)=ai_b(i)-st_a;
end
ai_cell{k}=ai;
n=0;
while (n~=1)
    tou=tou+st_t;
    if(tou>Tst && tou<=Tsd && LocGr==false)
        for i=G
%             [ir,ic]=find(ds==i); j=ds(ir,ic+1); 
            j=i+1;t=tstart+Tst;
            
            pow = Power_Update_mod(ds,Vdel,ai_cell,k,t);            
            P_t(i)=pow(i,t)*Vdel(i,t)^-3;            
            P_td(j)=pow(j,t)*Vdel(j,t)^-3; 
            
            Gr_Pt(i) = (P_t(i)-P_b(i))/(ai(i)-ai_prev(i));
            P_b(i)=P_t(i);
            P_bd(j)=P_td(j);
        end
        LocGr=true;
    else if(tou>Tsd)
            for i=G
                j=i+1; t=tstart+Tsd;
                
                pow = Power_Update_mod(ds,Vdel,ai_cell,k,t);
                P_td(j)=pow(j,t)*Vdel(j,t)^-3;
                
                Gr_Ptd(j) = (P_td(j)-P_bd(j))/(ai(i)-ai_prev(i));
                P_b(i) = P_t(i);
                ai_b(i) = ai(i);
                ai(i)=ai_b(i)+K*(Gr_Pt(i)+Gr_Ptd(j));
            end
            tou=0; LocGr=false; n=1;
        end
    end
end    
            
            

        
        