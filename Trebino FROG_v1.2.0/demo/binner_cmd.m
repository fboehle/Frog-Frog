function Filename = binner_cmd_demo(in_file, varargin)
% binner_cmd.m
% 
% Command line version of binner GUI. This take in customize parameters to
% bin the trace. 
% 'width' : is the bin width in percentage
% 'sz' : is the size of the grid
% 'm' : is the method. 1 for fit time, 2 for fit wavelength
%
% See also: PG_XFROG, binner_cmd_demo, calibrate, qFROG_TX, frog_wtol_x,
% frog_wtol

% By Jeff Wong (GaTech) - 2011-08-09, 2022

% === START === 
fprintf(1,'Start Binning\n');
% Load the frog trace with the parameters
[Isig, tau, lam, dtau, lam0, dlam, numDelay, numLam, filename] = frogload_all(in_file, 'delay');


%Delete the source file 
% delete(filename);

% Calculate the Autocorreatlion and the Frequency Convolution as the
% marginals.
[ac, freq] = marginals(Isig);

% Calculate the Center wavelength and the delay
% Or take the data from the .frg file ?

% Think about this
lam_c = find_center(lam, freq, 1);
tau_c = find_center(tau, ac, 1);

f = ltof(lam);
tau = tau - tau_c;
f0 = ltof(lam_c);

% Some default setting for the calculation of new grid
c=1;
sz = 128;
width = 100;
m = 1;
% Parse varargin
for ii = 1:2:length(varargin)
    varname = varargin{ii};
    varval  = varargin{ii+1};
    cmd = sprintf('%s = %g;', varname, varval);
    eval(cmd);
end

%% Binner_CalcGrid
% Calculate the new Grid for the binning, using method: 'Fit Delay' or 'Fit
% Wavelength'

switch m
    case 1
        % % case 'Fit Delay'
        dtau = 2 * max(abs([min(tau), max(tau)])) / sz / (width/100);
        tau2 = (-sz/2:sz/2-1) * dtau;
        df = 1 / sz / dtau;
        f2 = (-sz/2:sz/2-1) * df + f0;
        f2 = f2';


    case 2
        % % case 'Fit Wavelengths'
        df = (max(f) - min(f)) / sz / (width/100);
        f2 = (-sz/2:sz/2-1) * df + f0;
        f2 = f2';
        dtau = 1 / sz / df;
        tau2 = (-sz/2:sz/2-1) * dtau;
end

assignin('base','tau_bincmd',tau);
assignin('base','lam_bincmd',lam);
assignin('base','f2_bincmd',f2);
assignin('base','tau2_bincmd',tau2);

% figure;imagesc(Isig);title('before cleanup');
% Isig(Isig > 0.36)= 0;
% figure;imagesc(Isig);title('after cleanup');

%% Binner_GridData
% This is the process for binning, basically it is a 2D interpolation
[Isig, tau2, f2] = Binner_GridData(Isig, tau, lam, tau2, f2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [Isig2, tau2, f2] = Binner_GridData(Isig, tau, lam, tau2, f2)
        error(nargchk(5,5,nargin))
        lam2 = ltof(f2);
        Isig2 = interp2(tau, lam, Isig, tau2, lam2, 'linear');
        dl_dw = lam2.^2;    % d_l / d_w = l .^ 2 / (2 * pi * c)
        Isig2 = Isig2 .* repmat(dl_dw, 1, length(tau2));    % correction for d_l / d_w
        Isig2(~isfinite(Isig2)) = 0;
        Isig2 = nonegatives(Isig2);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Save binned FROG Trace
[pname, fname, ext] = fileparts(filename);
fprintf(1,'dtau:%.7g\nf0:%.7g\ndf:%.7g\nlambda0:%.7g\n',dtau, f0,df,lam_c);
Filename = fullfile(pname, sprintf('%s_b%i_w%i_m%i.bin.frg',fname, sz, width, m));
frogsave(quickscale(Isig), dtau, f0, df, [], Filename, Filename);

% Displaying binned trace, optional
h = figure;
imagesc(tau2, f2, quickscale(Isig));
title('After binning');
fprintf(1,'Binned FROG trace saved as %s\n', Filename) ;
end

%% Find Center
function y = find_center(X, Y, meth)

switch meth
    case 1
        y = X(floor(end/2+1));
    case 2
        y = first_moment(Y(:), X(:));
    case 3
        y = X(maxindex(Y(:)));
    otherwise
        error('Unknown centering method.');
end
end
