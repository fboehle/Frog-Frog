function filename = frogtracesave(trace, lambda, delay, strf, filename)
%FROGTRACESAVE saves a FROG trace file
%	FILENAME = FROGTRACESAVE(TRACE, LAMBDA, DELAY) saves a FROG trace file with
%   header information.  The function opens a standard file dialog to select the
%   file.  The FROG trace is passed in TRACE, the wavelength vector in LAMBDA, and
%   the delay vector in DELAY.  The filename is returned in FILENAME.
%
%	... = FROGTRACESAVE(...,STRF) same as above, but uses the format string, STRF.
%
%	... = FROGTRACESAVE(...,FILENAME) same as above, but saves the file as FILENAME,
%	instead of opening a dialog box.
%
%   FROGTRACESAVE now accepts pathname input, but the pathname has to end
%   with '\'.

%	$Revision: 1.1 $ $Date: 2007-05-26 21:40:41 $

error(nargchk(3,5,nargin));

if nargin < 4 | isempty(strf)
	strf = '%.6e';
end

if nargin < 5
    filename = '';
end

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname, pname, filterindex] = uiputfile(...
		{'*.dat', 'FROG Trace Files (*.dat)';...
			'*.*', 'All Files (*.*)'}, 'Save FROG trace file as', filename);
	if ~filterindex
		error('frogtracesave:NoSelection','No file selected.');
    end
    filename = [pname, fname];
end

sizes = size(trace);

if (sizes ~= [length(lambda) length(delay)])
    error('frogtracesave:SizeError', 'Trace size does not match wavelength/delay vectors.');
end

limits = [min(min(trace)) max(max(trace))];

[file,err] = fopen(filename,'wt');

if file < 0
	error(err);
end

fprintf(file, ['%d\t%d\n' strf '\t' strf '\n'], sizes, limits);
fprintf(file, [strf '\n'], lambda);
fprintf(file, [strf '\n'], delay);

fprintf(file, [strf '\n'], trace');

error(ferror(file));

fclose(file);