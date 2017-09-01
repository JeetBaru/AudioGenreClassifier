n = 8280;
d = 8280;


k = 40;
G = 180 * rand(d,n);
% k = O(epsilon^(-2) * log(n))
epsilon = sqrt(log(n)/k)
%
% epsilon is really O( sqrt(log(n)/k) )
%
%
% Projection in dim k << d % let us take 
%Defining P (k x d) % first define
%q % 
q = min((log(n))^2/d,1); 
% 
P = rand(k,d); 
P = (P < q); 
P1 = 1/q * randn(k,d); P = P1 .* P; 
% % Defining H (d x d)
for i=1:8280
    for j=1:8280
    C=dot(i-1,j-1);
    H(i,j)=(1/sqrt(d))*(-1)^C;
    end
end

% % Defining D ( d x d) 
vec1=rand(d,1); 
v1 = ((vec1 > 0.5) - 1*(vec1<=0.5)); 
D = diag(v1); 
F= P * H * D; 
%u = FJLT * G(:,5); 
