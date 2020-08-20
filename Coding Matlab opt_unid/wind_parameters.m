%% creating wind data
function [V,time] = wind_parameters(Vel_mean,hrs,plotting)
mu=Vel_mean;angle=90; rng(1);
time=1:hrs*(3600);teta=angle+randn(1,length(time));
V=12*ones(1,length(time));
% V= 12+0.01*randn(1,length(time));
% V=mu*ones(1,length(time));
wd(1,:)=V;wd(2,:)=teta;wd(3,:)=time;
t=time./3600;
if(plotting)
    plot(t,V)
    xlabel('Hours')
    ylabel('Wind speed')
end
end