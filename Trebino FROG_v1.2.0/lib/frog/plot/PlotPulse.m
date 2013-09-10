function PlotPulse(T,Et,W,varargin)
%PLOTPULSE Plots a pulse.
%   PLOTPULSE(T,Et,W) plots the pulse, Et, as a function of time, T,
%   and wavelength.  The wavelengths are calculated from the angular
%   frequency, W.
%   
%   PLOTPULSE(...,T1,T2,L1,L2) uses T1 and T2 as the upper and lower
%   limits on the time axis, and L1 and L2 as the limits on the
%   wavelength axis.

%   $Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $

[T1,T2,L1,L2]=parsevarargin(varargin, -100, 100, 600, 1000);

Ew = fftc(Et);

clf

I = find((T>T1)&(T2>T));
T=T(I);
Et=Et(I,:);

Et=quickscale(Et);

subplot 211
plotcmplxI(T,Et)
drawnow

L=ltow(W);

[L,I]=sort(L);
Ew=Ew(I);

I = find((L>L1)&(L2>L));
L=L(I);
Ew=Ew(I,:);

Ew=quickscale(Ew);

subplot 212
plotcmplxI(L,Ew)
