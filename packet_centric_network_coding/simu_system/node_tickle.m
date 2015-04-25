function simu_context = node_tickle(simu_context, node_id )
%NODE_STEP 结点运行一个时隙
%   Detailed explanation goes here
[simu_context,ok] = is_ok_to_send(simu_context,node_id);
if ~ok
    return;
end

nbor_id = choose_nbor(simu_context,node_id);
if ~is_nbor_ok(simu_context,nbor_id)
    return;
end

simu_context = send_to_nbor(simu_context,node_id,nbor_id);
end
%%
function simu_context = send_to_nbor(simu_context,node_id,nbor_id)
simu_context = acquire_channel(simu_context,node_id,nbor_id);
[simu_context,pack] = get_pack_to_send(simu_context,node_id);
simu_context = process_income_pack(simu_context,nbor_id,pack);
end
%%
function simu_context = acquire_channel(simu_context,node_id,nbor_id)
nodeNum = simu_context.nodeNum;
phyNBorMap = simu_context.phyNBorMap;
%RTS/CTS信道申请
for node_x = 1:nodeNum
    %任一结点，如果在这RTS/CTS范围内，就要标志为忙，这个时隙内无法传输。
    %phyNBorMap中，结点与自身不为邻结点。但因为通信双方互为邻结点，所以如下代码能正确将结点本身标识。
    if phyNBorMap(node_x,node_id) > 0 || phyNBorMap(node_x,nbor_id) > 0
        simu_context.nodes(node_x).is_busy = 1;
    end
end
end
%%
function [simu_context,pack] = get_pack_to_send(simu_context,node_id)
codeable_pack_num = ListSize(simu_context.nodes(node_id).coding_mems);
indx_rand = randi(codeable_pack_num)-1;%链表的Indx从0开始
pack = ListRemove(simu_context.nodes(node_id).coding_mems,indx_rand);%取出的是链表数据结构的一个结点
end
%%
function simu_context = process_income_pack(simu_context,node_id,pack)
    pack.left_hop = max(pack.left_hop - 1, 0);
    pack.hop_count = pack.hop_count + 1;
    
    if is_pack_codeable(pack,node_id)
        pack = encode_pack(simu_context,pack,node_id);
    end
    
    if is_pack_finished(pack)
        ListInsert(simu_context.nodes(node_id).code_finished_mems,pack);
    else
        ListInsert(simu_context.nodes(node_id).coding_mems,pack);
    end
end
%%
function ret = is_pack_codeable(pack,node_id)
ret = 1;
if ~(pack.left_hop <= 0 && pack.coeffs(node_id) == int32(0))
    ret = 0;
    return;
end
end
function pack = encode_pack(simu_context,pack,node_id) 
    pack.coeffs(node_id) = int32(1);
    pack.left_degree = pack.left_degree - 1;
    pack.left_hop = simu_context.tau;
end
function ret = is_pack_finished(pack)
    ret = pack.left_degree == 0;
end
function ret = is_channel_busy(simu_context,node_id)
ret = simu_context.nodes(node_id).is_busy;
end
function ret = has_no_pack_to_send(simu_context,node_id)
coding_pack_list = simu_context.nodes(node_id).coding_mems;
ret = ListEmpty(coding_pack_list);
end
function [simu_context,ret] = is_ok_to_send(simu_context,node_id)
    ret = 1;
    if is_channel_busy(simu_context,node_id)
        ret = 0;
        return;
    end

    if has_no_pack_to_send(simu_context,node_id)
        ret = 0;
        return;
    else
        simu_context.is_code_finished = 0;
        return;
    end
end
function ret = is_nbor_ok(simu_context,nbor_id)
ret = 1;
if nbor_id == -1%没有邻结点
    ret = 0;
    return;
end
%信道检查
if is_channel_busy(simu_context,nbor_id)%邻结点忙
    ret = 0;
    return;
end
end
