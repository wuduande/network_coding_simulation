function simu_N_times(N,tau,dg,simu_times)
%AUTO_SIMU �趨��һ����ҵ�У�Ϊ����N�趨�����ֶȷֲ��ֱ���з���
%   Detailed explanation goes here
addpath('../rateless_coding');
addpath('../lib');

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

type = 'degree_limit_opt';
distribution = getDistribution( N,'degree_limit',p1,dg );
gen = DegreeGenerater(distribution);

parfor indx = 1:simu_times
    save_file_name = build_degree_limit_data_file_name(N,type,indx,tau,dg);
    if exist(save_file_name,'file')
        continue;
    end
    
    [simu_context is_succ] = simu(N,gen);

    if is_succ
        save(save_file_name, 'simu_context');
    end
end


end