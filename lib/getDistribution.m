 function distribution = getDistribution( inputNum,type,extra_data,gamma )
%SETDISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here
%%
%度受限分布=================================================================
switch(type)
    case 'degree_limit'
        distribution = zeros(1,inputNum);
        distribution(1) = extra_data;%<-N300M430;0.260487;%N300,0.263426036;N200
        distribution(gamma) = 1  - distribution(1);
%%
%robust siliton codes======================================================
    case 'robust_siliton'
        %理想分布
        distribution = zeros(1,inputNum);
        for indx = 2:inputNum
           distribution(indx) = 1/(indx*(indx-1));
        end
        distribution(1) = 1/inputNum;
        %第二步
        delta = 0.9;
        bound2 = floor(inputNum*0.35);
        bound1 = bound2 -1;
        tao = zeros(1,inputNum);
        for indx = 1:bound1
            tao(indx) = 1/(indx*bound2);
        end
        tao(bound2) = log(inputNum/(bound2*delta))/bound2;
        beta = 1 + sum(tao);

        distribution = (distribution + tao)./beta;
%%
%截断的siliton（用于raptor码中）============================================
    case 'cut_siliton'
        distribution = zeros(1,inputNum);
        for indx = 2:inputNum
           distribution(indx) = 1/(indx*(indx-1));
        end
        distribution(1) = 1/inputNum;

        %截断
        max_degree = extra_data;
        distribution((max_degree+1):inputNum) = 0;
        distribution = distribution./sum(distribution);
%%
%improved robust siliton
    case 'iLT'
        %理想分布
        distribution = zeros(1,inputNum);
        for indx = 2:inputNum
           distribution(indx) = 1/(indx*(indx-1));
        end
        distribution(1) = 1/inputNum;
        %第二步
        delta = 0.9;
        bound2 = floor(inputNum*0.35);
        tao = zeros(1,inputNum);

        tao(1) = 1/(bound2);
        tao(bound2) = log(inputNum/(bound2*delta))/bound2;
        beta = 1 + sum(tao);
        distribution = (distribution + tao)./beta;
end
end

