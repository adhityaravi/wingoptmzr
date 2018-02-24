% main script to optimize the 3D Aircraft Wing

%% Clearing the Workspace
close all;
clear;
clc;

%% PreP
% File Management
fixPath();

% Initial Data input
% Initial Weight 
Init.Wf = 2220;     % Initial Fuel Weight in kg
Init.Ww = 2107;     % Initial Wing Weight in kg
Init.Wto = 20820;   % Initial Take-Off Weight in kg
% Initial Airfoils
% CST's Root Airfoil
Init.AF.root = [0.257751849773405,0.284778157335682,0.149584217447372,0.241324120810623,0.200373441098857,-0.171555131253414,-0.0909010297201698,-0.257077271771597,-0.0583085434274001,-0.221462293163015];
% CST's Tip Airfoil
Init.AF.tip = [0.215492118995331,0.244049491852961,0.113945417074960,0.207168725501259,0.159975209942053,-0.128546762088269,-0.0564181201204965,-0.210720137310721,-0.0335971762440515,-0.176632769400283];
% Initial Planform Geometry
Init.PG.cr = 3.5;   % Root Chord
Init.PG.ct = 0.9;   % Tip Chord
Init.PG.hs = 14;    % Half Span
Init.PG.sa = 5;     % Sweep Angle

save('InitialValues.mat', 'Init');

% Flight Conditions
FC.alt = 10000; % Altitude in m
FC.M = 0.55;    % Mach
% Air properties at specified altitude
FC.Air.a = 299.46;      % Sound of Speed in m/s
FC.Air.rho = 0.4127;    % Air Density in kg/m^3
FC.Air.mu = 1.4688e-5;  % Dynamic Viscosity of Air in Pa.s

save('FlyingConditions.mat', 'FC');

%% Building problem to optimize
problem = buildProblem;

%% Optimizing Wing
tic
DV_opt = fmincon(problem);
t = toc;
fprintf('Optimized in %f seconds', t);

%% PostP
DesVar_opt = rescale(DV_opt);

