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
%   Changelog: 19/02/2014 Return the figure handle
%
%*********************************************************


function  handle = myfigure(objectname)

    object = findobj('Name', objectname);
    if(object)
        set(0,'CurrentFigure',object);
        handle = gcf;
    else
        handle = figure('Name', objectname,'NumberTitle','off');
    end
end
