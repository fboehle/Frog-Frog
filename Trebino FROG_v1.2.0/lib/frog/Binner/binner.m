function varargout = Binner(varargin)
% BINNER Application M-file for Binner.fig
%    FIG = BINNER launch Binner GUI.
%    BINNER('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 07-May-2006 12:23:32

if nargin == 0  % LAUNCH GUI
	
	fig = openfig(mfilename,'reuse');
	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));
	
	% Move figure to center of screen.
	movegui(fig,'center');
	
	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	
	handles.isdirty			= false;
	handles.isloaded		= false;
	handles.isbinned		= false;
	handles.FrogData		= struct('Isig',{},'Tau',{},'Lam',{},'Binned',{});
	handles.size			= 128;
	handles.ButtonMode		= 0;
	handles.ExtractBox.x	= [];
	handles.ExtractBox.y	= [];
	handles.ExtractBox.Axis	= [];
	
	guidata(fig, handles);
	
	if nargout > 0
		varargout{1} = fig;
	end
	
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
	
	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end
	
end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.



% --------------------------------------------------------------------
function varargout = binnerMain_CreateFcn(h, eventdata, handles, varargin)
set(gcbo,'IntegerHandle','off');
% S=warning('off');
% movegui(h, 'northwest');
% S=warning(S);

% --------------------------------------------------------------------
function varargout = File_Menu_Callback(h, eventdata, handles, varargin)
if handles.isloaded
	set(handles.Save_MenuItem, 'Enable', 'on');
else
	set(handles.Save_MenuItem, 'Enable', 'off');
end
figure(gcf)

% --------------------------------------------------------------------
function varargout = Load_Callback(h, eventdata, handles, varargin)

try
    [Isig, Tau, Lam, dtau, lam0, dlam, NumD, NumL, Filename] = frogload_all;
catch
    [errmsg, msgid] = lasterr;
    % Exit load function if is didn't work.
	if ~strcmp(msgid, 'frogload:NoSelection')
        errordlg(lasterr, 'Error loading FROG file.', 'modal');
    end
	return
end

% calculating Isig in a uniform wavelength grid
Isig = Isig .* repmat(dist_transform_to_linear(Lam(:)), 1, NumD);

handles.isloaded = true;
handles.FrogData = struct('Isig',{},'Tau',{},'Lam',{},'Binned',{},'Filename',{});

handles = Binner_NewData(handles, Isig, Tau, Lam, false, Filename);

if length(handles.ExtractBox.x) ~= 2
	handles.ExtractBox.x = [min(handles.FrogData(end).Tau(:)), ...
			max(handles.FrogData(end).Tau(:))];
end

if length(handles.ExtractBox.y) ~= 2
	handles.ExtractBox.y = [min(handles.FrogData(end).Lam(:)), ...
			max(handles.FrogData(end).Lam(:))];
end

set(handles.Dtau_Edit, 'String', num2str(mean(diff(handles.FrogData(end).Tau(:)))));
set(handles.Dlam_Edit, 'String', num2str(mean(diff(handles.FrogData(end).Lam(:)))));
set(handles.Lam0_Edit, 'String', num2str(handles.FrogData(end).Lam(floor(end / 2 + 1))));

handles = RedrawTraces(handles);

set(handles.Save_Button, 'Enable', 'on');

guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = UnDo_Button_Callback(h, eventdata, handles, varargin)
handles = Binner_UnDo(handles);

handles = RedrawTraces(handles);

guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = FrogTrace_Axes_ButtonDownFcn(h, eventdata, handles, varargin)
Point1 = get(gca, 'CurrentPoint');
FinalRect = rbbox;
Point2 = get(gca, 'CurrentPoint');

Point1 = Point1(1,1:2);
Point2 = Point2(1,1:2);
p1 = min(Point1,Point2);
offset = abs(Point1-Point2);
handles.ExtractBox.x = [p1(1) p1(1)+offset(1)];
handles.ExtractBox.y = [p1(2) p1(2)+offset(2)];

handles = UpdateExtractBox(handles);

guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function handles = UpdateExtractBox(handles)
if (length(handles.ExtractBox.x) ~= 2) || ...
		(length(handles.ExtractBox.y) ~= 2)
	return;
end

if ~isempty(handles.ExtractBox.Axis)
	if ishandle(handles.ExtractBox.Axis)
		delete(handles.ExtractBox.Axis);
	end
	handles.ExtractBox.Axes = [];
