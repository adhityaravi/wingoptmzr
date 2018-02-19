% script to initiate a struct with data necessary for EMWET

function [I] = initiate(Wf, Wto, DesVar)

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
    % I          - Initiator struct with data necessary for EMWET
    
    %% Design Weight
    I.Weight.MTOW = Wto;            
    I.Weight.ZFW = Wto - Wf;          
    I.n_max = 2.5; % maximum load factor 
    
    %% Wing Geometry
    I.Wing(1).Area = 2 * 0.5 * (DesVar.PG.cr+DesVar.PG.ct) * DesVar.PG.hs; % m^2 
    I.Wing(1).Span = 2 * DesVar.PG.hs; % m     
    I.Wing(1).SectionNumber = 2; % planform sections
    I.Wing(1).AirfoilNumber = 2; % number of airfoils

    % Airfoil specification
    I.Wing(1).AirfoilName = {'optfoil1' 'optfoil2'};
    I.Wing(1).AirfoilPosition = [0 1]; % airfoil positions
    
    % Building airfoil coordinate files for EMWET
    buildACF(DesVar.AF.root, 'optfoil1');
    buildACF(DesVar.AF.tip, 'optfoil2');
    
    % Section specification
    % Section 1
    I.Wing(1).WingSection.Chord = DesVar.PG.cr; % m
    I.Wing(1).WingSection.Xle = 0;
    I.Wing(1).WingSection.Yle = 0;
    I.Wing(1).WingSection.Zle = 0;
    I.Wing(1).WingSection.FrontSparPosition = 0.20;
    I.Wing(1).WingSection.RearSparPosition = 0.70;
    
    % Section 2
    I.Wing(2).WingSection.Chord = DesVar.PG.ct; % m
    I.Wing(2).WingSection.Xle = tand(DesVar.PG.sa)*DesVar.PG.hs;
    I.Wing(2).WingSection.Yle = DesVar.PG.hs;
    I.Wing(2).WingSection.Zle = 0;
    I.Wing(2).WingSection.FrontSparPosition = 0.20;
    I.Wing(2).WingSection.RearSparPosition = 0.70;
    
    %% Fuel Tank Geometry
    I.WingFuelTank.Ystart = 0.1; % start position at the semi-span
    I.WingFuelTank.Yend = 0.7; % end position at the semi-span
    
    %% Engine Specification
    I.PP(1).WingEngineNumber = 1;  
    I.PP(1).EnginePosition = 0.25; % position at the semi-span
    I.PP(1).EngineWeight = 1200; % in kg
    
    %% Material and Structure (Al alloy 7075-T6 used here)
    % Upper Panel Material
    I.Material.Wing.UpperPanel.E = 7.0e10; % Young's modulus N/m^2
    I.Material.Wing.UpperPanel.rho = 2800; % Density kg/m^3
    I.Material.Wing.UpperPanel.Sigma_tensile = 4.8e8; % tensile stress N/m^2
    I.Material.Wing.UpperPanel.Sigma_compressive = 4.6e8; % compressive stress N/m^2
    
    % Lower Panel Material
    I.Material.Wing.LowerPanel.E = 7.0e10;
    I.Material.Wing.LowerPanel.rho = 2800;
    I.Material.Wing.LowerPanel.Sigma_tensile = 4.8e8;
    I.Material.Wing.LowerPanel.Sigma_compressive = 4.6e8;
    
    % Front Spar Material
    I.Material.Wing.FrontSpar.E = 7.0e10;
    I.Material.Wing.FrontSpar.rho = 2800;
    I.Material.Wing.FrontSpar.Sigma_tensile = 4.8e8;
    I.Material.Wing.FrontSpar.Sigma_compressive = 4.6e8;
    
    % Rear Spar Material
    I.Material.Wing.RearSpar.E = 7.1e10;
    I.Material.Wing.RearSpar.rho = 2800;
    I.Material.Wing.RearSpar.Sigma_tensile =4.8e8;
    I.Material.Wing.RearSpar.Sigma_compressive = 4.6e8;
    
    % Structure Properties
    I.Structure.Wing.UpperPanelEfficiency=0.96; % Z type stringers 
    I.Structure.Wing.RibPitch =0.5;
    
end
    
    

    