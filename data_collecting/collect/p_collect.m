function [ ret ] = p_collect(filename_without_indx,sample_num,M_rate)
%SIMU_TAU Summary of this function goes here
%   this is used to get the prabability of decoding successfully, when
%   M_rate*N packets is recved
    ret = 0;
    for indx = 1:sample_num
        load([filename_without_indx, '_indx_', num2str(indx), '.mat'],'context');
        recorder = zeros(1,100);
        parfor j = 1:100
            [recorder(j) tmp] = sink_collect(context,M_rate);
        end
        
        ret = ret + sum(recorder);
        indx
    end
    ret = ret/10000;
end