end

[A, Tau, Lam] = Binner_GetCurrData(handles);
A = [];

axes(handles.FrogTrace_Axes)

X = handles.ExtractBox.x;
x = [X(1) X(2) X(2) X(1) X(1)];
Y = handles.ExtractBox.y;
y = [Y(1) Y(1) Y(2) Y(2) Y(1)];

TC = str2double(get(handles.TauCen_Edit, 'String'));
LC = str2double(get(handles.LamCen_Edit, 'String'));

hold on
axis manual
handles.ExtractBox.Axis = plot(x, y, 				'w', ...
	[TC, TC], 				[min(Lam), max(Lam)],	'c', ...
	[min(Tau), max(Tau)],	[LC, LC],				'r', 'LineWidth', 2);
hold off

set(handles.TauLow_Edit, 'String', num2str(handles.ExtractBox.x(1)));
set(handles.TauHigh_Edit, 'String', num2str(handles.ExtractBox.x(2)));

set(handles.LamLow_Edit, 'String', num2str(handles.ExtractBox.y(1)));
set(handles.LamHigh_Edit, 'String', num2str(handles.ExtractBox.y(2)));


% --------------------------------------------------------------------
function handles = RedrawTraces(handles)
if isempty(handles.FrogData)
	return
end

axes(handles.FrogTrace_Axes)

[A, Tau, Lam, Binned] = Binner_GetCurrData(handles);

[AC, Freq] = marginals(A);

X = get(handles.TauCen_Popupmenu, 'Value');
Y = str2double(get(handles.TauCen_Edit, 'String'));
Y = Binner_Center(Tau, AC, X, Y);
set(handles.TauCen_Edit, 'String', num2str(Y));

X = get(handles.LamCen_Popupmenu, 'Value');
Y = str2double(get(handles.LamCen_Edit, 'String'));
Y = Binner_Center(Lam, Freq, X, Y);
set(handles.LamCen_Edit, 'String', num2str(Y));

A	= sqrt(quickscale(nonegatives(A)));     % for drawing only

if Binned
    h=imagesc(Tau, ltof(Lam), A);
else
    h=pcolor(Tau, Lam, A);
    shading flat;
end

axis xy
colormap FrogColorMap(101)
set(handles.FrogTrace_Axes, 'XAxisLocation', 'top');
set(h, 'ButtonDownFcn', 'binner(''FrogTrace_Axes_ButtonDownFcn'',gcbo,[],guidata(gcbo))');
handles = UpdateExtractBox(handles);

AC = quickscale(AC);
Freq = quickscale(Freq);

axes(handles.AutoCorr_Axes);
plot(Tau, AC);
axis tight

Y = str2double(get(handles.TauCen_Edit, 'String'));
hold on
plot([Y, Y],[min(AC), max(AC)],'c');
hold off

axes(handles.FreqMarg_Axes);
plot(Freq, Lam);
axis tight
set(handles.FreqMarg_Axes, 'YAxisLocation', 'right', 'XAxisLocation', 'top');

Y = str2double(get(handles.LamCen_Edit, 'String'));
hold on
plot([min(Freq), max(Freq)],[Y, Y],'r');
hold off

Band = (max(Tau)-min(Tau)) * (max(ltow(Lam)) - min(ltow(Lam)));
set(handles.BinBand_Edit, 'String', num2str(Band));

Binner_CalcGrid(handles);

figure(gcf)

% --- Executes on button press in Save_Button.
function Save_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Save_Callback(hObject, eventdata, handles);


function varargout = Save_Callback(h, eventdata, handles, varargin)

[A, Tau, Lam, Binned, Filename] = Binner_GetCurrData(handles);
if Binned   % save in frequencies
    Lam = ltof(Lam);
end
[pname, fname, ext] = fileparts(Filename);
dtau = incre(Tau);

try
    if Binned
        Filename = fullfile(pname, [fname, '.bin.frg']);
        L0 = Lam(floor(end/2+1));
        dlam = incre(Lam);
        frogsave(A, dtau, L0, dlam, [], [], Filename);
    else
      Filename = fullfile(pname, [fname, '.unbinned.frg']);
      frogsave_all(A, dtau, Lam, [], [], Filename);  
    end
