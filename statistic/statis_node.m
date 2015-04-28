%% statis_node: function description
function [ret] = statis_node(node)
	packs = node.code_finished_mems;
	sub_ret = foreach_pack(packs,statis_pack);