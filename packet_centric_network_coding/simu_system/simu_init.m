function simu_context = simu_init(simu_context,gen)
%INIT_SIMU Ϊ����ϵͳ��ʼ�����泡����
%  ��������������ݡ�����ϵͳ��Ҫ�õ���ͼ��
%��ʼ�����
addpath('../../lib/data_structure');
addpath('lib');
%<global init>
simu_context = put_nodes_in_grid(simu_context,gen);
simu_context = construct_phy_NBor_map(simu_context);

%ȫ�ֿ����ź�
simu_context.is_code_finished = 1;
end

%
%node mem size:�ܻ���ռ�
%refuse reception threshold:������ռ�ö���ʱ���ܾ������°�
%code redundence:ÿ���������ɶ��ٸ��ظ����
%
function simu_context = put_nodes_in_grid(simu_context,gen)
%Ŀ�깦�ܣ�
%�ھ����ܽӽ������ε�ƽ��ռ��ڣ�����Ԥ���ܶȷ������н�㡣Ϊ�ˣ�������΢�޸Ľڵ��������
%Ҫ������Ϊ�������ˡ�
%Ҫ���㱻��ʼ��������Ŀ��ȸ�����ͬ����������ͬԭʼ���ŵ������
    nx = simu_context.nx;
    nodeNum = simu_context.nodeNum;
    code_redundence = simu_context.code_redundence;
    grid_width = simu_context.grid_width;
    tau = simu_context.tau;

    for k=1:nodeNum
        simu_context.nodes(k).id = k;
        
        %�趨λ��
        x = mod(k-1,nx)*grid_width;
        y = floor((k-1)/nx)*grid_width;
        simu_context.nodes(k).pos = [x,y];
        
        %<��ʼ�����>-----------------------------------------------
        %--��һ�α���ǰ�����贫�������
        pack.left_hop = tau;
        pack.hop_count = int32(0);
        
        %--�������ϵ��
        tmp = int32(zeros(1,nodeNum));
        tmp(k) = int32(1);  
        pack.coeffs = tmp;
        
        %--����b����ʼ�������롰δ��ɱ�������������С�
        list = doubleLinkedList();
        for counter=1:code_redundence
            pack.left_degree = int32(gen.next() - 1);%�������ķ��ŷ�����
            ListInsert(list, pack);
        end
        simu_context.nodes(k).coding_mems = list;
        %--��ʼ��������ɱ������������
        simu_context.nodes(k).code_finished_mems = doubleLinkedList();
        %</��ʼ�����>---------------------------------------------

        simu_context.nodes(k).is_busy = 0;%used to media access control
        simu_context.nodes(k).is_collected = 0;
    end
end

function simu_context = construct_phy_NBor_map(simu_context)
    nodes = simu_context.nodes;
    comRange = simu_context.comRange;
    nodeNum = simu_context.nodeNum;

    phyNBorMap = zeros(nodeNum,nodeNum);
    for k1 = 1:nodeNum
        for k2 = k1+1:nodeNum
            phyNBorMap(k1,k2) = (norm(nodes(k1).pos - nodes(k2).pos) < comRange);
        end
    end
    phyNBorMap = phyNBorMap + phyNBorMap';
    
    simu_context.max_nb_num = max(sum(phyNBorMap,1));
    simu_context.phyNBorMap = phyNBorMap;
end