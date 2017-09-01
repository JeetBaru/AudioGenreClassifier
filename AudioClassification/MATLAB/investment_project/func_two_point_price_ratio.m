function price_ratio=func_two_point_price_ratio(x,p,n)
% function price_ratio=func_two_point_price_ratio(x,p,n)
% price_ratio= n iid X with p_X(x(1))=p, p_X(x(2))=1-p

rand_walk=floor(rand(1,n)+(1-p))+1;
price_ratio=x(rand_walk);
