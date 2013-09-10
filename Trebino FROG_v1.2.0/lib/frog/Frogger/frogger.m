function varargout = frogger(varargin)
% frogger is the FROG retrieval program
%
% See also: BINNER

% Edit the above text to modify the response to help frogger

% Last Modified by GUIDE v2.5 17-Mar-2005 12:14:44

%	$Id: frogger.m,v 1.3 2008-01-22 01:55:47 pam Exp $
%       (c) 2002-2004 Erik Zeek  All rights reserved

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
	'gui_Singleton',  gui_Singleton, ...
	'gui_OpeningFcn', @frogger_OpeningFcn, ...
	'gui_OutputFcn',  @frogger_OutputFcn, ...
	'gui_LayoutFcn',  [], ...
	'gui_Callback',   []);
if nargin && isstr(varargin{1})
	gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
	[varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
	gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before frogger is made visible.
function frogger_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for frogger
handles.output = hObject;

% Set the menu accelerators.
set(handles.Open_MenuItem, 'Accelerator', 'o');
set(handles.Save_MenuItem, 'Accelerator', 's');
set(handles.Exit_MenuItem, 'Accelerator', 'q');
set(handles.Run_MenuItem, 'Accelerator', 'r');
set(handles.Stop_MenuItem, 'Accelerator', 'x');
set(handles.NewPulse_MenuItem, 'Accelerator', 'n');
set(handles.Print_MenuItem, 'Accelerator', 'p');

% Setup default preferences.
pth = fileparts(mfilename('fullpath'));
loadprefs(pth);

% Enumerate the available algorithms.
getalgos(handles);

% Update the controls for the non-linearities.
updateclass(handles);
updatenonlin(handles);
updatedomain(handles);
updatealgo(handles);

% Set the colormap to the default. (Probably should have a preference for
% this.)
% colormap FrogColorMap;

DStruct = DisplayStructSet('xlabel', 'Delay', 'ylabel', 'Frequency', 'drawnow', false, 'colorbar', true);
DStructPulse = DisplayStructSet('cutoff', 1e-4, 'drawnow', false);
setappdata(handles.Frogger_Main, 'DStruct', DStruct);
setappdata(handles.Frogger_Main, 'DStructPulse', DStructPulse);

% Create a pulse for the default trace.
[Et, t, Ew, w] = pulsegenerator(128, @fgaussian, 100, 15, 800, [], [], [0, 0, 2000, 40000]);
% Center the pulse in the same manner the frogger Alogorithm does.
Et = center(Et,'max');

if true
	% Create a default FrogObj.
	FrogObj = ShgAlgo;
	
	% Calculate the FROG trace.
	Esig = CalcEsig(Et,gate_shg(Et));

	% Calculating the frequency axis.
	w2 = w + w(end/2+1);
else
	% Create a default FrogObj.
	FrogObj = PgAlgo;
	
	% Calculate the FROG trace.
	Esig = CalcEsig(Et,gate_pg(Et));

	% Calculating the frequency axis.
	w2 = w;
end

% Continuing the calculation, adding noise and removing the negative
% values.
Esig = nonegatives(abs(fft_FROG(Esig)) + 0.1 * rand(size(Esig)));

% Store the values in the FrogObj.
FrogObj = set(FrogObj, 'EtOrig',	Et);
FrogObj = set(FrogObj, 'Asig',		Esig);
FrogObj = set(FrogObj, 'tau',		t);
FrogObj = set(FrogObj, 'w2',		w2);
FrogObj = set(FrogObj, 't',			t);

% Gererate a first guess...
[Et, t, Ew, w] = pulsegenerator(128, @frand, 40, 1, 800);
% ...and store it in the FrogObj.
FrogObj = set(FrogObj, 'Et',		Et);

% Run one step to get the initial error values.
FrogObj = RunAlgoKern(FrogObj, handles);

% Initialize the preferences.
loadprefs( mfilename('fullpath'));

% Store the current filename and FrogObj in the AppData.
setappdata(hObject, 'Filename', '');
setappdata(hObject, 'FrogObj', FrogObj);

% Update handles structure
guidata(hObject, handles);

% Center the GUI on the screen.
movegui(hObject, 'center');

% Update the plots.
UpdateOriginal(FrogObj, handles.Original_Axes, DStruct);
UpdateRecon(FrogObj, handles.Recon_Axes, handles.Diff_Axes, DStruct);
UpdatePlots(FrogObj, handles.Time_Axes, handles.Spec_Axes, ...
	handles.Error_Axes, handles.Status_Text, DStructPulse);

% Make the controls match the current object.
setclass(handles, get(FrogObj, 'TypeName'));
setnonlin(handles, get(FrogObj, 'NonLinName'));
setdomain(handles, get(FrogObj, 'DomainName'));
setalgo(handles, get(FrogObj, 'AlgoName'));

% Make sure that everything matches.
resetalgo(handles);


% --- Outputs from this function are returned to the command line.
function varargout = frogger_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_MenuItem_Callback(hObject, eventdata, handles)
% Load a binned FROG trace.
% hObject    handle to Open_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Try to load a trace.
try
% 	[Asig,tau,lam,dtau,lam0,dlam,NumD,NumL,filename] = frogload;
    [Asig,tau,freq,dtau,f0,df,NumD,NumL,filename] = frogload;   % Binned trace loads in frequencies
catch
    [errmsg, msgid] = lasterr;
    % Exit load function if is didn't work.
	if ~strcmp(msgid, 'frogload:NoSelection')
        errordlg(lasterr, 'Error loading FROG file.', 'modal');
    end
	return
end

% Simple check for a binned trace.
if size(Asig,1) ~= size(Asig,2)
	errordlg('Please select a binned trace!', 'File Error', 'modal');
	return
end

% We only want the amplitude.
Asig = sqrt(Asig);

% The array size.
N = size(Asig,1);

% % lam is not the proper frequency array.  It assumes that the FROG trace is
% % in constant wavelength spacing.  Binner saves the lam0 and dlam values
% % for the frequency array at the center of the trace.
% W0 = ltow(lam0);
% dW = W0 - ltow(lam0 + dlam);
% 
% % Now we can calculate the angular frequency array for the binned FROG
% % trace.
% w2 = ((-N/2):(N/2-1)) * dW + W0;

% HACK!!!!
% Binnined traces were not saved in expected units.  This hack fixes it.

w2 = freq * 2 * pi;


% Get the current FrogObj.
FrogObj = getappdata(handles.Frogger_Main, 'FrogObj');

DStruct = getappdata(handles.Frogger_Main,'DStruct');
DStructPulse = getappdata(handles.Frogger_Main,'DStructPulse');

% Create a new, empty FrogObj.
FrogObj = feval(class(FrogObj));

% Assign the new values to the FrogObj.
FrogObj = set(FrogObj, 'Asig', Asig);
FrogObj = set(FrogObj, 'tau', tau);
FrogObj = set(FrogObj, 't', tau);
FrogObj = set(FrogObj, 'w2', w2);
% Set a default new first guess.
FrogObj = set(FrogObj, 'Et', frand(tau, tau(floor(end*3/4))));

% Run one step to get the proper error values.
FrogObj = RunAlgoKern(FrogObj, handles);

% Update the plots.
UpdateOriginal(FrogObj, handles.Original_Axes, DStruct);
UpdateRecon(FrogObj, handles.Recon_Axes, handles.Diff_Axes, DStruct);
UpdatePlots(FrogObj, handles.Time_Axes, handles.Spec_Axes, ...
	handles.Error_Axes, handles.Status_Text, DStructPulse);

% Stor the new FrogObj.
setappdata(handles.Frogger_Main, 'FrogObj', FrogObj);

% Clear the dirty bit.
cleardirty(handles);

% Save the filename.
setappdata(handles.Frogger_Main, 'Filename', filename);

% Add the filename to the title bar.
[X,filename] = fileparts(filename);
set(handles.Frogger_Main, 'Name', ['frogger - ', filename]);

% --------------------------------------------------------------------
function Save_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to Save_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if FroggerSave(handles.Frogger_Main)
	% If the use pressed OK clear the dirty bit.
	cleardirty(handles);
end

% If we're closing, continue closing.
if getappdata(handles.Frogger_Main, 'Closing')
	Frogger_Main_CloseRequestFcn(handles.Frogger_Main, eventdata, handles);
end

% --------------------------------------------------------------------
function Exit_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to Exit_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.Frogger_Main);

