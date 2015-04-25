function [simu_context is_exit_0] = simu(N,gen)
%启动仿真系统，按指定参数（N，distribustion）进行仿真
%此仿真，假设丢包率为0
simu_context = get_simu_context(N);%N并不是仿真时真实采用的结点数。为了呈现矩形区域，会稍微变量节点数。
simu_context = simu_init(simu_context,gen);%初始化场景。这个必须放在其它参数配置好了以后。

nodeNum = simu_context.nodeNum;

round_count = 1;
while(1)
    sequence = randperm(nodeNum);
    for run_index =1:nodeNum
        node_id = sequence(run_index);
        simu_context = node_tickle(simu_context,node_id);
    end
    %channel update at the next tickle
    for clear_index =1:nodeNum
        if  simu_context.nodes(clear_index).is_busy
            simu_context.nodes(clear_index).is_busy =  simu_context.nodes(clear_index).is_busy - 1;
        end
    end
    %when to stop
    %当网络中没有编码通信时，表示所有码包都已经编码完成。
    if(simu_context.is_code_finished)
        is_exit_0 = 1;
        return;
    else
        simu_context.is_code_finished = 1;%reset the value
    end
    if round_count > 3000*4
        is_exit_0 = 0;
        return;
    end
    round_count = round_count +1;
    %show progress
    if mod(round_count,3000) == 0
        display(round_count);
%        if get_unfinished_pack_num() < nodeNum/50
%             break;
%        end
%        
%        if round_count > 20000
%            break;
%        end
    end
end
%-------------------------------------------------
end