catch
    [errmsg, msgid] = lasterr;
    % Exit load function if is didn't work.
	if ~strcmp(msgid, 'frogsave:NoSelection')
        errordlg(lasterr, 'Error specifying a file to save to.', 'modal');
    end
	return
end

% --------------------------------------------------------------------
function varargout = Quit_Callback(h, eventdata, handles, varargin)
delete(handles.BinnerMain)

% --------------------------------------------------------------------
function varargout = Print_Callback(h, eventdata, handles, varargin)
printdlg(handles.BinnerMain);
figure(gcf)

% --------------------------------------------------------------------
function varargout = Cal_Button_Callback(h, eventdata, handles, varargin)
handles.ButtonMode = 0;
guidata(gcbo, handles);

Set_ToggleButtons(handles)

figure(gcf)

% --------------------------------------------------------------------
function varargout = Extract_Button_Callback(h, eventdata, handles, varargin)
handles.ButtonMode = 1;
guidata(gcbo, handles);

Set_ToggleButtons(handles)

figure(gcf)

% --------------------------------------------------------------------
function varargout = BackSub_Button_Callback(h, eventdata, handles, varargin)
handles.ButtonMode = 2;
guidata(gcbo, handles);

Set_ToggleButtons(handles)

figure(gcf)

% --------------------------------------------------------------------
function varargout = Center_Button_Callback(h, eventdata, handles, varargin)
handles.ButtonMode = 3;
guidata(gcbo, handles);

Set_ToggleButtons(handles)

figure(gcf)

% --------------------------------------------------------------------
function varargout = Filt_Button_Callback(h, eventdata, handles, varargin)
handles.ButtonMode = 4;
guidata(gcbo, handles);

Set_ToggleButtons(handles)

figure(gcf)

% --------------------------------------------------------------------
function varargout = Bin_Button_Callback(h, eventdata, handles, varargin)
handles.ButtonMode = 5;
guidata(gcbo, handles);

Set_ToggleButtons(handles)

figure(gcf)

% --------------------------------------------------------------------
function Set_ToggleButtons(handles)
Buttons = [handles.Cal_Button, handles.Extract_Button, handles.BackSub_Button, ...
		handles.Center_Button, handles.Bin_Button, handles.Filt_Button];
set(Buttons,'Value',0);

CalControls = [handles.Cal_text1, handles.Cal_text2, handles.Cal_text3, handles.Cal_text4, ...
		handles.Cal_text5, handles.Dtau_Edit, handles.Dlam_Edit, handles.Lam0_Edit, ...
		handles.NL_Popupmenu, handles.FrogTyp_Popupmenu];
set(CalControls, 'Visible', 'off');

ExtractControls = [handles.DoExtract_Button, handles.Extract_Text1, handles.Extract_Text2,...
		handles.Extract_Text3, handles.Extract_Text4, handles.TauLow_Edit, ...
		handles.TauHigh_Edit, handles.LamLow_Edit, handles.LamHigh_Edit, ...
		handles.DoErase_Button];
set(ExtractControls, 'Visible', 'off');

BackgroundControls = [handles.BackSub_Text1, handles.BackSub_Text2, handles.SubDelay_Edit,...
		handles.SubDelay_Button, handles.SubFreq_Edit, handles.SubFreq_Button,...
		handles.NoNeg_Button];
set(BackgroundControls, 'Visible', 'off');

CenterControls = [handles.Center_Text, ...
		handles.TauCen_Popupmenu, handles.LamCen_Popupmenu, handles.TauCen_Edit, ...
		handles.LamCen_Edit];
set(CenterControls, 'Visible', 'off');

FiltControls = [handles.Filt_Text, ...
		handles.WidthFilt_Edit, handles.FiltTau_Button, handles.FiltFreq_Button];
set(FiltControls, 'Visible', 'off');

BinControls = [handles.Bin_Text, ...
		handles.BinBand_Edit, handles.AxisFit_Popupmenu, handles.ArraySize_Popupmenu, ...
		handles.DoBin_Button, handles.BinWidth_Edit, handles.TauSpcBin_Edit, ...
		handles.FreqSpcBin_Edit, handles.WaveSpcBin_Edit, handles.SpecEffCorr_Button, ...
        handles.FreqMargCorr_Button];
set(BinControls, 'Visible', 'off');

