%% foreach_situation: function description
function [out] = foreach_situation(file_prefix,do_func)
	path = 'result_data/';
	out = init_statis_context();

	for indx = 1:simu_data_num
		file = [file_prefix '_indx_' num2str(indx) '.mat'];
		load(file,'context');

		ret = do_func(context);
		out = merge_statis(out,ret);
	end

%% merge_statis: function description
function [statis] = merge_statis(statis,new_statis)
	statis.sample_num = statis.sample_num + new_statis.sample_num;
	statis.hop_count = statis.hop_count + new_statis.hop_count;
	statis.max_hop = statis.max_hop + new_statis.max_hop;
