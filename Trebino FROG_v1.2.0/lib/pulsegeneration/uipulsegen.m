function varargout = uipulsegen(varargin)
% UIPULSEGEN a GUI for PULSEGENERATOR
%	[ET, T, EW, W] = UIPULSEGEN returns the pulse as specified by the
%	parameters on the front panel.
%
% See also: PULSEGENERATOR

%	$Id: uipulsegen.m,v 1.1 2006-11-11 00:15:30 pablo Exp $

% Edit the above text to modify the response to help uipulsegen

% Last Modified by GUIDE v2.5 22-Apr-2006 23:56:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
	'gui_Singleton',  gui_Singleton, ...
	'gui_OpeningFcn', @uipulsegen_OpeningFcn, ...
	'gui_OutputFcn',  @uipulsegen_OutputFcn, ...
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

% ---------------------------------------------------------------
function X = GetVal(hObject)

if strcmpi(get(hObject, 'Style'), 'edit')
	X = get(hObject, 'String');
	X = strcat('[', X, ']');
	X = eval(X);
end

if strcmpi(get(hObject, 'Style'), 'popupmenu')
	X = get(hObject, 'String');
	X = eval(X{get(hObject, 'Value')});
end

% ---------------------------------------------------------------
function UpdateFields(handles)

if get(handles.Delay_Check, 'Value')
	return
end

N = getappdata(handles.uipulsegen, 'N');
Shape = getappdata(handles.uipulsegen, 'Shape');
FWHM = getappdata(handles.uipulsegen, 'FWHM');
Dt = getappdata(handles.uipulsegen, 'Dt');
L0 = getappdata(handles.uipulsegen, 'L0');
TempPhase = getappdata(handles.uipulsegen, 'TempPhase');
SPM = getappdata(handles.uipulsegen, 'SPM');
SpecPhase = getappdata(handles.uipulsegen, 'SpecPhase');


if getappdata(handles.uipulsegen, 'UseFile');
	fname = get(handles.File_Edit, 'String');
	
	[T, Et, fname] = eload(fname);
    
    if get(handles.FlipTime_Check, 'value')
        Et = fliptime(Et);
    end
	
	Et = AddPolyPhase(T, Et, TempPhase);
	
	if ~isempty(SPM) && SPM ~= 0;
		tphase = SPM .* abs(Et) .^ 2;
		Et= Et.*exp(1i.*tphase);
	end
	
	[W, Ew] = timetofreq(T, Et, L0);

	if ~isempty(SpecPhase) && any(SpecPhase)
		Ew = AddPolyPhase(W - W(floor(end/2)+1), Ew, SpecPhase);
		Et = ifftc(Ew);
	end
	
	set(handles.Size_Edit, 'String', length(T));
	set(handles.Dt_Edit, 'String', mean(diff(T)));
else
	[Et, T, Ew, W] = pulsegenerator(N, Shape, FWHM, Dt, L0, TempPhase, SPM, SpecPhase);
end

setappdata(handles.uipulsegen, 'Et', Et);
setappdata(handles.uipulsegen, 'T', T);
setappdata(handles.uipulsegen, 'Ew', Ew);
setappdata(handles.uipulsegen, 'W', W);

% ---------------------------------------------------------------
function UpdatePlots(handles)

if get(handles.Delay_Check, 'Value')
	return
end

Et = getappdata(handles.uipulsegen, 'Et');
T = getappdata(handles.uipulsegen, 'T');
Ew = getappdata(handles.uipulsegen, 'Ew');
W = getappdata(handles.uipulsegen, 'W');

axes(handles.Time_Axes);
plotcmplx2(T, Et);
title('\bfTime')
xlabel('Time')

set(handles.FWHMT_Text, 'String', sprintf('FWHM = %.2f', fwhm(magsq(Et), T)))

axes(handles.Spec_Axes);
plotcmplx2(W/2/pi, Ew);
title('\bfSpectrum')
xlabel('Frequency')

