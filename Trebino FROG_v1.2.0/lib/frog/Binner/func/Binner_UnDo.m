function handles = Binner_UnDo(handles)

if length(handles.FrogData) <= 1
	return
end

handles.FrogData(end) = [];

if length(handles.FrogData) <= 1
	set(handles.UnDo_Button, 'Enable', 'off');
end

if handles.FrogData(end).Binned
    set(handles.FreqMargCorr_Button, 'enable', 'on');
else
    set(handles.FreqMargCorr_Button, 'enable', 'off');
end
