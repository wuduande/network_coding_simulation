function [ output_args ] = test_nbor_map( input_args )
%TEST_NBOR_MAP Summary of this function goes here
%   Detailed explanation goes here
addpath('..\lib\data_structure');
addpath('..\lib');
set_env(10,getDistribution(10,'robust_siliton'));
put_nodes_in_grid();
construct_phy_NBor_map();
global phyNBorMap;
display(phyNBorMap);
end
%此函数来源于system_init文件，用于生成phyNBorMap矩阵，此变量记录了任意两个节点是否相邻。
%相邻则相应位置的值为1，否则为0;
function construct_phy_NBor_map()
    global nodes comRange nodeNum phyNBorMap;
    phyNBorMap = zeros(nodeNum,nodeNum);
    for k1 = 1:nodeNum
        for k2 = k1+1:nodeNum
            phyNBorMap(k1,k2) = (norm(nodes(k1).pos - nodes(k2).pos) < comRange);
        end
    end
    phyNBorMap = phyNBorMap + phyNBorMap';
end

%以下函数用于帮助构建测试环境
function set_env(nodeNum_arg,distribution_arg)
global comRange	  nodeMemSize     sensor_density ...
       nodeNum    distribution  code_redundence;
   
nodeNum = nodeNum_arg;%场景下的结点总数。，这个不能改，要改的话，许多函数里面的常数都要改。因为是方格mesh网络。
nodeMemSize = 100;%每个结点可以存储4个包。
code_redundence = 2;%每个码包生成多少个副本
distribution = distribution_arg;%初始化度分布
comRange = 10;%communication range
 % phyNBorMap:物理场景下，在通信范围内的邻结点。结点自身不一定发现了这些邻结点。这个map用于模拟信道通信距离。
sensor_density = 2;%结点密度：单个结点通信面积*结点总数/布置面积
end
function put_nodes_in_grid()
%目标功能：
%在尽可能接近正方形的平面空间内，按照预定密度放置所有结点。为此，可以稍微修改节点的总数。
%要求网络为网格拓扑。
%要求结点被初始化，生成目标度各不相同，但含有相同原始符号的码包。
    global nodes nodeNum sensor_density comRange code_redundence grid_width nx ny;%收集时，绕的圈数;
    %使得区域近乎方形，并调整结点的数量
    n = sqrt(nodeNum);
    nx = floor(n);
    ny = ceil(n);
    nodeNum = nx*ny;
    
    grid_width = sqrt(comRange^2/sensor_density);
    dis = grid_width;
    
    for k=1:nodeNum
        nodes(k).id = k;
        
        %设定位置
        x = mod(k-1,nx)*dis;
        y = floor((k-1)/nx)*dis;
        nodes(k).pos = [x,y];
        
        %<初始化码包>-----------------------------------------------
        %--下一次编码前，还需传输的跳数
        pack.left_hop = int32(log(nodeNum));
        
        %--构造编码系数
        tmp = int32(zeros(1,nodeNum));
        tmp(k) = int32(1);  
        pack.coeffs = tmp;
        
        %--复制b个初始包，放入“未完成编码码包”链表中。
        list = doubleLinkedList();
        for counter=1:code_redundence
            pack.left_degree = int32(get_target_degree() - 1);%还需编入的符号分量数
            new_node = dlnode(pack);
            ListInsert(list, new_node);
        end
        nodes(k).coding_mems = list;
        %--初始化“已完成编码码包”链表
        nodes(k).code_finished_mems = doubleLinkedList();
        %</初始化码包>---------------------------------------------

        nodes(k).is_busy = 0;%used to media access control
        nodes(k).is_collected = 0;
    end
end
function targetDegree = get_target_degree()
    global distribution nodeNum;
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