switch handles.ButtonMode
	case 0
		set(handles.Cal_Button, 'Value', 1);
		set(CalControls, 'Visible', 'on');
	case 1
		set(handles.Extract_Button, 'Value', 1);
		set(ExtractControls, 'Visible', 'on');
	case 2
		set(handles.BackSub_Button, 'Value', 1);
		set(BackgroundControls, 'Visible', 'on');
	case 3
		set(handles.Center_Button, 'Value', 1);
		set(CenterControls, 'Visible', 'on');
	case 4
		set(handles.Filt_Button, 'Value', 1);
		set(FiltControls, 'Visible', 'on');
	case 5
		set(handles.Bin_Button, 'Value', 1);
		set(BinControls, 'Visible', 'on');
end	

% --------------------------------------------------------------------
function varargout = Dtau_Edit_Callback(h, eventdata, handles, varargin)
if isempty(handles.FrogData); return; end

X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	[Isig, tau, lam] = Binner_GetCurrData(handles);
	
	N = length(tau);
	
	tau = (-N/2:N/2-1) * X;
	
	handles = Binner_NewData(handles, Isig, tau, lam);
	handles = RedrawTraces(handles);
	guidata(gcbo, handles);
	figure(gcf)
end

% --------------------------------------------------------------------
function varargout = Dlam_Edit_Callback(h, eventdata, handles, varargin)
if isempty(handles.FrogData); return; end

X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	[Isig, tau, lam] = Binner_GetCurrData(handles);
	
	N = length(lam);
	
	Lam0 = lam(end/2+1);
	
	lam = (-N/2:N/2-1) * X + Lam0;
	
	handles = Binner_NewData(handles, Isig, tau, lam);
	handles = RedrawTraces(handles);
	guidata(gcbo, handles);
	figure(gcf)
end

% --------------------------------------------------------------------
function varargout = Lam0_Edit_Callback(h, eventdata, handles, varargin)
if isempty(handles.FrogData); return; end

X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	[Isig, tau, lam] = Binner_GetCurrData(handles);
	
	N = length(lam);
	
	Lam0 = lam(end/2+1);
	
	lam = lam + X - Lam0;
	
	handles = Binner_NewData(handles, Isig, tau, lam);
	handles = RedrawTraces(handles);
	guidata(gcbo, handles);
	figure(gcf)
end

% --------------------------------------------------------------------
function varargout = NL_Popupmenu_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = FrogTyp_Popupmenu_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = DoExtract_Button_Callback(h, eventdata, handles, varargin)
handles = Binner_ExtractData(handles);
handles = RedrawTraces(handles);

guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = TauLow_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	handles.ExtractBox.x(1) = X;
	handles.ExtractBox.x = sort(handles.ExtractBox.x);
	handles = UpdateExtractBox(handles);
	
	guidata(gcbo, handles);
end

figure(gcf)

% --------------------------------------------------------------------
function varargout = TauHigh_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	handles.ExtractBox.x(2) = X;
	handles.ExtractBox.x = sort(handles.ExtractBox.x);
	handles = UpdateExtractBox(handles);
	
	guidata(gcbo, handles);
end

figure(gcf)

% --------------------------------------------------------------------
function varargout = LamLow_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	handles.ExtractBox.y(1) = X;
	handles.ExtractBox.y = sort(handles.ExtractBox.y);
	handles = UpdateExtractBox(handles);
	
	guidata(gcbo, handles);
end

figure(gcf)

% --------------------------------------------------------------------
function varargout = LamHigh_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	handles.ExtractBox.y(2) = X;
	handles.ExtractBox.y = sort(handles.ExtractBox.y);
	handles = UpdateExtractBox(handles);
	
	guidata(gcbo, handles);
end

figure(gcf)

% --------------------------------------------------------------------
function varargout = BinnerMain_KeyPressFcn(h, eventdata, handles, varargin)
persistent Cntrl
Key = get(gcf, 'CurrentKey');

if any(strcmp(Key, {'control'}))
	Cntrl = Key;
	return;
end

if strcmp(Cntrl, 'control')
	switch Key
		case 'q'
			Quit_Callback(h, eventdata, handles, varargin);
			return
		case 'o'
			Load_Callback(h, eventdata, handles, varargin);
		case 's'
			Save_Callback(h, eventdata, handles, varargin);
	end
end

figure(gcf)

% --------------------------------------------------------------------
function varargout = SubDelay_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	set(h, 'Value', X)
	set(h, 'String', num2str(X))
end

