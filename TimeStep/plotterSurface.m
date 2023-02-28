clear all;
close all;

% Load simulation results
dataSet = load('exc_propagationSpeedArray_c1c2_from_0.10_to_1.50.mat'); % plot for the inhibitory activity
dataSet1 = dataSet.parameterList;
dataSet2 = dataSet.propagationSpeedArray2;

c1Axis = dataSet1; % Parameter list for c1 (x-axis)
x = c1Axis;
c2Axis = dataSet1; % Parameter list for c2 (y-axis)
y = c2Axis;
propagationSpeed = dataSet2;
z = propagationSpeed;

nOfSamples = length(x);

% Surface plot
figure(1);
stem3(x, y, z)
grid on
xv = linspace(min(x), max(x), nOfSamples);
yv = linspace(min(y), max(y), nOfSamples);
[X,Y] = meshgrid(xv, yv);
Z = griddata(x,y,z,X,Y);
figure(2)
surf(X, Y, Z, 'FaceAlpha', 0.5);
colormap([0 0 1])
grid on
set(gca, 'ZLim',[0 5])
shading interp
xlabel('c1')
ylabel('c2')
zlabel('pSpeed')

