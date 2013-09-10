function width = rms(s, x);

% width = rms(s, x); where x the independent variable and s the funcion
% whose width you are finding.
%If an independent variable is not given, then the width will be calculated 
%in units of pixelcalculated in terms of pixel.  Make sure that the units
%of s and x are the same.
print_result = true;

version = '$Id: rms_width.m,v 1.1 2008-08-11 21:06:31 pam Exp $'; 

if nargin ==1;
    x = [1:length(s)];
end

dx = abs(x(1)-x(2));

moment_0 =  sum(s.*dx);
moment_1 = sum(x.*s.*dx)./moment_0;
moment_2 = sum((x).^2.*s.*dx)./moment_0;

rms = (moment_2-moment_1.^2).^.5;  

width = rms;

if print_result == true;
    display(['the rms width is ' num2str(rms)]);
end
