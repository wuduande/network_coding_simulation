function [simu_context is_exit_0] = simu(N,gen)
%��������ϵͳ����ָ��������N��distribustion�����з���
%�˷��棬���趪����Ϊ0
simu_context = get_simu_context(N);%N�����Ƿ���ʱ��ʵ���õĽ������Ϊ�˳��־������򣬻���΢�����ڵ�����
simu_context = simu_init(simu_context,gen);%��ʼ�����������������������������ú����Ժ�

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
    %��������û�б���ͨ��ʱ����ʾ����������Ѿ�������ɡ�
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