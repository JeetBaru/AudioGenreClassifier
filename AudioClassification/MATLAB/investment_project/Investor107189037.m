% *Change the classname and filename to InvestorYourStudentID
classdef Investor107189037 < handle
    properties
        % hold the stock pmf
        StockPmf
        count
        diff
        %}
        % You may add other variables here for your to calculate
        % the allocation ratio
    end
    methods
        %This method create the object by taking the stock pmf.
        %*You need to change this function name to be the same as your classname
        function obj = Investor107189037(val)
            if nargin == 1
                if isnumeric(val)
                    obj.StockPmf = val;
                else
                    error('Value must be numeric')
                end
            end
            obj.count=0;
            obj.diff=0
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
            maxwealth=abs(3650*log2(exp));
            expwealth=log2(exp)*obj.count;
            obj.diff(obj.count)=abs(current_wealth)-abs(expwealth);
            if expwealth<0 
                b=0;
            else if expwealth>current_wealth
                b=0.5+0.5*atan(obj.diff(obj.count)/maxwealth)/1.57; 
                else
                    b=0.5-0.5*atan(obj.diff(obj.count)/maxwealth)/1.57;
                end
            end
        end
    end
end
