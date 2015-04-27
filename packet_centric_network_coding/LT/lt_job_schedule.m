function lt_job_schedule()
%²¼ÖÃ×÷Òµ

% matlabpool open local 2;
N = [100 200 300 400 500];
tau = [27 27 27 27 27];
simu_times = 100;


for indx = 1:5
    lt_simu_N_times(N(indx),tau(indx),simu_times);
end
% matlabpool close;
end