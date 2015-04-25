%% figure_energy_cost: function description
function figure_energy_cost(arg)
    addpath('..\lib');
	dgl_cost = zeros(5,1000);
	rbst_cost = zeros(1,1000);
    N_feild = 50:100:1000;
	for N = N_feild
		for gamma = 4:8;
			dgl_cost(gamma-3,N) = get_ddllt_cost_upper(N,gamma);
		end
		rbst_cost(N) = get_rbst_cost_lower(N);
	end

	figure(1);hold on;
	plot(N_feild,dgl_cost(1,N_feild),'d');
    plot(N_feild,dgl_cost(2,N_feild),'d');
    plot(N_feild,dgl_cost(3,N_feild),'d');
    plot(N_feild,dgl_cost(4,N_feild),'d');
    plot(N_feild,dgl_cost(5,N_feild),'d');
	plot(N_feild,rbst_cost(N_feild),'rd');
end

%% get_ddllt_cost: function description
function [ret] = get_ddllt_cost_upper(N,gamma)
	ret = gamma*log(N);
end
%% get_rbst_cost: function description
function [ret] = get_rbst_cost_lower(N)
	ret_part1 = log(N);

	distribution = getDistribution(N,'robust_siliton');
	ret_part2 = 0;
	for degree = 1:N
		ret_part2 = ret_part2 + degree*distribution(degree);
	end

	ret = ret_part1.*ret_part2;
end