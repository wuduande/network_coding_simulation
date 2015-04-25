%²¼ÖÃ×÷Òµ

% matlabpool open local 2;
N = [100 200 300 400 500];
simu_times = 100;

for indx = 1:5
    simu_N_times(N(indx),simu_times);
end

for indx = 1:5
    simu_N_times(N(indx),simu_times);
end

% matlabpool close;