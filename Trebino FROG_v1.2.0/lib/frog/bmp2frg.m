function [] = bmp2frg(dt,dlam,lo,trace)

%this will load a FROG trace which is a BMP and then save it as a ASCII
%with the correct header to use binner run the program like this: 
%bmp2frg(dt,dlam,lo) where dx is the frequency calibration in nm, dt is the 
%time calibration in fw and lo is the center wavelength in nm.
%If you are using the GREN 8-50 the calibration is delam = 0.0575nm and 
%dt= 2.8625fs. An optional 4th argument can be the FROG trace if you have
%it in the workspace. The trace should be orientiented so that delay is the 
%horizontal axis and wavelength is the vertical axis

if nargin==3
    [trace,path] = traceload;
    [PATHSTR,NAME,EXT,VERSN] = fileparts(path);
else
    NAME = 'trace';
end

m = size(trace);
header = [m(2);m(1);dt;dlam;lo];
save([NAME '.frg'],'header','-ASCII')
save([NAME '.frg'],'trace','-APPEND','-ASCII')
display(['saving the frog trace as ' [NAME '.frg']  ])