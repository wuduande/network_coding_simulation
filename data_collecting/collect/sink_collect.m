function [is_successfull statis] = sink_collect(context,M_rate)
%COLLECT 模拟sink节点的收集过程。
%   统计如下量：
%   1.码包所传输的跳数--这基本与参数无关。--测量能耗。
%   2.完成解码所收集的包数,须关心不同的参数设定（N，M，k），否则此仿真没有意义。--测量解码性能。
%   3.最大传输跳数
%   
%   注意事项：
%   1.在衡量解码性能时，网络仿真中，是否可以绘制随解码率变化的平均代价图。
%   2.一次编码的数据，可以通过收集的随机性多次利用。
statis = 10;
is_successfull = 1;
return;
addpath('../../lib');

[decode_context context] = init_collect(context);
nodeNum = context.nodeNum;
grid_width = context.grid_width;
nx = context.nx;
ny = context.ny;
comRange = context.comRange;
k = context.k;

if M_rate < 0
    M_rate = 1.9;%当设定M_rate小于0时，是为了得到解码代价。理论上应当不设上限，直到解码成功为止。如此，万一始终无法成功解码，将陷入无限循环。因此设定为1.9
end
recv_bound = ceil(nodeNum*M_rate);%收集码包数量上限
walker = randStrLineWalker(0,grid_width*nx,grid_width*ny,0,comRange);%前进的步长为comRange
% figure(1);
% hold on;
% draw_situation( nodes,nodeNum,phyNBorMap );
while ~decode_context.is_finished
    pos = walker.move();
    node_list = getNodesInCircle(context,pos(1),pos(2),comRange);
    [context decode_context statis] = retrieve_data(context,decode_context,node_list,recv_bound);
    
    if decode_context.receive_counter >= recv_bound
        break;
    end
%     circle(pos,comRange);
end

%统计量
statis.recv_num = decode_context.receive_counter;
statis.num_decode_symbol = sum(decode_context.decoded_processed);

if statis.num_decode_symbol < k
    is_successfull = 0;
else
    is_successfull = 1;
end
end

function [context decode_context] = retrieve_data(context,decode_context,node_list,recv_bound)
    indx_bound = ListSize(node_list);
    for indx = 0:indx_bound-1
        node_id = ListGet(node_list,indx);
        if(~context.nodes(node_id).is_collected)
            pack_list =context. nodes(node_id).code_finished_mems;
            indx_bound2 = ListSize(pack_list);
            for indx2 = 0:indx_bound2-1
                pack = ListGet(pack_list,indx2);
                decode_context = sink_decode_new_pack(context,decode_context,pack);
                
                if decode_context.is_finished
                    return;
                end

                if decode_context.receive_counter >= recv_bound
                    return;
                end
            end
            context.nodes(node_id).is_collected = 1;
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
function node_list = getNodesInCircle(context,x,y,r)
    rect_list = nodesInRect(context,x,y,r);%加快计算速度，减少距离运算
    node_list = nodesInCircle(context,rect_list,x,y,r);
end

function rect_list = nodesInRect(context,x,y,r)%圆心(x,y)，半径r的圆的外切矩形，内的点
nodeNum = context.nodeNum;
nodes = context.nodes;
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

function circle_list = nodesInCircle(context,rect_list,x,y,r)
    nodes = context.nodes;
    circle_list = doubleLinkedList();
    Op = [x,y];
    indx_bound = ListSize(rect_list);
    for indx = 0:indx_bound-1
        node_id = ListGet(rect_list,indx);
        pos = nodes(node_id).pos;
        if(norm(pos - Op) < r)
            ListInsert(circle_list,node_id);
        end
    end
end