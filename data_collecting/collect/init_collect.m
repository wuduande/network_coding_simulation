function [statis decode_context context] = init_collect(context)
%SYSTEM_INIT_COLLECT Summary of this function goes here
%   Detailed explanation goes here
nodeNum = context.nodeNum;
for indx = 1:nodeNum
    context.nodes(indx).is_collected = 0;
end

decode_context = init_decode_context(context);
statis = init_statis_context(context);
end