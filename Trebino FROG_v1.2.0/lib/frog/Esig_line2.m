function Esig_line(P,G,varargin)
%Esig_line calculates and saves the FROG trace line by line.
%   Esig_line(P, G) calculates and saves the delay-by-frequency FROG trace
%   line by line, using two signal fields P and G.
%
%   A file selection dialog will open to allow for choosing file names.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: Esig_line2.m,v $
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.6  2005/08/06 19:28:40  xg
%	*** empty log message ***
%	
%	Revision 1.5  2001/11/06 23:20:33  zeekec
%	More corrections
%	
%	Revision 1.4  2001/11/06 23:15:30  zeekec
%	Fixed error in second half of trace
%	
%	Revision 1.3  2001/11/06 23:07:56  zeekec
%	Misc
%	
%	Revision 1.2  2001/11/06 20:35:05  xg
%	misc
%	
%	Revision 1.1  2001/11/06 18:55:30  zeekec
%	Added TIC and TOC
%	
%	Revision 1.1  2001/10/19 19:12:27  xg
%	Created based on Esig_FOR_LOOP v1.4
%	

start = 1;
finish = length(P);

[start,finish] = parsevarargin(varargin, {start, finish});

[fname,pname] = uiputfile(...
	{'*.dat', 'FROG Files (*.dat)';...
		'*.*', 'All Files (*.*)'}, 'Select a FROG save file.');
if fname == 0
	error('Invalid filename');
end
filename = [pname,fname];

N=40;

Pspec = fftc(P);
P_abs = abs(Pspec);
P_phase = angle(Pspec);


strf = '%.6g\t';

%fprintf(file, '%d\t%d\t%.6g\t%.6g\t%.6g\n', 8192, 8192, 2.531, .024, 386.73);

M_p = toeplitz([P_abs((N+1) : -1 : 1)'; zeros(N, 1)], [P_abs((N+1) : end), zeros(1, N)]);
M = ones(2 * N + 1, 1) * exp(j * P_phase) .* M_p;
P0 = ifftc(M, [], 2);
clear Pspec P_abs P_phase M_p M;

tic

	Esig = zeros(2 * N + 1, length(P));
	trace = zeros(length(P), 1);

for y = start:finish
	Esig(:)=0;
	for z = 1:length(P)
		tp = z - (y - length(P)/2 - 1);
		if (tp > 0) & (tp <= length(P))
			Esig(:, z) = P0(:, z) * G(tp);
		end
	end
	trace = sum(abs(fftc(Esig, [], 2)) .^ 2)';
	
	[file,err] = fopen(sprintf('%s%04d.dat',filename,y),'wt');
	error(ferror(file));
	fprintf(file, strf, trace);
	fprintf(file, '\n');
	fclose(file);
	
	t = toc;
	x = (y-start+1);
	
	disp(sprintf('Iteration: %d, Elapsed Time: %g, Time per Iteration: %g, Time Left: %g\n',...
		x,t,t/x,t/x*(finish-y)));
end

display('end');
