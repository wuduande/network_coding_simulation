%% foreach_simu: function description
function [ret] = foreach_node(nodes,do_func)
	nodes = context.nodes;
	nodeNum = length(nodes);
	ret = [];

	for indx = 1:nodeNum
		ret = do_func(ret,nodes(indx));
	end
