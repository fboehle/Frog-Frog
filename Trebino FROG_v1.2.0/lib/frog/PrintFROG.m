function PrintFROG(k , G, Z, Gcutoff, Zcutoff, T)
%PRINTFROG Display FROG info on commandline.
T = T/k;

if k>1
	disp(sprintf(' k = %5d, T = %5.3fs, G = %.3E, dG = %+.3E, Z = %.3E, dZ = %+.3E, Exit = %.3E',...
		k,T,G(end,1),G(end,1)-G(end-1,1),Z(end),Z(end)-Z(end-1),G(end,1)-Gcutoff));
else
	disp(sprintf(' k = %5d, T = %5.3fs, G = %.3E, dG = %+.3E, Z = %.3E, dZ = %+.3E, Exit = %.3E',...
		k,T,G(end,1),0,Z(end),0,G(end,1)-Gcutoff));
end
