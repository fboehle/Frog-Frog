function Pt = guesspulse(EF,lastPt,domain,antialias,PowerOrSVD)
%guesspulse: Extracts the pulse as a function of time, starting with a FROG
%   FIELD (i.e. complex amplitude), and the previous best-guess pulse. Uses
%   either "power method" from Kane1999 or SVD method from Kane1998.
%   [This program was formerly called "svdexFROG"]

%
%Usage:
%
%   Pt = guesspulse(EF, lastPt, domain, antialias, PowerOrSVD)
%   Pt = guesspulse(EF, lastPt) assumes domain=antialias=PowerOrSVD=0
%
%       Pt		=	Pulse field (in time)
%       EF		=	Input FROG field (i.e., complex amplitude.) (The
%					complex phases are not measured, they are best-guess from the last
%					iteration.
%       lastPt	=	Previous guess for pulse field (E-field as function of
%					time)
%		domain = integration method...
%					domain=0 for integrating in the time-domain
%						i.e., integral(P(t) * G(t-tau) * e^(-iwt) dt)
%					or 1 for integrating in the frequency-domain
%						i.e., integral[P(w') * G(w-w')e^(-iw'tau)dw'].
%					We're not integrating here exactly, we're approximating a matrix
%					as the outer product of two time-domain pulses
%					(if domain=0) or two frequency-domain pulses (if
%					domain=1). In Kane1999, only domain=0 is used.
%		antialias = whether or not to anti-alias. 0 (or false) means run
%					normally with no anti-aliasing; 1 (or true) means use
%					anti-aliasing. If domain=0, anti-aliasing is like
%					padding with zeros in the time-domain, if domain=1,
%					anti-aliasing is like padding with zeros in the
%					frequency-domain.
%		PowerOrSVD= 0 for power method (default) or 1 for SVD method, see
%					Kane1999. If it's 1 then the "lastPt" argument is
%					ignored. (SVD generates its guess "from scratch", not
%					from a seed like the power method does.)
%
% See FileInformation.txt for further discussion of algorithm and also FROG
% trace conventions.

%PARSE INPUT
if(~exist('domain','var') || isempty('domain'))
	domain=0;
end
if(~exist('antialias','var') || isempty('antialias'))
	antialias=0;
end
if(~exist('PowerOrSVD','var') || isempty('PowerOrSVD'))
	PowerOrSVD=0;
end

%Start program

N = size(EF, 1);

if domain==0
	%Do the exact inverse of the procedure in makeFROG...
	%Undo the line: EF=circshift(fft(EF,[],1),ceil(N/2)-1);
	EF = ifft(circshift(EF, 1-ceil(N/2)), [], 1);
	%Undo the line: EF=fliplr(fftshift(EF,2));
	EF = ifftshift(fliplr(EF),2);
	%Undo the lines: for n=2:N  EF(n,:) = circshift(EF(n,:), [0 1-n]);  end
	for n=2:N
		EF(n,:) = circshift(EF(n,:), [0, (n-1)]);
	end
	% Now EF is the "outer product form", see Kane1999.
	
	if(antialias)
		%Anti-alias in time domain. See makeFROG for explanation.
		EF=EF-tril(EF,-ceil(N/2))-triu(EF,ceil(N/2));
	end
	
	if(PowerOrSVD==0) % Power method
		Pt=EF*(EF'*lastPt);
	else % SVD method
		[U, S, V] = svds(EF,1);
		Pt = U(:,1);
	end
	Pt=Pt/norm(Pt); %Normalize to Euclidean norm 1
	return;
end
if(domain==1)
	%Do the exact inverse of the procedure in makeFROG...
	%Undo the line: EF=EF.';
	EF=EF.';
	%Undo the line: EF = circshift(EF,[ceil(N/2), ceil(N/2)-1]);
	EF = circshift(EF,[-ceil(N/2), -ceil(N/2)+1]);
	%Undo the line: EF = flipud(fliplr(EF));
	EF = flipud(fliplr(EF));
	%Undo the line: EF = ifft(EF,[],1);
	EF = fft(EF,[],1);
	%Undo the lines: for n=2:N  EF(n,:) = circshift(EF(n,:), [0 1-n]); end
	for n=2:N
		EF(n,:) = circshift(EF(n,:), [0 n-1]);
	end
	%Undo the line: EF = fliplr(EF);
	EF = fliplr(EF);
	%now we're up to the lines in makeFROG: PtFFT=fft(Pt); EF = PtFFT*(PtFFT.');

	if(antialias)
		%Anti-alias in frequency domain. See makeFROG for explanation.
		vmax = ceil((N+1)/2);
		vmin = vmax+1;
		for n=2:vmax
			EF(n,vmax-(n-2):vmax)=0;
		end
		for n=vmin:N
			EF(n,vmin:vmin+(N-n))=0;
		end
	end
	if(PowerOrSVD==0) % Power method
		lastPtFFT=fft(lastPt);
		Pt=ifft(EF*(EF'*lastPtFFT));
	else % SVD method
		[U, S, V] = svds(EF,1);
		Pt = ifft(U(:,1));
	end
	Pt=Pt/norm(Pt); %Normalize to Euclidean norm 1
	return;
end

disp('ERROR in guesspulse! Probably domain wasnt 0 or 1'); 
return;