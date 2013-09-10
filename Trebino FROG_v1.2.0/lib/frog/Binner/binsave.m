%  This program saves the output from the binner in the .frg format along with headers.
%   Only before you bin the data

A=Asig2.^2;
DT=mean(diff(tau2));
L0=l2(end/2+1);
DL=mean(diff(l2));
FROGSAVE(A,DT,L0,DL);
