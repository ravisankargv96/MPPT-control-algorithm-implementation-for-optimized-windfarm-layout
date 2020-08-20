function [ai_cell,TurPow,OrgPow,I_TurPow,I_OrgPow,time_hrs]=Calculations(ds,ai,Vdel,time,t_d,f_td,plotting)
% Initializing parameters iter,Tsd,Tst,Tstart,etc.
k=1; Tsd=ceil(max(t_d,[],'all'));Tst=5; a_d=1.225; dia=80; 
C=1e-6*(0.5)*a_d*(0.25*pi*dia^2);idx=sum(~cellfun(@isempty,ds),1);
% Maximum starting delay time (tstart)
for i=1:sum(idx)
    ix=find(f_td(i,:)~=0,1,'first');
    if isempty(ix)
        freedelay(i)=0;
    else
        freedelay(i)=ceil(f_td(i,ix));
    end
end
tstart=max(freedelay)+1;ai_cell{1}=ai;

% Deriving Turb_det from ds (Just done in Delayed Velocities)
Turb_det=reshape(ds,[size(ds,1)*size(ds,2),1]);
Turb_det=Turb_det(~cellfun('isempty',Turb_det));

% Iteration Loop
Total_iters=floor((time(end)-tstart)/Tsd)+1;
while (tstart+Tsd <= time(end))    
    ai_cell{k+1} = Gradient_Ascent_mod(ds,Turb_det,ai_cell,k,tstart,Tsd,Vdel);
    time_Ud(k) = tstart; tstart = tstart+Tsd;k=k+1;
    sprintf('Iteration=================>%d/%d',k,Total_iters)
end

% Power Calculation with updating ai
count=1;
while (count <= size(ai_cell,2)-1)
    t=time_Ud(count);
    Pow_V = C*Power_Update_mod(ds,Vdel,ai_cell,count+1,t);
    TurPow(:,count)=Pow_V(:,end);
    OrgPow(count)=sum(Pow_V,'all');
% Power Calculation without updating ai
    Pow_V = C*Power_Update_mod(ds,Vdel,ai_cell,1,t);
    I_TurPow(:,count)=Pow_V(:,end);
    I_OrgPow(count)=sum(Pow_V,'all');count=count+1;
    sprintf('Counting=================>%d/%d',count,Total_iters)
end
% Converting time_Ud in hours
time_hrs=time_Ud./3600;
% Total power plotting and comparing with initial power
if(plotting)
    plot(time_hrs,OrgPow)
    hold on
    plot(time_hrs,I_OrgPow)
    xlabel('hours');
    ylabel('power in MW');
    legend('Updated Power','Initial Power');
end