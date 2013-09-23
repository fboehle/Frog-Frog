%*********************************************************
%	Implementation to reshape a frogtrace for the commercial Frog Software 
%	
%	Developement started:
%	Author:
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

clear all
tic
A=imread('afterXPW_2.bmp') - 16; % read the original image from the FROG camera
A=double(A); %convert to uint8 to double

%% shearing of the figure
[m,n]=size(A); %read the dimension of the image
x=1:n; %create an array x with numbers until the x dimension
y=1:m;
alpha=0; %angle, the figure needs to be sheared
if alpha~=0 %if alpha is not equal to 0 run the bracket
    [XI,YI]=meshgrid(x,y);
    tmp=YI;
    YI=cos(alpha)*YI+alpha*XI;
    XI=cos(alpha)*XI-alpha*YI;
    Ymax=max(max(y));
    Ymin=min(min(y));
    Xmax=max(max(x));
    Xmin=min(min(x));
    for i=1:m
        for j=1:n
            if YI(i,j)>Ymax
                YI(i,j)=YI(i,j)-(Ymax-Ymin);
            end
            if YI(i,j)<Ymin
                YI(i,j)=YI(i,j)+(Ymax-Ymin);
            end
            if XI(i,j)>Xmax
                XI(i,j)=XI(i,j)-(Xmax-Xmin);
            end
            if XI(i,j)<Xmin
                XI(i,j)=XI(i,j)+(Xmax-Xmin);
            end
        end
    end
    A=interp2(x,y,A,XI,YI);
end

tpx=0.209; %time per pixel in fs
[lamdapoints,tpoints]=size(A); %create another array with the same dimension as the FROG input image
head=[tpoints,lamdapoints,2,0.25,400]; %store some values there. What are those values?
CCDpixel=[1,354,530,825,1016,1130,1376]; %this is probably for the calubration of the wavelength
%CCDpixel=[1,393,566,946,1134,1246,1376];
lamplines=[280,302,313,365,404,436,473]; %dito
%lamplines=[280,312,323,375,414,446,473];
pixel=1:1:1376;
lamda=interp1(CCDpixel,lamplines,pixel); %gives each pixel an interpolated value of lamba from the calibration
time=1:1:1035; %time will not be calibrated?
[X,Y] = meshgrid(lamda,time);
lamdanew=280:0.1:473;  %5fs
%lamdanew=375:0.03:435;  %20fs
%lamdanew=340:0.1:450;  %15fs
timenew=1:1:1035;
[WAVELENGTH,TIME]=meshgrid(lamdanew,timenew);
Frogtrace=interp2(X,Y,A,WAVELENGTH,TIME); % interpolate the original Frogtrace on the new grid with specified ranges
lo=(280+473)/2; %what is this for, the value equals to the middle of the lamplines
%lo=(375+435)/2;
%lo=lamdanew((2120+1520)/2);
%Frogtrace=Frogtrace(:,1520:2120);
%Timedownsampling=2;    %5fs
%Timedownsampling=12;    %20fs
%Timedownsampling=10;    %15fs
Timedownsampling=5;    %myvalue
Frogtrace=downsample(Frogtrace,Timedownsampling);
Frogtrace=Frogtrace'; %complex conjugate transpose; though just transpose .' would have been the same
Frogtrace=downsample(Frogtrace,1); %because the downsample function always usues the first dimension
Frogtrace=Frogtrace'; %and everything back to normal
[w,xr]=size(Frogtrace);Headnew=[w,xr,tpx*Timedownsampling,0.1,lo]; %5fs
%[w,xr]=size(Frogtrace);Headnew=[w,xr,tpx*Timedownsampling,0.03,lo]; %20fs

Headnew(1)=floor(Headnew(1)); %rounds to the next smaller integer
Headnew(2)=floor(Headnew(2));
%Frogtrace=Frogtrace.*(ones(518,1)*lamdanew.^(-2));  %SHG calibration
Nonsymetr=Frogtrace;
Centraltimeline=round(500/Timedownsampling); %centre trace frog
for t=8:Centraltimeline-1,
    Frogtrace(t,:)=(Frogtrace(t,:)+Frogtrace(2*Centraltimeline-t,:))/2;
    Frogtrace(2*Centraltimeline-t,:)=Frogtrace(t,:);
end
figure(2)
subplot(3,1,1); imagesc(A);
subplot(3,1,2); imagesc(lamdanew,time,Nonsymetr);
subplot(3,1,3); imagesc(lamdanew,time,Frogtrace);

% time=-517:517;
% time=time*tpx;
% figure(1)
% imagesc(lamdanew*2,time,Frogtrace)
% Frogtrace=Frogtrace-sum(sum(Frogtrace(:,1:5)))/10350*2;
% figure(7)
% plot(time,Frogtrace(:,741)/max(Frogtrace(:,741)))
% hold on
% plot(time,Frogtrace(:,991)/max(Frogtrace(:,991)),'r')
% plot(time,Frogtrace(:,1241)/max(Frogtrace(:,1241)),'g')
% plot(time,Frogtrace(:,1491)/max(Frogtrace(:,1491)),'k')

%Frogtrace=fliplr(Frogtrace);
Frogtrace=Frogtrace(:);         %transform to vector
Frogtrace=Frogtrace';
toc

dlmwrite('CCDtoFROGinFiber.out', Headnew, ' ');
save CCDtoFROGinFiber.out Frogtrace -ASCII -append;  %problem : two first numbers have to be integers