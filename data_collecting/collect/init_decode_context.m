function decode_context = init_decode_context(context)
nodeNum = context.nodeNum;
%初始化解码环境
decode_context.k = floor(0.98*nodeNum);
decode_context.is_finished = 0;
decode_context.decoded_processed = zeros(1,nodeNum);
decode_context.decoded_unprocessed = [];
%记录下，每个还没被解码出来的原始码被哪些已收到的码字依赖。
%当原始码被解出来后，就可以根据这个表来消除他们的冗余分量
decode_context.future_decode_register = cell(1,nodeNum);
decode_context.undecoded_codes = [];
%find indx table
decode_context.indx_table = 1:nodeNum;
decode_context.receive_counter = 0;
end
