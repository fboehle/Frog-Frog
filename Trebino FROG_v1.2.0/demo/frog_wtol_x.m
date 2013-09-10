% frog_wtol_x.m
%
% Subroutine for converting the frog trace from time-frequency to
% time-wavelength. 
%
% See also: PG_XFROG, binner_cmd_demo, calibrate, qFROG_TX, frog_wtol_x,
% frog_wtol

% By Jeff Wong (GaTech) - 2011-11-02, 1423

% === START === 
w = w1;
t = t1;
% Convert everything from angular frequency (w) into lambda (lam)
[Asig1_lam, lam] = frog_wtol(Asig1,w,t);
[Asig1r_lam, lam] = frog_wtol(Asig1r,w,t);
[ELam1B, lam] = equally_spaced_spectrum_lam(Ew1B,w);


h=figure;imagesc(t,lam,Asig1_lam);set(h,'Tag','FROG Trace,dum');title('Measure 1');
h1 = get(h,'children');

h=figure;imagesc(t,lam,Asig1r_lam);set(h,'Tag','FROG Trace,dum');title('Retrieved 1');
h2 = get(h,'children');
linkaxes([h1,h2]);

clear h
clear Asig1 Asig1r Asig2 Asig2r 