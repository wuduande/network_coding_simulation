function init_statis_context()
global statis nodeNum;
%��ʼ��ͳ�ƻ���
statis.degree_statis = zeros(1,nodeNum);
statis.hop_statis = 0;
statis.max_path_len = 0;
statis.is_data_valid = 1;
statis.num_statis = 1;
end