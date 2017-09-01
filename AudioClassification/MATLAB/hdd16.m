
clear all
clc
n=300;
alpha=[5:50];
beta=[1:50];
n2=n/2;
c=0;
g=0;

for i=1:150
    w2(i)=1;
end
for i=151:300
    w2(i)=-1;
end

for l=1:46
  for j=1:50
      for m=1:2
       p=alpha(l)*(log(n)/n);
        q=beta(j)*(log(n)/n);
P=random('bino',1,p,n2,n2);
dP2=random('bino',1,p,n2,1);
Q=random('bino',1,q,n2,n2);
U = triu(P, 1);
L = tril(P,-1);
dP = diag(P);
A0 = U + transpose(U) + diag(dP);
A1 = Q;
A2 = Q.';
A3 = L + transpose(L)+ diag(dP2);
A =[A0 A1;A2 A3];

[v,d]=eig(A);
k=v(:,299);
%for i=1:300
  %  if k(i)>0
   %     disp('community 1');
   % else disp('community 2');
   % end
%end
y=transpose(k);

for i=1:300
if y(i)>0
    w1(i)=1;
else w1(i)=-1;
end
if w1(i)==w2(i)
       c(i)=1;
else c(i)=0;
    end
    if w1(i)==-w2(i)
        g(i)=1;
    else g(i)=0;
    end
end
  o=sum(c);
  u=sum(g);
e=max(o,u);
f(m)=((2/n)*e)-1;
z=mean(f);
      end
      
s(l,j)=z;
  end
end

imagesc(s);
hold on; 
h1 = ezplot('a-b-sqrt((2*a+2*b)/5.7)',[1 50 1 46]);
