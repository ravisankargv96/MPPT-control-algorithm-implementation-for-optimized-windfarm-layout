%% Layout
function [X,Y,b] = Layout(Upper_bound,Points,plotting)
% b=[1;1;1;1];
x=linspace(0,Upper_bound,Points);y=linspace(0,Upper_bound,Points);dia=80;
[A,B]=meshgrid(x,y);
%%%
load('b.mat');
A=reshape(A,[1,size(b,1)]);B=reshape(B,[1,size(b,1)]);
X=A(b==1);Y=B(b==1);
if(plotting)
    scatter(X,Y,'X','r');
    %title('Machine Learning method Turbs:38');
end
end