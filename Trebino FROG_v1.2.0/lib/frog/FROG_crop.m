function [Asig,tau,l] = FROG_crop(Asig,tau,l);
%FROG_CROP Crops a FROG trace.
%	[ASIG,TAU,L] = FROG_CROP(ASIG,TAU,L) takes in a FROG trace, ASIG,
%	a delay array, TAU, and a wavelength array, L, and provides a graphical
%	interface to crop the trace.  The function returns the cropped trace and
%	the cropped delays and wavelengths.
%
%	This function presents a window to the user with an image of the FROG trace.
%	The user then drags a box around the data.  When the button is released,
%	the function displays cropped trace and exits.
%
%	WARNING:  There is NO UNDO on this function.  Please asign the output to
%	a new variable.  You have been warned.
%
%	See also IMCROP.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: FROG_crop.m,v $
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.6  2002/05/13 20:57:07  zeekec
%	*** empty log message ***
%	
%	Revision 1.5  2002/05/03 23:21:21  zeekec
%	*** empty log message ***
%	
%	Revision 1.4  2002/05/01 15:55:17  zeekec
%	Added to help.
%	
%	Revision 1.3  2002/04/25 18:53:01  zeekec
%	Corrected an error with the size of the returned arrays.
%	

error(nargchk(3,3,nargin))

H = figure('Name','Raw FROG Data', 'NumberTitle', 'off');

imagesc(tau,l,Asig);
axis xy
colormap hsv2

[Asig,rect]=imcrop;

taul = rect(1);
tauh = taul + rect(3);
tau = tau(find(tau >= taul));
tau = tau(1:size(Asig,2));

flp = false;
if l(1) > l(end)
	l = l(end:-1:1);
	flp = true;
end

ll = rect(2);
lh = ll + rect(4);
l = l(find(l >= ll));
l = l(1:size(Asig,1));

if flp
	l = l(end:-1:1);
end

set(H, 'Name','Extracted FROG Data', 'NumberTitle', 'off');
imagesc(tau,l,Asig);
axis xy

pause(1)
close(H)