% --- Executes during object creation, after setting all properties.
function NonLin_Popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NonLin_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in NonLin_Popup.
function NonLin_Popup_Callback(hObject, eventdata, handles)
% hObject    handle to NonLin_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns NonLin_Popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NonLin_Popup

updatedomain(handles);
updatealgo(handles);
resetalgo(handles);

% --- Executes during object creation, after setting all properties.
function Class_Popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Class_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in Class_Popup.
function Class_Popup_Callback(hObject, eventdata, handles)
% hObject    handle to Class_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Class_Popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Class_Popup


updatenonlin(handles);
updatedomain(handles);
updatealgo(handles);
resetalgo(handles);

% --- Executes during object creation, after setting all properties.
function Domain_Popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Domain_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Domain_Popup.
function Domain_Popup_Callback(hObject, eventdata, handles)
% hObject    handle to Domain_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Domain_Popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Domain_Popup

updatealgo(handles);
resetalgo(handles);

% --- Executes during object creation, after setting all properties.
function Algo_Popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Algo_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
% 	set(hObject,'BackgroundColor','white');
else
	set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Algo_Popup.
function Algo_Popup_Callback(hObject, eventdata, handles)
% hObject    handle to Algo_Popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Algo_Popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Algo_Popup
resetalgo(handles);

