function sink_decode_new_pack(new_pack)
%MAIN 按需解码，内部有解码状态机。
%   Detailed explanation goes here
global decode_context nodeNum;
%%
%仿真开始
new_code = new_pack.coeffs;
%消除冗余分量(reduce)
can_be_removed = new_code & decode_context.decoded_processed;
new_code = new_code - int32(can_be_removed);
%分情况处理
if sum(new_code) > 1
    decode_context.undecoded_codes = [decode_context.undecoded_codes;new_code];
    %register
    [row,col] = size(decode_context.undecoded_codes);%row的值，实际作用是指出：这个新的未解出的包，在undecoded_codes中的行索引。
    for indx = 1:nodeNum
        if new_code(indx)
            decode_context.future_decode_register{indx} = [decode_context.future_decode_register{indx},row];
        end
    end
elseif sum(new_code) == 1
    decode_context.decoded_unprocessed = [decode_context.decoded_unprocessed,decode_context.indx_table(boolean(new_code))];
end

%%
%解码第二阶段：循环处理所有decoded_unprocessed
[row,col] = size(decode_context.decoded_unprocessed);
next = 1;
while next <= col
    next_code_indx = decode_context.decoded_unprocessed(next);
    decode_context.codes_registered_to_reduce = decode_context.future_decode_register{next_code_indx};
    [decode_context.decoded_unprocessed,decode_context.undecoded_codes] = reduce(next_code_indx,decode_context.codes_registered_to_reduce,decode_context.decoded_unprocessed,decode_context.undecoded_codes);
    decode_context.decoded_processed(next_code_indx) = 1;
    %update states
    next = next + 1;
    [row,col] = size(decode_context.decoded_unprocessed);
end

decode_context.decoded_unprocessed = [];
decode_context.receive_counter = decode_context.receive_counter + 1;

if(sum(decode_context.decoded_processed) >= decode_context.k)
    decode_context.is_finished = 1;
end
end

function [decoded_unprocessed,undecoded_codes] = reduce(origin_code_indx,undecoded_to_reduce_indx,decoded_unprocessed,undecoded_codes)
    global decode_context;
    [row,col] = size(undecoded_to_reduce_indx);
    for indx = 1:col
        curr = undecoded_to_reduce_indx(indx);
        undecoded_codes(curr,origin_code_indx) = 0;
        if sum(undecoded_codes(curr,:)) == 1%如果解出来此码
            new_code_indx = decode_context.indx_table(boolean(undecoded_codes(curr,:)));
            if(sum(new_code_indx == decoded_unprocessed) == 0)
                decoded_unprocessed = [decoded_unprocessed,decode_context.indx_table(boolean(undecoded_codes(curr,:)))];
            end
            %虽然undecoded_codes中这一行已被解出，但这一行不能放入新内容，因为其它行的行索引已经放入register中，无
            %法更改。但不处理这一行，也没有影响。为安全起见，全部置0
            undecoded_codes(curr,:) = 0;
        end
    end
end
