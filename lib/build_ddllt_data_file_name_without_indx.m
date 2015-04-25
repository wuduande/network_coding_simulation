function [ ret ] = build_ddllt_data_file_name_without_indx( N,tau,dg)
%BUILD_DATA_FILE_NAME Summary of this function goes here
%   Detailed explanation goes here
ret = ['N',num2str(N),'_net_simu_degree_limit_tau_',num2str(tau),'_dg_',num2str(dg)];
end
