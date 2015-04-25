classdef randStrLineWalker < handle
% 以流的形式输出路径，路径为随机直线运动。
% 每调用一次，返回一个新点。
   properties(SetAccess = private)
      pos_curr
      step_move
      step_size
      %运动所在的矩形区域范围
      xleft
      xright
      yup
      ydown
      
      %状态机，此状态机有bug，因为有步长的原因，有时候向入界的方向前进时，还没入界，又出界了。
      %解决方法：引入强制转向
      %当位置离边界太远时，强制转回
      state
      state_in
      state_out
   end
    
   methods
       function walker = randStrLineWalker(xleft_arg,xright_arg,yup_arg,ydown_arg,step_size_arg)
           %为了引入随机性，出发点也地面
           walker.pos_curr = [xleft_arg + rand()*(xright_arg - xleft_arg), ydown_arg + rand()*(ydown_arg - ydown_arg)];
           
           rand_angle = pi*rand();
           walker.step_move = step_size_arg*[cos(rand_angle) sin(rand_angle)];
           walker.step_size = step_size_arg;
           
           walker.xleft = xleft_arg;
           walker.xright = xright_arg;
           walker.yup = yup_arg;
           walker.ydown = ydown_arg;
           
           walker.state_in = 'in';
           walker.state_out = 'out';
           walker.state = walker.state_in;
       end
       %唯一的公开函数
       function new_pos = move(walker)
           new_pos = walker.pos_curr + walker.step_move;
           walker.pos_curr = new_pos;
           
           in_feild = walker.is_in_feild();
           if ~in_feild && strcmp(walker.state, walker.state_in)
               %出界，则随机转向
               walker.rand_turn();
               walker.state = walker.state_out;
           end
           
           if in_feild && strcmp(walker.state, walker.state_out)
               %入界
               walker.state = walker.state_in;
           end
           
           if walker.is_escaping()
               walker.rand_turn();
           end
       end
       
       function ret = is_escaping(walker)
           bound_dis = walker.get_bound_dis();
           
           if max(bound_dis) > 1.5*walker.step_size%当walker出界时，正常情况下会立即回转，不可能达到2倍步长的距离
               ret = 1;
           else
               ret = 0;
           end
       end
       
       function bound_dis = get_bound_dis(walker)
           x = walker.pos_curr(1);
           y = walker.pos_curr(2);
           
           bound_dis = zeros(1,4);
           bound_dis(1) = walker.xleft - x;%左面
           bound_dis(2) = walker.ydown - y;%下面
           bound_dis(3) = x - walker.xright;%右面
           bound_dis(4) = y - walker.yup;%上面
       end
       
       function ret = is_in_feild(walker)
           pos_curr_tmp = walker.pos_curr;
           cond_in_rect = walker.xleft < pos_curr_tmp(1) && pos_curr_tmp(1) < walker.xright && ...
                          walker.ydown < pos_curr_tmp(2) && pos_curr_tmp(2) < walker.yup;
           
           if cond_in_rect
               ret = 1;
               return;
           else
               ret = 0;
               return;
           end
       end
       
       function rand_turn(walker)%较少调用，因此复杂度不要紧
           %以张角最大的边界作为进入窗口。
           bound_dis = walker.get_bound_dis();
           indx_max = find(max(bound_dis) == bound_dis);%张角最大的边序号
            
          %设定窗口的左右边界点
           if indx_max == 1
               corner1 = [walker.xleft,walker.ydown];%边界起点，按角度体系的逆时针方向
               corner2 = [walker.xleft,walker.yup];%边界终点，按角度体系的逆时针方向
           elseif indx_max == 2
               corner1 = [walker.xright,walker.ydown];
               corner2 = [walker.xleft,walker.ydown];
           elseif indx_max == 3
               corner1 = [walker.xright,walker.yup];
               corner2 = [walker.xright,walker.ydown];
           else
               corner1 = [walker.xleft,walker.yup];
               corner2 = [walker.xright,walker.yup];
           end
%            为避免复杂计算，以及易出错的坐标转换，现采用矢量相加法。
%            bias_vect = corner2 - corner1;
%            new_dir_vect = (corner1 - walker.pos_curr) + bias_vect.*rand();%随机长度
%            walker.step_move = walker.step_size*new_dir_vect./norm(new_dir_vect);%将长度标准化为step_size
          
           %以下是随机角度的方法。
           %计算左右边界点相对当前walker所在点的位移矢量
           vect_s = corner1 - walker.pos_curr;
           vect_t = corner2 - walker.pos_curr;
           %转化为极坐标，以求随机新角
           poly_s = walker.xy2poly(vect_s);
           poly_t = walker.xy2poly(vect_t);
           angle_new = poly_s(1) + rand()*mod((poly_t(1) - poly_s(1) + 2*pi),2*pi);
           
           walker.step_move = walker.poly2xy([angle_new,walker.step_size]);
           
       end
   end% methods
   methods(Static)
       function ret = xy2poly(pos)%0-2pi以内
             r = norm(pos);
             angle = acos(pos(1)/r);
             if (pos(2) < 0)
                 angle = 2*pi - angle;
             end
             ret = [angle,r];
       end
       
       function pos = poly2xy(poly)
           x = poly(2)*cos(poly(1));
           y = poly(2)*sin(poly(1));
           pos = [x,y];
       end
   end % static methods
end % classdef

    
    