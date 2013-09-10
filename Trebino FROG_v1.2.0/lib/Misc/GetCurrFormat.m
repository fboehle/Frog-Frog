function [frmt,IsLoose] = GetCurrFormat
% An attempt to match the format to a format string.

IsLoose = strcmp(get(0,'FormatSpacing'),'loose');
get(0,'Format')
switch get(0,'Format')
case 'short'
	frmt = '%.5g';
case 'shortE'
	frmt = '%5.4e';
case 'shortG'
	frmt = '%.5g';
case 'long'
	frmt = '%15.14e';
case 'longE'
	frmt = '%.15e';
case 'longG'
	frmt = '%.15g';
case 'bank'
	frmt = '%.2f';
case 'hex'
	frmt = '%bx';
case '+'
	frmt = '%+1.0f';
case 'rat'
	frmt = '%.5f';
end
