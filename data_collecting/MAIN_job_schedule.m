function MAIN_job_schedule()
%MAIN_JOB Summary of this function goes here
%   Èë¿Ú
addpath('collect');
addpath('../lib');
N = [100 200 300 400 500];
tau = 27;
dg = 5;
sample_num = 100;
path = '../result_data/';

cost_ddllt = zeros(1,5);
av_hop_ddllt = zeros(1,5);
max_hop_ddllt = zeros(1,5);
%ddllt curve
for indx = 1:5
file = build_ddllt_data_file_name_without_indx( N(indx),tau,dg);
file = [path file];
[ cost_ddllt(indx),av_hop_ddllt(indx),max_hop_ddllt(indx) ] = cost_collect(file,sample_num);
save;
end

cost_lt = zeros(1,5);
av_hop_lt = zeros(1,5);
max_hop_lt = zeros(1,5);
%lt curve
for indx = 1:5
file = build_lt_data_file_name_without_indx( N(indx));
file = [path file];
[ cost_lt(indx),av_hop_lt(indx),max_hop_lt(indx) ] = cost_collect(file,sample_num);
save;
end
end
