% *Change the classname and filename to InvestorYourStudentID
classdef Investor222222222
    properties
        % hold the stock pmf
        StockPmf
        % You may add other variables here for your to calculate
        % the allocation ratio
    end
    methods
        %This method create the object by taking the stock pmf.
        %You don't need to modify anything here.
        function obj = Investor222222222(val)
            if nargin == 1
                if isnumeric(val)
                    obj.StockPmf = val;
                else
                    error('Value must be numeric')
                end
            end
        end
        %*You should modify this function to calculate your portfolio.
        % 1-b portion of your wealth is in cash and b portion is in stock.
        % The function input is (log2(your current wealth), yesterday's stock
        % ratio), which should not be changed.
        function b = allocateRatio(obj,current_wealth,last_x_stock_realization)
            %*use your own method to calculate how much portion of your
            % money will be in stock for today.
            % You may make b a function of your current wealth, past stock
            % ratios.
            b = 0.5;
        end
    end
end
