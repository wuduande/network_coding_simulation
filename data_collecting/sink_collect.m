function decode_cost = sink_collect()
%COLLECT 模拟sink节点的收集过程。
%   统计如下量：
%   1.码包所传输的跳数--这基本与参数无关。--测量能耗。
%   2.完成解码所收集的包数,须关心不同的参数设定（N，M，k），否则此仿真没有意义。--测量解码性能。
%   3.最大传输跳数
%   
%   注意事项：
%   1.在衡量解码性能时，网络仿真中，是否可以绘制随解码率变化的平均代价图。
%   2.一次编码的数据，可以通过收集的随机性多次利用。

global nodeNum  decode_context statis grid_width nx ny ...
     code_redundence k comRange;%这一行的变量需要手工搭建
addpath('..\lib\data_structure');

init_collect();
recv_bound = nodeNum*code_redundence*0.9;%如果接收了90%的码包还没成功解码，则放弃。
walker = randStrLineWalker(0,grid_width*nx,grid_width*ny,0,comRange/2);%前进的步长需要调整
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

%解出符号数
statis.num_decode_symbol = sum(decode_context.decoded_processed);
if statis.num_decode_symbol < k
    statis.is_data_valid = 0;
end
%接收码包数
statis.num_received_pack = decode_context.receive_counter;
decode_cost = decode_context.receive_counter;
% figure(6);
% bar(statis.hop_statis);
% title('码包路径长度统计');
% 
% figure(7);
% bar(statis.degree_statis);
% title('码包度的统计');
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
% %----螺旋运动
% % step_size = comRange/2;
% % delta_theta = step_size/r;
% % theta = theta + delta_theta;
% % 
% % r_rate = comRange/pi;
% % r = r + r_rate*delta_theta;       
% 
% %--随机采点
% % pos = grid_width.*[nx,ny].*rand(1,2);
% 
% end

% get nodes in circle =================================================
function node_list = getNodesInCircle(x,y,r)
    rect_list = nodesInRect(x,y,r);%加快计算速度，减少距离运算
    node_list = nodesInCircle(rect_list,x,y,r);
end

function rect_list = nodesInRect(x,y,r)%圆心(x,y)，半径r的圆的外切矩形，内的点
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