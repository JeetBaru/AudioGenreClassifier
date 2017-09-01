% *Change the classname and filename to InvestorYourStudentID
classdef Investor111111111 < handle
    properties
        % hold the stock pmf
        StockPmf
        count
        inccount
        %}
        % You may add other variables here for your to calculate
        % the allocation ratio
    end
    methods
        %This method create the object by taking the stock pmf.
        %*You need to change this function name to be the same as your classname
        function obj = Investor111111111(val)
            if nargin == 1
                if isnumeric(val)
                    obj.StockPmf = val;
                else
                    error('Value must be numeric')
                end
            end
            obj.count=0;
            obj.inccount=0;
        end
        %*You should modify this function to calculate your portfolio.
        % 1-b portion of your wealth is in cash and b portion is in stock.
        % The function input is (log2(your current wealth), yesterday's stock
        % ratio), which should not be changed.
        function b = allocateRatio(obj,current_wealth,last_x_stock_realization)
            %*use your own method to calculate how much portion of your
            % money will be in stock for today.
            % You may make b a function of your current wealth, past stock
            % ratios._
            obj.count=obj.count+1;
            
            exp=obj.StockPmf(1,1)*obj.StockPmf(1,2)+obj.StockPmf(2,1)*obj.StockPmf(2,2);
            
            expwealth=log2(exp)*obj.count;
            diff=current_wealth-expwealth;
            b=0.5-0.5*diff/(406);
            %{
            
            if last_x_stock_realization==1.4
                obj.inccount=obj.inccount+1;
            end

            if obj.inccount/obj.count>0.6
                b=0;
            end
            if obj.inccount/obj.count<=0.6
                b=1;
            end
            
            %}
        end
    end
end
