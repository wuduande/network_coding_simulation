function test_straight_line_rand_walker()
%TEST_STRAIGHT_LINE_RAND_WALKER Summary of this function goes here
%   Detailed explanation goes here
addpath('..\lib\data_structure');
comRange = 10;
walker = randStrLineWalker(0,comRange*10,comRange*10,0,comRange/2);%ǰ���Ĳ�����Ҫ����
last_pos = walker.move();

figure(1);hold on;
%�����߿�
rectangle('Position',[0 0 comRange*10 comRange*10]);

%��̬·��
while(1)
    new_pos = walker.move();
    line = [new_pos; last_pos];
    plot(line(:,1),line(:,2));
%     pause(0.001);
    last_pos = new_pos;
end
end

