function mem_foot_print( )
%MEM_FOOT_PRINT Summary of this function goes here
%   Detailed explanation goes here
global nodes;
mem_foot_print = zeros(10,10);
for k1 = 1:10
  for k2 = 1:10
     node = nodes((k1-1)*10 + k2);
     mem_foot_print(k1,k2) = ListSize(node.coding_mems) + ListSize(node.code_finished_mems) + strcmp(node.state_code,'state_code_ready');
  end
end
display(mem_foot_print);
end

