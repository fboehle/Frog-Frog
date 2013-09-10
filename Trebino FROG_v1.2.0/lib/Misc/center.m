function [X, k, rotmeth] = center(X, varargin)
%CENTER centers the array.
%	CENTER(X) returns X centered on its first moment.
%
%	CENTER(X, METHOD) returns X centered by METHOD.  METHOD Defaults
%		to 'moment', first moment. Also supported is 'max', maximum.
%
%	CENTER(X, METHOD, ROTMETH) returns X centered by METHOD.  Rotates
%		array using ROTMETH.  Supported are 'circshift' (default) and
%		'shift' (for linear shift).
%
%   [XP, K, ROTMETH] = CENTER(...) returns the centered X in XP, the amount
%   of shift used in K, and ROTMETH.  Note K is returned in a fashion such
%   that XP = FEVAL(STR2FUNC(ROTMETH), X, K).

%	$Revision: 1.2 $ $Date: 2007-05-26 21:27:20 $
%
%	$Log: center.m,v $
%	Revision 1.2  2007-05-26 21:27:20  pablo
%	lowercase
%	
%	Revision 1.1  2006-11-11 00:15:34  pablo
%	CVS server re-installation
%	
%	Revision 1.8  2003/02/28 20:20:40  xg
%	Now calls maxall.
%	
%	Revision 1.7  2002/09/08 19:18:29  xg
%	Added shift value and method outputs.
%	
%	Revision 1.6  2002/05/09 16:28:00  zeekec
%	*** empty log message ***
%	
%	Revision 1.5  2002/04/30 16:19:02  pat
%	Works on rows and colums now.
%	
%	Revision 1.4  2001/11/16 17:48:23  zeekec
%	Centered properly for FFTC
%	
%	Revision 1.3  2001/11/15 21:32:30  zeekec
%	New ParseVarargin
%	
%	Revision 1.2  2001/10/31 18:08:24  zeekec
%	Changed to ParseVarargin implementation.
%	
%	Revision 1.1  2001/10/19 18:22:03  zeekec
%	Added function
%	

error(nargchk(1,3,nargin));

[method, rotmeth] = parsevarargin(varargin, 'moment', 'circshift');

if strcmp(lower(rotmeth), 'circ')
    rotmeth = 'circshift'
end

switch lower(method)
case 'max'
    [m, Ic] = maxall(X);
    
case 'moment'
	Ic = moment(X);
	
otherwise
	error(['Unknown centering method, ', method, '.']);
end

nshift = floor(size(X) / 2) - round(Ic) + 1;

X = feval(str2func(rotmeth), X, nshift);