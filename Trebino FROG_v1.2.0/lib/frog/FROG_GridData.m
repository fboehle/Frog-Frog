function [Asig2, tau2, w2, lam2] = FROG_GridData(N, Asig, tau, lam, varargin)
%FROG_GRIDDATA Grids the raw FROG data.
%	[ASIG, TAU, W, LAM] = FROG_GRIDDATA(N, ASIG, TAU, LAM, U, CNTR, SZ)
%	This function prepares raw data for the FROG algorithm.  The data should already
%	have the background removed, negatives eliminated, and be cropped.  This function
%	assumes that the entire delay range in, TAU, should be represented in the output.
%
%	INPUTS
%	N:  The size of the gridded array.  This should be a power of 2.
%	ASIG:  The FROG signal of interest.  Currently this code assumes that Asig is in
%	constant wavelength spacing.
%	TAU:  An array of the delays of ASIG.
%	LAM:  An array of the wavelengths of ASIG.
%	OPTIONAL
%	U:  The units of C, the speed of light.
%	CNTR:  The centering to be performed. 'TAU,' center in delays, 'FREQ,' center
%	in frequency, and 'BOTH,' for both.  Any other string is ignored.  Defaults to
%	'TAU.'
%	SZ:  UNSUPPORTED.  Set the size of the delay domain relative to the frequency
%	domain.
%
%	OUTPUTS
%	ASIG:  The gridded FROG signal.
%	TAU:  The new delays for ASIG.
%	W:  The angular frequencies for ASIG.
%	LAM:  The wavelengths corresponding to W.
%
%	See also FROG_CROP, FROGBACKSUB.

error(nargchk(4,6,nargin));

u = 'nm/fs';
cntr = 'tau';
sz = 1;

[u, cntr, sz] = parsevarargin(varargin, u, cntr, sz);

w = ltow(lam,u);

tau0 = 0;

% w0 = ltow((lam(1) + lam(end))/2,u)
w0 = ((w(1) + w(end))/2);
% w0 = w(end/2)

if length(cntr) > 4; cntr = cntr(1:4); end

switch lower(cntr)
case 'tau'
	tau0 = first_moment(sum(Asig,1), tau);
% 	[temp,k] = max(sum(Asig,1));
% 	tau0 = tau(k)
case 'freq'
	w0 = first_moment(sum(Asig,2) .* w.^2, w);
case 'both'
	tau0 = first_moment(sum(Asig,1), tau);
	w0 = first_moment(sum(Asig,2) .* w.^2, w);
end

tau = tau - tau0;

dtau = (tau(end) - tau(1)) / (length(tau) - 1) * length(tau) / N;

tau2 = (-N/2 : N/2-1) * dtau;

dw = 2 * pi / (tau2(end) - tau2(1));

% disp(sprintf('tau0 = %+f, w0 = %+f, dtau = %+f, dw = %+f', tau0, w0, dtau, dw));

w2 = (-N/2 : N/2-1) * dw + w0;

lam2 = ltow(w2,u);

[T, L] = meshgrid(tau,lam);
[T2, L2] = meshgrid(tau2,lam2);

Asig2 = interp2(T, L, Asig, T2, L2, 'cubic');

C = w2.^2 / const_c(u)^2;

Asig2 = Asig2 .* repmat(C.', 1, N);

Asig2(find(~isfinite(Asig2))) = 0;
