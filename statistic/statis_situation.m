%% statis_situation: function description
function [ret] = statis_situation(context)
	nodes = context.nodes;
	ret = foreach_node(nodes,statis_node);

