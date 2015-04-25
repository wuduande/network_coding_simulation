function decode_context = init_decode_context(context)
nodeNum = context.nodeNum;
%��ʼ�����뻷��
decode_context.k = floor(0.98*nodeNum);
decode_context.is_finished = 0;
decode_context.decoded_processed = zeros(1,nodeNum);
decode_context.decoded_unprocessed = [];
%��¼�£�ÿ����û�����������ԭʼ�뱻��Щ���յ�������������
%��ԭʼ�뱻������󣬾Ϳ��Ը�����������������ǵ��������
decode_context.future_decode_register = cell(1,nodeNum);
decode_context.undecoded_codes = [];
%find indx table
decode_context.indx_table = 1:nodeNum;
decode_context.receive_counter = 0;
end
