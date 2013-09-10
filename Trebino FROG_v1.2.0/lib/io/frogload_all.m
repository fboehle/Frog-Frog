function [A,tau,lam,dtau,lam0,dlam,NumD,NumL,filename] = frogload_all(varargin)
%FROGLOAD_ALL loads a FROG file with (.dwc) or without (.frg) the full
%wavelength vector based on the file extension name.
%
%	[A,TAU,LAM,DTAU,L0,DL,NUMD,NUML,FILENAME] = FROGLOAD_ALL loads a FROG file with
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

%	$Revision: 1.3 $ $Date: 2008-08-13 14:15:40 $

error(nargchk(0,2,nargin));

[filename,type] = parsevarargin(varargin,'','delay');

% convert empty list to empty string
if ~isa(filename, 'char')
    filename = '';
end

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname,pname,filterindex] = uigetfile(...
		{'*.frg', 'FROG Files (*.frg)';...
			'*.*', 'All Files (*.*)'}, 'Load FROG file', '');
	if ~filterindex
		error('frogload_all:NoSelection','No file selected.');
    end
	filename = fullfile(pname, fname);
    
    [pname, fname, ext] = fileparts(filename);
	type = 'ask';
end

switch upper(ext)
    case '.FRG'
        [A,tau,lam,dtau,lam0,dlam,NumD,NumL] = frogload(filename, type);
    case '.DWC'
        [A,tau,lam,dtau,NumD,NumL] = dwcload(filename, type);
        lam0 = lam(int32(NumL / 2) + 1);
        dlam = incre(lam);
    otherwise
        question = 'Please select the FROG file type.';
        selection = questdlg(question, 'FROG file type', 'DWC', 'FRG', 'DWC');
        switch selection
            case 'DWC'
                [A,tau,lam,dtau,NumD,NumL] = dwcload(filename, type);
                lam0 = lam(int32(NumL / 2) + 1);
                dlam = incre(lam);
            case 'FRG'
                [A,tau,lam,dtau,lam0,dlam,NumD,NumL] = frogload(filename, type);
            otherwise
                error('frogload_all:NoTypeSelection','No file type selected.');
        end
end
