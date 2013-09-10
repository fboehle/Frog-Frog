function w = equally_spaced_w(lam)
% EQUALLY_SPACED_W Equally-spaced angular frequency
%
%   W = EQUALLY_SPACED_W(LAM) returns an equally-spaced array of angular
%   frequencies W corresponding to a sorted array of wavelenghts LAM
%   (increasing or decreasing).
%
%   Units are m/s.
%%% begin skeleton 
	version = '$Id: equally_spaced_w.m,v 1.1 2008-10-13 21:26:11 pam Exp $'; 
	
	% Units
	cm = 1e-2;
	mm = 1e-3;
	um = 1e-6;
	nm = 1e-9;
    ps = 1e-12;
    fs = 1e-15;
	THz = 1e12; 
	% Constants
	c = 300; % speed of light
%%% end skeleton
%%% Code starts here
n = length(lam);
if n == 0
    w = [];
else if n == 1
        w = ltow(lam);
    else
        wmin=2*pi*c/max(lam);
        wmax=2*pi*c/min(lam);
        dw = (wmax-wmin)/n;
        w = (wmax:-dw:wmin+dw);
    end
end