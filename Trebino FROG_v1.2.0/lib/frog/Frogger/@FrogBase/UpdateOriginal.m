function UpdateOriginal(X, Horig, DStruct)
%UPDATEORIGINAL updates the plot of the experimental FROG trace.
%	X		the FrogObj
%	Horig	handle to the axes of the plot.

%	$Id: UpdateOriginal.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% Plot the data
axes(Horig);
DStruct = DisplayStructSet(DStruct, 'title', '\bf{Original}');
plot_Esig(X.Asig, X.w2/2/pi, X.tau, DStruct);

% UpdateImagesc(Horig, X.tau, X.w2/2/pi, X.Asig);
% title('\bf{Original}');
% xlabel('Delay');
% ylabel('Frequency');
% 
% % Plottng function
% function UpdateImagesc(h,tau,w,trace)
% axes(h);
% imagesc(tau, w, trace);
% axis xy
% colorbar