function simu_context = simu_init(simu_context,gen)
%INIT_SIMU 为仿真系统初始化仿真场景。
%  包括：结点结点数据、仿真系统所要用到地图。
%初始化结点
addpath('../../lib/data_structure');
addpath('lib');
%<global init>
simu_context = put_nodes_in_grid(simu_context,gen);
simu_context = construct_phy_NBor_map(simu_context);

%全局控制信号
simu_context.is_code_finished = 1;
end

%
%node mem size:总缓存空间
%refuse reception threshold:当缓存占用多少时，拒绝接收新包
%code redundence:每个符号生成多少个重复码包
%
function simu_context = put_nodes_in_grid(simu_context,gen)
%目标功能：
%在尽可能接近正方形的平面空间内，按照预定密度放置所有结点。为此，可以稍微修改节点的总数。
%要求网络为网格拓扑。
%要求结点被初始化，生成目标度各不相同，但含有相同原始符号的码包。
    nx = simu_context.nx;
    nodeNum = simu_context.nodeNum;
    code_redundence = simu_context.code_redundence;
    grid_width = simu_context.grid_width;
    tau = simu_context.tau;

    for k=1:nodeNum
        simu_context.nodes(k).id = k;
        
        %设定位置
        x = mod(k-1,nx)*grid_width;
        y = floor((k-1)/nx)*grid_width;
        simu_context.nodes(k).pos = [x,y];
        
        %<初始化码包>-----------------------------------------------
        %--下一次编码前，还需传输的跳数
        pack.left_hop = tau;
        pack.hop_count = int32(0);
        
        %--构造编码系数
        tmp = int32(zeros(1,nodeNum));
        tmp(k) = int32(1);  
        pack.coeffs = tmp;
        
        %--复制b个初始包，放入“未完成编码码包”链表中。
        list = doubleLinkedList();
        for counter=1:code_redundence
            pack.left_degree = int32(gen.next() - 1);%还需编入的符号分量数
            ListInsert(list, pack);
        end
        simu_context.nodes(k).coding_mems = list;
        %--初始化“已完成编码码包”链表
        simu_context.nodes(k).code_finished_mems = doubleLinkedList();
        %</初始化码包>---------------------------------------------

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