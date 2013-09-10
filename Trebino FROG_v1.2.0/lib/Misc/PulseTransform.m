function [Wt,Wl] = PulseTransform(L,El,back,u,shwplt)
%PULSETRANSFORM plot transform limited pulse.
%	PULSETRANSFORM(L,EL) plots the transformlimited pulse of the spectrum
%	EL with wavelengths L.

error(nargchk(2,5,nargin));

if nargin < 3 | isempty(back)
	back = 0;
end

if nargin < 4 | isempty(u)
	u = 'nm/fs';
end

if nargin < 5 | isempty(shwplt)
	shwplt = true;
end

El = quickscale(El) - back;

[T,Et] = SpecToTime(L,El,u);

Wt = FWHM(abs(Et).^2,T);

Wl = FWHM(abs(El).^2,T);

if shwplt
	ff = find((T > (-5*Wt)) & (T < (5*Wt)));
	
	subplot 212
	plot(T(ff), quickscale(abs(Et(ff)).^2));
	xlabel('Time')
	ylabel('Intensity')
	title(sprintf('Transform Limited Pulse\nFWHM = %.5f',Wt))
	
	L0 = mean(L);

	ff = find((L > (L0 - 2*Wl)) & (L < (L0 + 2*Wl)));

	subplot 211
	plot(L(ff), quickscale(abs(El(ff)).^2));
	xlabel('Spectrum')
	ylabel('Intensity')
	title(sprintf('Pulse Spectrum\nFWHM = %.5f',Wl))
end
