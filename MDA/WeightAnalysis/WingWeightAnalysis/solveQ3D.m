% script to perform inviscous Aerodynamic analysis to calculate load for
% EMWET

function [Res] = solveQ3D(Wto, DesVar)
    global HomeDir

    % input variables 
    % ---------------------------------------------------------------------
    % Wf         - Aircraft Fuel Weight in kg
    % Wto        - Aircraft Take-Off Weight in kg
    % DesVar     - Design Variables 
    %                [Planform Geometry : root chord, tip chord, 
    %                                     sweep angle, half span
    %                 Airfoils          : root airfoil, tip airfoil]
    
    % output variables
    % ---------------------------------------------------------------------
    % Res        - Result from Q3D Aerosolver
    
    %% Prep
    % CL calculation
    load FlyingConditions.mat
    L = 2.5 * 9.81 * Wto; % critical pull up lift
    V = FC.M * FC.Air.a; % Aircraft Velocity
    S = 2 * 0.5 * (DesVar.PG.cr+DesVar.PG.ct) * DesVar.PG.hs; % Wing Area
    CL = L / (0.5*FC.Air.rho*V*V*S);
    
    % Aircraft Wing Geometry Calculation
    %       x                                y             z  chord (m)     twist angle
    Root = [0                              , 0           , 0, DesVar.PG.cr, 0];
    Tip  = [tand(DesVar.PG.sa)*DesVar.PG.hs, DesVar.PG.hs, 0, DesVar.PG.ct, 0];
    
    % Re calculation
    MAC = DesVar.PG.cr - (2*(DesVar.PG.cr-DesVar.PG.ct)*...
          (0.5*DesVar.PG.cr + DesVar.PG.ct) / ...
          (3*(DesVar.PG.cr + DesVar.PG.ct))); % Mean Aerodynamic Chord
    Re = (FC.Air.rho*V*MAC) / (FC.Air.mu);
    
    %% Solver setting for Q3D
    % Wing planform geometry
    AC.Wing.Geom = [Root;
                    Tip];
    
    % Wing incidence angle
    AC.Wing.inc = 0;
    
    % Airfoil coefficients input matrix
    AC.Wing.Airfoils = [DesVar.AF.root;
                        DesVar.AF.tip];
                    
    AC.Wing.eta = [0;1];      % Spanwise location of the airfoil sections
    
    % Viscous vs inviscid
    AC.Visc  = 0;             % 0 for inviscid and 1 for viscous analysis
    
    % Flight conditions
    AC.Aero.V = V;            % flight speed (m/s)
    AC.Aero.rho = FC.Air.rho; % air density  (kg/m3)
    AC.Aero.alt = FC.alt;     % flight altitude (m)
    AC.Aero.Re = Re;          % reynolds number (based on mean aerodynamic chord)
    AC.Aero.M = FC.M;         % flight Mach number
    AC.Aero.CL = CL;          % lift coefficient - comment this line to run the code for given alpha
    %AC.Aero.Alpha = 2;       % angle of attack -  comment this line to run the code for given cl
    
    %% Calling the Q3D solver
    CP = pwd;
    cd (HomeDir) % make sure Q3D is always called from the Home Directory (for acessing xfoil and avl)
    Res = Q3D_solver(AC);
    cd (CP)
    
end