function ret = choose_nbor(simu_context, node_id )
%CHOOSE_NBOR Summary of this function goes here
%   Detailed explanation goes here
if has_no_nbor(simu_context,node_id)
    ret = -1;
    return;
end
rand_nbr_indx = get_rand_nbr_indx(simu_context,node_id);
ret = get_nth_nbor(simu_context,node_id,rand_nbr_indx);
end

function ret = has_no_nbor(simu_context,node_id)
ret = sum(simu_context.phyNBorMap(node_id,:)) == 0;
end

function ret = get_rand_nbr_indx(simu_context,node_id)
num_nbor = sum(simu_context.phyNBorMap(node_id,:));
ret = randi(num_nbor);
end

function ret = get_nth_nbor(simu_context,node_id,nbr_indx)
indxs = find(simu_context.phyNBorMap(node_id,:));
ret = indxs(nbr_indx);
end