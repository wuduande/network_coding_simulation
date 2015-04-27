function ddllt_job_schedule()
%²¼ÖÃ×÷Òµ

% matlabpool open local 2;
N = [100 200 300 400 500];
dg = [5 6 6 7 7];
tau = [27 27 27 27 27];
simu_times = 100;

for indx = 1:5
    ddllt_simu_N_times(N(indx),tau(indx),dg(indx),simu_times);
end

% matlabpool close;
end