constants; %load physical, mathematical and numerical constants
setup; %initilized values
indexForCircshift; 

fftw('Planner', 'patient');

myfigure('Frog Retrieval');
	colormap([0 0 0.0;0 0 0.53125;0 0 0.546875;0 0 0.5625;0 0 0.578125;0 0 0.59375;0 0 0.609375;0 0 0.625;0 0 0.640625;0 0 0.65625;0 0 0.671875;0 0 0.6875;0 0 0.703125;0 0 0.71875;0 0 0.734375;0 0 0.75;0 0 0.765625;0 0 0.78125;0 0 0.796875;0 0 0.8125;0 0 0.828125;0 0 0.84375;0 0 0.859375;0 0 0.875;0 0 0.890625;0 0 0.90625;0 0 0.921875;0 0 0.9375;0 0 0.953125;0 0 0.96875;0 0 0.984375;0 0 1;0 0.015625 1;0 0.03125 1;0 0.046875 1;0 0.0625 1;0 0.078125 1;0 0.09375 1;0 0.109375 1;0 0.125 1;0 0.140625 1;0 0.15625 1;0 0.171875 1;0 0.1875 1;0 0.203125 1;0 0.21875 1;0 0.234375 1;0 0.25 1;0 0.265625 1;0 0.28125 1;0 0.296875 1;0 0.3125 1;0 0.328125 1;0 0.34375 1;0 0.359375 1;0 0.375 1;0 0.390625 1;0 0.40625 1;0 0.421875 1;0 0.4375 1;0 0.453125 1;0 0.46875 1;0 0.484375 1;0 0.5 1;0 0.515625 1;0 0.53125 1;0 0.546875 1;0 0.5625 1;0 0.578125 1;0 0.59375 1;0 0.609375 1;0 0.625 1;0 0.640625 1;0 0.65625 1;0 0.671875 1;0 0.6875 1;0 0.703125 1;0 0.71875 1;0 0.734375 1;0 0.75 1;0 0.765625 1;0 0.78125 1;0 0.796875 1;0 0.8125 1;0 0.828125 1;0 0.84375 1;0 0.859375 1;0 0.875 1;0 0.890625 1;0 0.90625 1;0 0.921875 1;0 0.9375 1;0 0.953125 1;0 0.96875 1;0 0.984375 1;0 1 1;0.015625 1 0.984375;0.03125 1 0.96875;0.046875 1 0.953125;0.0625 1 0.9375;0.078125 1 0.921875;0.09375 1 0.90625;0.109375 1 0.890625;0.125 1 0.875;0.140625 1 0.859375;0.15625 1 0.84375;0.171875 1 0.828125;0.1875 1 0.8125;0.203125 1 0.796875;0.21875 1 0.78125;0.234375 1 0.765625;0.25 1 0.75;0.265625 1 0.734375;0.28125 1 0.71875;0.296875 1 0.703125;0.3125 1 0.6875;0.328125 1 0.671875;0.34375 1 0.65625;0.359375 1 0.640625;0.375 1 0.625;0.390625 1 0.609375;0.40625 1 0.59375;0.421875 1 0.578125;0.4375 1 0.5625;0.453125 1 0.546875;0.46875 1 0.53125;0.484375 1 0.515625;0.5 1 0.5;0.515625 1 0.484375;0.53125 1 0.46875;0.546875 1 0.453125;0.5625 1 0.4375;0.578125 1 0.421875;0.59375 1 0.40625;0.609375 1 0.390625;0.625 1 0.375;0.640625 1 0.359375;0.65625 1 0.34375;0.671875 1 0.328125;0.6875 1 0.3125;0.703125 1 0.296875;0.71875 1 0.28125;0.734375 1 0.265625;0.75 1 0.25;0.765625 1 0.234375;0.78125 1 0.21875;0.796875 1 0.203125;0.8125 1 0.1875;0.828125 1 0.171875;0.84375 1 0.15625;0.859375 1 0.140625;0.875 1 0.125;0.890625 1 0.109375;0.90625 1 0.09375;0.921875 1 0.078125;0.9375 1 0.0625;0.953125 1 0.046875;0.96875 1 0.03125;0.984375 1 0.015625;1 1 0;1 0.984375 0;1 0.96875 0;1 0.953125 0;1 0.9375 0;1 0.921875 0;1 0.90625 0;1 0.890625 0;1 0.875 0;1 0.859375 0;1 0.84375 0;1 0.828125 0;1 0.8125 0;1 0.796875 0;1 0.78125 0;1 0.765625 0;1 0.75 0;1 0.734375 0;1 0.71875 0;1 0.703125 0;1 0.6875 0;1 0.671875 0;1 0.65625 0;1 0.640625 0;1 0.625 0;1 0.609375 0;1 0.59375 0;1 0.578125 0;1 0.5625 0;1 0.546875 0;1 0.53125 0;1 0.515625 0;1 0.5 0;1 0.484375 0;1 0.46875 0;1 0.453125 0;1 0.4375 0;1 0.421875 0;1 0.40625 0;1 0.390625 0;1 0.375 0;1 0.359375 0;1 0.34375 0;1 0.328125 0;1 0.3125 0;1 0.296875 0;1 0.28125 0;1 0.265625 0;1 0.25 0;1 0.234375 0;1 0.21875 0;1 0.203125 0;1 0.1875 0;1 0.171875 0;1 0.15625 0;1 0.140625 0;1 0.125 0;1 0.109375 0;1 0.09375 0;1 0.078125 0;1 0.0625 0;1 0.046875 0;1 0.03125 0;1 0.015625 0;1 0 0;0.984375 0 0;0.96875 0 0;0.953125 0 0;0.9375 0 0;0.921875 0 0;0.90625 0 0;0.890625 0 0;0.875 0 0;0.859375 0 0;0.84375 0 0;0.828125 0 0;0.8125 0 0;0.796875 0 0;0.78125 0 0;0.765625 0 0;0.75 0 0;0.734375 0 0;0.71875 0 0;0.703125 0 0;0.6875 0 0;0.671875 0 0;0.65625 0 0;0.640625 0 0;0.625 0 0;0.609375 0 0;0.59375 0 0;0.578125 0 0;0.5625 0 0;0.546875 0 0;0.53125 0 0;0.515625 0 0;0.972549021244049 0.972549021244049 0.972549021244049]);
	ax(1) = subplot(2,2,1);
		originalTracePlot = imagesc(tau, frequency,zeros(N,N), [0 1]);
        title('original Frogtrace');
    ax(2) = subplot(2,2,2);
		retrievedTracePlot = imagesc(tau, frequency,zeros(N,N), [0 1]);
        title('retrieved Frogtrace');
    linkaxes(ax);
    subplot(2,2,3);
		[temporalPlot, temporalPlot1, temporalPlot2] = plotyy(t, zeros(N), t, zeros(N));
		xlabel('Time') 
        xlim([t(1) t(N)]);
        ylim(temporalPlot(1),[-0.1 1.1]);
        ylim(temporalPlot(2),[-3.5 3.5]);
		%hold(temporalPlot(1), 'on')
		hold(temporalPlot(2), 'on')
		temporalPlot3 = plot(t, ones(N)*50, 'r', 'Parent', temporalPlot(2));
        set(temporalPlot1,'Color','blue','LineWidth',2)
		set(temporalPlot2,'Color',[0 0.498 0],'LineWidth',2)
		set(temporalPlot3,'Color','red','LineWidth',1)
        title('retrieved temporal shape');
    subplot(2,2,4);
		[spectralPlot, spectralPlot1, spectralPlot2] = plotyy(frequency, zeros(N), frequency, zeros(N));
		xlabel('Frequency') 
        xlim([frequency(1) frequency(N)]);
        ylim(spectralPlot(1),[-0.1 1.1]);
        ylim(spectralPlot(2),[-3.5 3.5]);
		%hold(spectralPlot(1), 'on') %slows drawnow significantly down
		hold(spectralPlot(2), 'on')
		spectralPlot3 = plot(frequency, ones(N)*50, 'r', 'Parent', spectralPlot(2));
        set(spectralPlot1,'Color','blue','LineWidth',2)
		set(spectralPlot2,'Color',[0 0.498 0],'LineWidth',2)
		set(spectralPlot3,'Color','red','LineWidth',1)
        title('retrieved spectral shape');
       
