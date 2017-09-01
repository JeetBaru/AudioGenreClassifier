clear all;
clc;
n=34;
load zachary.mat;
[V,D]=eig(A);
v=V(:,n-1);

w=[1,1,1,1,1,1,1,1,-1,-1,1,1,1,1,-1,-1,1,1,-1,1,-1,1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];

j=1;
k=1;

for i=1:n
    if v(i)>0
        wdash(i)=1;
        community1(j)=i;
        j=j+1;
    else
        wdash(i)=-1;
        community2(k)=i;
        k=k+1;
    end
end

sum1=0;
sum2=0;
            
for i=1:n
    if w(i)==wdash(i)
        sum1=sum1+1;
    end
    if w(i)==-wdash(i)
        sum2=sum2+1;
    end
end

rawoverlap=max(sum1,sum2);

overlap=(rawoverlap*2/n)-1;
display('Community 1: ');
display(community1);
display('Community 2: ');
display(community2);