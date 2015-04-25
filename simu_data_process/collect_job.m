function collect_job(  )
%COLLECT_JOBS Summary of this function goes here
%   Detailed explanation goes here
global dgl_curve rbst_curve;
addpath('../lib');
dgl = 'degree_limit_opt';
rbst = 'robust_siliton';

dgl_curve = get_cost_curve(dgl);
rbst_curve = get_cost_curve(rbst);

save('collect_curve_data.mat','dgl_curve','rbst_curve');
end

function ret = get_cost_curve(dis_type)
    N = [100,200,300,400,500];
    ret = zeros(1,size(N,2));
    
    for j = 1:size(N,2)
        ret(j) = ave_N_type(N(j),dis_type);
    end
end

function ret = ave_N_type(nodeNum,dis_type)
    ret = 0;
    for indx = 1:100
        init_job(nodeNum,dis_type,indx);
        for j = 1:10
            ret = ret + sink_collect();
        end
    end
    ret = ret/1000;
end

function init_job(nodeNum,dis_type,indx)
global k;
set_env(nodeNum,[]);
k = 0.98*nodeNum;
load_globals(nodeNum,dis_type,indx);
end