function [trace, lam] = frog_wtol(trace, w,time)
% frog_wtol.m 
%
% Helper function convert the FROG trace from Time-Frequency to Time-Wavelength
% domain. This is necessary because Matlab can't handle uneven grid space in 
% image plot
%
% See also: PG_XFROG, binner_cmd_demo, calibrate, qFROG_TX, frog_wtol_x,
% frog_wtol

% By Jeff Wong (GaTech) - 2011-11-12, 1538

% === START === 
    [w_ax, t_ax] = size(trace);
    for t = 1:t_ax
        [Eout, lam] = equally_spaced_spectrum_lam(trace(:,t),w);
        trace(:,t) = Eout;
    end
end