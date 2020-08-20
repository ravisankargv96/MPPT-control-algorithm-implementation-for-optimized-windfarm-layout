% clear all
% FIRST
% SECOND

k=1; Tsd=ceil(max(t_d,[],'all'));  
Tst=5; a_d=1.225; dia=80; C=1e-6*(0.5)*a_d*(0.25*pi*dia^2); Lr=0.0026;

% Maximum starting delay time (tstart)
for i=1:sum(idx)
    ix=find(f_td(i,:)~=0,1,'first');
    if isempty(ix)
        freedelay(i)=0;
    else
        freedelay(i)=ceil(f_td(i,ix));
    end
end
tstart=max(freedelay)+1;


% for k=1:2
ai_cell{1}=ai;
while (tstart+Tsd <= time(end))    
    ai_cell{k+1} = Gradient_Ascent_mod(ds,Turb_det,ai_cell,k,tstart,Tsd,Vdel);
    %aiUd(k,:) =Gradient_Ascent(ds,ai,k,tstart,Tsd);
%     ai(k+1,:)=aiUd(k,:);
    time_Ud(k) = tstart; tstart = tstart+Tsd;
    %k=k+1,pow1,pow2
    k=k+1
end
%%%

% Power with updating ai
count=1;
while (count <= size(ai_cell,2)-1)
    t=time_Ud(count);
    Pow_V = C*Power_Update_mod(ds,Vdel,ai_cell,count+1,t);
    TurPow(:,count)=Pow_V(:,end);
    OrgPow(count)=sum(Pow_V,'all');
% Power without updating ai
    Pow_V = C*Power_Update_mod(ds,Vdel,ai_cell,1,t);
    I_TurPow(:,count)=Pow_V(:,end);
    I_OrgPow(count)=sum(Pow_V,'all');
    count=count+1
end
% Converting time_Ud in hours
time_hrs=time_Ud./3600;
%%%
% Total power plotting and comparing with initial power
plot(time_hrs,OrgPow)
hold on
plot(time_hrs,I_OrgPow)
xlabel('hours');
ylabel('power in MW');
legend('Updated Power','Initial Power');
%% Plotting Power Axial induction factor for 16 turbines
% for i=1
for i=1:16
    figure(i)
    [hAx,hLine1,hLine2]=plotyy(time_Ud,TurPow(i,:),time_Ud,aiUd(:,i));
%     hLine1.LineStyle = '--';
    hLine2.LineStyle = '--';
    str = sprintf('Power & AIF of Turbine %d',i);
    title(str)    
    xlabel('Hours')
    ylabel(hAx(1),'Turbine Power in MW') % left y-axis 
    ylabel(hAx(2),'Axial Induction Factor') % right y-axis
    hold on
    plot(time_Ud,I_TurPow(i,:),'k')
    legend('Upd Pwr','Base Pwr','Upd AIF')
end
%% Saving the above all plots into a temp folder
FolderName = tempdir;   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = get(FigHandle, 'Name');
  savefig(FigHandle, fullfile(FolderName, [FigName, '.fig']));
end

%%
x=1:size(TurPow,2);y=1:size(TurPow,1);
[X,Y]=meshgrid(x,y);
%subplot(1,2,1)
plot3(X,Y,TurPow,'x');
hold on
%subplot(1,2,2)
plot3(X,Y,I_TurPow,'.');
xlabel('Iterations');
ylabel('Turbines');
zlabel('Power in MW');

%%








        

