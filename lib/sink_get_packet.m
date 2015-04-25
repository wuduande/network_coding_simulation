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
    %��¼�£�ÿ����û�����������ԭʼ�뱻��Щ���յ�������������
    %��ԭʼ�뱻������󣬾Ϳ��Ը�����������������ǵ��������
    future_decode_register = cell(1,inputNum);
    undecoded_codes = [];
    %find indx table
    indx_table = 1:inputNum;
    receive_counter = 0;
end
%%
    %�����������(reduce)
    can_be_removed = new_code & decoded_processed;
    new_code = new_code - can_be_removed;
    %���������
    if sum(new_code) > 1
        undecoded_codes = [undecoded_codes;new_code];
        %register
        [row,col] = size(undecoded_codes);%row��ֵ��ʵ��������ָ��������µ�δ����İ�����undecoded_codes�е���������
        for indx = 1:inputNum
            if new_code(indx)
                future_decode_register{indx} = [future_decode_register{indx},row];
            end
        end
    elseif sum(new_code) == 1
        decoded_unprocessed = [decoded_unprocessed,indx_table(boolean(new_code))];
    end

    %%
    %����ڶ��׶Σ�ѭ����������decoded_unprocessed
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
        if sum(undecoded_codes(curr,:)) == 1%������������
            decoded_unprocessed = [decoded_unprocessed,indx_table(boolean(undecoded_codes(curr,:)))];
            %��Ȼundecoded_codes����һ���ѱ����������һ�в��ܷ��������ݣ���Ϊ�����е��������Ѿ�����register�У���
            %�����ġ�����������һ�У�Ҳû��Ӱ�졣Ϊ��ȫ�����ȫ����0
            undecoded_codes(curr,:) = 0;
        end
    end
end
