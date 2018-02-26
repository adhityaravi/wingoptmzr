%% script to build Airfoil Coordinates

    function [x, y] = buildAFC(A)
        
        % input variables
        % -----------------------------------------------------------------
        % A        - CST coefficients
        
        % output variables 
        % -----------------------------------------------------------------
        % x, y     - x and y coordinates of the Airfoil respectively
        
        %% Converting CST's to XY's
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