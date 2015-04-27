%% lt_job: function description
function [out] = lt_job()
	N = [100 200 300 400 500];
	tau = 27;
	simu_data_num = 100;

	av_hop = zeros(length(N));
	av_max_hop = zeros(length(N));

	path = 'result_data/';

	for indx = 1:5
		file_prefix = build_lt_data_file_name_without_indx(N,tau);
		file_prefix{indx_name} = [path file_prefix];

		out = foreach_situation(file_prefix,simu_data_num,statis_situation);
		av_hop(indx) = out.hop_count/out.sample_num;
		av_max_hop(indx) = out.max_hop/simu_data_num;
	end

	save('statis_result.mat');
	