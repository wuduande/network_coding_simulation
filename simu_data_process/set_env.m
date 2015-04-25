function set_env(nodeNum_arg,distribution_arg)
global comRange	  sensor_density ...
       nodeNum    distribution  code_redundence;
   
nodeNum = nodeNum_arg;%场景下的结点总数。，这个不能改，要改的话，许多函数里面的常数都要改。因为是方格mesh网络。
code_redundence = 2;%每个码包生成多少个副本
distribution = distribution_arg;%初始化度分布
comRange = 10;%communication range
 % phyNBorMap:物理场景下，在通信范围内的邻结点。结点自身不一定发现了这些邻结点。这个map用于模拟信道通信距离。
sensor_density = 2;%结点密度：单个结点通信面积*结点总数/布置面积
end