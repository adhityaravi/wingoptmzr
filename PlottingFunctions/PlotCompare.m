% script to perform a Plot Comparison between initial and optimized wing

function PlotCompare(DesVar)

    % input variables
    % ---------------------------------------------------------------------
    % DesVar       - Design Variables 
    %                   [Planform Geometry : root chord, tip chord, 
    %                                        sweep angle, half span
    %                    Airfoils          : root airfoil, tip airfoil]
               
    %% PreP
    Init = load('InitialValues.mat');
    
    % Initial Airfoil Coordinates
    % Root Airfoil
    [xInitRootAFC, yInitRootAFC] = buildAFC(Init.Init.AF.root);
    % Tip Airfoil
    [xInitTipAFC, yInitTipAFC] = buildAFC(Init.Init.AF.tip);
    
    % Initial Planform Geometry Coordinates
    [xInitPGC, yInitPGC] = buildPGC(Init.Init);
    
    % Optimized Airfoil Coordinates
    % Root Airfoil
    [xOptRootAFC, yOptRootAFC] = buildAFC(DesVar.AF.root);
    % Tip Airfoil
    [xOptTipAFC, yOptTipAFC] = buildAFC(DesVar.AF.tip);
    
    % Optimized Planform Geometry Coordinates
    [xOptPGC, yOptPGC] = buildPGC(DesVar);
    
    %% Plotting Operation
    figure('Name', 'Comparison Plot')
    % Root Airfoil Comparison
    subplot(3, 1, 1)
    plot(xInitRootAFC, yInitRootAFC, 'B+-')
    hold on
    plot(xOptRootAFC, yOptRootAFC, 'R*-')
    hold off
    title('Initial Root Airfoil Vs Optimized Root Airfoil')
    xlabel('x/c')
    ylabel('y/c')
    legend('Initial', 'Optimized')
    
    % Tip Airfoil Comparison
    subplot(3, 1, 2)
    plot(xInitTipAFC, yInitTipAFC, 'B+-')
    hold on
    plot(xOptTipAFC, yOptTipAFC, 'R*-')
    hold off
    title('Initial Tip Airfoil Vs Optimized Tip Airfoil')
    xlabel('x/c')
    ylabel('y/c')
    legend('Initial', 'Optimized')
    
    % Planform Geometry Comparison
    subplot(3, 1, 3)
    P1 = plot(xInitPGC, yInitPGC, 'B+-');
    hold on
    P2 = plot(xOptPGC, yOptPGC, 'R*-');
    hold off
    set([P1 P2], 'LineWidth', 2);
    axis ([-16 16 -1 5])
    title('Initial Planform Geometry Vs Optimized Planform Geometry')
    xlabel('x')
    ylabel('y')
    legend('Initial', 'Optimized')
    
end
    
    
    
    
    
    
    