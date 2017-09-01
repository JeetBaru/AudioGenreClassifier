clear all;
close all;

%student ID in numeric array
%*Put your ID in the array below.
student_id=[107189037;222222222];
% change to string and prefix with Investor
student_classes = strcat('Investor',num2str(student_id));
%pmf of the stock:1st column: prob, 2nd column: values.
%*Try different pmf. This pmf will change in the final evaluation
a=0.4;
p=0.55;
pmf=[p 1+a
    1-p 1-a];
%10 years of investment
len_days=3650;

n_students=size(student_classes,1);
%get 10 years of stock up and down
x_stock_realization=func_two_point_price_ratio(pmf(:,2)',pmf(1,1),len_days);
%produce time line for drawing
time_line=1:1:len_days;

% mean_x=sum(pmf(:,1).*log2(pmf(:,2)))
% var_x=(sum(pmf(:,1).*(log2(pmf(:,2)).^2))-mean_x^2)/len_days

%--------------------------------------------------
% start investing for each student
%--------------------------------------------------
for k=1:n_students
    %total wealth exponent
    wealth=0;
    x_stock=0;
    % create object from students defined classes
    create_obj=str2func(student_classes(k,:));
    %skip if errors happen
    try
        investor=create_obj(pmf); 
    catch
        %warning('Class not submitted');
        cum_logmean(k)=-123;
        continue;
    end
    
    %--------------------------------------------------
    % start investing for each student
    %--------------------------------------------------
    
    for i_day=1:len_days
        %--------------------------------------------------------
        % Get portfolio allocation for the stock for this day
        % Wealth is current wealth exponent, x_stock is past stock
        % realization.
        %--------------------------------------------------------
        b=investor.allocateRatio(wealth,x_stock);
        % Catch allocation error
        if b<0 || b>1
            wealth=-132*len_days;
            break;
        end
        %today's price ratio
        x_stock=x_stock_realization(i_day);
        %--------------------------------------------------------
        % 1-b portion is in cash, b portion is in stock
        %--------------------------------------------------------
        wealth=wealth+log2((1-b)+b*x_stock);
        % record each day's wealth
        wealth_record(i_day)=wealth;
    end
    % get wealth exponent per day
    temp=wealth./(len_days);
    % wealth exponent per day will used for grading.
    cum_logmean(k)=temp;
    %draw figure of wealth
    figure(1);
    semilogy(time_line,2.^wealth_record,'r');
    hold on
    semilogy(time_line,2.^(cum_logmean(k)*(1:len_days)),'g');
    xlabel('day')
    ylabel('Wealth ($)')
    title('Wealth Growth');
end
cum_logmean
project_score_factor=0.5+0.5*(max(cum_logmean,0)/max(cum_logmean))
save('project_scores.mat','cum_logmean','project_score_factor')

