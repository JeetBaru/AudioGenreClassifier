count=0;
inccount=0;
d=0;
function d=decide(currentwealth,laststock)
count=count+1;
%obj.expwealth=(0.111)*obj.count;
            
if laststock==1.4
    inccount=inccount+1;
end
     
if inccount/count>0.6
    d=0;
end
if inccount/count<=0.6
    d=1;
end
end 

