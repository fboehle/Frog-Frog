function UpdateRecon(X, Hrecon, Hdiff, DStruct)
%UPDATERECON updates the reconstructed and difference FROG traces.
% X			a FrogBase derivative.
% Hrecon	handle to the reconstruced axis.
% Hdiff		handle to the difference axis.
% DStruct   Display options

%	$Id: UpdateRecon.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

axes(Hrecon);
DStruct1 = DisplayStructSet(DStruct, 'title', '{\bfReconstruction}');
plot_Esig(X.Esig, X.w2/2/pi, X.tau, DStruct1);

axes(Hdiff);
DStruct1 = DisplayStructSet(DStruct, 'title', '{\bfDifference}', 'cutoff', -Inf);
plot_Esig(abs(X.Esig) - X.Asig, X.w2/2/pi, X.tau, DStruct1);

% 
% UpdateImagesc(Hrecon, X.tau, X.w2/2/pi, abs(X.Esig));
% title('{\bfReconstruction}');
% xlabel('Delay');
% ylabel('Frequency');
% 
% UpdateImagesc(Hdiff, X.tau, X.w2/2/pi, abs(X.Esig) - X.Asig);
% title('{\bfDifference}');
% xlabel('Delay');
% ylabel('Frequency');
% 
% function UpdateImagesc(h,tau,w,trace)
% axes(h);
% imagesc(tau, w, trace);
% axis xy
% colorbar
% 
