% script to perform the wing weight analyis on the Aircraft wing to
% estimate the value of wing weight

function [Ww] = WWAnalysis(Wf, Wto, DesVar)
    global HomeDir

    % input variables 
    % ---------------------------------------------------------------------
    % Wf         - Aircraft Fuel Weight in kg
    % Wto        - Aircraft Take-Off Weight in kg
    % DesVar     - Design Variables 
    %                [Planform Geometry : root chord, tip chord, 
    %                                     sweep angle, half span
    %                 Airfoils          : root airfoil, tip airfoil]
    
    % output variables
    % ---------------------------------------------------------------------
    % Ww         - Aircraft Wing Weight in kg
    
    %% Prep
    load FlyingConditions.mat
    filename = 'optwing';
    
    % Display option for EMWET
    DisplayOption = 0; % 0 -> Off / 1 -> On
    
    % Initiator for EMWET
    I = initiate(Wf, Wto, DesVar);
    
    % Calling Q3D solver to calculate Load for EMWET
    Res = solveQ3D(Wto, DesVar);
    
    % Dynamic pressure calculation
    V = FC.M * FC.Air.a; % Aircraft Velocity
    q = 0.5 * FC.Air.rho * V * V; 
    
    % Mean Aerodynamic Chord calculation
    MAC = DesVar.PG.cr - (2*(DesVar.PG.cr-DesVar.PG.ct)*...
          (0.5*DesVar.PG.cr + DesVar.PG.ct) / ...
          (3*(DesVar.PG.cr + DesVar.PG.ct))); 
      
    % Lift and Pitching Moment distribution calculation
    AS.Y = linspace(0,1,20);
    AS.L = interp1(Res.Wing.Yst,Res.Wing.ccl*q,AS.Y*I.Wing(1).Span/2,'spline'); %lift distribution
    AS.T = interp1(Res.Wing.Yst,Res.Wing.cm_c4.*Res.Wing.chord*q*MAC,AS.Y*I.Wing(1).Span/2,'spline'); % pitching moment distribution
    
    %% Creating .init file for EMWET
    CP = pwd;
    cd ([HomeDir '\Storage']) % writing files in the Storage folder
    fid = fopen([filename '.init'], 'wt'); 
    
    % Design weight
    fprintf(fid,'%g %g\n',I.Weight.MTOW,I.Weight.ZFW);
    fprintf(fid,'%g\n',I.n_max);
    fprintf(fid,'%g %g %g %g\n',I.Wing(1).Area,I.Wing(1).Span,I.Wing(1).SectionNumber,I.Wing(1).AirfoilNumber);
    
    % Airfoil specification
    for i=1:length(I.Wing(1).AirfoilName)
        fprintf(fid,'%g %s\n',I.Wing(1).AirfoilPosition(i),I.Wing(1).AirfoilName{i});
    end
    
    % Planform section specification
    for i=1:I.Wing(1).SectionNumber
       fprintf(fid,'%g %g %g %g %g %g\n',I.Wing(i).WingSection.Chord,I.Wing(i).WingSection.Xle,I.Wing(i).WingSection.Yle,I.Wing(i).WingSection.Zle,I.Wing(i).WingSection.FrontSparPosition,I.Wing(i).WingSection.RearSparPosition); 
    end
    
    % Fuel tank specification
    fprintf(fid,'%g %g\n',I.WingFuelTank.Ystart,I.WingFuelTank.Yend);
    fprintf(fid,'%g\n',I.PP(1).WingEngineNumber);
    
    % Engine specification
    for i = 1:I.PP(1).WingEngineNumber
        fprintf(fid,'%g %g\n',I.PP(i).EnginePosition,I.PP(i).EngineWeight);
    end
    
    % Material specification
    fprintf(fid,'%g %g %g %g\n',I.Material.Wing.UpperPanel.E,I.Material.Wing.UpperPanel.rho,I.Material.Wing.UpperPanel.Sigma_tensile,I.Material.Wing.UpperPanel.Sigma_compressive);
    fprintf(fid,'%g %g %g %g\n',I.Material.Wing.LowerPanel.E,I.Material.Wing.LowerPanel.rho,I.Material.Wing.LowerPanel.Sigma_tensile,I.Material.Wing.LowerPanel.Sigma_compressive);
    fprintf(fid,'%g %g %g %g\n',I.Material.Wing.FrontSpar.E,I.Material.Wing.FrontSpar.rho,I.Material.Wing.FrontSpar.Sigma_tensile,I.Material.Wing.FrontSpar.Sigma_compressive);
    fprintf(fid,'%g %g %g %g\n',I.Material.Wing.RearSpar.E,I.Material.Wing.RearSpar.rho,I.Material.Wing.RearSpar.Sigma_tensile,I.Material.Wing.RearSpar.Sigma_compressive);

    % Structure specification
    fprintf(fid,'%g %g\n',I.Structure.Wing.UpperPanelEfficiency,I.Structure.Wing.RibPitch);
    fprintf(fid,'%g\n',DisplayOption);

    fclose(fid);
    
    %% Creating .load file for EMWET
    fid = fopen([filename '.load'], 'wt');  

    for i=1:length(AS.Y)
        fprintf(fid,'%g %g %g\n',AS.Y(i),AS.L(i),AS.T(i));
    end

    fclose(fid);
    
    %% Calling EMWET
    EMWET(filename)
    
    %% Postp
    % Reading output from .weight file
    fid     = fopen([filename '.weight'], 'r');
    OUT = textscan(fid, '%s'); 
    fclose(fid);
    
    out = OUT{1};
    Ww = str2double (out(4));
    
    % Removing pre-existing data
    removeData(filename, I); 
    cd (CP)
    
end
    
    


    
    
    