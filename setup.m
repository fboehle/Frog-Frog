%*********************************************************
%	Setup parameters for the frogtrace 
%	
%	Developement started: end 2012
%	Author: Frederik B�hle code@fboehle.de
%
%*********************************************************
%   
%   Description: 
%
%   Notes:
%
%   Changelog:
%
%*********************************************************


N = 256;
NRange = (-(N)/2:(N)/2-1);
N0 = N/2 + 1;
delayRange = 500e-15;
dt = delayRange/N;
t = NRange*dt;
dtau = delayRange/N;
tau = NRange*dtau;
dfrequency = 1/(dt*N);
frequency = NRange * dfrequency;
frequencyRange = N / delayRange;
dOmega = dfrequency * 2 * pi;
omega = frequency * 2 * pi;
omegaRange = frequencyRange * 2 * pi;

mycolormap = [0 0 0.515625;0 0 0.53125;0 0 0.546875;0 0 0.5625;0 0 0.578125;0 0 0.59375;0 0 0.609375;0 0 0.625;0 0 0.640625;0 0 0.65625;0 0 0.671875;0 0 0.6875;0 0 0.703125;0 0 0.71875;0 0 0.734375;0 0 0.75;0 0 0.765625;0 0 0.78125;0 0 0.796875;0 0 0.8125;0 0 0.828125;0 0 0.84375;0 0 0.859375;0 0 0.875;0 0 0.890625;0 0 0.90625;0 0 0.921875;0 0 0.9375;0 0 0.953125;0 0 0.96875;0 0 0.984375;0 0 1;0 0.015625 1;0 0.03125 1;0 0.046875 1;0 0.0625 1;0 0.078125 1;0 0.09375 1;0 0.109375 1;0 0.125 1;0 0.140625 1;0 0.15625 1;0 0.171875 1;0 0.1875 1;0 0.203125 1;0 0.21875 1;0 0.234375 1;0 0.25 1;0 0.265625 1;0 0.28125 1;0 0.296875 1;0 0.3125 1;0 0.328125 1;0 0.34375 1;0 0.359375 1;0 0.375 1;0 0.390625 1;0 0.40625 1;0 0.421875 1;0 0.4375 1;0 0.453125 1;0 0.46875 1;0 0.484375 1;0 0.5 1;0 0.515625 1;0 0.53125 1;0 0.546875 1;0 0.5625 1;0 0.578125 1;0 0.59375 1;0 0.609375 1;0 0.625 1;0 0.640625 1;0 0.65625 1;0 0.671875 1;0 0.6875 1;0 0.703125 1;0 0.71875 1;0 0.734375 1;0 0.75 1;0 0.765625 1;0 0.78125 1;0 0.796875 1;0 0.8125 1;0 0.828125 1;0 0.84375 1;0 0.859375 1;0 0.875 1;0 0.890625 1;0 0.90625 1;0 0.921875 1;0 0.9375 1;0 0.953125 1;0 0.96875 1;0 0.984375 1;0 1 1;0.015625 1 0.984375;0.03125 1 0.96875;0.046875 1 0.953125;0.0625 1 0.9375;0.078125 1 0.921875;0.09375 1 0.90625;0.109375 1 0.890625;0.125 1 0.875;0.140625 1 0.859375;0.15625 1 0.84375;0.171875 1 0.828125;0.1875 1 0.8125;0.203125 1 0.796875;0.21875 1 0.78125;0.234375 1 0.765625;0.25 1 0.75;0.265625 1 0.734375;0.28125 1 0.71875;0.296875 1 0.703125;0.3125 1 0.6875;0.328125 1 0.671875;0.34375 1 0.65625;0.359375 1 0.640625;0.375 1 0.625;0.390625 1 0.609375;0.40625 1 0.59375;0.421875 1 0.578125;0.4375 1 0.5625;0.453125 1 0.546875;0.46875 1 0.53125;0.484375 1 0.515625;0.5 1 0.5;0.515625 1 0.484375;0.53125 1 0.46875;0.546875 1 0.453125;0.5625 1 0.4375;0.578125 1 0.421875;0.59375 1 0.40625;0.609375 1 0.390625;0.625 1 0.375;0.640625 1 0.359375;0.65625 1 0.34375;0.671875 1 0.328125;0.6875 1 0.3125;0.703125 1 0.296875;0.71875 1 0.28125;0.734375 1 0.265625;0.75 1 0.25;0.765625 1 0.234375;0.78125 1 0.21875;0.796875 1 0.203125;0.8125 1 0.1875;0.828125 1 0.171875;0.84375 1 0.15625;0.859375 1 0.140625;0.875 1 0.125;0.890625 1 0.109375;0.90625 1 0.09375;0.921875 1 0.078125;0.9375 1 0.0625;0.953125 1 0.046875;0.96875 1 0.03125;0.984375 1 0.015625;1 1 0;1 0.984375 0;1 0.96875 0;1 0.953125 0;1 0.9375 0;1 0.921875 0;1 0.90625 0;1 0.890625 0;1 0.875 0;1 0.859375 0;1 0.84375 0;1 0.828125 0;1 0.8125 0;1 0.796875 0;1 0.78125 0;1 0.765625 0;1 0.75 0;1 0.734375 0;1 0.71875 0;1 0.703125 0;1 0.6875 0;1 0.671875 0;1 0.65625 0;1 0.640625 0;1 0.625 0;1 0.609375 0;1 0.59375 0;1 0.578125 0;1 0.5625 0;1 0.546875 0;1 0.53125 0;1 0.515625 0;1 0.5 0;1 0.484375 0;1 0.46875 0;1 0.453125 0;1 0.4375 0;1 0.421875 0;1 0.40625 0;1 0.390625 0;1 0.375 0;1 0.359375 0;1 0.34375 0;1 0.328125 0;1 0.3125 0;1 0.296875 0;1 0.28125 0;1 0.265625 0;1 0.25 0;1 0.234375 0;1 0.21875 0;1 0.203125 0;1 0.1875 0;1 0.171875 0;1 0.15625 0;1 0.140625 0;1 0.125 0;1 0.109375 0;1 0.09375 0;1 0.078125 0;1 0.0625 0;1 0.046875 0;1 0.03125 0;1 0.015625 0;1 0 0;0.984375 0 0;0.96875 0 0;0.953125 0 0;0.9375 0 0;0.921875 0 0;0.90625 0 0;0.890625 0 0;0.875 0 0;0.859375 0 0;0.84375 0 0;0.828125 0 0;0.8125 0 0;0.796875 0 0;0.78125 0 0;0.765625 0 0;0.75 0 0;0.734375 0 0;0.71875 0 0;0.703125 0 0;0.6875 0 0;0.671875 0 0;0.65625 0 0;0.640625 0 0;0.625 0 0;0.609375 0 0;0.59375 0 0;0.578125 0 0;0.5625 0 0;0.546875 0 0;0.53125 0 0;0.515625 0 0;0.972549021244049 0.972549021244049 0.972549021244049];
