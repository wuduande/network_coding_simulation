%% figure_scalability: function description
function [outputs] = figure_scalability(arg)
%绘制论文用图，比较LT码与DDL-LT码的扩展性�?
	N = 1:100:1000;
	figure(1); hold on;
	
	plot_rbst_R(N);

	for gamma = 4:8
		plot_dlg(N,gamma);
	end
end

function plot_rbst_R(N)
	rbst = 78 - N./8;
    rbst = max(rbst,0);
	plot(N,rbst,'r');
end

function plot_dlg(N,gamma)
	dgl = 78 - gamma.*log2(N)./8;
	plot(N,dgl,'k');
end