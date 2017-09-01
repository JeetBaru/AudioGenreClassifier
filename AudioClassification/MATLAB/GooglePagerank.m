clear all;

H=loadlinks();%loadH

n=length(H);
alpha=0.99;
a=sum(H,2)==0;%indicator matrix
V(1:n,1)=1/9664;%Vector V
S=H+(a*V');%RowStochasticMatrix
e=ones(n,1);
G=alpha*S+(1-alpha)*e*V';%GoogleMatrix

%PowerMethod
r=ones(n,1);
finished=0;
p=0;
k=1;
limit=1e-8;
while(finished==0)
    p=r;
    r=G'*p;
    error(k)=(norm(r-p)/norm(r));
    finished=error(k)<limit;
    k=k+1;
end

[M,I]=sort(r,'descend');
loglog(1:k-1,error);
