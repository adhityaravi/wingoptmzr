% script to perform a Plot Comparison between initial and optimized wing

function comparePlot(DesVar)

    % input variables
    % ---------------------------------------------------------------------
    % DesVar       - Design Variables 
    %                   [Planform Geometry : root chord, tip chord, 
    %                                        sweep angle, half span
    %                    Airfoils          : root airfoil, tip airfoil]
    
    %% Subfunction to build Planform Geometry Coordinates
    function [x, y] = buildPGC(DesVar)
        
        % output variables 
        % -----------------------------------------------------------------
        % x, y     - x and y coordinates of the Planform Geometry
        %            respectively
        
        x = zeros(8, 1);
        y = zeros(8, 1);
        
        x(1) = 0;
        y(1) = 0;
        
        x(2) = 0;
        y(2) = DesVar.PG.cr;
        
        x(3) = DesVar.PG.hs;
        y(3) = tand(DesVar.PG.sa)*DesVar.PG.hs;
        
        x(4) = x(3);
        y(4) = y(3) - DesVar.PG.ct;
        
        x(5) = 0;
        y(5) = 0;
        
        x(6) = -x(4);
        y(6) = y(4);
        
        x(7) = -x(3);
        y(7) = y(3);
        
        x(8) = -x(2);
        y(8) = y(2);
        
    end

    %% Subfunction to build Airfoil Coordinates
    function [x, y] = buildAFC(A)
        
        % input variables
        % -----------------------------------------------------------------
        % A        - CST coefficients
        
        % output variables 
        % -----------------------------------------------------------------
        % x, y     - x and y coordinates of the Airfoil respectively
        
        % Converting CST's to XY's
        % Generating x coordinates with cossine spacing
        xcos = cosspace(0, 1, 101);

        % Splitting CST's into upper and lower parts
        l = length(A);
        ls = l/2;
        
        % Converting CST's to y coordinates
        yu = CSTairfoil(A(1:ls),xcos');
        yl = CSTairfoil(A(ls+1:end),xcos(2:end)');
        
        x = [flipud(xcos');xcos(2:end)'];
        y = [flipud(yu');yl'];
        
    end
               
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
    figure
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
    
    
    
    
    
    
    