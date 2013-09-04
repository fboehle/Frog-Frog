clear all

f = 10^(-15);
n = 10^(-9);
c = 300000000;

N = 1024;
dt = 100/N*f;
t = (-(N)/2:(N)/2-1)*dt;

tau = 5*f; %half width
omega0 = 0*2 * pi * c /(800 * n); %central wavelength
A0 = 1; %peak amplitude
a = 1; %chirp parameter
a2 = 3;
a3 = 0;
phi = 0 + 0 * t/tau + a * t.^2/tau.^2 + a2 * t.^3/tau.^3 + a3 * t.^4/tau.^4; %phase
A = A0 * exp(-t.^2/(tau.^2)) .* exp( i * phi ); %comples amplitude
E = A .* exp(i * omega0 * t); %electromagnetic field

V = ifftshift(fft(fftshift(E)));
frequency = (-length(E)/2:length(E)/2-1)  /  dt / length(E);
lambda = c ./ frequency;


figure(1);
plot(t, real(E), t, abs(E), t, angle(A) .* min(round(abs(A/A0) .* 10), 1))
figure(2);
plotyy(frequency, abs(V), frequency, angle(V) )

Esig = E.' * E;
%Esig=Esig-tril(Esig,-ceil(N/2))-triu(Esig,ceil(N/2));
tic

p = 1:N;
q = 1:N;
[P, Q] = ndgrid(p, q);
Q = Q -1;
k = 0:(N-1);
K = repmat(k(:), [1 N]);
Q = 1+mod(Q+K, N);
indexforcircshift = sub2ind([N N], P, Q);
tic
Esig = Esig(indexforcircshift);
toc
Esig = fliplr(fftshift(Esig,2));

figure(4);
imagesc(abs(Esig))



