function gvm = gvm(wavelength, varargin)

%   GVM returns the group velocity mismatch for a material
%	GVEL(WAVELENGTH, MATERIAL, ANG, POLARIZATION, WAVELENGTH UNIT) returns 
%   the group velocity dispersion of a MATERIAL.
%
%   unit of group velocity mismatch is Fs/cm
%   WAVELENGTH UNIT defaults  to 'nm'. ANGLE unit defaults to 'rad'
%
error(nargchk(1,5,nargin))

material = 'BBO';
ang = [];
polarization = 'O';
u = 'nm';

[material, ang, polarization, u] = parsevarargin(varargin,material, ang, polarization, u);

if isempty(ang)
    ang = shang(wavelength,material);
end
    vf=gvel(wavelength, material,ang, 'O');
    vh=gvel(wavelength/2, material, ang,'E');
    gvm=abs(1./vh - 1./vf);