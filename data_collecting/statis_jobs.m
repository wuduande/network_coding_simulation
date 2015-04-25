function [ output_args ] = statis_jobs( input_args )
%STATIS_JOBS Summary of this function goes here
%   Detailed explanation goes here
global dgl_curve rbst_curve;
dgl = 'degree_limit_opt';
rbst = 'robust_siliton';
N = [50,100,200,300,400,500];
[max_hop_curve_dgl mean_hop_curve_dgl] = get_cost_curve(dgl);
[max_hop_curve_rbst mean_hop_curve_rbst] = get_cost_curve(rbst);

figure(1);hold on;
plot(N,max_hop_curve_dgl,'r');
plot(N,mean_hop_curve_dgl,'r');

plot(N,max_hop_curve_rbst,'k');
plot(N,mean_hop_curve_rbst,'k');
end

function [max_hop_curve mean_hop_curve] = get_cost_curve(dis_type)
    N = [50,100,200,300,400,500];
    max_hop_curve = zeros(1,size(N,2));
    mean_hop_curve = zeros(1,size(N,2));
    
    for j = 1:size(N,2)
       [max_hop_curve(j) mean_hop_curve(j)] = ave_N_type(N(j),dis_type);
    end
end

function [av_max_hop av_mean_hop] = ave_N_type(nodeNum,dis_type)
    av_max_hop = 0;
    av_mean_hop = 0;
    for indx = 1:100
        [av_max_hop_tmp av_mean_hop_tmp] = system_statis(nodeNum,dis_type,indx);
        av_max_hop = av_max_hop +  av_max_hop_tmp;
        av_mean_hop = av_mean_hop + av_mean_hop_tmp;
    end
    av_max_hop = av_max_hop/100;
    av_mean_hop = av_mean_hop/100;
end