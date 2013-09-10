function [A,tau,lam,dtau,lam0,dlam,NumD,NumL,filename] = frogload(varargin)
%FROGLOAD Loads a FROG file
%	[A,TAU,LAM,DTAU,L0,DL,NUMD,NUML,FILENAME] = FROGLOAD loads a FROG file with
%	header information.  The function opens a standard file dialog to
%	select the file.  The FROG trace is returned in A, the time array in
%	TAU, the wavelength array in LAM, the delay spacing in DTAU, the center
%	wavelength in LAM0, the wavelength spacing in DLAM, the number of delay
%	steps in NUMD, and the number of wavelengths in NUML
%
%	... = FROGLOAD(FILENAME) same as above, but loads the file, FILENAME,
%	instead of opening a dialog box.
%
%	... = FROGLOAD(...,TYPE) the TYPE parameter switches between loading
%	delay first, 'DELAY,' to wavelength first, 'WAVE,' files.  The default
%	is, 'DELAY.'  If no FILENAME is specified, a dialog box is used.

%	$Revision: 1.2 $ $Date: 2008-01-22 00:29:37 $

error(nargchk(0,2,nargin));

[filename,type] = parsevarargin(varargin,'','delay');
%Pam changed the above line  from 'parsevarargin(varargin,[],'delay')' to 
%make compatable with 2007 version


[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname,pname,filterindex] = uigetfile(...
		{'*.frg', 'FROG Files (*.frg)';...
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

T = fscanf(file, '%f', 5);

NumD = T(1);
NumL = T(2);
dtau = T(3);
dlam = T(4);
lam0 = T(5);

switch lower(type)
case 'delay'
	A = fscanf(file, '%f', [NumD,NumL]).';
case 'wave'
	A = fscanf(file, '%f', [NumL,NumD]);
end

tau = (-NumD/2:NumD/2-1) * dtau;
lam = (-NumL/2:NumL/2-1) * dlam + lam0;

error(ferror(file));

fclose(file);
