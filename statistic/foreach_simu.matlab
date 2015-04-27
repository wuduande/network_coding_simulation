%% foreach_node: function description
function [ret] = foreach_node(nodes,do_func,ret)
	nodes = context.nodes;
	nodeNum = length(nodes);

	for indx = 1:nodeNum
		ret = do_func(ret,nodes(indx));
	end
