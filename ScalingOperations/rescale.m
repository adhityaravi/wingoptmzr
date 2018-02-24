% script to re-scale design variables and store them in a struct

function [DesVar] = rescale(DV)

    % input variables
    % ---------------------------------------------------------------------
    % DV       - normalized Design Vector
    
    % output variables
    % ---------------------------------------------------------------------
    % DesVar   - rescale Design Variables in a struct
    
    %% Rescaling Operation
    % Fetching Airfoil CST numbers and planform geometry numbers
    load InitialValues.mat
    dimAF = numel(Init.AF.root);
    
    % Rescaling and storing it in a struct
    % Airfoil
    % Root Foil
    DV(1:dimAF) = DV(1:dimAF) .* (Init.AF.root);
    DesVar.AF.root = DV(1:dimAF);
    % Tip Foil
    DV((dimAF+1):(2*dimAF)) =  DV((dimAF+1):(2*dimAF)) .* (Init.AF.tip);
    DesVar.AF.tip = DV((dimAF+1):(2*dimAF));
    % Planform Geometry
    % Root Chord
    DV((2*dimAF)+1) = DV((2*dimAF)+1) * (Init.PG.cr);
    DesVar.PG.cr = DV((2*dimAF)+1);
    % Tip Chord
    DV((2*dimAF)+2) = DV((2*dimAF)+2) * (Init.PG.ct);
    DesVar.PG.ct = DV((2*dimAF)+2);
    % Half Span
    DV((2*dimAF)+3) = DV((2*dimAF)+3) * (Init.PG.hs);
    DesVar.PG.hs = DV((2*dimAF)+3);
    % Sweep Angle
    DV((2*dimAF)+4) = DV((2*dimAF)+4) * (Init.PG.sa);
    DesVar.PG.sa = DV((2*dimAF)+4);
    
end
    
    