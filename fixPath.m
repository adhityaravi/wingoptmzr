% script to add all the subfolders of the current folder to the matlab
%  search path

function fixPath()

here = mfilename('fullpath');
[path, ~, ~] = fileparts(here);
addpath(genpath(path));

end