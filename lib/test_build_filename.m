function [ output_args ] = test_build_file_name(  )
%TEST_BUILD_LT Summary of this function goes here
%   Detailed explanation goes here
N = 100;
indx = 'XindxX';
tau = 'XtauX';
dg = 'XdgX';
build_lt_data_file_name( N,indx)
build_degree_limit_data_file_name( N,tau,dg,indx)
end

