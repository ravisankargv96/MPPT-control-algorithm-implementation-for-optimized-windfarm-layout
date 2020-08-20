function time = time_delay(T1,T2,tdM)
[row,col]=find(tdM);

if(T1~=T2)
    ind=find(row==T1);j=col(ind);
    m=T1;n=j;sum=0;    
    while n~=T2
        sum=sum+tdM(m,n);
        m=n;
        ind=find(row==m);
        n=col(ind);
    end
    sum=sum+tdM(m,n);    
else
    sum=0;
end
time = sum;