fid=fopen('./california.dat');
a = textscan(fid, '%s %s %s');
b = char(a{1,1});
edgInd = find(b=='e');
clear b;
i = a{1,2};
i = str2num(char(i(edgInd)));
j = a{1,3};
j = str2num(char(j(edgInd)));
D=zeros(9664,2);
for k=1:16150
    in=i(k,1)+1;
    out=j(k,1)+1;
    D(in,1)=D(in,1)+1;
    D(out,2)=D(out,2)+1;
end