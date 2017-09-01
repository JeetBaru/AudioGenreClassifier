clear all;
q=1;
n=100;
for N=1:100
        for i=1:n
            for j=1:n
                if i==j
                    a(i,j)=sqrt(2).*(randn(1,1));
                    x(i,j)=sqrt(2).*(randn(1,1));
                else 
                    a(i,j)=randn(1,1);
                    x(i,j)=randn(1,1);
                end
            end
        end
        b=rand(n,n);
        y=rand(n,n);
        for i=1:n
            for j=1:n
               if b(i,j)>0.5;
                  b(i,j)=1;
               end
               if b(i,j)<0.5
                  b(i,j)=-1;
               end
               if y(i,j)>0.5;
                  y(i,j)=1;
               end
               if y(i,j)<0.5
                  y(i,j)=-1;
               end
            end
        end
        As=eig(complex(a,x));
        Bs=eig(complex(b,y));
        for k=1:n
            G(k,N)=As(k,1)/sqrt(n);
            B(k,N)=Bs(k,1)/sqrt(n);
        end
    end
o=reshape(G,N*n,1);
p=reshape(B,N*n,1);

