function [A,tau,lam,dtau,NumD,NumL,filename] = dwcload(varargin)
%DWCLOAD Loads a FROG file
%	[A,TAU,LAM,DTAU,NUMD,NUML,FILENAME] = DWCLOAD loads a FROG file with
%	header information.  The function opens a standard file dialog to
%	select the file.  The FROG trace is returned in A, the time array in
%	TAU, the wavelength array in LAM, the delay spacing in DTAU, the number
%   of delay steps in NUMD, and the number of wavelengths in NUML.
%
%	... = DWCLOAD(FILENAME) same as above, but loads the file, FILENAME,
%	instead of opening a dialog box.
%
%	... = DWCLOAD(...,TYPE) the TYPE parameter switches between loading
%	delay first, 'DELAY,' to wavelength first, 'WAVE,' files.  The default
%	is, 'DELAY.'  If no FILENAME is specified, a dialog box is used.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $

error(nargchk(0,2,nargin));

[filename,type] = parsevarargin(varargin,[],'delay');

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname,pname,filterindex] = uigetfile(...
		{'*.dwc', 'FROG Files with wavelength (*.dwc)';...
			'*.*', 'All Files (*.*)'}, 'Load FROG file', '');
	if ~filterindex
		error('frogload:NoSelection','No file selected.');
	end
	filename = [pname,fname];
	
	type = 'ask';
end

if strcmpi(type,'ask')
	question = sprintf('Please select the file order.\nDelays or wavelengths first.');
	type = questdlg(question, 'File Order', 'Delay', 'Wave' ,'Delay');
end

[file,err] = fopen(filename,'rt');

if file < 0
	error(err);
end

s = fscanf(file, '%c');
fclose(file);

s_wavelength = '^\[Wavelength vector\]$';
s_trace = '^\[Data array\]$';

[i1_wavelength, i2_wavelength] = regexp(s, s_wavelength, 'start', 'end', 'lineanchors');
[i1_trace, i2_trace] = regexp(s, s_trace, 'start', 'end', 'lineanchors');
headertext = s(1 : i1_wavelength - 1);
wavelengthtext = s(i2_wavelength + 2 : i1_trace - 1);
tracetext = s(i2_trace + 2 : end);

tok = regexp(headertext, 'delay points.*?([\d.]+)$', 'tokens', 'lineanchors');
NumD = str2num(tok{:}{:});
tok = regexp(headertext, 'wavelength points.*?([\d.]+)$', 'tokens', 'lineanchors');
NumL = str2num(tok{:}{:});
tok = regexp(headertext, 'Delay increment.*?([\d.]+)$', 'tokens', 'lineanchors');
dtau = str2num(tok{:}{:});

lam = sscanf(wavelengthtext, '%f', [1, NumL]);
switch lower(type)
case 'delay'
	A = sscanf(tracetext, '%f', [NumD,NumL]).';
case 'wave'
	A = sscanf(tracetext, '%f', [NumL,NumD]);
end

tau = (-NumD/2:NumD/2-1) * dtau;