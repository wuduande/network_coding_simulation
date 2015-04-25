function [  ] = test_xy2poly()
%TEST_XY2POLY ���� 0~2*pi֮�䣬ֱ�����굽������֮����ֻ�����
%   ����ͨ��
N = 10000;
r = 10;
for j = 1:N
    theta = j*2*pi/N;
    pos = xy2poly([theta,r]);
    poly = poly2xy(pos);
    if sum(poly - [theta,r]) > eps*100
        sum(poly - [theta,r])
        display('wrong!');
    end
end
end

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