function Run_Button_Callback(hObject, eventdata, handles, DStruct, DStructPulse)
% hObject    handle to Run_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Enable or disable buttons, menus, and popups.
set(handles.Stop_Button,'Enable','on')
set(handles.Run_Button,'Enable','off')
set(handles.Run_MenuItem,'Enable','off')
set(handles.Stop_MenuItem,'Enable','on')
set(handles.NewPulse_MenuItem,'Enable','off')

set(handles.Class_Popup, 'Enable', 'off')
set(handles.NonLin_Popup, 'Enable', 'off')
set(handles.Domain_Popup, 'Enable', 'off')
set(handles.Algo_Popup, 'Enable', 'off')

set(handles.Extra_Button, 'Enable', 'off')
set(handles.Extra_MenuItem, 'Enable', 'off');

% Clear the Stopping bit and set the Running bit.
setappdata(handles.Frogger_Main, 'Stopping', false);
setappdata(handles.Frogger_Main, 'Running', true);

% Get the FrogObj.
FrogObj = getappdata(handles.Frogger_Main,'FrogObj');

DStruct = getappdata(handles.Frogger_Main,'DStruct');
DStructPulse = getappdata(handles.Frogger_Main,'DStructPulse');

% Run the algorithm.  This function doesn't return until we stop it with
% the Stop button.
FrogObj = RunAlgo(FrogObj, handles, DStruct, DStructPulse);

% Store the new FrogObj.
setappdata(handles.Frogger_Main, 'FrogObj', FrogObj);

% Clear the running bit.
setappdata(handles.Frogger_Main, 'Running', false);

% New we're dirty, unsaved data.
setdirty(handles);

% Re-enable or re-disable buttons, menus, and popups.
set(handles.Run_Button,'Enable','on')
set(handles.Stop_Button,'Enable','off')
set(handles.Run_MenuItem,'Enable','on')
set(handles.Stop_MenuItem,'Enable','off')
set(handles.NewPulse_MenuItem,'Enable','on')

set(handles.Class_Popup, 'Enable', 'on')
set(handles.NonLin_Popup, 'Enable', 'on')
set(handles.Domain_Popup, 'Enable', 'on')
set(handles.Algo_Popup, 'Enable', 'on')

if get(FrogObj, 'NeedsExtraInfo')
	set(handles.Extra_Button, 'Enable', 'on')
    set(handles.Extra_MenuItem, 'Enable', 'on');
end

% If we're closing, continue.
if getappdata(handles.Frogger_Main, 'Closing')
	Frogger_Main_CloseRequestFcn(handles.Frogger_Main, eventdata, handles);
end

% --- Executes on button press in Stop_Button.
function Stop_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Stop_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set the Stopping bit.
setappdata(handles.Frogger_Main, 'Stopping', true);

% --------------------------------------------------------------------
function Edit_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Pref_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to Pref_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if FroggerPrefs
	% TODO: We should do something here.
end

% --------------------------------------------------------------------
% function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Help_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function About_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to About_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

helpdlg({'Frogger Ver 3.0', '(c) 2002-06 Erik Zeek, Xun Gu'}, 'About Frogger');

% --------------------------------------------------------------------
function NewPulse_MenuItem_Callback(hObject, eventdata, handles)
% Get a new starting guess.
% hObject    handle to NewPulse_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the FrogObj.
FrogObj = getappdata(handles.Frogger_Main,'FrogObj');

