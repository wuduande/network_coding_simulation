function [ cost,av_hop,max_hop ] = cost_collect( filename_without_indx,sample_num )
%COST_DECODE Summary of this function goes here
%   this func is used to get the cost when decoding is successful

    cost = 0;
    av_hop = 0;
    max_hop = 0;
    statis_sample_num = 0;
    for indx = 1:sample_num
        context = load([filename_without_indx, '_indx_', num2str(indx), '.mat'],'context');
        recorder = cell(1,100);
        parfor j = 1:100
            [tmp recorder{j}]= sink_collect(context,-1);
        end
        for h = 1:100
            cost = cost + recorder{h}.recv_num;
        end
        %平均编码跳数，最大编码跳数
        len = context.nodes(indx).code_finished_mems.ListSize();
        if len <= 0
            continue;
        end
        for indx_pack = 1:len
            pack = context.nodes(indx).code_finished_mems.ListGet(indx_pack-1);
            hop_count = hop_count + pack.hop_count;
            max_hop = max(max_hop, pack.hop_count);
        end
        statis_sample_num = statis_sample_num  + len;
        
        indx
    end
    cost = cost/(100*sample_num);
    av_hop = av_hop/statis_sample_num;%在所有仿真的每个包中平均。
    max_hop = max_hop/(sample_num);
end

