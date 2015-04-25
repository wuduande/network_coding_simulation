function [ max_hop, mean_hop ] = system_statis(N,distribution,indx)
%SYSTEM_STATIS ���������ȫ��ͳ������
%   ͳ����������
%   1.ȫ��ƽ������
%   2.���������
addpath('..\lib');
load_globals(N,distribution,indx);
hop_data = get_hop_data();
max_hop = max(hop_data);
mean_hop = mean(hop_data);
end
function ret = get_hop_data()
    global code_redundence nodeNum nodes;
    hop_data = zeros(1,nodeNum*code_redundence);
    
    indx = 1;
    for node_id = 1:nodeNum
        pack_list = nodes(node_id).code_finished_mems;
        indx_bound2 = ListSize(pack_list);
        for indx2 = 0:indx_bound2-1
            pack_node = ListGet(pack_list,indx2);
            pack = pack_node.Data;
            
            hop_data(indx) = pack.hop_count;
            indx = indx + 1;
        end
    end
    ret = hop_data;
end