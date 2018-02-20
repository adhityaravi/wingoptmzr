% script to build .dat Airfoil Coordinate File

function buildACF(A, filename)
    global HomeDir

    % input variables
    % ---------------------------------------------------------------------
    % A          - CST coefficients
    % filename   - Airfoil name
    
    %% Converting CST's to XY's
    % Generating x coordinates with cossine spacing
    x = cosspace(0, 1, 101);
    
    % Splitting CST's into upper and lower parts
    l = length(A);
    ls = l/2;
    
    % Converting CST's to y coordinates
    yu = CSTairfoil(A(1:ls),x');
    yl = CSTairfoil(A(ls+1:end),x(2:end)');
    
    xys = [flipud(x'), flipud(yu'); x(2:end)', yl'];
    
    %% Building new Airfoil Coordinate File
    CP = pwd;
    cd ([HomeDir '\Storage']) % writing the files in Storage Folder
    dlmwrite([filename '.dat'], xys, 'delimiter', ' ', 'precision', 6);
    cd (CP)
    
end
    