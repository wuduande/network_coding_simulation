function [ ret ] = confirm_coded_pack()
%CONFIRM_CODED_PACK Summary of this function goes here
%   Detailed explanation goes here
confirm_finished_pack_degree()
confirm_pack_num()
get_unfinished_pack_num()
end

function ret = confirm_pack_num()
global nodeNum code_redundence;
total = get_finished_pack_num() + get_unfinished_pack_num();
if total == nodeNum*code_redundence
    ret = 1;
else
    ret = 0;
end
end

function [ ret ] = get_finished_pack_num()
%GET_UNFINISHED_PACK_NUM Summary of this function goes here
%   Detailed explanation goes here
global nodes nodeNum;
ret = 0;
for node_id = 1:nodeNum
    pack_list = nodes(node_id).code_finished_mems;
    ret = ret + ListSize(pack_list);        
end
end

function [ ret ] = get_unfinished_pack_num()
%GET_UNFINISHED_PACK_NUM Summary of this function goes here
%   Detailed explanation goes here
global nodes nodeNum;
ret = 0;
for node_id = 1:nodeNum
    pack_list = nodes(node_id).coding_mems;
    ret = ret + ListSize(pack_list);        
end
end

%%
function ret = confirm_finished_pack_degree()
    global nodes nodeNum;
    ret = 1;
    for indx = 1:nodeNum%each node
        node = nodes(indx);
        
        pack_list = node.code_finished_mems;
        indx_bound2 = ListSize(pack_list);
        %each pack
        for indx2 = 0:indx_bound2-1
            pack_node = ListGet(pack_list,indx2);
            if ~confirm_degree(pack_node.Data);
                ret = 0;
            end
        end
    end
end

function ret = confirm_degree(pack)
if pack.left_degree == 0
    ret = 1;
    return;
else
    ret = 0;
    return;
end
end