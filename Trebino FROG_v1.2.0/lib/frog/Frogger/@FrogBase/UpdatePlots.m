function UpdatePlots(X, Htime, Hspec, Herr, Htext, DStruct)
%UPDATEPLOTS updates the 2d plots in frogger.
% X		the FrogBase object
% Htime	handle to the temporal plot
% Hspec handle to the spectrum plot
% Herr	handle to the error plot
% Htext	handle to a text box.

%	$Id: UpdatePlots.m,v 1.4 2007-05-26 21:26:20 pablo Exp $

% Initialize some variables.
t = X.t(:);
w1 = get(X, 'w1');
freq = w1(:) / 2 / pi;

% Place holder for the fields.
Et = complex([]);
% Place holder for the legend.
leg = {};
% Place holder for the colors.
clrs = {};

% If we have a theoretical field, add it to the plot.
if ~isempty(X.EtOrig)
	Et = [Et,  X.EtOrig(:)];
	leg = {leg{:}, 'Theoretical'};
% 	clrs = {clrs{:}, [0, 0.75, 0.75]};
	clrs = {clrs{:}, [0, 1, 0]};    % 'g'
end

% If we have a best G error field, add it to the plot.
if ~isempty(X.BestG.Et)
	Et = [Et,  X.BestG.Et(:)];
	leg = {leg{:}, 'Best G'};
% 	clrs = {clrs{:}, [1, 0, 0]};
	clrs = {clrs{:}, [0, 0, 0]};    % 'k'
end

% If we have a best Z error field, add it to the plot.
if ~isempty(X.BestZ.Et)
	Et = [Et,  X.BestZ.Et(:)];
	leg = {leg{:}, 'Best Z'};
% 	clrs = {clrs{:}, [0, 0, 1]};
	clrs = {clrs{:}, [0, 0, 1]};    % 'b'
end

% If we have a current field, add it to the plot.
if ~isempty(X.Et)
	Et = [Et,  X.Et(:)];
	leg = {leg{:}, 'Current'};
% 	clrs = {clrs{:}, [0, .5, 0]};
	clrs = {clrs{:}, [1, 0, 0]};  % 'r'
end

% Get the number of error iterations to plot.
Nmax = getpref('frogger', 'PlotNum');

% Get the high and low times to plot.
Tl = getpref('frogger', 'PlotTimeLow');
Th = getpref('frogger', 'PlotTimeHigh');

% Get the high and low frequencies to plot.
Fl = getpref('frogger', 'PlotFreqLow');
Fh = getpref('frogger', 'PlotFreqHigh');

% Find the items to plot.
I = find(t > Tl & t < Th);

% Plot the time axis.
axes(Htime)
DStruct = DisplayStructSet(DStruct, 'colorseqMag', clrs, 'colorseqPhase', clrs);
DisplayStruct = DisplayStructSet(DStruct, 'title', '{\bfTime}', 'xlabel', 'Time');
[AX, H1, H2] = plotcmplx(t(I), Et(I,:), DisplayStruct);
% [AX, H1, H2] = plotcmplx2(t(I),Et(I,:),[],[],1e-4);
% axis tight
% title('{\bfTime}');
% xlabel('Time');
% ylabel('Amplitude');
% ylim(AX(1), 'auto');
% ylim(AX(2), 'auto');

% Set the colors.
% for k = 1:length(clrs)
% 	set(H1(k), 'Color', clrs{k})
% 	set(H2(k), 'Color', clrs{k})
% end

% Create the legend.
h=legend(leg{:});
p1 = get(h,'position');
p2 = get(Htime,'position');
p1(1) = p2(1) + p2(3) + 0.05;
p1(2) = p2(2) + p2(4)/2 - p1(4)/2;
p1(3) = p1(3);
p1(4) = p1(4);
set(h,'position',p1);

% Calculate the spectrum.
Ew = fftc(Et,[],1);

% Index of itmes to plot.
I = find(freq > Fl & freq < Fh);

% Spectral plot.
axes(Hspec)
DisplayStruct = DisplayStructSet(DStruct, 'title', '{\bfSpectrum}', 'xlabel', 'Frequency');
[AX, H1, H2] = plotcmplx(freq(I), Ew(I,:), DisplayStruct);

% [AX, H1, H2] = plotcmplx2(freq(I),Ew(I,:),[],[],1e-4);
% title('{\bfSpectrum}');
% xlabel('Frequency');
% ylabel('Amplitude');
% ylim(AX(1), 'auto');
% ylim(AX(2), 'auto');

