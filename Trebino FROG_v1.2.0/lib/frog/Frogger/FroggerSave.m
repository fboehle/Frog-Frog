function varargout = FroggerSave(varargin)
% FROGGERSAVE saves files for Frogger.
%	FROGGERSAVE is not intended to be called directly.
% See also: FROGGER and BINNER

%	$Id: FroggerSave.m,v 1.3 2008-08-13 14:25:33 pam Exp $

% Last Modified by GUIDE v2.5 02-Apr-2003 11:00:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
	'gui_Singleton',  gui_Singleton, ...
	'gui_OpeningFcn', @FroggerSave_OpeningFcn, ...
	'gui_OutputFcn',  @FroggerSave_OutputFcn, ...
	'gui_LayoutFcn',  [] , ...
	'gui_Callback',   []);
if nargin & isstr(varargin{1})
	gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
	[varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
	gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% ------------------------------------------------------------
function X = GetData(handles)
% Gets the FrogObj from Frogger.

X = getappdata(handles.Frogger_Main, 'FrogObj');

% ------------------------------------------------------------
function [Et, t, w] = GetField(handles)
% Gets the selected field from the FrogObj.

X = GetData(handles);

t = get(X, 't');
w = get(X, 'w1');

switch get(handles.Field_Popup, 'Value')
	case 1
		Et = get(X, 'BestG.Et');
	case 2
		Et = get(X, 'BestZ.Et');
	case 3
		Et = get(X, 'Et');
end

% ------------------------------------------------------------
function [Asig, tau, w2] = GetRecon(handles)
% Gets the reconstructed trace.

X = GetData(handles);

tau = get(X, 'tau');
w2 = get(X, 'w2');

switch get(handles.Field_Popup, 'Value')
	case 1
		Et = get(X, 'BestG.Et');
	case 2
		Et = get(X, 'BestZ.Et');
	case 3
		Et = get(X, 'Et');
end

Asig = CalcEsig(Et, Gate(X, Et));

Asig = abs(fft_FROG(Asig));

% ------------------------------------------------------------
function [Asig, tau, w2] = GetOriginal(handles)
% Gets the original trace.

X = GetData(handles);

tau = get(X, 'tau');
w2 = get(X, 'w2');
Asig = get(X, 'Asig');

% ------------------------------------------------------------
function fname = GetPath(handles)
% Gets the path from the path edit box.

fname = get(handles.Path_Edit, 'String');

% ------------------------------------------------------------
function fname = GetName(handles)
% Builds the path from the path and base name.

fname = get(handles.Base_Edit, 'String');

if ~isempty(fname)
	fname = [fname, '.'];
end

pname = GetPath(handles);

if isempty(fname) & ~isempty(pname)
	fname = filesep;
end

fname = fullfile(pname, fname);

% ------------------------------------------------------------
function AddLog(handles, S)
% Adds a string to the log.

T = cellstr(get(handles.Log_Edit, 'String'));

if isempty(T{1})
	set(handles.Log_Edit, 'String', S);
else
	T{end+1} = S;
	if length(T) > 4
		T = T(end - 3:end);
	end
	set(handles.Log_Edit, 'String', T);
end

% set(handles.Log_Edit, 'Value', length(T))

% --- Executes just before FroggerSave is made visible.
function FroggerSave_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FroggerSave (see VARARGIN)

% Choose default command line output for FroggerSave

if nargin > 3
	handles.Frogger_Main = varargin{1};
	
	fname = getappdata(handles.Frogger_Main, 'Filename');
% 	ischar(fname);
    [pth, fname, ext] = fileparts(fname);
	
	set(handles.Path_Edit, 'String', pth);
	set(handles.Base_Edit, 'String', fname);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FroggerSave wait for user response (see UIRESUME)
% This makes the dialog modal.
uiwait(handles.FroggerSave);


% --- Outputs from this function are returned to the command line.
function varargout = FroggerSave_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = getappdata(handles.FroggerSave, 'Result');

% When we get here we are ready to delete the dialog.
delete(handles.FroggerSave);

% --- Executes on key press over FroggerSave with no controls selected.
function FroggerSave_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to FroggerSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Catch the ret and esc character for the OK and Calcel buttons.
switch double(get(hObject, 'CurrentChar'))
	case 13
		OK_Button_Callback(hObject, eventdata, handles);
	case 27
		Cancel_Button_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in OK_Button.
function OK_Button_Callback(hObject, eventdata, handles)
% hObject    handle to OK_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.FroggerSave, 'Result', true)

close(handles.FroggerSave);

% --- Executes on button press in Cancel_Button.
function Cancel_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.FroggerSave, 'Result', false)

