%% foreach_node: function description
function [out] = foreach_node(nodes,do_func)
	nodes = context.nodes;
	nodeNum = length(nodes);
	out = init_statis_context();

	for indx = 1:nodeNum
		ret = do_func(nodes(indx));
		[out] = merge_statis(out,ret);
	end

%% merge_statis: function description
function [out] = merge_statis(out,ret)
	out.sample_num = out.sample_num + ret.sample_num;
	out.hop_count = out.hop_count + ret.hop_count;
	out.max_hop = max(out.max_hop, ret.max_hop);
