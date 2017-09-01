clear all;
clc;

n=8;
p=0.8;
q=0.2;

I = eye(n);
ix = randperm (n);
T = I(ix,:);

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
B =[A0 A1;A2 A3];

A=T*B*T'
