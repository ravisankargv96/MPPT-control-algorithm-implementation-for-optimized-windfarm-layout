
%% Jensen wake model
K=0.084;
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
%%
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
            Bx = i{1}(1); By = i{1}(2)+abs(j{1}(2)-i{1}(2));
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
        Vel(i,t) = V(t)*(1-defV(i));
    end
end

%% calculating delay time from upstream to downstream turbine

for col=1:size(ds,2)
    T=ds(1:idx(col),col);
%     iter_p = 1;
    for iter_p=1:length(T)
        i=T(iter_p);
        if (iter_p < length(T))
            j=T(iter_p+1);
            X = [i{1}(1:2),j{1}(1:2)]';
            t_d(i{1}(3),j{1}(3)) = pdist(X,'euclidean')/(0.5*(Vel(i{1}(3),1)+Vel(j{1}(3),1)));
        end
%         iter_p=iter_p+1;
    end
end
%%
Turb_det=reshape(ds,[size(ds,1)*size(ds,2),1]);
Turb_det=Turb_det(~cellfun('isempty',Turb_det));
%% Recalculating delayed velocity by considering ideal cases

for k=1:Turbs
    j=Turb_det(k);
    [p,q]=find(cellfun(@(x) isequal(x,j{1}),ds));uj=ds(1,q);
    X = [uj{1}(1:2),j{1}(1:2)]';
    f_td(k) = (pdist(X,'euclidean')/V(t-ceil(time_delay(uj{1}(3),j{1}(3),t_d))))...
        +time_delay(uj{1}(3),j{1}(3),t_d);
    for t=ceil(f_td(k))+1:length(time)
        Vdel(k,t) = V(t-ceil(f_td(k)));
    end
end

%% combining all above sections to get original delayed velocities

for i=1:Turbs
    for t=time
        OrgVel(i,t)=Vdel(i,t)*(1-defV(i));
    end
end






            
            










    