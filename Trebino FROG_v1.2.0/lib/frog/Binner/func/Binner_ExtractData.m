function handles = Binner_ExtractData(handles)

if isempty(handles.FrogData)
	return
end

[Isig, Tau, Lam] = Binner_GetCurrData(handles);

% px = handles.ExtractBox.x;
% py = handles.ExtractBox.y;

X = find((Tau >= handles.ExtractBox.x(1)) & ...
	(Tau <= handles.ExtractBox.x(2)));
Y = find((Lam >= handles.ExtractBox.y(1)) & ...
	(Lam <= handles.ExtractBox.y(2)));

Isig = Isig(Y,X);
Tau = Tau(X);
Lam = Lam(Y);

handles = Binner_NewData(handles, Isig, Tau, Lam);
