function Esig_line(P,G)
%Esig_line calculates and saves the FROG trace line by line.
%   Esig_line(P, G) calculates and saves the delay-by-frequency FROG trace
%   line by line, using two signal fields P and G.
%
%   A file selection dialog will open to allow for choosing file names.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: Esig_line.m,v $
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.1  2001/10/19 19:12:27  xg
%	Created based on Esig_FOR_LOOP v1.4
%	
%

Esig = zeros(1, length(P));

[fname,pname] = uiputfile(...
    {'*.dat', 'FROG Files (*.dat)';...
        '*.*', 'All Files (*.*)'}, 'Select a FROG save file.');
if fname == 0
    error('Invalid filename');
end
filename = [pname,fname];

[file,err] = fopen(filename,'wt');
error(ferror(file));

strf = '%.6g\t';

for i = 1:length(P)
    for j = 1:length(P)
        tp = j - (i - length(P)/2 - 1);
        if (tp > 0) & (tp <= length(P))
            Esig(j) = P(j) * G(tp);
        end
    end
    Ef = fftc(Esig);
    fprintf(file, strf, abs(Ef') .^ 2);
    fprintf(file, '\n');
    Esig = zeros(1, length(P));
end

fclose(file);