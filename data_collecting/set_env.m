function set_env(nodeNum_arg,distribution_arg)
global comRange	  sensor_density ...
       nodeNum    distribution  code_redundence;
   
nodeNum = nodeNum_arg;%�����µĽ����������������ܸģ�Ҫ�ĵĻ�����ຯ������ĳ�����Ҫ�ġ���Ϊ�Ƿ���mesh���硣
code_redundence = 2;%ÿ��������ɶ��ٸ�����
distribution = distribution_arg;%��ʼ���ȷֲ�
comRange = 10;%communication range
 % phyNBorMap:�������£���ͨ�ŷ�Χ�ڵ��ڽ�㡣�������һ����������Щ�ڽ�㡣���map����ģ���ŵ�ͨ�ž��롣
sensor_density = 2;%����ܶȣ��������ͨ�����*�������/�������
end