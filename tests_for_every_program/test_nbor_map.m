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
%�˺�����Դ��system_init�ļ�����������phyNBorMap���󣬴˱�����¼�����������ڵ��Ƿ����ڡ�
%��������Ӧλ�õ�ֵΪ1������Ϊ0;
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

%���º������ڰ����������Ի���
function set_env(nodeNum_arg,distribution_arg)
global comRange	  nodeMemSize     sensor_density ...
       nodeNum    distribution  code_redundence;
   
nodeNum = nodeNum_arg;%�����µĽ����������������ܸģ�Ҫ�ĵĻ�����ຯ������ĳ�����Ҫ�ġ���Ϊ�Ƿ���mesh���硣
nodeMemSize = 100;%ÿ�������Դ洢4������
code_redundence = 2;%ÿ��������ɶ��ٸ�����
distribution = distribution_arg;%��ʼ���ȷֲ�
comRange = 10;%communication range
 % phyNBorMap:�������£���ͨ�ŷ�Χ�ڵ��ڽ�㡣�������һ����������Щ�ڽ�㡣���map����ģ���ŵ�ͨ�ž��롣
sensor_density = 2;%����ܶȣ��������ͨ�����*�������/�������
end
function put_nodes_in_grid()
%Ŀ�깦�ܣ�
%�ھ����ܽӽ������ε�ƽ��ռ��ڣ�����Ԥ���ܶȷ������н�㡣Ϊ�ˣ�������΢�޸Ľڵ��������
%Ҫ������Ϊ�������ˡ�
%Ҫ���㱻��ʼ��������Ŀ��ȸ�����ͬ����������ͬԭʼ���ŵ������
    global nodes nodeNum sensor_density comRange code_redundence grid_width nx ny;%�ռ�ʱ���Ƶ�Ȧ��;
    %ʹ������������Σ���������������
    n = sqrt(nodeNum);
    nx = floor(n);
    ny = ceil(n);
    nodeNum = nx*ny;
    
    grid_width = sqrt(comRange^2/sensor_density);
    dis = grid_width;
    
    for k=1:nodeNum
        nodes(k).id = k;
        
        %�趨λ��
        x = mod(k-1,nx)*dis;
        y = floor((k-1)/nx)*dis;
        nodes(k).pos = [x,y];
        
        %<��ʼ�����>-----------------------------------------------
        %--��һ�α���ǰ�����贫�������
        pack.left_hop = int32(log(nodeNum));
        
        %--�������ϵ��
        tmp = int32(zeros(1,nodeNum));
        tmp(k) = int32(1);  
        pack.coeffs = tmp;
        
        %--����b����ʼ�������롰δ��ɱ�������������С�
        list = doubleLinkedList();
        for counter=1:code_redundence
            pack.left_degree = int32(get_target_degree() - 1);%�������ķ��ŷ�����
            new_node = dlnode(pack);
            ListInsert(list, new_node);
        end
        nodes(k).coding_mems = list;
        %--��ʼ��������ɱ������������
        nodes(k).code_finished_mems = doubleLinkedList();
        %</��ʼ�����>---------------------------------------------

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