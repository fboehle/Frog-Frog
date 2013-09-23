%*********************************************************
%	Create or reopen a figure with specified title
%	
%	Developement started: 2013
%	Author: Frederik Böhle code@fboehle.de
%
%*********************************************************
%   
%   Description: 
%
%   Notes:
%
%   Changelog:
%
%*********************************************************


function  myfigure(objectname)

    object = findobj('Name', objectname);
    if(object)
        set(0,'CurrentFigure',object);
    else
        figure('Name', objectname,'NumberTitle','off');
    end
end
