%%%% This m-file contains the main routine to produce spreading depression.
%%%% It simulates the spatially extended cortical spreading depression model
%%%% provided in Baspinar et al. [1]. This m-file and its corresponding
%%%% code package was prepared by Emre Baspinar and Daniele Avitabile.

% Contact: emre.baspinar@cnrs.fr





%% Initialization

clear all, close all, clc;
addpath('../ProblemFiles');

nx = 2^11; % Equal number of neurons are assumed for both populations and use the same grid for both connectivity kernels.  
Lx = 200; % 200 mm!
% index formula: (x+Lx)/(2*Lx)*(nx-1)

iVe = [1:nx]'; iVi = nx+iVe; iK = nx+iVi; idx = [iVe iVi iK];

[x,wHat,W,Dxx] = LinearOperators(nx,Lx);

%% Parameters
p(1)  = 1;    % delta
p(2)  = 0.3;  % he
p(3)  = 0.3;  % hi
p(4)  = 100;  % betae
p(5)  = 10;   % betai
p(6)  = 100;  % beta_ve
p(7)  = 10;   % beta_vi
p(8)  = 0.4;  % S0e
p(9)  = 0.4;  % S0i
p(10)  = 1.5; % veStar
p(11)  = 1.5; % viStar
p(12)  = 1.4; % keStar
p(13)  = 1.8; % keStar2
p(14)  = 1.0; % kiStar
p(15)  = 1.4; % kiStar2
p(16)  = 1.7; % kveStar 
p(17)  = 1.7; % kviStar 
p(18) = 1.0;  % c1 
p(19) = 1.0;  % c2
p(20) = -0.2; % cross connection weight from inh. to exc. population (cie)
p(21) = 0.2;  % cross connection weight from exc. to inh. population (cei)
p(22) = 1.0;  % recurrent connection weight from exc. to exc. population (cee)
p(23) = -1.0; % recurrent connection weight from inh. to inh. population (cii)
p(24) = 0.91; % wavefront threshold for excitory propagation
p(25) = 0.33; % wavefront threshold for inhibitory propagation
p(26) = 0.2;  % time scale tau


%% Model in action!

% Plot the excitatory population transfer function
[V,K] = meshgrid(0:0.01:2,0:0.01:2);
Se = FiringRateE(V,K,p(2),p(4),p(12),p(13));
figure;
surf(V,K,Se); shading interp; xlabel('V'); ylabel('K'); zlabel('Rate');


% Plot the inhibitory population transfer function
[V,K] = meshgrid(0:0.01:2,0:0.01:2);
Si = FiringRateI(V,K,p(3),p(5),p(14),p(15));
figure;
surf(V,K,Si); shading interp; xlabel('V'); ylabel('K'); zlabel('Rate');
% % % % pause

% Initialize the arrays to save the state variables
ve0 = ones(size(x)); vi0 = ones(size(x)); k0 = ones(size(x)); z0 = [ve0; vi0; k0];

% Plot initial solution
parentE = PlotSolution(x,z0,p,[],idx,false);
parentI = PlotSolution(x,z0,p,[],idx,false);

% Define handle to right-hand side and time output function
prob    = @(t,z) NeuralFieldWithDiffusible(t,z,p,Dxx,wHat,x,Lx,idx, p(26));
timeOutE = @(t,z,flag) TimeOutputE(t,z,flag,true,x,p,parentE,idx);
timeOutI = @(t,z,flag) TimeOutputI(t,z,flag,true,x,p,parentI,idx);

% Time step
tF = 200; % 200 mns! Final time of the simulation.
tStep = 1; % 1 mns!
tSpan = [0:tStep:tF]; opts = odeset('OutputFcn',timeOutE);
[t,Z] = ode45(prob,tSpan,z0,opts);
Se = FiringRateE(Z(:,iVe), Z(:,iK), p(2), p(4), p(12), p(13));
Si = FiringRateI(Z(:,iVi), Z(:,iK), p(3), p(5), p(14), p(15));

% Plot history
PlotHistory(x,t,[Z(:,[iVe iK]) Se],p,parentE,[idx(:, [1 2]) [2*nx+1:3*nx]']);
PlotHistory(x,t,[Z(:,[iVi iK]) Si],p,parentI,[idx(:, [1 2]) [2*nx+1:3*nx]']);

% Plot the time course of example state variables
id = 1500; % index of the neuron whose plots are shown
ve = Z(:,iVe(id)); vi = Z(:,iVi(id)); k = Z(:,iK(id)); re = Se(:,id); ri = Si(:,id);

figure; % for the excitatory population
plot(t,[ve k re], 'Linewidth', 2); 
legend({'ve', 'k','Xi'}); xlabel('time'); title([ 'x = ' num2str(x(id))]);

figure; % for the inhibitory population
plot(t,[vi k ri],'Linewidth', 2); 
legend({'vi','k','Eta'}); xlabel('time'); title([ 'x = ' num2str(x(id))]);

% Plot the final time solutions
PlotSolution(x,[Z(end,:) Se(end,:)],p,[],[idx(:, [1 3]) [3*nx+1:4*nx]'],false); % Plot the solution for the exc. population
PlotSolution(x,[Z(end,:) Si(end,:)],p,[],[idx(:, [2 3]) [3*nx+1:4*nx]'],false); % Plot the solution for the inh. population

% Plot the final time solution of both excitatory and inhibitory population firing rates
PlotSolutionFinE(x,Z(end,:),p,[],idx(:, 1),false); % excitatory population
PlotSolutionFinI(x,Z(end,:),p,[],idx(:, 2),false); % inhibitory population

% Compute the propagation speed for the excitatory population
spatialUnitConstant = 1;
LxPhysical = spatialUnitConstant*Lx; % Introduce the physical measure in the radial length of the population
hx = 2*LxPhysical/(nx-1);
waveFrontThreshold = p(24);
dist    = abs(Z(end,idx(:, 1)) - waveFrontThreshold);
minDist = min(dist);
errorVal = 0.075;
if minDist>errorVal
    disp('No propagating excitatory wave! Increase errorVal.')
else    
    indFind     = find(dist == minDist);
    waveFrontIndexE = max(indFind);    
    waveFrontIndexE = abs(-LxPhysical + (waveFrontIndexE-1)*hx);
    waveFrontIndexEReel = waveFrontIndexE/spatialUnitConstant;
    indFind;
    propagationSpeedExc = waveFrontIndexE/tF; % Compute the physical propagation speed and print it on the command window
end

% Display the propagation speed
dispStr = ['CSD Propagation velocity: ',num2str(propagationSpeedExc)];
disp(dispStr)
