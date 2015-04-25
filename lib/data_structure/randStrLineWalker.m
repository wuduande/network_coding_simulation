classdef randStrLineWalker < handle
% ��������ʽ���·����·��Ϊ���ֱ���˶���
% ÿ����һ�Σ�����һ���µ㡣
   properties(SetAccess = private)
      pos_curr
      step_move
      step_size
      %�˶����ڵľ�������Χ
      xleft
      xright
      yup
      ydown
      
      %״̬������״̬����bug����Ϊ�в�����ԭ����ʱ�������ķ���ǰ��ʱ����û��磬�ֳ����ˡ�
      %�������������ǿ��ת��
      %��λ����߽�̫Զʱ��ǿ��ת��
      state
      state_in
      state_out
   end
    
   methods
       function walker = randStrLineWalker(xleft_arg,xright_arg,yup_arg,ydown_arg,step_size_arg)
           %Ϊ����������ԣ�������Ҳ����
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
       %Ψһ�Ĺ�������
       function new_pos = move(walker)
           new_pos = walker.pos_curr + walker.step_move;
           walker.pos_curr = new_pos;
           
           in_feild = walker.is_in_feild();
           if ~in_feild && strcmp(walker.state, walker.state_in)
               %���磬�����ת��
               walker.rand_turn();
               walker.state = walker.state_out;
           end
           
           if in_feild && strcmp(walker.state, walker.state_out)
               %���
               walker.state = walker.state_in;
           end
           
           if walker.is_escaping()
               walker.rand_turn();
           end
       end
       
       function ret = is_escaping(walker)
           bound_dis = walker.get_bound_dis();
           
           if max(bound_dis) > 1.5*walker.step_size%��walker����ʱ����������»�������ת�������ܴﵽ2�������ľ���
               ret = 1;
           else
               ret = 0;
           end
       end
       
       function bound_dis = get_bound_dis(walker)
           x = walker.pos_curr(1);
           y = walker.pos_curr(2);
           
           bound_dis = zeros(1,4);
           bound_dis(1) = walker.xleft - x;%����
           bound_dis(2) = walker.ydown - y;%����
           bound_dis(3) = x - walker.xright;%����
           bound_dis(4) = y - walker.yup;%����
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
       
       function rand_turn(walker)%���ٵ��ã���˸��ӶȲ�Ҫ��
           %���Ž����ı߽���Ϊ���봰�ڡ�
           bound_dis = walker.get_bound_dis();
           indx_max = find(max(bound_dis) == bound_dis);%�Ž����ı����
            
          %�趨���ڵ����ұ߽��
           if indx_max == 1
               corner1 = [walker.xleft,walker.ydown];%�߽���㣬���Ƕ���ϵ����ʱ�뷽��
               corner2 = [walker.xleft,walker.yup];%�߽��յ㣬���Ƕ���ϵ����ʱ�뷽��
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
%            Ϊ���⸴�Ӽ��㣬�Լ��׳��������ת�����ֲ���ʸ����ӷ���
%            bias_vect = corner2 - corner1;
%            new_dir_vect = (corner1 - walker.pos_curr) + bias_vect.*rand();%�������
%            walker.step_move = walker.step_size*new_dir_vect./norm(new_dir_vect);%�����ȱ�׼��Ϊstep_size
          
           %����������Ƕȵķ�����
           %�������ұ߽����Ե�ǰwalker���ڵ��λ��ʸ��
           vect_s = corner1 - walker.pos_curr;
           vect_t = corner2 - walker.pos_curr;
           %ת��Ϊ�����꣬��������½�
           poly_s = walker.xy2poly(vect_s);
           poly_t = walker.xy2poly(vect_t);
           angle_new = poly_s(1) + rand()*mod((poly_t(1) - poly_s(1) + 2*pi),2*pi);
           
           walker.step_move = walker.poly2xy([angle_new,walker.step_size]);
           
       end
   end% methods
   methods(Static)
       function ret = xy2poly(pos)%0-2pi����
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

    
    