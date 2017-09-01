a=zeros(8,8);
for i=1:8
    for j=1:8
        if (1<=i && i<=j && j<=4) || (4<i && i<=j && j<=8)
            a(i,j)=1;
        end
        if 1<=i && i<=4 && 4<j && j<=8
            a(i,j)=0;
        end
    end
end
for i=1:8
    for j=1:8
        a(j,i)=a(i,j);
    end
end
a
            