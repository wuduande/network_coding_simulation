 function distribution = getDistribution( symbol_num,distribution_type,p1,gamma )
%SETDISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here
%%
%�����޷ֲ�=================================================================
switch(distribution_type)
    case 'ddllt'%degree limit
        distribution = zeros(1,symbol_num);
        distribution(1) = p1;%<-N300M430;0.260487;%N300,0.263426036;N200
        distribution(gamma) = 1  - distribution(1);
%%
%robust siliton codes======================================================
    case 'lt'%robust siliton
        %����ֲ�
        distribution = zeros(1,symbol_num);
        for indx = 2:symbol_num
           distribution(indx) = 1/(indx*(indx-1));
        end
        distribution(1) = 1/symbol_num;
        %�ڶ���
        delta = 0.9;
        bound2 = floor(symbol_num*0.35);
        bound1 = bound2 -1;
        tao = zeros(1,symbol_num);
        for indx = 1:bound1
            tao(indx) = 1/(indx*bound2);
        end
        tao(bound2) = log(symbol_num/(bound2*delta))/bound2;
        beta = 1 + sum(tao);

        distribution = (distribution + tao)./beta;
%%
%�ضϵ�siliton������raptor���У�============================================
%     case 'cut_siliton'
%         distribution = zeros(1,symbol_num);
%         for indx = 2:symbol_num
%            distribution(indx) = 1/(indx*(indx-1));
%         end
%         distribution(1) = 1/symbol_num;
% 
%         %�ض�
%         max_degree = extra_data;
%         distribution((max_degree+1):symbol_num) = 0;
%         distribution = distribution./sum(distribution);
end
end

