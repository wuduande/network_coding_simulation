function [  ] = job(  )
%JOB Summary of this function goes here
%   Detailed explanation goes here
addpath('lib')
addpath('lib/data_structure')
addpath('packet_centric_network_coding/LT');
addpath('packet_centric_network_coding/DDL-LT');

% ddllt_job_schedule();
% lt_job_schedule();

addpath('data_collecting');
collect_job_schedule();
end