figure(gcf)

% --------------------------------------------------------------------
function varargout = SubDelay_Button_Callback(h, eventdata, handles, varargin)
if isempty(handles.FrogData)
	return
end

X = get(handles.SubDelay_Edit, 'Value');

[Isig, Tau, Lam] = Binner_GetCurrData(handles);

Isig = frogbacksub(Isig, 0, X);

handles = Binner_NewData(handles, Isig, Tau, Lam);

handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = SubFreq_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	set(h, 'Value', X)
	set(h, 'String', num2str(X))
end

figure(gcf)

% --------------------------------------------------------------------
function varargout = SubFreq_Button_Callback(h, eventdata, handles, varargin)
if isempty(handles.FrogData)
	return
end

X = get(handles.SubFreq_Edit, 'Value');

[Isig, Tau, Lam] = Binner_GetCurrData(handles);

Isig = frogbacksub(Isig, X, 0);

handles = Binner_NewData(handles, Isig, Tau, Lam);

handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = NoNeg_Button_Callback(h, eventdata, handles, varargin)
if isempty(handles.FrogData)
	return
end

[Isig, Tau, Lam] = Binner_GetCurrData(handles);

handles = Binner_NewData(handles, nonegatives(Isig), Tau, Lam);

handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = AxisFit_Popupmenu_Callback(h, eventdata, handles, varargin)
Binner_CalcGrid(handles);

guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = BinBand_Edit_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = ArraySize_Popupmenu_Callback(h, eventdata, handles, varargin)
sz = str2double(get(h, 'String'));
sz = sz(get(h, 'Value'));
handles.size = sz;

Binner_CalcGrid(handles);

guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = DoBin_Button_Callback(h, eventdata, handles, varargin)
if isempty(handles.FrogData); return; end

X = get(handles.AxisFit_Popupmenu, 'Value');
Tau_C = str2double(get(handles.TauCen_Edit, 'String'));
Lam_C = str2double(get(handles.LamCen_Edit, 'String'));
Width = str2double(get(handles.BinWidth_Edit, 'String'))/100;

[Tau2, F2] = Binner_CalcGrid(handles);

[Isig, Tau, Lam] = Binner_GetCurrData(handles);

[Isig, Tau, F2] = Binner_GridData(Isig, Tau-Tau_C, Lam, Tau2, F2);

handles = Binner_NewData(handles, Isig, Tau, ftol(F2), true);
set(handles.FreqMargCorr_Button, 'enable', 'on');

handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = TauCen_Popupmenu_Callback(h, eventdata, handles, varargin)
if isempty(handles.FrogData); return; end
handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = LamCen_Popupmenu_Callback(h, eventdata, handles, varargin)
if isempty(handles.FrogData); return; end
handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = TauCen_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	set(h, 'Value', X)
	set(h, 'String', num2str(X))
	set(handles.TauCen_Popupmenu, 'Value', 4);
end

handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = LamCen_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	set(h, 'Value', X)
	set(h, 'String', num2str(X))
	set(handles.LamCen_Popupmenu, 'Value', 4);
end

handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = Export_Button_Callback(h, eventdata, handles, varargin)
if isempty(handles.FrogData); return; end

N = handles.size;

Et = pulsegenerator(N); Et = complex(abs(Et));
[Isig, Tau, Lam] = Binner_GetCurrData(handles);

f2 = Lam;

l2 = ltof(f2);
f1 = f2 - f2(floor(end/2)+1)/2;
l1 = ltof(f1);
w1 = 2 * pi * f1;
w2 = 2 * pi * f2;

assignin('base', 'Et', Et);
assignin('base', 'Asig2', sqrt(nonegatives(Isig)));
assignin('base', 'tau2', Tau);
assignin('base', 'f1', f1);
assignin('base', 'w1', w1);
assignin('base', 'l1', l1);
assignin('base', 'f2', f2);
assignin('base', 'w2', w2);
assignin('base', 'l2', l2);

% --------------------------------------------------------------------
function varargout = DoErase_Button_Callback(h, eventdata, handles, varargin)
handles = Binner_EraseData(handles);
handles = RedrawTraces(handles);

guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = BinWidth_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	set(h, 'Value', X)
	set(h, 'String', num2str(X))
end

handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = WidthFilt_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	set(h, 'Value', X)
	set(h, 'String', num2str(X))
end

guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = TauSpcBin_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	set(h, 'Value', X);
	set(h, 'String', num2str(X));
	Y = get(handles.AxisFit_Popupmenu, 'String');
	Y = strmatch('Fixed Delay', Y);
	set(handles.AxisFit_Popupmenu, 'Value', Y);
end

Binner_CalcGrid(handles);

guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = FreqSpcBin_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	set(h, 'Value', X)
	set(h, 'String', sprintf('%g',X))
	set(handles.WaveSpcBin_Edit, 'String', sprintf('%g',ltof(X)))
	Y = get(handles.AxisFit_Popupmenu, 'String');
	Y = strmatch('Fixed Frequency', Y);
	set(handles.AxisFit_Popupmenu, 'Value', Y);
end

Binner_CalcGrid(handles);

guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = WaveSpcBin_Edit_Callback(h, eventdata, handles, varargin)
X = str2double(get(h,'String'));

if isnan(X)
	errordlg('Entry must be a number.', 'Bad Input', 'modal');
else
	set(h, 'Value', X)
	set(h, 'String', sprintf('%g',X))
	
	[Isig, Tau, Lam] = Binner_GetCurrData(handles);
	
	Lam0 = Lam(floor(end/2+1));
	
	df = (ltof(Lam0-X) - ltof(Lam0+X)) / 2;
	
	set(handles.FreqSpcBin_Edit, 'String', sprintf('%g',df))
	Y = get(handles.AxisFit_Popupmenu, 'String');
	Y = strmatch('Fixed Frequency', Y);
	set(handles.AxisFit_Popupmenu, 'Value', Y);
end

Binner_CalcGrid(handles);

guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = FiltTau_Button_Callback(h, eventdata, handles, varargin)
if isempty(handles.FrogData); return; end

X = str2double(get(handles.WidthFilt_Edit,'String')) / 100;

[Isig, Tau, Lam] = Binner_GetCurrData(handles);

N = size(Isig, 2);
n = floor(N * X / 2);

Isig = fftc(Isig, [], 2);

Isig(:,1:n) = 0;
Isig(:,end-n:end) = 0;

Isig = real(ifftc(Isig, [], 2));

handles = Binner_NewData(handles, Isig, Tau, Lam);

handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)

% --------------------------------------------------------------------
function varargout = FiltFreq_Button_Callback(h, eventdata, handles, varargin)
if isempty(handles.FrogData); return; end

X = str2double(get(handles.WidthFilt_Edit,'String')) / 100;

[Isig, Tau, Lam] = Binner_GetCurrData(handles);

N = size(Isig, 1);
n = floor(N * X / 2);

Isig = fftc(Isig, [], 1);

Isig(1:n,:) = 0;
Isig(end-n:end,:) = 0;

Isig = real(ifftc(Isig, [], 1));

handles = Binner_NewData(handles, Isig, Tau, Lam);

handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)


% --- Executes on button press in SpecEffCorr_Button.
function SpecEffCorr_Button_Callback(hObject, eventdata, handles)

[Isig, tau2, f2] = Binner_GetCurrData(handles);

Isig = ApplySpecEffCorr(Isig, f2 * 2 * pi);

handles = Binner_NewData(handles, Isig, tau2, f2);

handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)


% --------------------------------------------------------------------
function varargout = FreqMargCorr_Button_Callback(h, eventdata, handles, varargin)

[Isig, tau2, f2] = Binner_GetCurrData(handles);

Isig = ApplyFreqMargCorr_SHG(Isig, f2 * 2 * pi);

handles = Binner_NewData(handles, Isig, tau2, f2);

handles = RedrawTraces(handles);
guidata(gcbo, handles);
figure(gcf)


% --------------------------------------------------------------------
function Help_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Help_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to Help_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HelpFile = which('Binner.html');
web(HelpFile);


% --------------------------------------------------------------------
function About_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to About_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg({'Binner Ver 3.0', '(c) 2002-06 Erik Zeek, Xun Gu'}, 'About Binner');


% --------------------------------------------------------------------
function PageSetup_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PageSetup_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pagesetupdlg(handles.BinnerMain);


% --------------------------------------------------------------------
function PrintPreview_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintPreview_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printpreview(handles.BinnerMain);


% --------------------------------------------------------------------
function Save_MenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to Save_MenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Save_Callback(hObject, eventdata, handles)
