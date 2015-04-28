%% foreach_pack: function description
function [out] = foreach_pack(pack_list,do_func)
	out = init_statis_context();

	len = pack_list.ListSize(pack_list);
	for indx = 1:len
		ret = do_func(pack_list.ListGet(indx - 1));
		[out] = merge_statis(out,ret)
	end

	out.sample_num = len;

%% merge_statis: function description
function [out] = merge_statis(out,ret)
	out.hop_count = out.hop_count + ret.hop_count;
	out.max_hop = max(out.max_hop, ret.max_hop);
