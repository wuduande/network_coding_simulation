function ddllt_simu_N_times(N,tau,dg,simu_times)
%AUTO_SIMU 设定在一次作业中，为参数N设定多少种度分布分别进行仿真
%   Detailed explanation goes here
display('lt simu x times with ');
display(['(N,tau,dg)=' num2str(N) num2str(tau) num2str(dg)]);

addpath('rateless_coding');
addpath('lib');
addpath('packet_centric_network_coding/simu_system');

switch(N)
    case 50
        p1 = 0.374818822;
    case 100
        p1 = 0.311692099;%0.409566859722892;%0.518575458622288;%0.125339741994915;%0.275525844137450;%0.4096;%0.311692099;
    case 200
        p1 = 0.29679236;
    case 300
        p1 = 0.263474711;
    case 400
        p1 = 0.248577936;
    case 500
        p1 = 0.248577936;
end

type = 'ddllt';
distribution = getDistribution( N,type,p1,dg );
gen = DegreeGenerator(distribution);

results = cell(1,simu_times);
parfor indx = 1:simu_times
%     save_file_names{indx} = build_ddllt_data_file_name(N,tau,dg,indx);
%     if exist(save_file_names{indx},'file')
%         continue;
%     end
    
    [results{indx} is_succ] = simu(N,tau,gen);
end

path = 'result_data/';
for indx = 1:simu_times
    context = results{indx};
    save([path, build_ddllt_data_file_name(N,tau,dg,indx)], 'context');
end
end