set(handles.FWHML_Text, 'String', sprintf('FWHM = %.2f', fwhm(magsq(Ew), W)))

% ---------------------------------------------------------------
function UpdateAppData(handles)

setappdata(handles.uipulsegen, 'N', GetVal(handles.Size_Edit));
setappdata(handles.uipulsegen, 'Shape', GetVal(handles.Shape_Popup));
setappdata(handles.uipulsegen, 'FWHM', GetVal(handles.FWHM_Edit));
setappdata(handles.uipulsegen, 'Dt', GetVal(handles.Dt_Edit));
setappdata(handles.uipulsegen, 'L0', GetVal(handles.L0_Edit));
setappdata(handles.uipulsegen, 'TempPhase', GetVal(handles.TempPhase_Edit));
setappdata(handles.uipulsegen, 'SPM', GetVal(handles.SPM_Edit));
setappdata(handles.uipulsegen, 'SpecPhase', GetVal(handles.SpecPhase_Edit));

% ---------------------------------------------------------------
function UpdateAll(handles)

UpdateAppData(handles);
UpdateFields(handles);
UpdatePlots(handles);

% --- Executes just before uipulsegen is made visible.
function varargout = uipulsegen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uipulsegen (see VARARGIN)

% Choose default command line output for uipulsegen

while length(varargin) > 0
	switch varargin{1}
		case 'LockN'
			set(handles.Size_Edit, 'Enable', 'off', 'String', varargin{2});
			if length(varargin) > 2
				varargin = varargin(3:end);
			else
				varargin = {};
			end
		case 'LockDt'
			set(handles.Dt_Edit, 'Enable', 'off', 'String', varargin{2});
			if length(varargin) > 2
				varargin = varargin(3:end);
			else
				varargin = {};
			end
		case 'LockL0'
			set(handles.L0_Edit, 'Enable', 'off', 'String', varargin{2});
			if length(varargin) > 2
				varargin = varargin(3:end);
			else
				varargin = {};
			end
		case 'N'
			set(handles.Size_Edit, 'String', varargin{2});
			if length(varargin) > 2
				varargin = varargin(3:end);
			else
				varargin = {};
			end
		case 'Dt'
			set(handles.Dt_Edit, 'String', varargin{2});
			if length(varargin) > 2
				varargin = varargin(3:end);
			else
				varargin = {};
			end
		case 'L0'
			set(handles.L0_Edit, 'String', varargin{2});
			if length(varargin) > 2
				varargin = varargin(3:end);
			else
				varargin = {};
			end
		otherwise
			error('Unknown option');
	end
end

