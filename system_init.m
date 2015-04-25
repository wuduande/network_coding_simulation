function simu_context = system_init(simu_context)
%INIT_SIMU 为仿真系统初始化仿真场景。
%  包括：结点结点数据、仿真系统所要用到地图。
%初始化结点
addpath('lib\data_structure');
addpath('lib');
%<global init>
simu_context = put_nodes_in_grid(simu_context);
simu_context = construct_phy_NBor_map(simu_context);

%全局控制信号
simu_context.is_code_finished = 1;
end

%
%node mem size:总缓存空间
%refuse reception threshold:当缓存占用多少时，拒绝接收新包
%code redundence:每个符号生成多少个重复码包
%
function simu_context = put_nodes_in_grid(simu_context)
%目标功能：
%在尽可能接近正方形的平面空间内，按照预定密度放置所有结点。为此，可以稍微修改节点的总数。
%要求网络为网格拓扑。
%要求结点被初始化，生成目标度各不相同，但含有相同原始符号的码包。
    nx = simu_context.nx;
    ny = simu_context.ny;
    nodeNum = simu_context.nodeNum;
    code_redundence = simu_context.code_redundence;
    comRange = simu_context.comRange;
    sensor_density = simu_context.sensor_density;
    grid_width = simu_context.grid_width;
    tau = simu_context.tau;

    for k=1:nodeNum
        nodes(k).id = k;
        
        %设定位置
        x = mod(k-1,nx)*grid_width;
        y = floor((k-1)/nx)*grid_width;
        nodes(k).pos = [x,y];
        
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
            pack.left_degree = int32(get_target_degree(simu_context) - 1);%还需编入的符号分量数
            ListInsert(list, pack);
        end
        nodes(k).coding_mems = list;
        %--初始化“已完成编码码包”链表
        nodes(k).code_finished_mems = doubleLinkedList();
        %</初始化码包>---------------------------------------------

        nodes(k).is_busy = 0;%used to media access control
        nodes(k).is_collected = 0;
    end
    simu_context.nodes = nodes;
end
function targetDegree = get_target_degree(simu_context)
    distribution = simu_context.distribution;
    nodeNum = simu_context.nodeNum;

    rand_scalar = rand();
    for indx = 1:nodeNum
       if rand_scalar < distribution(indx)
           targetDegree = indx;
           break;
       else
           rand_scalar = rand_scalar - distribution(indx);
       end
    end
end
%density: comRange^2*nodeNum/area
% function init_nodes_random()
% global nodes nodeNum density comRange nodeMemSize;
% area_width = floor(sqrt(comRange.^2*nodeNum/density));
% %id
% %pos
% %neigbor
% %mem
% %hopRank
% for k=1:nodeNum
%     nodes(k).id = k;
%     nodes(k).pos = randi(area_width,1,2);
%     nodes(k).neigborNum = 0;%具体的邻结点在通信过程中更新，这个属性是为使访问不出界。
%     
%     tmp = zeros(1,nodeNum);
%     tmp(k) = 1;
%     nodes(k).mem = ones(nodeMemSize,1)*tmp;%第k个行向量，代表第k个mem上存储的包的系数向量。
%     nodes(k).hopRank = -1;
% end
% nodes(1).pos = [0,0];%将sink放在左下角
% end

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