%frogtraceMarginalDelay = sum
%frogtraceMarginalLambda = sum
    
    
pixelAvg = 1; %sum(sum(frogtrace))/(1376*1035);

%% Do things in advance for manipulation of original Frogtrace

dimensionL = 1376;
dimensionT = 1035;

pixell = 1:dimensionL;
pixelt = 1:dimensionT;

%calibrate camera

load('Calibrations/20131122.mat');

% lambdalines = [302,313,365,405,436] * n;
% lambdapixel = [256,361,693,945,1143];
% delayfromposition = (-[37.1,59.2,57.1,51.6,48.1,43.0,40.1,37.5,47.6]) * u * 2 / c; 
% delaypixel = [713,224,269,394,470,581,646,703,483];
% not the above lines are in the calibration file

tauRange = tau(N) - tau(1);
frequencyRange = frequency(N) - frequency(1);

% create filter matrix
noiseReduction = 1.1;
fftFrog_Delay = 1 / ccd_delayRange * (-dimensionT/2:dimensionT/2-1);
fftFrog_Frequency = 1 / ccd_frequencyRange * (-dimensionL/2:dimensionL/2-1);%this is only an approximation as the frog trace is still in the wavelength domain
NyquistDelay = N / delayRange / 2;
NyquistFrequency = N / frequencyRange / 2; 
[fftFrog_DelayMesh,fftFrog_FrequencyMesh] = meshgrid(fftFrog_Delay,fftFrog_Frequency); 

%simple low pass filter with sharp cuttof
%filterMatrix = ( (fftFrog_DelayMesh/NyquistDelay).^2 + (fftFrog_FrequencyMesh/NyquistFrequency).^2 <= 1/noiseReduction^2);

%use a nth-order butterworth filter, with the Nyquist as cutoff
butterworthOrder = 3; %too low is not good, as it would 
filterMatrixNormalizedRadius =  sqrt(noiseReduction) * sqrt(( (fftFrog_DelayMesh/NyquistDelay).^2 + (fftFrog_FrequencyMesh/NyquistFrequency).^2)) ;
filterMatrix = sqrt(1./ (1 + (filterMatrixNormalizedRadius).^(2 * butterworthOrder)));

%% Do things in advance for retrieval
iterations = 100;

%% create an Efiel from noise for EfieldOld

Efield = random('Poisson',50,1,N) + 1i*random('Poisson',50,1,N);
Efield = Efield/max(Efield);

%% that's it for now