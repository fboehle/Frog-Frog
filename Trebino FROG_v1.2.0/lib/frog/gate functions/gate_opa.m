function Etgate = gate(Et, Gain, type)
% opa gate function.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:30 $

if nargin < 3
	type = false;
end

if ~type
	Etgate = exp(abs(Et)*Gain);
else
	Etgate = cosh(abs(Et)*Gain) - 1;
end
