function [ output_args ] = testGenerater( input_args )
%TESTGENERATER Summary of this function goes here
%   Detailed explanation goes here
N = 100;
dg = 5;
type = 'ddllt';
distribution = getDistribution(N,type,0.2,dg);
gen = DegreeGenerator(distribution);
gen.next()
end