close(handles.FroggerSave);


% --- Executes when user attempts to close FroggerSave.
function FroggerSave_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to FroggerSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% Since we want to return a value we need to resume the GUI instead of
% deleting it.
uiresume(handles.FroggerSave);


% --- Executes during object creation, after setting all properties.
function Path_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Path_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Path_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Path_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Path_Edit as text
%        str2double(get(hObject,'String')) returns contents of Path_Edit as a double


% --- Executes during object creation, after setting all properties.
function Base_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Base_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Base_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Base_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Base_Edit as text
%        str2double(get(hObject,'String')) returns contents of Base_Edit as a double


% --- Executes on button press in Path_Button.
function Path_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Path_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pth = uigetdir(get(handles.Path_Edit, 'String'), 'Select a save directory.');

if pth
	set(handles.Path_Edit, 'String', pth);
end

% --- Executes during object creation, after setting all properties.
function Field_Popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Field_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Field_Popup.
function Field_Popup_Callback(hObject, eventdata, handles)
% hObject    handle to Field_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Field_Popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Field_Popup


% --- Executes on button press in Ek_SaveAs_Button.
function Ek_SaveAs_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Ek_SaveAs_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = [GetName(handles), 'Ek.dat'];

[fname, pname] = uiputfile({'*Ek.dat',	'Electric fields (*Ek.dat)'; ...
		'*.dat',	'Data files (*.dat)'; ...
		'*.*',		'All files (*.*)'}, ...
	'Save the temporal field as...', ...
	fname);

if isequal(fname, 0) || isequal(pname, 0)
	return
end

fname = fullfile(pname, fname);

[Et, t] = GetField(handles);

esave(t, Et, fname);

AddLog(handles, ['Saved:  ', fname]);

% --- Executes on button press in Ek_Save_Button.
function Ek_Save_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Ek_Save_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = [GetName(handles), 'Ek.dat'];

[Et, t] = GetField(handles);

esave(t, Et, fname);

AddLog(handles, ['Saved:  ', fname]);

% --- Executes on button press in Ek_Export_Button.
function Ek_Export_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Ek_Export_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[Et, t] = GetField(handles);

assignin('base', 'Et', Et);
assignin('base', 't', t);

% --- Executes on button press in Ek_SaveOld_Button.
function Ek_SaveOld_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Ek_SaveOld_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = [GetName(handles), 'Ek.dat'];
% fname = fullfile(GetPath(handles), 'Ek.dat');

[Et, t] = GetField(handles);

esave(t, Et, fname);

AddLog(handles, ['Saved:  ', fname]);

% --- Executes on button press in Speck_Save_Button.
function Speck_Save_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Speck_Save_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = [GetName(handles), 'Speck.dat'];

[Et, t, w] = GetField(handles);

esave(ltow(w), fftc(Et), fname);

AddLog(handles, ['Saved:  ', fname]);

% --- Executes on button press in Speck_Export_Button.
function Speck_Export_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Speck_Export_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[Et, t, w] = GetField(handles);

assignin('base', 'Ew', fftc(Et));
assignin('base', 'w1', w);
assignin('base', 'l1', ltow(w));


% --- Executes on button press in Speck_SaveAs_Button.
function Speck_SaveAs_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Speck_SaveAs_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = [GetName(handles), 'Speck.dat'];

[fname, pname] = uiputfile({'*Speck.dat',	'Electric fields (*Speck.dat)'; ...
		'*.dat',	'Data files (*.dat)'; ...
		'*.*',		'All files (*.*)'}, ...
	'Save the spectral field as...', ...
	fname);

if isequal(fname, 0) || isequal(pname, 0)
	return
end

fname = fullfile(pname, fname);

[Et, t, w] = GetField(handles);

esave(ltow(w), fftc(Et), fname);

AddLog(handles, ['Saved:  ', fname]);

% --- Executes on button press in Speck_SaveOld_Button.
function Speck_SaveOld_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Speck_SaveOld_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = [GetName(handles), 'Speck.dat'];
% fname = fullfile(GetPath(handles), 'Speck.dat');

[Et, t, w] = GetField(handles);

esave(ltow(w), fftc(Et), fname);

AddLog(handles, ['Saved:  ', fname]);

% --- Executes on button press in Arecon_Save_Button.
function Arecon_Save_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Arecon_Save_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = [GetName(handles), 'Arecon.dat'];

[Asig, t, w] = GetRecon(handles);

fname = frogtracesave(magsq(Asig), ltow(w), t, [], fname);

AddLog(handles, ['Saved:  ', fname]);

