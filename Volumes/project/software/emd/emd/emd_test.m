% Performs the same test as in example2.c
mex emd_wrapper.c
supply = [.4 .2 .2 .1 .1];
demand = [.6 .2 .1];
cost = [ 3 5 2 ; 0 2 5 ; 1 1 3; 8 4 3; 7 6 5 ];
emd_wrapper(cost, supply, demand)
% correct answer is: 1.888888...

supply = hist(binornd(10,0.2,20,1),0:10);
demand = hist(binornd(10,0.4,10,1),0:10);

%supply = [10 0 0 0 0];
%demand = [0 0 1 1 1];

figure;
stem(supply,'o-');
hold on
stem(demand,'ro-')

cost = zeros(length(supply),length(demand));
for i=1:length(supply),
    for j=1:length(demand),
        cost(i,j) = norm(i-j);
    end
end

title(emd_wrapper(cost,supply,demand)*sum(demand)+(sum(supply)-sum(demand))*min(cost(cost(:)>0)))