clear all;

%loadH
H=loadlinks();

n=length(H);
alpha=0.9;

fid=fopen('./california.dat');
z = textscan(fid, '%s %s %s');
l = string(z{1,3});
links = l(1:n);

%normalization
%b=sum(H,2)==0;
%H=H./(sum(H,2)+b);

%indicator matrix
a=sum(H,2)==0;

%Vector V
%v=rand(n,1);
%V=v/sum(v);
V(1:n,1)=1/9664;

%RowStochasticMatrix
S=H+(a*V');

%GoogleMatrix
e=ones(n,1);
k=1;
for alpha=[0.99,0.95,0.85,0.75,0.5]
    G=alpha*S+(1-alpha)*e*V';

    %PowerMethod
    r=ones(n,1);
    finished=0;
    p=0;
    limit=1e-8;
    while(finished==0)
        p=r;
        r=G'*p;
        finished=(norm(r-p)/norm(r))<limit;
    end
    [M(:,k),I(:,k)]=sort(r,'descend');
    LinkRank(:,k)=links(I(:,k));
    k=k+1;
end