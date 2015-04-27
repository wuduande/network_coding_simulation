function lt_simu_N_times(N,tau,simu_times)
%AUTO_SIMU 设定在一次作业中，为参数N设定多少种度分布分别进行仿真
%   Detailed explanation goes here
display('lt simu x times with ');
display(['(N,tau)=' num2str(N) num2str(tau)]);

addpath('rateless_coding');
addpath('lib');
addpath('packet_centric_network_coding/simu_system');

type = 'lt';
distribution = getDistribution( N,type );
gen = DegreeGenerator(distribution);

results = cell(1,simu_times);
parfor indx = 1:simu_times
%     save_file_names{indx} = build_lt_data_file_name(N,indx);
%     if exist(save_file_names{indx},'file')
%         continue;
%     end
    
    [results{indx} is_succ] = simu(N,tau,gen);
end

path = 'result_data/';
for indx = 1:simu_times
    context = results{indx};
    save([path, build_lt_data_file_name(N,tau,indx)], 'context');
end
end