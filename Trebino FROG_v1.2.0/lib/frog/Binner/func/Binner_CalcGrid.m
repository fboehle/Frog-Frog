function [tau2, f2] = Binner_CalcGrid(handles)

error(nargchk(1,1,nargin))

if isempty(handles.FrogData); return; end

Fit = get(handles.AxisFit_Popupmenu, 'String');
Fit = Fit{get(handles.AxisFit_Popupmenu, 'Value')};
Tau_C = str2double(get(handles.TauCen_Edit, 'String'));
Lam_C = str2double(get(handles.LamCen_Edit, 'String'));
Width = str2double(get(handles.BinWidth_Edit, 'String'))/100;
sz = handles.size;
dtau = str2double(get(handles.TauSpcBin_Edit, 'String'));
df = str2double(get(handles.FreqSpcBin_Edit, 'String'));

[Isig, tau, lam] = Binner_GetCurrData(handles);

f = ltof(lam);

tau = tau - Tau_C;

f0 = ltof(Lam_C);

switch Fit
case 'None'
	dtau = mean(diff(tau)) / Width;
	tau2 = (-sz/2:sz/2-1) * dtau;
	
	df = 1 / sz / dtau;
	f2 = (-sz/2:sz/2-1) * df + f0;
case 'Fit Delay'
	dtau = 2 * max(abs([min(tau), max(tau)])) / sz / Width;
	tau2 = (-sz/2:sz/2-1) * dtau;
	
	df = 1 / sz / dtau;
	f2 = (-sz/2:sz/2-1) * df + f0;
case 'Fit Wavelengths'
	df = (max(f) - min(f)) / sz / Width;
	f2 = (-sz/2:sz/2-1) * df + f0;
	
	dtau = 1 / sz / df;
	tau2 = (-sz/2:sz/2-1) * dtau;
case 'Fixed Delay'
	tau2 = (-sz/2:sz/2-1) * dtau;
	
	df = 1 / sz / dtau;
	f2 = (-sz/2:sz/2-1) * df + f0;
case 'Fixed Frequency'
	f2 = (-sz/2:sz/2-1) * df + f0;
	
	dtau = 1 / sz / df;
	tau2 = (-sz/2:sz/2-1) * dtau;
otherwise
	error('Unknown axis fit method.');
end

f2 = f2';

set(handles.TauSpcBin_Edit, 'String', sprintf('%g',dtau));
set(handles.FreqSpcBin_Edit, 'String', sprintf('%g',df));

dlam = (ltof(f0-df) - ltof(f0+df)) / 2;
set(handles.WaveSpcBin_Edit, 'String', sprintf('%g',dlam));
