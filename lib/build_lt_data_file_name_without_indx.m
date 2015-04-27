function [ ret ] = build_lt_data_file_name_without_indx( N,tau)
%BUILD_DATA_FILE_NAME Summary of this function goes here
%   Detailed explanation goes here
ret = ['N',num2str(N),'_net_simu_robust_siliton','_tau_',num2str(tau)];
end

