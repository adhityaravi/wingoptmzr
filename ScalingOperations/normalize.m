% script to normalize objective function and constraints

function [sol] = normalize(varargin)

    % input variables
    % ---------------------------------------------------------------------
    % Wf       - Fuel Weight
    % WL       - Wing Loading
    % AR       - Aspect Ratio
    
    % output variables
    % ---------------------------------------------------------------------
    % sol      - value of input normalized with initial value
    
    %% Normalizing Objective Function
    if nargin == 1
        
        load InitialValues.mat
        Wf = varargin{1};
        
        % Normalized Objective Function
        sol = Wf / Init.Wf;
        
    else
        
        load InitialValues.mat
        WL = varargin{1};
        AR = varargin{2};
        
        % Intial Wing Loading calculation
        WLi = Init.Wto / (2 * 0.5 * (Init.PG.cr+Init.PG.ct) * Init.PG.hs);
        
        % Normalized Constraints
        sol(1) = (WL/WLi) - 1; % Wing Loading Constraint
        sol(2) = 1 - (AR/9); % Aspect Ratio Constraint
        
    end
    
end
        