function [A,pathfile] = bmpload(varargin)
% BMPLOAD(PATHFILE) loads a bitmap, converting it to a normal array.
% If PATHFILE is empty, then a standard dialog box opens up.  The 
% array A is returned, along with the PATHFILE (path and filename)
% returned, if desired.

error(nargchk(0,1,nargin))

[pathfile] = parsevarargin(varargin,[]);

if isempty(pathfile)
    [fname, pname] = uigetfile('*.bmp');
    pathfile = strcat(pname,fname);
end
rawdata = imread(pathfile,'bmp');
A = double(rawdata);