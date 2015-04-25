%²¼ÖÃ×÷Òµ

% matlabpool open local 2;
N = [100 200 300 400 500];
tau = [5 6 6 7 7];
dg = [27 38 46 54 60];

for indx = 1:5
    auto_simu_N(N(indx),1,tau(indx),dg(indx));
end

for indx = 1:5
    auto_simu_N(N(indx),2,tau(indx),dg(indx));
end

% matlabpool close;