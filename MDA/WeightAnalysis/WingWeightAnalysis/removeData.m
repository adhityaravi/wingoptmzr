% script to check if all data are written and remove them 
% -> written as a debugging step 

function removeData(filename, I)

    % input variables
    % ---------------------------------------------------------------------
    % filename     - filename of the files to remove
    % I            - for removing written airfoil files

    %% checking and removing the preexisting data written for and by EMWET
    for i=1:I.Wing(1).AirfoilNumber
        if exist([char(I.Wing(1).AirfoilName(i)) '.dat'], 'file')
            delete ([char(I.Wing(1).AirfoilName(i)) '.dat'])
        else
            error('buildACF did not write .dat files')
        end
    end
    
    if exist([filename '.weight'], 'file')
        delete ([filename '.weight'])
        delete ([filename '.load'])
        delete ([filename '.init'])
    else
        error('EMWET did not write the .weight file');
    end
    
end