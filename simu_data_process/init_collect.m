function init_collect()
%SYSTEM_INIT_COLLECT Summary of this function goes here
%   Detailed explanation goes here
global nodes nodeNum
for indx = 1:nodeNum
    nodes(indx).is_collected = 0;
end

init_decode_context();
init_statis_context();
end