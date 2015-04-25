function [ack,sink_rank] = sink_get_packet( packet)
%SINK_GET_PACKET Summary of this function goes here
%   Detailed explanation goes here
%-sink decode
global sink_collect_log record_indx nodeNum;
decode_progress = decode(nodeNum,packet.pack);
%-rocord
record_indx = record_indx + 1;
sink_collect_log(record_indx) = sum(decode_progress);
sink_rank = sink_collect_log(record_indx);
ack = decode_progress;
%sink_collect_log(record_indx) = sum(decoded);
end

function decode_footprint = decode( inputNum ,new_code)
%MAIN Summary of this function goes here
%   Detailed explanation goes here
%%
%init
global indx_table decoded_processed decoded_unprocessed future_decode_register undecoded_codes simu_time;
if isempty(decoded_processed)
    decoded_processed = zeros(1,inputNum);
    decoded_unprocessed = [];
    %记录下，每个还没被解码出来的原始码被哪些已收到的码字依赖。
    %当原始码被解出来后，就可以根据这个表来消除他们的冗余分量
    future_decode_register = cell(1,inputNum);
    undecoded_codes = [];
    %find indx table
    indx_table = 1:inputNum;
    receive_counter = 0;
end
%%
    %消除冗余分量(reduce)
    can_be_removed = new_code & decoded_processed;
    new_code = new_code - can_be_removed;
    %分情况处理
    if sum(new_code) > 1
        undecoded_codes = [undecoded_codes;new_code];
        %register
        [row,col] = size(undecoded_codes);%row的值，实际作用是指出：这个新的未解出的包，在undecoded_codes中的行索引。
        for indx = 1:inputNum
            if new_code(indx)
                future_decode_register{indx} = [future_decode_register{indx},row];
            end
        end
    elseif sum(new_code) == 1
        decoded_unprocessed = [decoded_unprocessed,indx_table(boolean(new_code))];
    end

    %%
    %解码第二阶段：循环处理所有decoded_unprocessed
    [row,col] = size(decoded_unprocessed);
    next = 1;
    while next <= col
        next_code_indx = decoded_unprocessed(next);
        codes_registered_to_reduce = future_decode_register{next_code_indx};
        [decoded_unprocessed,undecoded_codes] = reduce(next_code_indx,codes_registered_to_reduce,decoded_unprocessed,undecoded_codes);
        decoded_processed(next_code_indx) = 1;
        %update states
        next = next + 1;
        [row,col] = size(decoded_unprocessed);
    end
    decoded_unprocessed = [];
%     receive_counter = receive_counter + 1;
    decode_footprint = decoded_processed;
end

function [decoded_unprocessed,undecoded_codes] = reduce(origin_code_indx,undecoded_to_reduce_indx,decoded_unprocessed,undecoded_codes)
    global indx_table ;
    [row,col] = size(undecoded_to_reduce_indx);
    for indx = 1:col
        curr = undecoded_to_reduce_indx(indx);
        undecoded_codes(curr,origin_code_indx) = 0;
        if sum(undecoded_codes(curr,:)) == 1%如果解出来此码
            decoded_unprocessed = [decoded_unprocessed,indx_table(boolean(undecoded_codes(curr,:)))];
            %虽然undecoded_codes中这一行已被解出，但这一行不能放入新内容，因为其它行的行索引已经放入register中，无
            %法更改。但不处理这一行，也没有影响。为安全起见，全部置0
            undecoded_codes(curr,:) = 0;
        end
    end
end
