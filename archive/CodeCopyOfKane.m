clear all

f = 10^(-15);
n = 10^(-9);
c = 300000000;

N = 256;
dt = 300/N*f;
t = (-(N)/2:(N)/2-1)*dt;
dtau = dt;
tau = t;
dw = 1/(dt*N);
w = (-N/2:N/2-1) * dw;


tw = 10*f; %half width
omega0 = 0 * 2 * pi * c /(2800 * n); %central wavelength
A0 = 1; %peak amplitude
a = 2; %chirp parameter
a2 = 1;
a3 = 1;
phi = 0 + 0 * t/tw + a * t.^2/tw.^2 + a2 * t.^3/tw.^3 + a3 * t.^4/tw.^4; %phase
A = A0 * exp(-t.^2/(tw.^2)) .* exp( i * phi ); %complex amplitude
E = A .* exp(i * omega0 * t); %electromagnetic field

V = fftshift(fft(ifftshift(E)));
lambda = c ./ w;
lambdastep = (lambda(1)-lambda(2))/n


figure(1);
plot( t, abs(E), t, angle(A) .* min(round(abs(A/A0) .* 10), 1))
figure(2);
plotyy(w, abs(V), w, angle(V) )

Esig = E.' * E;
%Esig=Esig-tril(Esig,-ceil(N/2))-triu(Esig,ceil(N/2));

for i = 1:N
    Esig(i,:) = circshift(Esig(i,:), [0 -i+1]);
end

Esig = fliplr(fftshift(Esig,2));

IFrogwphase = fftshift(fft(Esig,[],1),1);
IFrog = abs(IFrogwphase).^2;

figure(4);
imagesc(tau,w,IFrog)
title('Original Frog')
colormap(jet(256));


figure(3);
imagesc(tau, t, abs(Esig))
title('Esig')
colormap(jet(256));


spectrogram = IFrog;
iterations = 100;
gpulse = random('Poisson',50,1,N) + i*random('Poisson',50,1,N);
ggate = random('Poisson',50,1,N) + i*random('Poisson',50,1,N);

% function [gpulse, ggate] = ispecshg(spectrogram,
% gpulse, ggate,iterations)
% ispecshg inverts a spectrogram using the fast
% version. It assumes SHG FROG.
%
% Principal Component Generalized Projections
% (PCGPA). The
% input parameters are:
% spectrogram The spectrogram to be inverted
%
% gpulse Vector containing the initial guess
% for the pulse
%
% ggate Vector containing the initial guess
% for the gate
%
% iterations Number of iterations
%
% The function returns as soon as the number of
% iterations has been completed.
%
% Make the check for iterations
%
% Initializations
halfN = N/2;
efrog = zeros(N, N);
% efrog = N X N matrix filled with zeros
temp= zeros(N, N) ; % temporary matrix
%
%End Initializations
%
for x = 1:1:iterations
    % Because the transpose of a complex quantity
    %involves a complex conjugate,
    % gpulse = conjugate(ggate) for SHG FROG.
    efrog = gpulse.' * ggate +  ggate.' * gpulse; % ' means
    % transpose.
    % Convert from outer product to frog domain
    %First, rotate each row to the left by it 1 s
    % row number minus 1
    %First index is the row number, second is
    %the column
    for j = 2:1:N
        temp(j,1:j-1) = efrog(j,1:j-1);
        % save the left-most part
        efrog(j,1:N + 1- j) = efrog(j,j:N);
        % shift the vector
        efrog(j, N + 2 - j: N) = temp(j, 1: j - 1);
        % place the left-most part on the right
    end
    %switch left and right halves, ":" is an implied "for" loop
    temp(:,1:halfN) = efrog(: ,1:halfN);
    efrog(: , 1: halfN) = efrog(: , halfN + 1: N) ;
    efrog(: , halfN + 1:N) =temp(: , 1:halfN);
    % Now efrog is in the time domain
    % Perform "FFT Shift" on each column
    temp(1: halfN,:) = efrog(1:halfN,:);
    efrog(1:halfN,:) = efrog(halfN + 1: N,:);
    efrog(halfN+1:N,:) =temp(1:halfN,:);
    % FFT columns (MATLAB is column major,
    % C is row major)
    efrog = fft( efrog);
    %Perform "FFT Shift" on each column
    temp( 1: halfN, :) = efrog( 1: halfN, : );
    efrog(1:halfN, :) = efrog(halfN + 1: N, : );
    efrog(halfN + 1: N,:) = temp(1: halfN,: );
    
    
    figure(5)
    imagesc(abs(efrog).^2)
    title('efrog')
    colormap(jet(256));
    %This loop is slow running under MATLAB, for
    % faster running under
    % MATLAB , vectorize.
    for j = 1:1:N
        for k= 1:1:N
            temps= abs( efrog(j , k));
            if temps ~= 0
                efrog(j , k) = sqrt(spectrogram(j, k)) * (efrog(j , k)/temps);
            else
                efrog(j , k) = sqrt(spectrogram(j, k)) ;
            end
        end
    end
    % Column "FFT Shift" again
    temp( 1: halfN,:) = efrog(1:halfN,:);
    efrog( 1: halfN,:) = efrog(halfN+1: N,:);
    efrog (halfN + 1: N, :) =temp(1:halfN,:);
    % IFFT columns
    efrog = ifft(efrog);
    % "FFT Shift"
    temp( 1: halfN, : ) = efrog( 1: halfN, : ) ;
    efrog( 1: halfN,: ) = efrog(halfN + 1: N, : );
    efrog(halfN + 1: N, :) = temp(1: halfN, : );
    % Convert from the frog time domain to the
    % outer product

    temp(: , 1:halfN) = efrog(: , 1:halfN);
    efrog(: , 1: halfN) = efrog(: , halfN + 1: N) ;
    efrog(: , halfN + 1: N) =temp(:, 1: halfN);
    for j = 2: 1: N
        temp(j, N + 2 - j: N) = efrog(j, N + 2 - j: N) ;
        efrog(j, j: N) = efrog(j , 1: N + 1- j) ;
        efrog(j , 1: j - 1) = temp(j , N + 2- j: N) ;
    end
    % Now the frog trace is in the outer product
    % domain
    % Find the next estimate for the pulse and gate


    gpulse = ( (efrog *  efrog') * gpulse')' ;
    ggate = ( (efrog' *  efrog) * ggate')';

    % Normalize gpulse and ggate so the peak
    % height is one
    gpulse = gpulse/max(abs(gpulse));
    ggate = ggate/max(abs(ggate));
    
    figure(6);
    plot( t, abs(gpulse), t, unwrap(angle(gpulse) .* min(round(abs(gpulse/max(abs(gpulse))) .* 10), 1)))
    
end


