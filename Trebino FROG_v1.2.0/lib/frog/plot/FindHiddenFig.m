function H = FindHiddenFig(Prop, Val)
%FINDHIDDENFIG finds a hidden figure.
%	H = FINDHIDDENFIG(PROP, VAL) returns the handle of a figure with a
%	given PROP VAL pair.

S = get(0, 'ShowHiddenHandles');
set(0, 'ShowHiddenHandles', 'on');
H = findobj(Prop, Val);
set(0, 'ShowHiddenHandles', S);
