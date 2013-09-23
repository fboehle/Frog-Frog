%*********************************************************
%	Convert the frog camera image to a calibrated frogtrace
%	
%	Developement started: end 2012
%	Author: Frederik Böhle code@fboehle.de
%
%*********************************************************
%   
%   Description: 
%
%   Notes:
%       the camera has a timespan from -100fs until 100fs: bandwidth 200fs
%       and a frequency range from about 
%
%   Changelog:
%
%*********************************************************

clear all

[X,Y] = meshgrid(-2:.2:2, -2:.2:2);                                
Z = X .* exp(-X.^2 - Y.^2);                                        
surf(X,Y,X,Y,X)
