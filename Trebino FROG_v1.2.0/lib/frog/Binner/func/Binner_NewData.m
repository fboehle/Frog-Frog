function handles = Binner_NewData(handles, Isig, Tau, Lam, Binned, Filename)

error(nargchk(4,6,nargin));

if nargin < 5
	Binned = handles.FrogData(end).Binned;
end

if nargin < 6
	Filename = handles.FrogData(end).Filename;
end

X.Isig		= Isig;
X.Tau		= Tau;
X.Lam		= Lam;
X.Binned	= Binned;
X.Filename  = Filename;

handles.FrogData(end+1) = X;

if length(handles.FrogData) > 1
	set(handles.UnDo_Button, 'Enable', 'on');
end
