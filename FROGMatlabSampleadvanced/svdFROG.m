function [Pt, Fr, G, iter] = svdFROG(Fm, seed, GTol, iterMAX, method, mov, dtperpx, units)
%svdFROG: reconstructs a complex pulse function (in time) from a SHG-FROG
%   trace by use of the SVD algorithm.
%
%Usage:
%
%	[Pt, Fr, G, iter] = svdFROG(Fm, seed, GTol, iterMAX, method, mov, dtperpx, units)
%
%		Pt      =	Reconstructed pulse field (E-field as function of time).
%		Fr      =	reconstructed FROG trace.
%		G		=	Final FROG error
%		iter    =	Number of iterations to convergence or termination
%
%		Fm		=	Measured (experimental) FROG Trace. Square matrix of
%					intensity values.
%		seed	=	Initial guess for Pt (column vector) (default: Choose
%					randomly)
%		GTol  =   Tolerence on the error (default = 0).
%		iterMAX =   Maximum number of iterations allowed (default = +inf)
%		method  =	Algorithm choice, see below.
%		mov		=	0 (default): No updates while solving. 1: Output movie.
%					2: Print text.
%
%		dtperpx =   Difference in time-delay (dt) between consecutive
%					pixels (default = 1). This automatically fixes
%					frequency units too. Doesn't affect algorithm, only
%					plots and such.
%		units = Cell-array: units{1} is units of dtperpx, units{2} is
%				units{1}^-1, the units of frequency. Default: {'a.u.',
%				'1/a.u.'} (a.u. means arbitrary units). A common input here
%				would be {'fs','PHz'}
%
%
%		G = RMS difference in entries of Fm and alpha*Fr
%		(where Fm is normalized so max(Fm)=1 and alpha is whatever value
%		minimizes G.) See DeLong1996
%
%		eval(method) should give a 4-element row vector. First element is
%		makeFROG domain argument (0 for time, 1 for frequency), second is
%		makeFROG antialias argument (0 for alias, 1 for antialias), third
%		is guesspulse domain argument, fourth is guesspulse antialias
%		argument. Default: '[0,0,0,0]' (corresponds to Kane1999). You can
%		try creative possibilities like method='[parity(iter),1,parity(iter),1]'
%		to switch back and forth between different algorithms.
%
%		When mov=1, you can press q to stop the iteration and save the
%		latest results.
%
%   ------------------------------------------------------------
%
% Define some functions...
rmsdiff = @(F1, F2) sqrt(mean(mean((F1-F2).^2))); %RMS difference in the entries of two real matrices/vectors.
normalizemax1 = @(M) M/max(max(M)); %normalize a matrix or vector for its maximum to be 1. Must have real nonnegative entries.
calcalpha = @(Fm,Fr) sum(sum(Fm.*Fr))/sum(sum(Fr.^2)); %calculates alpha, the positive number that minimizes rmsdiff(Fm,alpha*Fr). See DeLong1996
parity = @(x) x-2*floor(x/2); %1 for odd, 0 for even. Don't delete! It looks like it's not used in the program, but it can be called by the 'method' strings.

%   Get trace dimensions
N = size(Fm, 1);

% Default behavior for various inputs...
if (~exist('iterMAX', 'var')||isempty(iterMAX))
    iterMAX = inf;
end
if (~exist('GTol', 'var')||isempty(GTol))
    GTol = 0;
end
if (~exist('mov', 'var')||isempty(mov))
    mov = 0;
end
if (~exist('method', 'var')||isempty(method))
    method = '[0,0,0,0]';
end
if (~exist('dtperpx','var')||isempty(dtperpx))
	dtperpx = 1;
end

dvperpx = 1 / (N*dtperpx); %frequency interval per pixel

if (~exist('units','var')||isempty(units))
	dtunit = 'a.u.';
	dvunit = '1/a.u.';
else
	dtunit = units{1};
	dvunit = units{2};
end

tpxls=(-dtperpx*(N-1)/2:dtperpx:dtperpx*(N-1)/2)'; %x-axis labels for plots
vpxls=(-dvperpx*(N-1)/2:dvperpx:dvperpx*(N-1)/2)'; %x-axis labels for plots

%maybe you only want to display part of the plot range, to zoom in on the
%interesting stuff. If so, edit the following lines...
tplotrange = [min(tpxls) max(tpxls)];
vplotrange = [min(vpxls) max(vpxls)];


%	User defined seed?
if (~exist('seed', 'var')||isempty(seed))
	%   Generate initial guess of gate and pulse from noise times a gaussian
	%   envelope function. Don't use complex phase 0 or it gets stuck in
	%   real numbers, but don't let the complex phase vary too much or it
	%   has aliasing problems.
	clear('i'); %ensure i=sqrt(-1)
	Pt = random('Poisson',50,1,N) + 1i*random('Poisson',50,1,N);
    Pt = Pt.';
else
	Pt = seed;
end

%   Normalize FROG trace to unity max intensity
Fm = normalizemax1(Fm);



% % % START MAIN PROGRAM % % %

% Generate FROG trace
iter = 0;


temp=eval(method);
makeFROGdomain=temp(1);
makeFROGantialias=temp(2);
%guesspulsedomain=temp(3); not used
%guesspulseantialias=temp(4); not used

%EFr is reconstructed FROG trace complex amplitudes ( Fr=|EFr|.^2 )
[Fr, EFr] = makeFROG(Pt,makeFROGdomain,makeFROGantialias);
%Calculate FROG error G, see DeLong1996
Fr = Fr * calcalpha(Fm,Fr); %scale Fr to best match Fm, see DeLong1996
G = rmsdiff(Fm,Fr);

