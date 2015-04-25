%% get_simu_context: function description
function [simu_context] = get_simu_context(N,tau)
%使得区域近乎方形，并调整结点的数�?
tmp = sqrt(N);
simu_context.nx = floor(tmp);
simu_context.ny = ceil(tmp);
simu_context.nodeNum = simu_context.nx*simu_context.ny;
simu_context.code_redundence = 2;
simu_context.comRange = 10;
simu_context.sensor_density = 2;
simu_context.grid_width  = sqrt(simu_context.comRange^2/simu_context.sensor_density);
simu_context.is_code_finished = 1;%若未完成，会被置�?
simu_context.tau = tau;

simu_context.distribution = [];
% simu_context.round_count = [];
simu_context.nodes  = [];
simu_context.phyNBorMap = [];
% simu_context.record_indx = [];
simu_context.max_nb_num = [];%max neigbor num
end