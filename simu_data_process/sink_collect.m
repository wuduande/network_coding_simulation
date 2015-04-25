function decode_cost = sink_collect()
%COLLECT ģ��sink�ڵ���ռ����̡�
%   ͳ����������
%   1.��������������--�����������޹ء�--�����ܺġ�
%   2.��ɽ������ռ��İ���,����Ĳ�ͬ�Ĳ����趨��N��M��k��������˷���û�����塣--�����������ܡ�
%   3.���������
%   
%   ע�����
%   1.�ں�����������ʱ����������У��Ƿ���Ի���������ʱ仯��ƽ������ͼ��
%   2.һ�α�������ݣ�����ͨ���ռ�������Զ�����á�

global nodeNum  decode_context statis grid_width nx ny ...
     code_redundence k comRange;%��һ�еı�����Ҫ�ֹ��
addpath('..\lib\data_structure');

init_collect();
recv_bound = nodeNum*code_redundence*0.9;%���������90%�������û�ɹ����룬�������
walker = randStrLineWalker(0,grid_width*nx,grid_width*ny,0,comRange/2);%ǰ���Ĳ�����Ҫ����
figure(1);
hold on;
draw_situation( nodes,nodeNum,phyNBorMap );
while ~decode_context.is_finished
    pos = walker.move();
    node_list = getNodesInCircle(pos(1),pos(2),comRange);
    retrieve_data(node_list);
    
    if decode_context.receive_counter >= recv_bound
        break;
    end
    circle(pos,comRange);
end

%���������
statis.num_decode_symbol = sum(decode_context.decoded_processed);
if statis.num_decode_symbol < k
    statis.is_data_valid = 0;
end
%���������
statis.num_received_pack = decode_context.receive_counter;
decode_cost = decode_context.receive_counter;
% figure(6);
% bar(statis.hop_statis);
% title('���·������ͳ��');
% 
% figure(7);
% bar(statis.degree_statis);
% title('����ȵ�ͳ��');
end

function retrieve_data(node_list)
    global nodes decode_context;
    indx_bound = ListSize(node_list);
    for indx = 0:indx_bound-1
        node_id = ListGet(node_list,indx);
        if(~nodes(node_id).is_collected)
            pack_list = nodes(node_id).code_finished_mems;
            indx_bound2 = ListSize(pack_list);
            for indx2 = 0:indx_bound2-1
                pack_node = ListGet(pack_list,indx2);
                sink_decode_new_pack(pack_node);
                
                if decode_context.is_finished
                    return;
                end
            end
            nodes(node_id).is_collected = 1;
        end
    end
end

% function pos = move()
% global path;
% %----�����˶�
% % step_size = comRange/2;
% % delta_theta = step_size/r;
% % theta = theta + delta_theta;
% % 
% % r_rate = comRange/pi;
% % r = r + r_rate*delta_theta;       
% 
% %--����ɵ�
% % pos = grid_width.*[nx,ny].*rand(1,2);
% 
% end

% get nodes in circle =================================================
function node_list = getNodesInCircle(x,y,r)
    rect_list = nodesInRect(x,y,r);%�ӿ�����ٶȣ����پ�������
    node_list = nodesInCircle(rect_list,x,y,r);
end

function rect_list = nodesInRect(x,y,r)%Բ��(x,y)���뾶r��Բ�����о��Σ��ڵĵ�
global nodeNum nodes;
rect_list = doubleLinkedList();
left_bound = x - r;
right_bound = x + r;
upper_bound = y + r;
lower_bound = y - r;
for indx = 1:nodeNum
    pos = nodes(indx).pos;
    if(pos(1) > left_bound && pos(1) < right_bound && pos(2) > lower_bound && pos(2) < upper_bound)
        ListInsert(rect_list,indx);
    end
end
end

function circle_list = nodesInCircle(rect_list,x,y,r)
    global nodes;
    circle_list = doubleLinkedList();
    Op = [x,y];
    indx_bound = ListSize(rect_list);
    for indx = 0:indx_bound-1
        data = ListGet(rect_list,indx);
        pos = nodes(data).pos;
        if(norm(pos - Op) < r)
            ListInsert(circle_list,data);
        end
    end
end