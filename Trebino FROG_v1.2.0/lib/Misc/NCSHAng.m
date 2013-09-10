function ang = NCSHAng(lf, fi, mat)
%   NCSHAng calculates the phase matching angle for -non collinear- 
%   single shot SHG FROG geometries.
%	NCSHAng(LF,fi,MAT) calculates the phasematching angle given
%	the fundamental wavelength LF, the beam crossing half angle in degrees 
%   (outside of nonlinear medium), and the material. The output angle is in
%   degrees.




error(nargchk(3,3,nargin));

fi_rad = degtorad(fi);

lh = lf ./ 2;

n1o = refindex(lf,mat,'O');
n2o = refindex(lh,mat,'O');
n2e = refindex(lh,mat,'E');

fi_in_rad = asin ( ( sin(fi_rad) / n1o ) );


x = ( (n1o * cos (fi_in_rad) ).^-2 - n2o.^-2)./(n2e.^-2 - n2o.^-2);

ang = radtodeg ( asin(sqrt(x)) );