function getalgos(handles)

%	$Id: GetAlgos.m,v 1.1 2007-10-10 18:51:02 pam Exp $

NonLinPath = getpref('frogger', 'NonLinPath');

S = what(NonLinPath);

while isempty(S)
    button = questdlg('Invalid Nonlinear Path.  Click ''OK'' to set the correct path, click ''Cancel'' to exit.',...
        'Path Error','OK','Cancel','OK');
    if strcmp(button, 'Cancel')
        error('Invalid nonlinear path.');
    end
    FroggerPrefs;
    NonLinPath = getpref('frogger', 'NonLinPath');
    S = what(NonLinPath);
end
    

S = S.classes;

Items = {};

for k=1:length(S)
	FrogObj = feval(S{k});
	Items{end+1,1} = get(FrogObj, 'TypeName');
	Items{end  ,2} = get(FrogObj, 'NonLinName');
	Items{end  ,3} = get(FrogObj, 'DomainName');
	Items{end  ,4} = get(FrogObj, 'AlgoName');
	Items{end  ,5} = S{k};
end

setappdata(handles.Frogger_Main, 'Algorithms', Items);

