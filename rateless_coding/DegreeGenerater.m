classdef DegreeGenerater < handle
% 给定度分布建立一个对象，第调用一次next，得到按此度分布下的一个目标度。
   properties(SetAccess = private)
      distribution
   end
    
   methods
       function gen = randStrLineWalker(distribution)
           %为了引入随机性，出发点也地面
           gen.distribution = distribution;
       end
       function degree = next(gen)
            distribution = gen.distribution;
            max_degree = length(distribution);

            rand_scalar = rand();
            for indx = 1:max_degree
               if rand_scalar < distribution(indx)
                   targetDegree = indx;
                   break;
               else
                   rand_scalar = rand_scalar - distribution(indx);
               end
            end
       end
end % classdef

    
    