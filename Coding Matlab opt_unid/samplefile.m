i=2;
% figure(1)
plot(time_hrs(i:end),OrgPow(i:end))
hold on
% figure(2)
plot(time_hrs(i:end),I_OrgPow(i:end))
xlabel('hours');
ylabel('power in MW');
legend('Updated Power','Initial Power'); 
%%
save('60hrs_test10.mat')
%%
mini=0.5;
for i=1:length(ai_cell)    
    if(mini>min(ai_cell{i}))
        mini=min(ai_cell{i});
    end
end
%%
ai1=0.3116;
Cp=4*(ai1)*(1-ai1)^2;
%%
imp_power=sum(OrgPow);
int_power=sum(I_OrgPow);
increase=((imp_power-int_power)/int_power)*100;
powdiff= imp_power-int_power
%%
