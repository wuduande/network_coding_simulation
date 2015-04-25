function [ output_args ] = lookintonode( node_id,which_queue )
%LOOKINTONODE Summary of this function goes here
%   Detailed explanation goes here
global nodes;
node = nodes(node_id);
switch(which_queue)
    case 'coding'
        ListDisp(node.coding_mems);
    case 'coded'
        ListDisp(node.code_finished_mems);
end
end

