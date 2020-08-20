clc
clear all
A=[];b=[];Aeq=[];beq=[];lb = zeros(1,16);ub=zeros(1,16) + (1/3);nonlcon=[];ai0=0.32*ones(1,16);
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
ai=fmincon(@Power_func,ai0,A,b,Aeq,beq,lb,ub,nonlcon,options);