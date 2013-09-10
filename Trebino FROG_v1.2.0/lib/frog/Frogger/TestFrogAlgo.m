function TestFrogAlgo( varargin )
%TESTFROGALGO Summary of this function goes here
%  Detailed explanation goes here

%	$Id: TestFrogAlgo.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

[ algo ] = parsevarargin(varargin, 'ShgAlgo');

X = feval(algo);

disp(FrogTypeName(X))
disp(NonLinName(X))
disp(DomainName(X))
disp(AlgoName(X))

[Et, t, Ew, w1] = PulseGenerator(256, @fgaussian, 20, 2, 800, [], [], [0, 0, 50, -200]);

figure(1)
plotpulse(Et,t,w1)

Esig = CalcEsig(Et,Et);

Esig = fft_FROG(Esig);

Asig = abs(Esig);

figure(2)
imagesc(Asig)

X.Asig = Asig;
X.tau = t;
X.w2 = w1+w1(end/2+1);

[Et, t, Ew, w1] = PulseGenerator(256, @frand, 40, 2, 800, [], [], [0, 0, 100, -400]);

X.Et = Et;
X.t = t;
X.w1 = w1;

figure(3)
plotpulse(X.Et,X.t,X.w1)
drawnow

for k = 1:200
	X = RunAlgo(X);
	
	if ~rem(k,10)
		figure(3)
		plotpulse(X.Et,X.t,X.w1)
		
		figure(4)
		imagesc(X.tau, X.w2, abs(X.Esig))
		
		figure(5)
		semilogy((0:length(X.G)-1)',[X.G.',X.Z.'])
		
		drawnow
	end
end

beep

function plotpulse(Et, t, w)

subplot 211
plotcmplx(t,Et)

subplot 212
plotcmplx(w,fftc(Et))