if mov==1
	myfig = figure(1)
	%figure('Tag',figtag);
	subplot(3,2,1)
	image([min(tpxls) max(tpxls)],[min(vpxls) max(vpxls)], Fm*64); %64 is colormap range
	title('Orig FROG trace');
	xlabel(['Delay (' dtunit ')']);
	ylabel(['SH freq (' dvunit ')']);
	drawnow; %forces figure to update before proceeding
	%getframe; %just using this to pause long enough to update fig
end

%   ------------------------------------------------------------
%   F R O G   I T E R A T I O N   A L G O R I T H M
%   ------------------------------------------------------------
while ((G>GTol)&&(iter<iterMAX))
	iter = iter+1;                  %   keep count of no. of iterations
	if mov==2
		disp(['Iteration number: ' num2str(iter) '  Error: ' num2str(G)]);
	end
	
	% Check method to use. Have to run this inside the loop because method
	% may vary depending on iter.
	temp=eval(method);
	makeFROGdomain=temp(1);
	makeFROGantialias=temp(2);
	guesspulsedomain=temp(3);
	guesspulseantialias=temp(4);
	
	%Update best-guess EFr: Phase from last makeFROG, amplitudes from Fm.
	Fr(Fr==0) = NaN;     %   Find any zero amplitudes
	EFr = EFr.*(sqrt(Fm./Fr));         % Change absolute values of EFr to match Fm (keep phase the same)
	EFr(isnan(Fr)) = 0;        %   Remove divide by zeros
	Pt = guesspulse(EFr,Pt,guesspulsedomain,guesspulseantialias);       %   Extract pulse field from FROG complex amplitude

	%%%Keep peak centered... not necessary, but this helps when visually
	%%%comparing and understanding reconstructions.
	if(true)
		centerindex = sum((1:N)' .* abs(Pt.^4))/sum(abs(Pt.^4)); %weighted average to find center of peak
		Pt = circshift(Pt,-round(centerindex-N/2));
	end
	
	[Fr, EFr] = makeFROG(Pt,makeFROGdomain,makeFROGantialias);    %   Make a FROG trace from new fields
	%Calculate FROG error G, see DeLong1996
	Fr = Fr * calcalpha(Fm,Fr); %scale Fr to best match Fm, see DeLong1996
	G = rmsdiff(Fm,Fr);

	if mov==1
		figure(1)
		drawnow; %make the target figure "current" before drawing
		subplot(3,2,2)
		%Display reconstructed trace. Note: Some pixels may be off-scale
		%because visual comparison is easiest when the colorscale of Fm and
		%Fr are consistent (assuming Fr is already scaled by alpha that
		%best matches Fm).
		image([min(tpxls) max(tpxls)],[min(vpxls) max(vpxls)], Fr*64);
        title(['Reconstructed: iter=' num2str(iter) ' Err=' num2str(G)]);
		xlabel(['Delay (' dtunit ')']);
		ylabel(['SH freq (' dvunit ')']);

		subplot(3,1,2)
		plot(tpxls, 2*pi*abs(Pt).^2/max(abs(Pt))^2,tpxls,angle(Pt)+pi);
		%title('Reconstructed pulse |E|^2 and angle(E)');
		xlabel(['Time (' dtunit ')']);
		ylabel('|E|^2 & ang(E)'); % |E|^2 in arbitrary units; phase-angle in radians
		axis([tplotrange 0 6.5]) %6.5 is a bit more than 2pi
		
		FFTPt=fftshift(fft(fftshift(Pt)));
		subplot(3,1,3)
		plot(vpxls, 2*pi*abs(FFTPt).^2/max(abs(FFTPt))^2,vpxls,angle(FFTPt)+pi);
		%title('Reconstructed pulse |E|^2 and angle(E)');
		xlabel(['Freq (' dvunit ')']);
		ylabel('|E|^2 & ang(E)'); % |E|^2 in arbitrary units; phase-angle in radians
		axis([vplotrange 0 6.5])  %6.5 is a bit more than 2pi
		
		drawnow; %forces figure to update before proceeding
		%quit if you selected the figure and pressed q.
		cc = get(myfig,'CurrentCharacter');
		if(strcmp(cc,'q'))
			break;
		end
		%getframe; %just using this to pause long enough to update fig on screen
		%pause(.001)
	end
	%pause(.001)
end
%   ------------------------------------------------------------
%   E N D   O F   A L G O R I T H M
%   ------------------------------------------------------------

% % % Compute and display some quantities of interest...

if(false)
	%very approximate FWHM calculation:
	%disp(['FWHM ~ ' num2str(dtperpx * sum(abs(Pt.^2)>max(abs(Pt.^2)/2)))]);
	
	%or, more accurate FWHM calculation (Pad the Fourier transform with zeros,
	%then transform back, to get a smoother version of the Pt curve)
	
	FFTPt=fft(Pt);
	FFTPtPadded=[ FFTPt(1:round(N/2)) ; zeros(5*N,1) ; FFTPt(round(N/2)+1:end)];
	Ptsmoothed=ifft(FFTPtPadded);
	dt=dtperpx*N/(N+5*N);
	FWHM = dt * sum(abs(Ptsmoothed.^2)>max(abs(Ptsmoothed.^2)/2));
	
	%intensity-weighted G...
	weightederror = sum(sum((Fr-Fm).^2 .* Fm))/sum(sum(Fm)); %CHECK!!
	
	disp(['FWHM ~ ' num2str(FWHM) ',  iter = ' num2str(iter)]);
	disp(['G = ' num2str(G) ',  Intens.-weighted G = ' num2str(weightederror) ]);
end