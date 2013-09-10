function DisplayFROG(Asig, Esig, Et, Ew, t, w, k, Klimit, G, Z, ...
	Gbest, Zbest, Gcutoff, Zcutoff)
%DISPLAYFROG Display a FROG trace.

persistent H

[ST,I] = dbstack;

[tmp,Prog] = fileparts(ST(I+1).name);

Ttle = 'FROG Retrieval';

if isempty(H) || ~ishandle(H)
	S = get(0, 'ShowHiddenHandles');
	set(0, 'ShowHiddenHandles', 'on');
	H = findobj('Name', Ttle);
	set(0, 'ShowHiddenHandles', S);

	if isempty(H) || ~ishandle(H)
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
imagesc(t,w+w(end/2+1),Asig);
title('Original FROG Trace')
colormap FrogColorMap(101)
% colorbar
xlabel('Delay (fs)');
ylabel('Frequency (rad/fs)');
axis xy

subplot(3,2,3)
imagesc(t,w+w(end/2+1),abs(Esig));
title('Retrieved FROG Trace')
% colorbar
xlabel('Delay (fs)');
ylabel('Frequency (rad/fs)');
axis xy

subplot(3,2,2)
plotcmplx(t,Et);
title('Retrieved E(t)')
xlabel('Time (fs)');
ylabel('Field (a.u.)');

subplot(3,2,4)
plotcmplx(ltow(w),Ew);
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

subplot(3,2,6)
semilogy(X,Z(X+1))
title(sprintf('Z Error, Best = %.3G, Target = %.3G',Zbest,Zcutoff))
xlabel('Iteration');
ylabel('Error');
legend(sprintf('Z = %.3G', Z(end)));
axis tight

drawnow

set(H, 'HandleVisibility', 'off');
