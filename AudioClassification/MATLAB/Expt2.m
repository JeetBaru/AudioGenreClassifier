clear all;

n=8;
p=0.8;
q=0.2;

n2 = n/2;
P = random('bino', 1, p, n2, n2); % upper left block
dP2 = random('bino', 1, p, n2, 1); % diagonal of the lower right block
Q = random('bino', 1, q, n2, n2); % upper right block
% carve the two triangular and diagonal matrices that we need
U = triu(P, 1);
L = tril(P,-1);
dP = diag(P);
A0 = U + U' + diag(dP);
A1 = Q;
A2 = Q';
A3 = L + L' + diag(dP2);
A =[A0 A1;A2 A3];

[V,D]=eig(A);
v=V(:,n-1);

for i=1:n
    if v(i)>0
        wdash(i)=1;
    else
        wdash(i)=-1;
    end
end

for i=1:n
    if i<=n/2
        w(i)=1;
    else
        w(i)=-1;
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

overlap=(rawoverlap*2/n)-1
