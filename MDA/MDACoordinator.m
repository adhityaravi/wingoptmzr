% script to coordinate the multidisciplinary analysis to determine the
% consistent values for state variables

% Used Architecture : Multidisciplinary feasible
% Used Algorithm    : Gauss-Siedel

function [Wf, Wto] = MDACoordinator(DesVar)

    % input variables
    % ---------------------------------------------------------------------
    % DesVar       - Design Variables 
    %                   [Planform Geometry : root chord, tip chord, 
    %                                        sweep angle, half span
    %                    Airfoils          : root airfoil, tip airfoil]

    % output variables
    % ---------------------------------------------------------------------
    % Wf           - Aircraft Fuel Weight
    % Wto          - Aircraft Take-Off Weight

    %% Prep
    % intial guess for Wf and Wto
    load InitialValues.mat
    Wf_c = Init.Wf;
    Wto_c = Init.Wto;
    Ww_c = Init.Ww;

    % tolerance on consistency and maximum number of allowed iterations
    eps = 1e-6;
    itermax = 1000;
    i = 1;
    res = 1;
    
    %% Gauss-Siedel Loop for Consistency
    while (i<itermax) && (res>eps)
        
        % Aircraft Aerodynamic Analysis
        [D, L] = ADAnalysis(Wf_c, Wto_c, DesVar);
        
        % Aircraft Weight Analysis
        % Aircraft Wing Weight Analyis
        [Ww_n] = WWAnalysis(Wf_c, Wto_c, DesVar);
        
        % Aircraft Fuel Weight Analysis
        [Wf_n] = FWAnalysis(Wto_c, D, L);
        
        % Aircraft Take-Off Weight Analysis
        [Wto_n] = TOWAnalysis(Ww_n, Wf_n);
        
        % Residue calculation
        res = norm([Ww_n-Ww_c, Wf_n-Wf_c, Wto_n-Wto_c]);
        i = i+1;
        
        Ww_c = Ww_n;
        Wf_c = Wf_n;
        Wto_c = Wto_n;
    
    end
    
    %% Tolerance check
    if (i>itermax) && (res>eps)
        warning(['Consistency loop converged with residual value %f,',...
                 'increase maximum number of iterations to meet the',...
                 'specified tolerance value of %f'], res, eps);
    end
    
    %% Postp
    Wf = Wf_c;
    Wto = Wto_c;
end
        
