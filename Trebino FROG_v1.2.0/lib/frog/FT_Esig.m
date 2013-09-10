function Esigout = FT_Esig(Esigin,tag)
% FT_sig(Esigin, tag) accepts two variable,  first one is a matrix 
% which is the Esig(t, tao), or Esig(w, tao), 
% tag can be choosed from two value: 'fft' or ifft, which means the 
% forward Fourier Transform, and Inverse Fourier transfer. And the 
% one dimensinal FT is for the coloumn vector 
%
% See also FFT_FROG, IFFT_FROG, IFFTC, FFT, IFFT.

% v1.0, 6/28/01, Ziyang wang, <gt386x@prism.gatech.edu>
%                Zhenting Dai, <gte859q@prism.gatech.edu>
% v1.1, 7/2/01,  Michael Butterfield <gte881s@prism.gatech.edu>
%                Erik Zeek  <zeekec@mad.scientist.com>
%       Rewrote FT_Esig.  Vectorized and functionalized.
%
%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: FT_Esig.m,v $
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.3  2002/02/07 20:35:11  pat
%	Fixed bugs.
%	
%	Revision 1.2  2001/07/10 01:10:00  zeekec
%	Library cleanup.  Added, deleted, and moved files.
%	
%

switch(tag)
case 'fft'
    Esigout = fft_FROG(Esigin);    
case 'ifft'
    Esigout = ifft_FROG(Esigin);    
end