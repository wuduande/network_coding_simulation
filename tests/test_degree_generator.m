function test_degree_generator()
%TEST_DEGREE_GENERATOR Summary of this function goes here
%   测试度产生函数是否满足功能要求
%   测试通过
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
title('标准度分布函数');

subplot(2,1,2);
plot(1:nodeNum,statis_recv_num_per_degree./pack_num);
title('实际产生码包的度分布');
hold off;
end

%以下待测试函数来源于system_init文件。
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