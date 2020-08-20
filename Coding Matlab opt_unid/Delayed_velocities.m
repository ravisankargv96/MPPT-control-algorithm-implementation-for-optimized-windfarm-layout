
function [Jen_Vdel,Vdel,t_d,f_td,Turb_det]=Delayed_velocities(ds,idx,Vel_Jen,defV,V,time,ai)
%% calculating delay time from upstream to downstream turbine
for col=1:size(ds,2)
    T=ds(1:idx(col),col);

    for iter_p=1:length(T)
        i=T(iter_p);
        if (iter_p < length(T))
            j=T(iter_p+1);
            X = [i{1}(1:2),j{1}(1:2)]';
            t_d(i{1}(3),j{1}(3)) = pdist(X,'euclidean')/...
                (0.5*(Vel_Jen(i{1}(3),1)*(1-2*ai(i{1}(3)))+Vel_Jen(j{1}(3),1)));
        end

    end
end
%%
Turb_det=reshape(ds,[size(ds,1)*size(ds,2),1]);
Turb_det=Turb_det(~cellfun('isempty',Turb_det));

%% Recalculating delayed velocity by considering ideal cases
Turbs=sum(idx);
for k=1:Turbs
    j=Turb_det(k);
    [p,q]=find(cellfun(@(x) isequal(x,j{1}),ds));uj=ds(1,q);
    X = [uj{1}(1:2),j{1}(1:2)]'; max_time=0;
    for ti=ceil(time_delay(uj{1}(3),j{1}(3),t_d))+1:length(time)
        f_td(k,ti) = (pdist(X,'euclidean')/V(ti-ceil(time_delay(uj{1}(3),j{1}(3),t_d))))...
            +time_delay(uj{1}(3),j{1}(3),t_d);
        if(max_time<f_td(k,ti))
            max_time=ceil(f_td(k,ti));
        end
    end
    sprintf('Turb: %d Delayed velocity',k)
    array=ceil(time_delay(uj{1}(3),j{1}(3),t_d))+1:length(time);
    for t=max_time+1:length(time)
        Vdel(k,t) = V(t-ceil(f_td(k,t)));
    end
end

%% combining all above sections to get original delayed velocities

for i=1:Turbs
    for t=time
        Jen_Vdel(i,t)=Vdel(i,t)*(1-defV(i));
    end
end
end
