% script for File Management

function fixPath()

    % NOTE: make sure that this function is always in the Home Folder: ACWingOptimizer
    global HomeDir
    HomeDir = pwd;

    % Adding subfolders to Matlab search path
    here = mfilename('fullpath');
    [path, ~, ~] = fileparts(here);
    addpath(genpath(path));

end