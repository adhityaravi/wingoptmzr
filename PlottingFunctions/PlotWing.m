% script to plot the given Wing Geometry

function PlotWing(DesVar, WingName)

    % input variables
    % ---------------------------------------------------------------------
    % DesVar       - Design Variables 
    %                   [Planform Geometry : root chord, tip chord, 
    %                                        sweep angle, half span
    %                    Airfoils          : root airfoil, tip airfoil]
    % WingName     - Name of the Wing to be plotted 
    %% PreP
    
    if nargin == 1
        WingName = 'Wing Plot';
    end
    
    % Fetching Airfoil Coordinates
    % Root
    [xRootAFC, yRootAFC] = buildAFC(DesVar.AF.root);
    % Tip
    [xTipAFC, yTipAFC] = buildAFC(DesVar.AF.tip);
    
    % Fetching Planform Geometry Coordinates
    [xPGC, yPGC] = buildPGC(DesVar);
    
    %% Plotting Operation
    figure('Name', WingName)
    % Root Airfoil Plot
    subplot(3, 1, 1)
    plot(xRootAFC, yRootAFC, 'B+-')
    title('Root Airfoil')
    xlabel('x/c')
    ylabel('y/c')
    
    % Tip Airfoil Plot
    subplot(3, 1, 2)
    plot(xTipAFC, yTipAFC, 'B+-')
    title('Tip Airfoil')
    xlabel('x/c')
    ylabel('y/c')
    
    % Planform Geometry Plot
    subplot(3, 1, 3)
    plot(xPGC, yPGC, 'B+-')
    title('Planform Geometry')
    xlabel('x/c')
    ylabel('y/c')
    
end
    
    

    