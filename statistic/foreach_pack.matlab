%% foreach_pack: function description
function [ret] = foreach_pack(pack_list,do_func)
	len = pack_list.ListSize(pack_list);
	for indx = 1:len
		ret = do_func(ret, pack_list.ListGet(indx - 1));
	end
