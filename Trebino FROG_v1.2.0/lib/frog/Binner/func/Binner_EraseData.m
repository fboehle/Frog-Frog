function handles = Binner_EraseData(handles)

if isempty(handles.FrogData)
	return
end

[Isig, Tau, Lam] = Binner_GetCurrData(handles);

X = find((Tau >= handles.ExtractBox.x(1)) & ...
	(Tau <= handles.ExtractBox.x(2)));
Y = find((Lam >= handles.ExtractBox.y(1)) & ...
	(Lam <= handles.ExtractBox.y(2)));

Isig(Y,X) = 0;

handles = Binner_NewData(handles, Isig, Tau, Lam);
