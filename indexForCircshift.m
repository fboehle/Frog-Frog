%*********************************************************
%	specific for the frog retrieval
%	
%	Developement started: end 2012
%	Author: Frederik Böhle code@fboehle.de
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

%% create index for the circshift
p = 1:N;
q = 1:N;
[P, Q] = ndgrid(p, q);
Q = Q -1;
k = 1:(N);
K = repmat(k(:), [1 N]);
Q = 1+mod(Q+K, N);
indexforcircshift = sub2ind([N N], P, Q);

p = 1:N;
q = 1:N;
[P, Q] = ndgrid(p, q);
Q = Q -1;
k = 1:(N);
K = -repmat(k(:), [1 N]);
Q = (1+mod(Q+K, N));
indexforcircshiftback = sub2ind([N N], P, Q);