setappdata(handles.uipulsegen, 'UseFile', false);
UpdateAll(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes uipulsegen wait for user response (see UIRESUME)
uiwait(handles.uipulsegen);


% --- Executes when user attempts to close uipulsegen.
function uipulsegen_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to uipulsegen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = uipulsegen_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

if getappdata(hObject, 'OK')
	varargout{1} = getappdata(hObject, 'Et');
	if nargout > 1
		varargout{2} = getappdata(hObject, 'T');
	end
	if nargout > 2
		varargout{3} = getappdata(hObject, 'Ew');
	end
	if nargout > 3
		varargout{4} = getappdata(hObject, 'W');
	end
else
	varargout{1} = [];
	if nargout > 1
		varargout{2} = [];
	end
	if nargout > 2
		varargout{3} = [];
	end
	if nargout > 3
		varargout{4} = [];
	end
end
delete(hObject)


% --- Executes during object creation, after setting all properties.
function Size_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Size_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Size_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Size_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Size_Edit as text
%        str2double(get(hObject,'String')) returns contents of Size_Edit as a double

UpdateAll(handles);

% --- Executes during object creation, after setting all properties.
function Shape_Popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Shape_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Shape_Popup.
function Shape_Popup_Callback(hObject, eventdata, handles)
% hObject    handle to Shape_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Shape_Popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Shape_Popup

UpdateAll(handles);

% --- Executes during object creation, after setting all properties.
function FWHM_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FWHM_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function FWHM_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to FWHM_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FWHM_Edit as text
%        str2double(get(hObject,'String')) returns contents of FWHM_Edit as a double

UpdateAll(handles);

% --- Executes during object creation, after setting all properties.
function Dt_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dt_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Dt_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Dt_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Dt_Edit as text
%        str2double(get(hObject,'String')) returns contents of Dt_Edit as a double

UpdateAll(handles);

% --- Executes during object creation, after setting all properties.
function L0_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L0_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function L0_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to L0_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L0_Edit as text
%        str2double(get(hObject,'String')) returns contents of L0_Edit as a double

UpdateAll(handles);

% --- Executes during object creation, after setting all properties.
function TempPhase_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TempPhase_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function TempPhase_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to TempPhase_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TempPhase_Edit as text
%        str2double(get(hObject,'String')) returns contents of TempPhase_Edit as a double

UpdateAll(handles);

% --- Executes during object creation, after setting all properties.
function SPM_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SPM_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function SPM_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to SPM_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SPM_Edit as text
%        str2double(get(hObject,'String')) returns contents of SPM_Edit as a double

UpdateAll(handles);

% --- Executes during object creation, after setting all properties.
function SpecPhase_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SpecPhase_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function SpecPhase_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to SpecPhase_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SpecPhase_Edit as text
%        str2double(get(hObject,'String')) returns contents of SpecPhase_Edit as a double

UpdateAll(handles);

% --- Executes on button press in Delay_Check.
function Delay_Check_Callback(hObject, eventdata, handles)
% hObject    handle to Delay_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Delay_Check

UpdateAll(handles);

% --- Executes on button press in OK_Button.
function OK_Button_Callback(hObject, eventdata, handles)
% hObject    handle to OK_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.uipulsegen, 'OK', true);

close(handles.uipulsegen);


% --- Executes on button press in File_Checkbox.
function File_Checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to File_Checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of File_Checkbox

% PulseGen_Tags = [handles.PulseGen_Text, handles.Size_Edit, handles.Shape_Popup, ...
% 		handles.FWHM_Edit, handles.Dt_Edit, handles.TempPhase_Edit, ...
% 		handles.SPM_Edit, handles.SpecPhase_Edit];
PulseGen_Tags = [handles.Size_Edit, handles.Shape_Popup, ...
		handles.FWHM_Edit, handles.Dt_Edit];

File_Tags = [handles.File_Text, handles.File_Edit, handles.Browse_Button];

if get(hObject, 'Value')
	set(PulseGen_Tags, 'Enable', 'off')
	set(File_Tags, 'Enable', 'on')
	setappdata(handles.uipulsegen, 'UseFile', true);
else
	set(PulseGen_Tags, 'Enable', 'on')
	set(File_Tags, 'Enable', 'off')
	setappdata(handles.uipulsegen, 'UseFile', false);
end

% --- Executes during object creation, after setting all properties.
function File_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function File_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to File_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of File_Edit as text
%        str2double(get(hObject,'String')) returns contents of File_Edit as a double


% --- Executes on button press in Browse_Button.
function Browse_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fname = get(handles.File_Edit, 'String');

[fname,pname] = uigetfile(...
	{'*.dat', 'FROG Output Files (*.dat)';...
		'*.*', 'All Files (*.*)'}, 'Load Temporal E-field file', fname);
if fname == 0
	error('Invalid filename');
end

fname = [pname,fname];

set(handles.File_Edit, 'String', fname);

UpdateAll(handles);


% --- Executes on button press in Cancel_Button.
function Cancel_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.uipulsegen, 'OK', false);

close(handles.uipulsegen);



% --- Executes on button press in FlipTime_Check.
function FlipTime_Check_Callback(hObject, eventdata, handles)
% hObject    handle to FlipTime_Check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

UpdateAll(handles);