% --- Executes on button press in Arecon_Export_Button.
function Arecon_Export_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Arecon_Export_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[Asig, t, w] = GetRecon(handles);

assignin('base', 'Asig', Asig);
assignin('base', 'tau', t);
assignin('base', 'w2', w);
assignin('base', 'l2', ltow(w));

% --- Executes on button press in Arecon_SaveAs_Button.
function Arecon_SaveAs_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Arecon_SaveAs_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = [GetName(handles), 'Arecon.dat'];

[fname, pname] = uiputfile({'*Arecon.dat',	'Reconstructed traces (*Arecon.dat)'; ...
		'*.dat',	'Data files (*.dat)'; ...
		'*.*',		'All files (*.*)'}, ...
	'Save the reconstructed trace as...', ...
	fname);

if isequal(fname, 0) || isequal(pname, 0)
	return
end

fname = fullfile(pname, fname);

[Asig, t, w] = GetRecon(handles);

frogtracesave(magsq(Asig), ltow(w), t, [], fname);

AddLog(handles, ['Saved:  ', fname]);

% --- Executes on button press in Arecon_SaveOld_Button.
function Arecon_SaveOld_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Arecon_SaveOld_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% fname = [GetPath(handles), 'Arecon.dat'];
fname = [GetName(handles), 'Arecon.dat'];

[Asig, t, w] = GetRecon(handles);

frogtracesave(magsq(Asig), ltow(w), t, [], fname);

AddLog(handles, ['Saved:  ', fname]);

% --- Executes on button press in Arecon_Save_Button.
function A_Save_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Arecon_Save_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = [GetName(handles), 'A.dat'];

[Asig, t, w] = GetOriginal(handles);

frogtracesave(magsq(Asig), ltow(w), t, [], fname);

AddLog(handles, ['Saved:  ', fname]);

% --- Executes on button press in Arecon_Export_Button.
function A_Export_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Arecon_Export_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[Asig, t, w] = GetOriginal(handles);

assignin('base', 'Asig2', Asig);
assignin('base', 'tau', t);
assignin('base', 'w2', w);
assignin('base', 'l2', ltow(w));

% --- Executes on button press in Arecon_SaveAs_Button.
function A_SaveAs_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Arecon_SaveAs_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = [GetName(handles), 'A.dat'];

[fname, pname] = uiputfile({'*A.dat',	'Original traces (*A.dat)'; ...
		'*.dat',	'Data files (*.dat)'; ...
		'*.*',		'All files (*.*)'}, ...
	'Save the reconstructed trace as...', ...
	fname);

if isequal(fname, 0) || isequal(pname, 0)
	return
end

fname = fullfile(pname, fname);

[Asig, t, w] = GetOriginal(handles);

frogtracesave(magsq(Asig), ltow(w), t, [], fname);

AddLog(handles, ['Saved:  ', fname]);

% --- Executes on button press in Arecon_SaveOld_Button.
function A_SaveOld_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Arecon_SaveOld_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = [GetName(handles), 'A.dat'];

[Asig, t, w] = GetOriginal(handles);

frogtracesave(magsq(Asig), ltow(w), t, [], fname);

AddLog(handles, ['Saved:  ', fname]);

% --- Executes during object creation, after setting all properties.
function Log_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Log_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Log_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Log_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Log_Edit as text
%        str2double(get(hObject,'String')) returns contents of Log_Edit as a double


% --- Executes on button press in All_Save_Button.
function All_Save_Button_Callback(hObject, eventdata, handles)
% hObject    handle to All_Save_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

A_Save_Button_Callback(hObject, eventdata, handles);
Arecon_Save_Button_Callback(hObject, eventdata, handles);
Ek_Save_Button_Callback(hObject, eventdata, handles);
Speck_Save_Button_Callback(hObject, eventdata, handles);


% --- Executes on button press in All_Export_Button.
function All_Export_Button_Callback(hObject, eventdata, handles)
% hObject    handle to All_Export_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

A_Export_Button_Callback(hObject, eventdata, handles);
Arecon_Export_Button_Callback(hObject, eventdata, handles);
Ek_Export_Button_Callback(hObject, eventdata, handles);
Speck_Export_Button_Callback(hObject, eventdata, handles);


% --- Executes on button press in All_SaveOld_Button.
function All_SaveOld_Button_Callback(hObject, eventdata, handles)
% hObject    handle to All_SaveOld_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

A_SaveOld_Button_Callback(hObject, eventdata, handles);
Arecon_SaveOld_Button_Callback(hObject, eventdata, handles);
Ek_SaveOld_Button_Callback(hObject, eventdata, handles);
Speck_SaveOld_Button_Callback(hObject, eventdata, handles);

