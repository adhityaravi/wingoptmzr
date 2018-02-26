% script to build the Optimization Problem

function [problem] = buildProblem

    % output variables
    % ---------------------------------------------------------------------
    % problem   - structure containing the objective function, constraints,
    %             bounds, initial values for optimization
    
    %% Initial Value for Design Variables
    % fetching the dimesion of the design vector
    Init = load ('InitialValues.mat');
    dimAF = 0;
    dimPG =  numel(fieldnames(Init.Init.PG));
    DVAirfoil = struct2cell(Init.Init.AF);
    for i=1:numel(DVAirfoil)
        dimAF = dimAF + numel(DVAirfoil{i});
    end
    dim = dimAF+dimPG;
    DV0 = ones(1, dim);
    
    % Global values to be shared
    DVlast = [];
    Wf = [];
    Wto = [];
    
    %% Objective Function
    function f = obj(DV)
        
        % Re-Scaling Design Vector
        DesVar = rescale(DV); 
        % MDA run 
        if ~isequal(DV, DVlast) % Checking if MDA run is necessary
            [Wf, Wto] = MDACoordinator(DesVar);
            DVlast = DV;
        end
        % Normalizing Objective Value
        f = normalize(Wf);
        
    end

    %% Constraints
    function [c, ceq] = con(DV)
        
        % Inequality constraint
        % Re-Scaling Design Vector
        DesVar = rescale(DV); 
        % MDA run 
        if ~isequal(DV, DVlast) % Checking if MDA run is necessary
            [Wf, Wto] = MDACoordinator(DesVar); 
            DVlast = DV;
        end
        % Wing Loading calculation 
        WL = Wto / (2 * 0.5 * (DesVar.PG.cr+DesVar.PG.ct) * DesVar.PG.hs);
        % Aspect Ratio calculation
        AR = ((2*DesVar.PG.hs)^2) / (2 * 0.5 * (DesVar.PG.cr+DesVar.PG.ct) * DesVar.PG.hs);
        % Normalizing Constaraint Value
        c = normalize(WL, AR);
        
        % Equality constraint
        ceq = [];
        
    end

    %% Bounds for Design Variables
    ub = zeros(1, dimAF+dimPG);
    lb = zeros(1, dimAF+dimPG);
    
    % Bounds for Airfoil CST's
    ub(1:dimAF) = 2.5 * DV0(1:dimAF);
    lb(1:dimAF) = -0.05 * DV0(1:dimAF);
    
    % Bounds for Planform Geometry
    ub((dimAF+1):dim) = 2.5 * DV0((dimAF+1):dim);
    lb((dimAF+1):dim) = 0.3 * DV0((dimAF+1):dim);
      
    %% Creating function handles and options for fmincon
    objective = @(DV) obj(DV);
    constraint = @(DV) con(DV);
    
    options = optimoptions(@fmincon,'Algorithm', 'sqp',...
                           'Display', 'iter-detailed',... 
                           'FinDiffRelStep', 0.03,...
                           'PlotFcn', {@optimplotfunccount, @optimplotfval, @optimplotstepsize, @optimplotfirstorderopt, @optimplotconstrviolation});
                       
    %% Creating the problem struct for fmincon
    problem.x0 = DV0;
    problem.objective = objective;
    problem.nonlcon = constraint;
    problem.lb = lb;
    problem.ub = ub;
    problem.solver = 'fmincon';
    problem.options = options;
    
end