DStruct = getappdata(handles.Frogger_Main,'DStruct');
DStructPulse = getappdata(handles.Frogger_Main,'DStructPulse');

% Get the parameters for the default values.
N = length(get(FrogObj, 'Et'));
t = get(FrogObj, 't');
dt = incre(t);
w1 = get(FrogObj, 'w1');
L0 = ltow(w1(floor(end/2)+1));

% Get a new pulse, passing in the default values.
[Et1, T1] = uipulsegen('N', N, 'Dt', dt, 'L0', L0);

% If the user cancelled, return.
if isempty(Et1)
	return
end

% Store the new pulse.
% TODO: We don't take into consideration a frequency shift.
FrogObj = set(FrogObj, 'Et', spline(T1, Et1, t));

% Clear the stuff that depended on the last pulse.
FrogObj = set(FrogObj, 'Esig', []);
FrogObj = set(FrogObj, 'G', []);
FrogObj = set(FrogObj, 'Z', []);
FrogObj = set(FrogObj, 'BestG.Et', []);
FrogObj = set(FrogObj, 'BestZ.Et', []);

% Run aa single step to initialize everything.
FrogObj = RunAlgoKern(FrogObj, handles);

% Store the FrogObj.
setappdata(handles.Frogger_Main, 'FrogObj', FrogObj);
% New pulse isn't dirty yet.
cleardirty(handles);

% Update the plots.
UpdateRecon(FrogObj, handles.Recon_Axes, handles.Diff_Axes, DStruct);
UpdatePlots(FrogObj, handles.Time_Axes, handles.Spec_Axes, ...
	handles.Error_Axes, handles.Status_Text, DStructPulse);

% --------------------------------------------------------------------
function Execute_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Execute_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close Frogger_Main.
function Frogger_Main_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Frogger_Main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

% Check to see if we're running.
if getappdata(hObject, 'Running')
	% Check to see if we're already closing.
	if getappdata(hObject, 'Closing')
		% The algorithm is not really running.  Most likely an error killed
		% it.  Should we exit now anyway?
		X = questdlg('frogger is currently closing.  Do you wish to close immediately?', ...
			'Currently Closing','Yes', 'No', 'No');
		if strcmp(X, 'Yes')
			delete(hObject);
		end
	end
	% Set the Stopping and Closing bits.
	setappdata(hObject, 'Stopping', true);
	setappdata(hObject, 'Closing', true);
	return
end

% Is there dirty data?
if getappdata(hObject, 'Dirty')
	ans = questdlg('There is unsaved data.  Do you wish to save it?', 'Dirty Data');
	switch ans
		case 'Yes'
			% Save the data.
			setappdata(hObject, 'Stopping', true);
			Save_MenuItem_Callback(hObject, eventdata, handles);
		case 'Cancel'
			% Don't save the data, but don't quit either.
			return
	end
end

% We're all done.  Kill frogger!!!!!!!!!
delete(hObject);


% --- Executes on button press in FlipTime_Button.
function FlipTime_Button_Callback(hObject, eventdata, handles)
% hObject    handle to FlipTime_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set the FlipTime flag.
setappdata(handles.Frogger_Main, 'FlipTime', true);


% --------------------------------------------------------------------
function Help_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to Help_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

HelpFile = which('frogger.html');
web(HelpFile);



% --- Executes on button press in Extra_Button.
function Extra_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Extra_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the extra info for the particular FROG algorithm.
FrogObj = ExtraInfo(getappdata(handles.Frogger_Main,'FrogObj'));

% Store the new FrogObj.
setappdata(handles.Frogger_Main, 'FrogObj', FrogObj);


% --- Executes on button press in FlatPhase_Button.
function FlatPhase_Button_Callback(hObject, eventdata, handles)
% hObject    handle to FlatPhase_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set the FlatPhase flag.
setappdata(handles.Frogger_Main, 'FlatPhase', true);


% --------------------------------------------------------------------
function Print_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to Print_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Print the frogger dialog.
printdlg(handles.Frogger_Main);


% --------------------------------------------------------------------
function PrintPreView_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintPreView_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Prieview the frogger dialog printing.
printpreview(handles.Frogger_Main)

% --------------------------------------------------------------------
function PageSetup_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PageSetup_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Print page setup dialog.
pagesetupdlg(handles.Frogger_Main);


% --- Executes on key press over Frogger_Main with no controls selected.
function Frogger_Main_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Frogger_Main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


