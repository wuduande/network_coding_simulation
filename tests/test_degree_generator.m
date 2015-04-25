function test_degree_generator()
%TEST_DEGREE_GENERATOR Summary of this function goes here
%   ���ԶȲ��������Ƿ����㹦��Ҫ��
%   ����ͨ��
global distribution nodeNum;
addpath('..\lib');
nodeNum = 100;
pack_num = 10000;
distribution = getDistribution( nodeNum,'robust_siliton' );

statis_recv_num_per_degree = zeros(1,nodeNum);
for k = 1:pack_num
    degree = get_target_degree();
    statis_recv_num_per_degree(degree) = statis_recv_num_per_degree(degree) + 1;
end
figure(1);hold on;
subplot(2,1,1);
plot(1:nodeNum,distribution);
title('��׼�ȷֲ�����');

subplot(2,1,2);
plot(1:nodeNum,statis_recv_num_per_degree./pack_num);
title('ʵ�ʲ�������Ķȷֲ�');
hold off;
end

%���´����Ժ�����Դ��system_init�ļ���
function targetDegree = get_target_degree()
    global distribution nodeNum;
    rand_scalar = rand();
    for indx = 1:nodeNum
       if rand_scalar < distribution(indx)
           targetDegree = indx;
           break;
       else
           rand_scalar = rand_scalar - distribution(indx);
       end
    end
end