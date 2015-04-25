function auto_simu(N,simu_times)
%AUTO_SIMU �趨��һ����ҵ�У�Ϊ����N�趨�����ֶȷֲ��ֱ���з���
%   Detailed explanation goes here
addpath('../rateless_coding');
addpath('../lib');

type = 'robust_siliton';
distribution = getDistribution( N,type );
gen = DegreeGenerater(distribution);

parfor indx = 1:simu_times
    save_file_name = build_lt_data_file_name(N,type,indx);
    if exist(save_file_name,'file')
        continue;
    end
    
    [simu_context is_succ] = simu(N,gen);

    if is_succ
        save(save_file_name, 'simu_context');
    end
end

end