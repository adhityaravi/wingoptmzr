% script to calculate the Aircraft Take-Off Weight for the given Aircraft
% Wing Weight and Fuel Weight

function [Wto] = TOWAnalysis(Ww, Wf)

    % input variables
    % ---------------------------------------------------------------------
    % Ww        - Aircraft Wing Weight in kg
    % Wf        - Aircraft Fuel Weight in kg
    
    % output variable
    % ---------------------------------------------------------------------
    % Wto       - Aircraft Take-Off Weight in kg
    
    %% Take-Off weight calculation
    % Aircraft specific rest weight (passengers, fuselage, tail, wings...)
    Wrest = 16493; %kg
    
    Wto = Ww + Wf + Wrest;