% Set colors.
% for k = 1:length(clrs)
% 	set(H1(k), 'Color', clrs{k})
% 	set(H2(k), 'Color', clrs{k})
% end

% Place holders.
G = X.G;
Z = X.Z;

% Get the length.
N = length(G);

if N > Nmax
	% If there are too many iterations cut it back.
	Iter = N - Nmax : N;
	G = G(Iter);
	Z = Z(Iter);
	Iter = Iter - 1;
elseif N <= 1
	% If there are not enough iterations, add some dummy ones.
	Iter = -1 : 1;
	G = [NaN, G, NaN];
	Z = [NaN, Z, NaN];
else
	% Just keep it.
	Iter = 0 : N-1;
end

% Error plots.
axes(Herr)
[AX, H1, H2] = plotyy2(Iter, G, Iter, Z, @semilogy);
title('\bfError');
xlabel('Iteration');

% Fix plot styles and color.
set(H1, 'LineStyle', 'none', 'Marker', '+', 'Color', 'r')
set(H2, 'LineStyle', 'none', 'Marker', '+', 'Color', 'b')

% Fix labels.
set(get(AX(1), 'YLabel'), 'String', 'G Error', 'Color', 'r', ...
	'FontName',		get(AX(1),'FontName'), ...
	'FontUnits',	get(AX(1),'FontUnits'), ...
	'FontSize',		get(AX(1),'FontSize'), ...
	'FontWeight',	get(AX(1),'FontWeight'), ...
	'FontAngle',	get(AX(1),'FontAngle') ...
	);
set(get(AX(2), 'YLabel'), 'String', 'Z Error', 'Rotation', 270, ...
	'VerticalAlignment', 'bottom', 'Color', 'b', ...
	'FontName',		get(AX(1),'FontName'), ...
	'FontUnits',	get(AX(1),'FontUnits'), ...
	'FontSize',		get(AX(1),'FontSize'), ...
	'FontWeight',	get(AX(1),'FontWeight'), ...
	'FontAngle',	get(AX(1),'FontAngle') ...
	);

% Fix axes colors.
set(AX(1), 'YColor', 'r');
set(AX(2), 'YColor', 'b');

axis(AX, 'tight');
ylim(AX(1), 'auto');
ylim(AX(2), 'auto');

% Turn off divide by zero and save warning value.
S = warning('off', 'MATLAB:divideByZero');

% Build text to display.
txt = {};

% If there is a current pulse...
if ~isempty(X.Et)
	txt{end+1} = sprintf('Current Pulse:');
	txt{end+1} = sprintf('FWHM = %.3f fs', fwhm(magsq(X.Et),X.t));
	txt{end+1} = sprintf('FWHM = %.3f nm', fwhm(magsq(fftc(X.Et)),ltow(w1)));
	txt{end+1} = sprintf('G = %.3e'   , X.G(end));
	txt{end+1} = sprintf('Z = %.3e'   , X.Z(end));
end
% If there is a best G...
if ~isempty(X.BestG.Et)
	txt{end+1} = sprintf('');
	txt{end+1} = sprintf('Best G Error:');
	txt{end+1} = sprintf('G = %.3e'   , X.BestG.G);
	txt{end+1} = sprintf('Z = %.3e'   , X.BestG.Z);
	txt{end+1} = sprintf('Iteration = %d'   , X.BestG.Iter);
end
% If there is a best Z...
if ~isempty(X.BestZ.Et)
	txt{end+1} = sprintf('');
	txt{end+1} = sprintf('Best Z Error:');
	txt{end+1} = sprintf('G = %.3e'   , X.BestZ.G);
	txt{end+1} = sprintf('Z = %.3e'   , X.BestZ.Z);
	txt{end+1} = sprintf('Iteration = %d'   , X.BestZ.Iter);
end
% If there is a theoretical pulse...
if ~isempty(X.EtOrig)
	txt{end+1} = sprintf('');
	txt{end+1} = sprintf('Original Pulse:');
	txt{end+1} = sprintf('FWHM = %.3f fs', fwhm(magsq(X.EtOrig),X.t));
	txt{end+1} = sprintf('FWHM = %.3f nm', fwhm(magsq(fftc(X.EtOrig)),ltow(w1)));
end

% Reset warning values.
warning(S);

% Set text display value.
set(Htext,  'String', txt);
