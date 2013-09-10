function T = Sec2Time(sec)
%SEC2TIME converts seconds to a time string.
%	T = SEC2TIME(SEC) converts the relative seconds in SEC to a string, T,
%	with the format HH:MM:SS.SSS

m = floor(sec/60);

s = sec - m * 60;

h = floor(m/60);

m = m - h * 60;

T = sprintf('%02d:%02d:%06.3f',h,m,s);