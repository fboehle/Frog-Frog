function [F, EF] = makeFROG(Pt,domain,antialias)
%makeFROG: Reads in the (complex) electric field as a function of time,
%  and computes the expected SHG-FROG trace.
%
% % % Usage: % % %
%
%	[F,EF]=makeFROG(Pt,domain,antialias)
%	[F,EF]=makeFROG(Pt) assumes domain=antialias=0.
%
%		EF      =   Complex amplitude of FROG trace
%						i.e., integral[P(t) * P(t-tau) * e^(-iwt) dt]
%		F       =   Intensity of FROG Trace = |EF|^2
%		Pt      =   Signal field (Column vector, length N) (E-field as a
%						function of time)
%		domain =	integration method...
%					domain=0 for integrating in the time-domain
%						i.e., integral[P(t) * P(t-tau) * e^(-iwt) dt]
%					or 1 for integrating in the frequency-domain
%						i.e., integral[P(w') * P(w-w') * e^(-iw'tau)dw'].
%					2 and 3 are for debugging-- 2 is the same calculation
%					as 0 but without using FFTs, 3 is the same as 1 but
%					without using FFTs. Should give the same answer, but much
%					slower.
%		antialias = whether or not to anti-alias. 0 (or false) means run
%					normally with no anti-aliasing; 1 (or true) means use
%					anti-aliasing. If domain=0, anti-aliasing is like
%					padding with zeros in the time-domain, if domain=1,
%					anti-aliasing is like padding with zeros in the
%					frequency-domain.
%		(If anti-alias=0, all values of "domain" should give the same answer.)
%
% See FileInformation.txt for further discussion of algorithm and also FROG
% trace conventions.
%


%PARSE INPUT
if(~exist('domain','var') || isempty(domain))
	domain=0;
end
if(~exist('antialias','var') || isempty(antialias))
	antialias=0;
end

%Start program
N = length(Pt);

if domain==0
	EF = Pt*(Pt.');

	if(antialias)
		% Anti-alias: Delete entries that come from spurious
		% wrapping-around. For example, an entry like P2*G(N-1) is spurious
		% because we did not measure such a large delay. For even N, there
		% are terms like P_i*G_(i+N/2) and P_(i+N/2)*G_i, which correspond
		% to a delay of +N/2 or -N/2. I'm deleting these terms. They are
		% sort of out-of-range, sort of in-range, because the maximal delay
		% in the FFT can be considered to have either positive or negative
		% frequency. This is the outer edge of the FROG trace so it
		% should be zero anyway. Deleting both halves keeps everything
		% symmetric when sign of delay is flipped.
		EF=EF-tril(EF,-ceil(N/2))-triu(EF,ceil(N/2));
	end
	
		%   Row rotation...eqns (10)-->(11) of Kane1999
	for n=2:N
		EF(n,:) = circshift(EF(n,:), [0 1-n]);
	end
	
	% EF is eqn (11) of Kane1999. From left column to right column, it's
	% tau=0,-1,-2...3,2,1


	%permute the columns to the right order, tau=...,-1,0,1,...
	EF=fliplr(fftshift(EF,2));
	%FFT each column and put 0 frequency in the correct place:
	EF=circshift(fft(EF,[],1),ceil(N/2)-1);
	
	% Generate FROG trace (= |field|^2)
	F = abs(EF).^2;
	return;
end

if(domain==1)
	%frequency-domain integration; in other words,
	%integral[P(w') * P(w-w')e^(-iw'tau)dw']. We follow Kane1999, but
	%starting in frequency-frequency space rather than delay-delay space.
	PtFFT=fft(Pt);
	EF = PtFFT*PtFFT.';
	% Right now the (i,j) (i'th row and j'th column) entry of EF corresponds
	% to the product of the i'th Fourier component with the j'th.
	% But keep in mind "1st Fourier component" is v=0, the 2nd is v=1,
	% etc., in the order 0,1,2,...,-2,-1.

	if(antialias)
		% Anti-alias. The product P(v1)*P(v2) contributes to the signal at
		% frequency v1+v2. This can only be relevant if v1+v2 is in the
		% range of the FROG trace. Otherwise the term is deleted. When N is
		% even, there is a "maximal frequency", which can correspond
		% equally well to +N/2 or -N/2 frequency. We assume it's positive.
		% That's consistent with the convention above for the FROG trace,
		% that places zero frequency in such a way that more positive
		% frequencies are visible than negative frequencies for even N.
		vmax = ceil((N+1)/2); %which index in EF uses the max positive freq?
		vmin = vmax+1; %which index in EF uses the most negative freq?
		for n=2:vmax
			EF(n,vmax-(n-2):vmax)=0;
		end
		for n=vmin:N
			EF(n,vmin:vmin+(N-n))=0;
		end
	end
	EF = fliplr(EF);

	%   Row rotation...analogous to eqns (10)-->(11) of Kane1999
	for n=2:N
		EF(n,:) = circshift(EF(n,:), [0 1-n]);
	end
	
	%FT each column
	EF = ifft(EF,[],1);
	%Right now the columns are in the order N*v=(N-1,N-2,...,1,0), and rows
	%are in the order tau=0,-1,...,1. (These are all mod N.)
	EF = flipud(fliplr(EF));
	%Now columns are N*v=(0,1,2,...-1) and rows are tau=1,2,3,...,0.	
	EF = circshift(EF,[ceil(N/2), ceil(N/2)-1]);
	%Now zero frequency & zero delay is at (ceil(N/2),ceil(N/2)) as desired
	EF=EF.';

	% Generate FROG trace (= |field|^2)
	F = abs(EF).^2;
	return;
end

%DEBUGGING CASES: Manually calculating the FT should give the exact same
%result (but slower of course!)

if(domain==2) %should give the same result as domain=0.
	N = length(Pt);
	dt = 1;
	dv = 1/(N*dt); %frequency interval ("v" looks like greek letter nu)
	clear('i'); % make sure i=sqrt(-1)
	EF=zeros(N);
	
	for whatrow = 1:N
		v = (whatrow - ceil(N/2))*dv;
		for whatcol = 1:N
			tau = whatcol - ceil(N/2);
			EF(whatrow,whatcol)=0;
			for t=1:N
				if(antialias)
					if((t-tau)>=1 && (t-tau)<=N && 2*tau ~= N) % the third condition only occurs when N is even and tau=N/2. See above.
						EF(whatrow,whatcol) =  EF(whatrow,whatcol) + Pt(t)*Pt(t-tau)*exp(-2*pi*i*v*(t-1));
					end
				else % no anti-alias, i.e. wrap it around
					if((t-tau)>=1 && (t-tau)<=N)
						tminustau=t-tau;
					elseif((t-tau)<=0)
						tminustau=t-tau+N;
					else
						tminustau=t-tau-N;
					end
					EF(whatrow,whatcol) = EF(whatrow,whatcol) + Pt(t)*Pt(tminustau)*exp(-2*pi*i*v*(t-1));
				end
			end
		end
	end

	F=abs(EF).^2;
	return;
end

if(domain==3) %should give the same result as domain=1.
				% formula is integral[P(w') * G(w-w')e^(-iw'tau)dw'].

	N = length(Pt);
	dv = 1; %frequency interval ("v" looks like greek letter nu)
	dt = 1/(N*dv); %delay interval
	PtFFT=fft(Pt); %frequencies are now in the order 0,1,2,...,-1
	PtFFT=circshift(PtFFT,ceil(N/2)-1); %frequencies are now in the order ...,-1,0,1,... with the 0-frequency at position ceil(N/2).
	clear('i'); % make sure i=sqrt(-1)
	EF=zeros(N);
	
	for whatrow = 1:N
		v = (whatrow - ceil(N/2));
		for whatcol = 1:N
			tau = dt*(whatcol - ceil(N/2));
			EF(whatrow,whatcol)=0;
			for vpindex = 1:N   % vpindex means "index of v prime on the list PtFFT"
				vp = vpindex - ceil(N/2);
				vminusvpindex = (v-vp) + ceil(N/2);
				if(antialias)
					if((vminusvpindex >= 1) && (vminusvpindex <= N))
						EF(whatrow,whatcol) = EF(whatrow,whatcol) + PtFFT(vpindex)*PtFFT(vminusvpindex)*exp(-2*pi*i*vp*tau);
					end
				else % no anti-alias, i.e. wrap it around
					if(vminusvpindex <= 0)
						vminusvpindex = vminusvpindex + N;
					elseif( vminusvpindex > N)
						vminusvpindex = vminusvpindex - N;
					end
					EF(whatrow,whatcol) = EF(whatrow,whatcol) + PtFFT(vpindex)*PtFFT(vminusvpindex)*exp(-2*pi*i*vp*tau);
				end
			end
		end
	end
	EF = EF/N; %from MATLAB's FFT normalization convention.
	F=abs(EF).^2;
	return;
end

disp('ERROR in makeFROG! Probably domain wasnt 0, 1, 2, or 3'); 
return;