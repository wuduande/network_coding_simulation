function decode_context = sink_decode_new_pack(context,decode_context,new_pack)
%MAIN ������룬�ڲ��н���״̬����
%   Detailed explanation goes here
nodeNum = context.nodeNum;

%%
%���濪ʼ
new_code = new_pack.coeffs;
%�����������(reduce)
can_be_removed = new_code & decode_context.decoded_processed;
new_code = new_code - int32(can_be_removed);
%���������
if sum(new_code) > 1
    decode_context.undecoded_codes = [decode_context.undecoded_codes;new_code];
    %register
    [row,col] = size(decode_context.undecoded_codes);%row��ֵ��ʵ��������ָ��������µ�δ����İ�����undecoded_codes�е���������
    for indx = 1:nodeNum
        if new_code(indx)
            decode_context.future_decode_register{indx} = [decode_context.future_decode_register{indx},row];
        end
    end
elseif sum(new_code) == 1
    decode_context.decoded_unprocessed = [decode_context.decoded_unprocessed,decode_context.indx_table(boolean(new_code))];
end

%%
%����ڶ��׶Σ�ѭ����������decoded_unprocessed
[row,col] = size(decode_context.decoded_unprocessed);
next = 1;
while next <= col
    next_code_indx = decode_context.decoded_unprocessed(next);
    decode_context.codes_registered_to_reduce = decode_context.future_decode_register{next_code_indx};
    [decode_context] = reduce(decode_context,next_code_indx);
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

function [decode_context] = reduce(decode_context,origin_code_indx)
decoded_unprocessed = decode_context.decoded_unprocessed;
undecoded_codes = decode_context.undecoded_codes;

    [row,col] = size(decode_context.codes_registered_to_reduce);
    for indx = 1:col
        curr = decode_context.codes_registered_to_reduce(indx);
        undecoded_codes(curr,origin_code_indx) = 0;
        if sum(undecoded_codes(curr,:)) == 1%������������
            new_code_indx = decode_context.indx_table(boolean(undecoded_codes(curr,:)));
            if(sum(new_code_indx == decoded_unprocessed) == 0)
                decoded_unprocessed = [decoded_unprocessed,decode_context.indx_table(boolean(undecoded_codes(curr,:)))];
            end
            %��Ȼundecoded_codes����һ���ѱ����������һ�в��ܷ��������ݣ���Ϊ�����е��������Ѿ�����register�У���
            %�����ġ�����������һ�У�Ҳû��Ӱ�졣Ϊ��ȫ�����ȫ����0
            undecoded_codes(curr,:) = 0;
        end
    end

decode_context.decoded_unprocessed = decoded_unprocessed;
decode_context.undecoded_codes = undecoded_codes;
end
