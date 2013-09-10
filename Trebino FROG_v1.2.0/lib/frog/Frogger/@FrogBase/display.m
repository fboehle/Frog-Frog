function display(FrogObj)
%DISPLAY displays a text representation of the FrogBase object.

%	$Id: display.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

disp([' '])
disp([inputname(1),' = '])
disp([' '])
disp(['    FrogAlgo object  :  ' class(FrogObj)])
disp(['          FROG Type  :  ' get(FrogObj, 'TypeName')])
disp(['       Nonlinearity  :  ' get(FrogObj, 'NonLinName')])
disp(['             Domain  :  ' get(FrogObj, 'DomainName')])
disp(['          Algorithm  :  ' get(FrogObj, 'AlgoName')])
disp([' '])
disp(['          Asig size  :  ' num2str(size(get(FrogObj, 'Asig')))])
disp(['   Asig min and max  :  ' num2str(min(min(get(FrogObj, 'Asig')))) ...
		' ' num2str(max(max(get(FrogObj, 'Asig'))))])
disp([' '])


% disp('  Asig =')
% display(FrogObj.Asig)
% disp('  Pulse =')
% display(FrogObj.Et)
% disp('  Best G Error =')
% display(FrogObj.EtBestG.Et)
% disp('  Best Z Error =')
% display(FrogObj.EtBestZ.Et)
