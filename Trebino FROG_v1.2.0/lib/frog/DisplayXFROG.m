function DisplayXFROG(Asig, Esig, Et, Ew, t, w1, w2, k, Klimit, G, Z, ...
	Gbest, Zbest, Gcutoff, Zcutoff, varargin)
%DISPLAYXFROG Display an XFROG trace.

persistent H

displaycutoff = 1e-2;
wht = true;
[displaycutoff, wht] = parsevarargin(varargin, displaycutoff, wht);

[ST,I] = dbstack;

[tmp,Prog] = fileparts(ST(I+1).name);

Ttle = 'FROG Retrieval';

if isempty(H) | ~ishandle(H)
	S = get(0, 'ShowHiddenHandles');
	set(0, 'ShowHiddenHandles', 'on');
	H = findobj('Name', Ttle);
	set(0, 'ShowHiddenHandles', S);

	if isempty(H) | ~ishandle(H)
		H = figure('IntegerHandle', 'off', 'NumberTitle', 'off', 'Name', Ttle);
	end
end

set(H, 'HandleVisibility', 'on', 'PaperPosition', [.25, .25, 8, 10.5]);
set(0, 'CurrentFigure', H);

if k > Klimit
	X = k - Klimit - 1 : k - 1;
else	
	X = 0 : k - 1;
end

% clf
subplot(3,2,1)
plotI_Esig(Asig, w2, t, displaycutoff, wht);
title('Original XFROG Trace')
xlabel('Delay (fs)');
ylabel('Frequency (rad/fs)');
axis xy

subplot(3,2,3)
plotI_Esig(Esig, w2, t, displaycutoff, wht);
title('Retrieved XFROG Trace')
xlabel('Delay (fs)');
ylabel('Frequency (rad/fs)');
axis xy

subplot(3,2,2)
plotcmplxI(t,Et);
title('Retrieved E(t)')
xlabel('Time (fs)');
ylabel('Field (a.u.)');

subplot(3,2,4)
plotcmplxI(ltow(w1),Ew);
title('Retrieved E(\lambda)')
xlabel('Wavelength (nm)');
ylabel('Field (a.u.)');

subplot(3,2,5)
semilogy(X,G(X+1,:))
title(sprintf('G Error, Best = %.3G, Target = %.3G',Gbest,Gcutoff))
xlabel('Iteration');
ylabel('Error');
if size(G,2)>1
	legend(sprintf('G_{min} = %.3G', G(end,1)), sprintf('G_{raw} = %.3G', G(end,2)));
else
	legend(sprintf('G_{min} = %.3G', G(end,1)));
end
axis tight

% subplot(3,2,6);
% semilogy(X,abs(Z(X+1)));
% title(sprintf('Z Error, Best = %.3G, Target = %.3G',Zbest,Zcutoff));
% xlabel('Iteration');
% ylabel('Error');
% legend(sprintf('Z = %.3G', Z(end)));
% axis tight;
% 
% drawnow;

set(H, 'HandleVisibility', 'off');
