function [ output_args ] = testGetDistribution( input_args )
%TESTGETDISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here
symbol_num = 10;
distribution_type = 'ddllt';
p1 = 0.2;
gamma = 5;

distribution_lt = getDistribution( symbol_num,distribution_type,p1,gamma )

distribution_type = 'lt';
distribution_ddllt = getDistribution( symbol_num,distribution_type )
plot(distribution_ddllt);
end

