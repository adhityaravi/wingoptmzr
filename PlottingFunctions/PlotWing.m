% script to plot the given Wing Geometry

function PlotWing(DesVar, PlotName)

    % input variables
    % ---------------------------------------------------------------------
    % DesVar       - Design Variables 
    %                   [Planform Geometry : root chord, tip chord, 
    %                                        sweep angle, half span
    %                    Airfoils          : root airfoil, tip airfoil]
    % WingName     - Name of the Wing to be plotted (optional) 
    %% PreP   
    if nargin == 1
        PlotName = 'WingPlot';
    end
    
    % Fetching Airfoil Coordinates
    % Root
    [xRootAFC, yRootAFC] = buildAFC(DesVar.AF.root);
    % Tip
    [xTipAFC, yTipAFC] = buildAFC(DesVar.AF.tip);
    
    % Fetching Planform Geometry Coordinates
    [xPGC, yPGC] = buildPGC(DesVar);
    
    %% Plotting Operation
    close(findobj('type', 'figure', 'name', 'DebugPlot'))
    figure('Name', PlotName)
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
    P1 = plot(xPGC, yPGC, 'B+-');
    set(P1, 'LineWidth', 2);
    title('Planform Geometry')
    xlabel('x')
    ylabel('y')
    
end
    
    

    