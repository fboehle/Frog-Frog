function filename = esave(x,E,filename)
%ESAVE saves an E-field file in the 'Ek.dat' or 'Speck.dat' format.
%	ESAVE(X,E) saves the field, E, as a function of X.  X is either
%	time or wavelength.

%	$Revision: 1.1 $ $Date: 2007-05-26 21:40:41 $
%
%	$Log: esave.m,v $
%	Revision 1.1  2007-05-26 21:40:41  pablo
%	lowercase
%	
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.1  2006/05/02 16:27:55  xg
%	frogger/binner v. 3 updates
%	
%	Revision 1.5  2005/08/06 19:28:40  xg
%	*** empty log message ***
%	
%	Revision 1.4  2003/02/26 15:36:59  pat
%	Fixed sign of phase, and set phase to zero at max intensity.
%	
%	Revision 1.3  2002/11/14 18:50:53  xg
%	Now handles path name only inputs (strings ending in '\').
%	
%	Revision 1.2  2001/10/22 23:10:34  xg
%	File name return added
%	
%	Revision 1.1  2001/10/22 21:17:38  zeekec
%	Added function
%	

if ~exist('filename')
    filename = '';
end

[pname, fname, ext] = fileparts(filename);

if isempty(fname)
	[fname,pname] = uiputfile(...
		{'*.dat', 'FROG Output Files (*.dat)';...
			'*.*', 'All Files (*.*)'}, 'Save FROG E-field file', filename);
	if fname == 0
		error('Invalid filename');
	end
	filename = [pname,fname];
end

data = zeros(length(x),5);

[Int,Phs] = IandP(E);

data(:,1) = x(:);
data(:,2) = Int(:);
data(:,3) = Phs(:);
data(:,4) = real(E(:));
data(:,5) = imag(E(:));

[fid, err] = fopen(filename, 'w');

if fid < 0
	error(err);
end

fprintf(fid, '%g\t%g\t%g\t%g\t%g\n', data');

error(ferror(fid));

fclose(fid);
