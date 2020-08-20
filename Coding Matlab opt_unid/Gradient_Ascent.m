function ai =Gradient_Ascent(ds,ai_mat,k,tstart,Tsd)
Tst=5; st_a=0.001; st_t=10; K=0.003; F=reshape(ds,[1,length(ds)^2]); 
G=F(1:12); tou=0; LocGr=false; a_d=1.225; dia=80;

ai=ai_mat(k,:);

n=0;t=tstart+Tsd;
save('t.mat','t');
while (n~=1)
    tou=tou+st_t;
    if(tou>Tsd)
        A=[];b=[];Aeq=[];beq=[];nonlcon=[];
        lb = zeros(1,16);ub=(1/3)*ones(1,16);
        options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
        [ai,pow]=fmincon(@Power_func,ai,A,b,Aeq,beq,lb,ub,nonlcon,options);
        tou=0; n=1;
     end
end
    
            
            

        
        