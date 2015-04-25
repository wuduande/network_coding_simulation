function [ ret ] = build_ddllt_data_file_name( N,tau,dg,indx)
%BUILD_DATA_FILE_NAME Summary of this function goes here
%   Detailed explanation goes here
ret = ['N',num2str(N),'_net_simu_degree_limit_tau_',num2str(tau),'_dg_',num2str(dg),'_indx_',num2str(indx),'.mat'];
end

