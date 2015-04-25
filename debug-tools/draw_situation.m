function draw_situation( nodes,phyNBorMap )
%DRAW_SITUATION 画出仿真场景
%   1.结点位置
%   2.结点邻接关系
plot([0,0],[0,0]);
hold on;
draw_nodes(nodes);
draw_links(nodes,phyNBorMap);
end
function draw_nodes(nodes)
    for k = 1:length(nodes)
        plot(nodes(k).pos(1),nodes(k).pos(2),'ko','MarkerFaceColor','k');
%         circle(nodes(k).pos,1);
    end
end

function draw_links(nodes,phyNBorMap)
    for k1=1:length(nodes)
       for k2 = k1+1:length(nodes)
          if phyNBorMap(k1,k2) 
              xs = [nodes(k1).pos(1), nodes(k2).pos(1)];
              ys = [nodes(k1).pos(2), nodes(k2).pos(2)];
              plot(xs,ys,'k');
          end
       end
    end
end