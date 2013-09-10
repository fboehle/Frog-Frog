function filename = ipsave(X,Int,Phs,varargin)

% FILENAME = IPSAVE(X,INT,PHS,FILENAME)
% Saves only the INTensity and PHaSe as a function of the
% X-variable, like Speck.dat or Ek.dat without the real and
% imaginary parts.  Use IANDP to generate the INT and PHS.
%
% See also: PHASEBLANK, IANDP, AANDP

error(nargchk(3,4,nargin));

[filename] = parsevarargin(varargin,'');

if ~exist('filename')
    filename = '';
end

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname,pname] = uiputfile(...
		{'*.blank.dat', 'Phaseblanked FROG Output Files (*.blank.dat)';...
			'*.*', 'All Files (*.*)'}, 'Save Phaseblanked FROG E-field file', filename);
	if fname == 0
		error('Invalid filename');
	end
	filename = [pname,fname];
end


data = zeros(length(X),3);
data(:,1) = X(:);
data(:,2) = Int;
data(:,3) = Phs;

[fid,err] = fopen(filename,'wt');

if fid < 0
	error(err);
end

fprintf(fid, '%g\t%g\t%g\n',data');

error(ferror(fid));

fclose(fid);