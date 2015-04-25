function draw_situation( nodes,nodeNum,phyNBorMap )
%DRAW_SITUATION �������泡��
%   1.���λ��
%   2.����ڽӹ�ϵ
plot([0,0],[0,0]);
hold on;
draw_nodes(nodes,nodeNum);
draw_links(nodes,nodeNum,phyNBorMap);
end
function draw_nodes(nodes,nodeNum)
    for k = 1:nodeNum
        plot(nodes(k).pos(1),nodes(k).pos(2),'ko','MarkerFaceColor','k');
%         circle(nodes(k).pos,1);
    end
end

function draw_links(nodes,nodeNum,phyNBorMap)
    for k1=1:nodeNum
       for k2 = k1+1:nodeNum
          if phyNBorMap(k1,k2) 
              xs = [nodes(k1).pos(1), nodes(k2).pos(1)];
              ys = [nodes(k1).pos(2), nodes(k2).pos(2)];
              plot(xs,ys,'k');
          end
       end
    end
end