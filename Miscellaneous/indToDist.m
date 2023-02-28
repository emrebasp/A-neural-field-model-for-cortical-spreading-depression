%% Convert the population pair index to distance from the center

indToDistF = @(ind, nOfPops, diskRadius, finTime)...
    (2*diskRadius*(ind - 1)/(nOfPops-1)-diskRadius)/finTime;

diskRadius = 200;
nOfPops = 2048;
finTime = 200;

% kVals and corresponding indices to peak positions
kVals = [1.20, 1.25, 1.30, 1.35, 1.40, 1.45, 1.50, 1.55, 1.60, 1.65, 1.70];
ind = [1474, 1427, 1389, 1356, 1328, 1301, 1275, 1250, 1225, 1199, 1171];
dist = indToDistF(ind, nOfPops, diskRadius, finTime);

% Plot decreasing propagation speed with increasing k_e^*=k_i^*=k^* value
figure;
plot(kVals, dist, '*-', 'MarkerSize', 12, 'LineWidth', 2)

