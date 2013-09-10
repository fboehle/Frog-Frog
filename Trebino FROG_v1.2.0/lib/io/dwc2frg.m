function frgfilename = dwc2frg(varargin)

error(nargchk(0,2,nargin));

[dwcfilename,frgfilename] = parsevarargin(varargin,[],[]);

[A,tau,lam,dtau,NumD,NumL,dwcfilename] = dwcload(dwcfilename);

lam1 = linspace(lam(1), lam(end), length(lam))';
A1 = interp1(lam, A, lam1, [], 0);

[pname, fname, ext] = fileparts(frgfilename);

if isempty(fname)
    [pname, fname, ext] = fileparts(dwcfilename);
    frgfilename = fullfile(pname, [fname, '.frg']);
end

frogsave(A1, dtau, lam1(end/2+1), incre(lam1), [], frgfilename);