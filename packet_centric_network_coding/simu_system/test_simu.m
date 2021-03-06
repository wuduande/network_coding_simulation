function [ output_args ] = test_simu( input_args )
%TEST_SIMU Summary of this function goes here
%   Detailed explanation goes here
N = 100;
distr = getDistribution(N,'ddllt',0.2,5);
gen = DegreeGenerator(distr);
tau = 4;

[simu_context is_exit_0] = simu(N,tau,gen);

nodes = simu_context.nodes;

sum_code_finished = 0;
sum_coding = 0;
sum_dg1 = 0;
sum_dg5 = 0;

for indx = 1:length(nodes)
    coding_pack_num = nodes(indx).coding_mems.ListSize();
    coded_pack_num = nodes(indx).code_finished_mems.ListSize();
    for indx_pack = 1:coding_pack_num
        pack = nodes(indx).coding_mems.ListGet(indx_pack-1);
        sum_dg1 = sum_dg1 + (sum(pack.coeffs) == 1);
        sum_dg5 = sum_dg5 + (sum(pack.coeffs) == 5);
    end
    for indx_pack = 1:coded_pack_num
        pack = nodes(indx).code_finished_mems.ListGet(indx_pack-1);
        sum_dg5 = sum_dg5 + (sum(pack.coeffs) == 5);
        sum_dg1 = sum_dg1 + (sum(pack.coeffs) == 1);
    end
    
    sum_coding = sum_coding + coding_pack_num;
    sum_code_finished = sum_code_finished + coded_pack_num;
end
sum_code_finished
sum_coding
sum_dg1
sum_dg5
end

