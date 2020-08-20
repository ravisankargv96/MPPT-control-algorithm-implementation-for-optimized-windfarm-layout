%% model for calculating power ideally
clear all
clc
[Vel,time] = wind_parameters(12,1,false);         % Creating Wind_parameters
%%%
[X,Y,b]=Layout(2000,10,true);                        % Obtaining layout
%%%
[Pos,ai,Tot_Pow] = ideal_power(Vel,time,X,Y,b);     % Calculating ideal power without any wake effect
%%%
% Obtaining wake velocities and positions as cells from Jensen_wake_model
[ds,idx,Vel_Jen,defV] = Jensen_wake_model(Vel,time,Pos,ai); 
%%%
% Obtaining Delayed_Jen_wake_velocities & Delayed time from calculating maximum delay time in wind_farm
[Jen_Vdel,Vdel,turb_del,f_turbdel,Turb_det]=Delayed_velocities(ds,idx,Vel_Jen,defV,Vel,time,ai);
%%%
% Calculations Using GA algorithm
[ai_cell,TurPow,OrgPow,I_TurPow,I_OrgPow,time_hrs]=Calculations(ds,ai,Vdel,time,turb_del,f_turbdel,true);

