% script to calculate the Fuel Weight of the Aircraft for the given
% Aircraft Take-Off Weight , Lift and Drag

function [Wf] = FWAnalysis(Wto, D, L)

    % input variables
    % ---------------------------------------------------------------------
    % Wto        - Aircraft Take-Off Weight in kg
    % D          - Aircraft Drag in N
    % L          - Aircraft Lift in N
    
    % output variables
    % ---------------------------------------------------------------------
    % Wf         - Aircraft Fuel Weight in kg
    
    %% Fuel Weight estimation
    % Aircraft specific Mff
    X = -0.6718;
    Mff = 0.9461 * exp(X*(D/L));
    
    % Fuel Weight
    Wf = 1.05 * (1-Mff) * Wto; 
    