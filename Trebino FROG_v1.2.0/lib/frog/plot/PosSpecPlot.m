function  [NormSpecArray, xvector, filename] = PosSpecPlot(calibrated, cmap, filename)
%POSSPECPLOT generates a normalized position-spectra plot
%   [NORMSPECARRAY, XVECTOR] = POSSPECPLOT(CALIBRATED, CMAP) generates a normalized position-
%   spectra plot.  The function opens a file selection dialog.  Boolean variable CALIBRATED
%   denotes whether the file is wavelength-calibrated or not.  CMAP denotes the colormap.
%   CALIBRATED defaults to TRUE (1).  CMAP defaults to hsv2.
%
%   ... = POSSPECPLOT(CALIBRATED, FILENAME) same as above, but loads the file, FILENAME,
%   instead of opening a dialog box.

%   $Revision: 1.1 $    $Date: 2006-11-11 00:15:35 $
%
%   $Log: PosSpecPlot.m,v $
%   Revision 1.1  2006-11-11 00:15:35  pablo
%   CVS server re-installation
%
%   Revision 1.1  2002/02/06 18:40:00  zeekec
%   Moved from misc.
%
%   Revision 1.2  2001/10/22 04:01:19  xg
%   A new figure is created to avoid clearing previous plots.
%   CMAP now defaults to hsv2.
%
%   Revision 1.1  2001/10/21 08:34:11  xg
%   Created
%

error(nargchk(0,3,nargin));

if nargin < 1 | isempty(calibrated)
	calibrated = TRUE;
end

if nargin < 2 | isempty(cmap)
    cmap = hsv2;
end

if nargin < 3 | isempty(filename)
    filename = [];
end

if calibrated
    LabelX = 'Wavelength [nm]';
else
    LabelX = 'Column Number';
end

[SpecArray, xvector, filename] = Load2dArray(filename);
NormSpecArray = NormArray(SpecArray);

figure;
imagesc(xvector, [], NormSpecArray);
colormap(cmap);
xlabel(LabelX);
ylabel('Row Number');