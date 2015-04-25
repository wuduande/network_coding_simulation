classdef DegreeGenerator < handle
    % get target degree according to distribution
   properties(SetAccess = private)
      dis_cumsum
   end
    
   methods
       function gen = DegreeGenerator(distribution)
           gen.dis_cumsum = cumsum(distribution);
       end
       function targetDegree = next(gen)
            rand_scalar = rand();
            targetDegree = find((gen.dis_cumsum - rand_scalar) > 0,1);
       end
    end % classdef
end

    
    