function [Esig]=Esiggenerate(P,G)
%calculation the theoretical Esig for any frog trace
%input P(t)and G(t) as 1xN vector
%it will return a NxN matrix
%Please email qc6@prism.gatech.edu if you have any trouble

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $
%
%	$Log: Esig_FOR_LOOP.m,v $
%	Revision 1.1  2006-11-11 00:15:30  pablo
%	CVS server re-installation
%	
%	Revision 1.4  2001/10/18 19:19:33  zeekec
%	Minor changes in order of tp calculation
%	
%	Revision 1.3  2001/10/08 20:39:11  zeekec
%	Corrected an error in the shift.
%	
%	Revision 1.2  2001/09/05 01:20:36  zeekec
%	Changed variable names
%	
%	Revision 1.1  2001/07/10 01:10:00  zeekec
%	Library cleanup.  Added, deleted, and moved files.
%	
%	v1.2 Michael Butterfield <gte881s@prism.gatech.edu.
%		changed size(E) to length(E) on line 11
%

Esig = zeros(length(P));

for i = 1:length(P)
    for j = 1:length(P)
        tp = i - (j - 1 - length(P)/2);
        if (tp > 0) & (tp <= length(P))
            Esig(i,j) = P(i) * G(tp);
        end
    end
end