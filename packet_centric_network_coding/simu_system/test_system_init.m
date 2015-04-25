function [ output_args ] = test_system_init( input_args )
%TEST_SYSTEM_INIT Summary of this function goes here
%   Detailed explanation goes here
addpath('../../rateless_coding');
addpath('../../debug-tools');
simu_context = get_simu_context(100,15);
distr = getDistribution(100,'ddllt',0.2,5);
gen = DegreeGenerator(distr);
simu_context = simu_init(simu_context,gen);

nodes = simu_context.nodes;
len = length(nodes)
sum_coding_pack = 0;
sum_coded_pack = 0;
for indx = 1:len
    sum_coding_pack = sum_coding_pack + nodes(indx).coding_mems.ListSize();
    sum_coded_pack = sum_coded_pack + nodes(indx).code_finished_mems.ListSize();
end
sum_coding_pack
sum_coded_pack

draw_situation(nodes,simu_context.phyNBorMap);
end

