function [ Prefs ] = loadprefs( pth )
%LOADPREFS sets the default values for the preferences.

%	$Id: LoadPrefs.m,v 1.1 2007-10-10 18:51:02 pam Exp $

if nargin > 0
	pth = [ pth, filesep, 'NonLins'];
else
	pth = '';
end

Prefs.NonLinPath = getpref('frogger', 'NonLinPath', pth);

Prefs.PlotNum = getpref('frogger', 'PlotNum', 100);
Prefs.PlotEvery = getpref('frogger', 'PlotEvery', 10);

Prefs.MaxIter = getpref('frogger', 'MaxIter', Inf);

Prefs.PlotTimeLow = getpref('frogger', 'PlotTimeLow', -Inf);
Prefs.PlotTimeHigh = getpref('frogger', 'PlotTimeHigh', Inf);
Prefs.PlotFreqLow = getpref('frogger', 'PlotFreqLow', -Inf);
Prefs.PlotFreqHigh = getpref('frogger', 'PlotFreqHigh', Inf);
