function auto_simu(N,type_arg,tau,dg)
%AUTO_SIMU 设定在一次作业中，为参数N设定多少种度分布分别进行仿真
%   Detailed explanation goes here
addpath('lib');

simu_context.N = N;
%使得区域近乎方形，并调整结点的数量
tmp = sqrt(N);
simu_context.nx = floor(tmp);
simu_context.ny = ceil(tmp);
simu_context.nodeNum = simu_context.nx*simu_context.ny;
simu_context.code_redundence = 2;
simu_context.comRange = 10;
simu_context.sensor_density = 2;
simu_context.grid_width  = sqrt(simu_context.comRange^2/simu_context.sensor_density);
simu_context.is_code_finished = 1;%若未完成，会被置于0
simu_context.tau = tau;

simu_context.distribution = [];
% simu_context.round_count = [];
simu_context.nodes  = [];
simu_context.phyNBorMap = [];
% simu_context.record_indx = [];
simu_context.max_nb_num = [];%max neigbor num

if type_arg == 1
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
save_file_name = ['N',num2str(N),'_net_simu_',type];
if(~exist(save_file_name,'file'))
    simu_context.distribution = getDistribution( N,'degree_limit',p1,dg );
    simu_type(simu_context,type);
end

else
% type = 'cut_siliton';
% save_file_name = ['N',num2str(N),'_net_simu_',type];
% if(~exist(save_file_name,'file'))
%     clear global;
%     distribution_arg = getDistribution( N,'cut_siliton',4 );
%     simu_type(N,distribution_arg,type);
% end

% type = 'iLT';
% save_file_name = ['N',num2str(N),'_net_simu_',type];
% if(~exist(save_file_name,'file'))
%     clear global;
%     distribution_arg = getDistribution( N,'iLT' );
%     simu_type(N,distribution_arg,type);
% end

type = 'robust_siliton';
save_file_name = ['N',num2str(N),'_net_simu_',type];
if(~exist(save_file_name,'file'))
    simu_context.distribution = getDistribution( N,'robust_siliton' );
    simu_type(simu_context,type);
end
end
end

function simu_type(simu_context,type)
simu_times = 100;
success_times = 0;
N = simu_context.N;
nodeNum = simu_context.nodeNum;
grid_width = simu_context.grid_width;
nx = simu_context.nx;
ny = simu_context.ny;

for indx = 1:simu_times
    save_file_name = build_data_file_name(N,type,indx);
    if exist(save_file_name,'file')
        continue;
    end
    
    [simu_context is_succ] = system_setout(simu_context);
    success_times = success_times + is_succ;
    
    nodes = simu_context.nodes;
    phyNBorMap = simu_context.phyNBorMap;
    save(save_file_name, 'nodes','nodeNum','phyNBorMap','grid_width', 'nx', 'ny');
end
end
