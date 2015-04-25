function circle(pos,radius)
O_x = pos(1);
O_y = pos(2);

theta = linspace(0,2*pi,36);
x = radius.*cos(theta) + O_x;
y = radius.*sin(theta) + O_y;
plot(x,y);
end