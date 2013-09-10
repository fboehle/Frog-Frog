function varargout = FroggerPrefs(varargin)
% FROGGERPREFS set the preferences for FROGGER
%	FROGGERPREFS can be called on its own to alter the FROGGER preferences.
% See also: FROGGER, BINNER

%	$Id: FroggerPrefs.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

% Last Modified by GUIDE v2.5 18-Feb-2003 12:34:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FroggerPrefs_OpeningFcn, ...
                   'gui_OutputFcn',  @FroggerPrefs_OutputFcn, ...
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


% --- Executes just before FroggerPrefs is made visible.
function FroggerPrefs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FroggerPrefs (see VARARGIN)

% Choose default command line output for FroggerPrefs
handles.output = hObject;

set(handles.NonLinPath_Edit,	'String', getpref('frogger', 'NonLinPath'));
set(handles.PlotNum_Edit,		'String', getpref('frogger', 'PlotNum'));
set(handles.PlotEvery_Edit,		'String', getpref('frogger', 'PlotEvery'));
set(handles.MaxIter_Edit,		'String', getpref('frogger', 'MaxIter'));
set(handles.PlotTimeLow_Edit,	'String', getpref('frogger', 'PlotTimeLow'));
set(handles.PlotTimeHigh_Edit,	'String', getpref('frogger', 'PlotTimeHigh'));
set(handles.PlotFreqLow_Edit,	'String', getpref('frogger', 'PlotFreqLow'));
set(handles.PlotFreqHigh_Edit,	'String', getpref('frogger', 'PlotFreqHigh'));


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FroggerPrefs wait for user response (see UIRESUME)
uiwait(handles.FroggerPrefs);


% --- Outputs from this function are returned to the command line.
function varargout = FroggerPrefs_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

varargout{1} = getappdata(handles.FroggerPrefs, 'Result');

delete(handles.FroggerPrefs);

% --- Executes on button press in OK_Button.
function OK_Button_Callback(hObject, eventdata, handles)
% hObject    handle to OK_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setpref('frogger', 'NonLinPath',	     get(handles.NonLinPath_Edit,	'String'));
setpref('frogger', 'PlotNum',		eval(get(handles.PlotNum_Edit,		'String')));
setpref('frogger', 'PlotEvery',		eval(get(handles.PlotEvery_Edit,	'String')));
setpref('frogger', 'MaxIter',		eval(get(handles.MaxIter_Edit,		'String')));
setpref('frogger', 'PlotTimeLow',	eval(get(handles.PlotTimeLow_Edit,	'String')));
setpref('frogger', 'PlotTimeHigh',	eval(get(handles.PlotTimeHigh_Edit,	'String')));
setpref('frogger', 'PlotFreqLow',	eval(get(handles.PlotFreqLow_Edit,	'String')));
setpref('frogger', 'PlotFreqHigh',	eval(get(handles.PlotFreqHigh_Edit,	'String')));

setappdata(handles.FroggerPrefs, 'Result', true)

close(handles.FroggerPrefs);

% --- Executes on button press in Cancel_Button.
function Cancel_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.FroggerPrefs, 'Result', false)

close(handles.FroggerPrefs);

% --- Executes on key press over FroggerPrefs with no controls selected.
function FroggerPrefs_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to FroggerPrefs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(hObject, 'CurrentCharacter')
	case char(13)
		OK_Button_Callback(hObject, eventdata, handles);
	case char(27)
		Cancel_Button_Callback(hObject, eventdata, handles);
end


% --- Executes on button press in Help_Button.
function Help_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Help_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function NonLinPath_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NonLinPath_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function NonLinPath_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to NonLinPath_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NonLinPath_Edit as text
%        str2double(get(hObject,'String')) returns contents of NonLinPath_Edit as a double


% --- Executes on button press in NonLinPath_Button.
function NonLinPath_Button_Callback(hObject, eventdata, handles)
% hObject    handle to NonLinPath_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

S = uigetdir(get(handles.NonLinPath_Edit, 'String'), 'Please select your NonLin directory');

if S ~= 0
	set(handles.NonLinPath_Edit, 'String', S)
end

% --- Executes when user attempts to close FroggerPrefs.
function FroggerPrefs_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to FroggerPrefs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

uiresume(handles.FroggerPrefs);


% --- Executes during object creation, after setting all properties.
function PlotNum_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotNum_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function PlotNum_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to PlotNum_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotNum_Edit as text
%        str2double(get(hObject,'String')) returns contents of PlotNum_Edit as a double


% --- Executes during object creation, after setting all properties.
function PlotEvery_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotEvery_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function PlotEvery_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to PlotEvery_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotEvery_Edit as text
%        str2double(get(hObject,'String')) returns contents of PlotEvery_Edit as a double


% --- Executes during object creation, after setting all properties.
function MaxIter_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxIter_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function MaxIter_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to MaxIter_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxIter_Edit as text
%        str2double(get(hObject,'String')) returns contents of MaxIter_Edit as a double


% --- Executes during object creation, after setting all properties.
function PlotTimeLow_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotTimeLow_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function PlotTimeLow_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to PlotTimeLow_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotTimeLow_Edit as text
%        str2double(get(hObject,'String')) returns contents of PlotTimeLow_Edit as a double


% --- Executes during object creation, after setting all properties.
function PlotTimeHigh_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotTimeHigh_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function PlotTimeHigh_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to PlotTimeHigh_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotTimeHigh_Edit as text
%        str2double(get(hObject,'String')) returns contents of PlotTimeHigh_Edit as a double


% --- Executes during object creation, after setting all properties.
function PlotFreqLow_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotFreqLow_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function PlotFreqLow_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to PlotFreqLow_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotFreqLow_Edit as text
%        str2double(get(hObject,'String')) returns contents of PlotFreqLow_Edit as a double


% --- Executes during object creation, after setting all properties.
function PlotFreqHigh_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotFreqHigh_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function PlotFreqHigh_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to PlotFreqHigh_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotFreqHigh_Edit as text
%        str2double(get(hObject,'String')) returns contents of PlotFreqHigh_Edit as a double


