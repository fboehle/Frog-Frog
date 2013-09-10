function map = FrogColorMap(varargin)
%FROGCOLORMAP Color map recreated from Delphi FROG code.
%   map = FROGCOLORMAP(m, n, wht, getcurrentdepth)
%       m is the depth of the colormap, default 256
%       n is number of maximum scales designated as white/black, default 1
%       wht, maximum is white if true, black if false
%       getcurrentdepth, depth will be obtained from current figure if true

error(nargchk(0,4,nargin));

m = 256;
n = 1;
wht = false;
getcurrentdepth = true;

[m, n, wht, getcurrentdepth] = parsevarargin(varargin, m, n, wht, getcurrentdepth);

if getcurrentdepth || isnan(m)
	m = size(get(gcf,'colormap'),1); 
end
	
if m < 1
	map = [];
else
	map = clrmp(m-n, wht);
	map = [ones(n,3) * wht ; map];
end

function map = clrmp(N,wht)

Step1 = floor(0.15*N);
Step2 = floor(0.50*N);
Step3 = floor(0.95*N);

map = zeros(N,3);

map(1:Step1,1) = 1.0;
map(1:Step1,2) = ((1:Step1)/Step1).^0.7.';
map(1:Step1,3) = 0.0;

map(Step1:Step2,1) = ((Step2 - (Step1:Step2))/(Step2 - Step1)).^0.7.';
map(Step1:Step2,2) = 1.0;
map(Step1:Step2,3) = 0.0;

map(Step2:Step3,1) = 0.0;
map(Step2:Step3,2) = ((Step3 - (Step2:Step3))/(Step3 - Step2)).^0.8.';
map(Step2:Step3,3) = (((Step2:Step3) - Step2)/(Step3 - Step2)).^0.8.';

if wht
	map(Step3:N,1) = 0.0;
	map(Step3:N,2) = 0.0;
	map(Step3:N,3) = 1.0 - (((Step3:N) - Step3)/(N - Step3)).^1.0.';
else
	map(Step3:N,1) = (((Step3:N) - Step3)/(N - Step3)).^1.0.';
	map(Step3:N,2) = map(Step3:N,1);
	map(Step3:N,3) = 1.0;
end
