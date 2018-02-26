%% script to build Planform Geometry Coordinates
    function [x, y] = buildPGC(DesVar)
    
         % input variables
        % -----------------------------------------------------------------
        % DesVar       - Design Variables 
        %                   [Planform Geometry : root chord, tip chord, 
        %                                        sweep angle, half span
        %                    Airfoils          : root airfoil, tip airfoil]

        
        % output variables 
        % -----------------------------------------------------------------
        % x, y     - x and y coordinates of the Planform Geometry
        %            respectively
        
        %% Planform Geometry Coordinates
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