% script to perform the aerodynamic analysis on the Aircraft wing to 
% estimate the Drag and Lift

function [D, L] = ADAnalysis(Wf, Wto, DesVar)
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
    % D          - Aircraft Drag in N
    % L          - Aircraft Lift in N
    
    %% PreP
    % CL calculation
    load FlyingConditions.mat
    Wc = Wto - (0.4*Wf); % Aircraft Cruise Weight in kg
    L = Wc * 9.81; % Aircraft Lift in N
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
    AC.Visc  = 1;             % 0 for inviscid and 1 for viscous analysis
    
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
    cd (HomeDir) % making sure Q3D is always called from the Home Directory (for accessing xfoil and avl) 
    Res = Q3D_solver(AC);
    cd (CP)
    
    %% PostP
    % Total Drag calculation
    D0 = 10.3446e3; % Drag from fuselage, tail... in N (specific to this aircraft)
    D = D0 + (0.5*FC.Air.rho*V*V*S*Res.CDwing);
    
end
    
    
    
    
    
    