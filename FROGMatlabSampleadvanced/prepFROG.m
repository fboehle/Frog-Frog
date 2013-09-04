function [fnlimg fnldt] = prepFROG(ccddt, ccddv,N,StartImgOrPrompt,showprogress, showautocor, flip)
%prepFROG: Cleans, smooths, and downsamples data in preparation for running
%the FROG algorithm on it.
%
%Usage:
%
%	fnlimg=prepFROG(N,StartImgOrPrompt,showprogress, showautocor)
%
%		fnlimg	=	"final image", an NxN matrix of nonnegative intensity
%					values, ready to be fed into FROG algorithm.
%		N		=	See above. A power of 2 is wise for faster FFTs. Not
%					*necessary*, of course, but wise. Default=128.
%		fnldt	=	"final dt per pixel", i.e. the difference in delay
%					between consecutive pixels of fnlimg. (The difference
%					in frequency between consecutive pixels is then
%					determined by the FFT relation, dt*dv=1/N.) Expressed
%					in the same units as ccddt.
%		StartImgOrPrompt = 0 to prompt for a BMP image file from disk, or a
%					matrix if the file is already in MATLAB. Default = 0.
%		ccddt = Difference in delay between consecutive pixels of
%					the starting image.
%		ccddv = Difference in frequency between consecutive pixels
%					of the starting image. Should be expressed in whatever
%					units are inverse to ccddt. For example, if ccddt is in
%					picoseconds, ccddv must be in terahertz.
%		showprogress = 1 to display partially-processed and
%					fully-processed images, 0 to not show it. Default=0
%		showautocor = 1 to graph the SHG autocorrelation (row-sums from
%					SHG-FROG trace), 0 to not show it. Default=0
%		flip	=	0 if the delay axis is horizontal, frequency axis
%					vertical, for a left-right-symmetric SHG-FROG image,
%					and the rows are going from low frequency to high.
%					That's what we want. Set flip=1 to switch rows and
%					columns, flip=2 to switch high and low freq, flip=3 for
%					both. Default=0.



%Plan: First, read in a BMP representing the CCD image, then
%filter it to remove noise and  background, then downsample to get from the
%original CCD image (which might be 1000x1000 pixels) to the image we can
%use in the FROG algorithm (which might be 128x128 pixels).

if(~exist('N','var') || isempty(N))
	N=128;
end
if(~exist('StartImgOrPrompt','var') || isempty(StartImgOrPrompt))
	StartImgOrPrompt=0;
end
if(~exist('showprogress','var') || isempty(showprogress))
	showprogress=0;
end
if(~exist('showautocor','var') || isempty(showautocor))
	showautocor=0;
end
if(~exist('flip','var') || isempty(flip))
	flip=0;
end

if isequal(StartImgOrPrompt,0)
	%When you run the program multiple times, dialog box should start in the previous
	%directory you used. A variable 'lastdirectory' is written in the base
	%workspace memory to store that information.
	if evalin('base','exist(''lastdirectory'')')
		defaultpath = evalin('base','lastdirectory');
		[filename1,pathname1] = uigetfile({'*.bmp;*.gif;*.jpg';'*.*'},'Pick file...',defaultpath);
	else
		[filename1,pathname1] = uigetfile({'*.bmp;*.gif;*.jpg';'*.*'});
	end

	if pathname1 == 0 %if the dialog box was cancelled...
		fnlimg=[];
		return;
	end

	assignin('base','lastdirectory',pathname1); %save as new default directory for next time.
	ccdimg = imread([pathname1 filename1]);
	%ccdimg is the raw image, presumably from a CCD camera.
else
	ccdimg = StartImgOrPrompt;
end

%For image uploads you can get a 3D array, x*y*3 entries, representing R
%and G and B. Since it should be grayscale, just take 1 color. Also,
%convert number type to "double" (BMP uploads into uint8).
ccdimg = double(ccdimg(:,:,1));

%ccddtdv = ccddt * ccddv, with units of "cycles
%per horizontal-pixel per vertical-pixel". This product ccddtdv is an
%important parameter for the FROG algorithm, but ccddt and ccddv are NOT
%themselves important. They are only used for graph labels.
ccddtdv = ccddt * ccddv;

%Choose correct image orientation.
if(flip==1 || flip==3)
	ccdimg = ccdimg';
end
if(flip==2 || flip==3)
	ccdimg = flipud(ccdimg);
end

%My CCD images have black bars around the outside for some reason!! Delete
%them here. Assume that if the color is exactly constant, it's a frame.
for ii=1:2  %Repeating twice helps when side bars and top bar are different colors.
	while std(ccdimg(:,1))==0
		ccdimg(:,1)=[];
	end
	while std(ccdimg(:,end))==0
		ccdimg(:,end)=[];
	end
	while std(ccdimg(1,:))==0
		ccdimg(1,:)=[];
	end
	while std(ccdimg(end,:))==0
		ccdimg(end,:)=[];
	end
end

%Find the approximate center of the spot, by calculating an average
%coordinate weighted by row-sums or column-sums.
ccdsize=size(ccdimg); %ccdsize(1) is how many rows, (2) is how many cols
colsums = sum(ccdimg);
centercol = ((1:ccdsize(2)) * colsums') / sum(colsums);
rowsums = sum(ccdimg,2);
centerrow = ((1:ccdsize(1)) * rowsums) / sum(rowsums);

%Find the (very) approximate width of the spot in each dimension
spotwidth = 2*sum(abs((1:ccdsize(2))-centercol) * colsums') / sum(colsums);
spotheight = 2*sum(abs((1:ccdsize(1))-centerrow) * rowsums) / sum(rowsums);

%large "aspectratio" means vertical-stripe original image. Can also input
%this or modify it by hand depending on what works best. This is relevant
%because the final image will scale the dimensions to make the final image
%aspect ratio roughly 1. (This helps accuracy).
aspectratio=spotheight/spotwidth; 

%vpxpersample and tpxpersample are the separation between consecutive "samples" to be
%fed into the FROG algorithm. There are N*N=N^2 "samples" total, each is a
%pixel taken from the CCD image. They satisfy these two equations:
%(A): vpxpersample / tpxpersample = aspectratio (this helps accuracy)
%(B): (vpxpersample * ccddv) * (tpxpersample * ccddt) = 1/N (this is FFT requirement)

vpxpersample = sqrt((1/(N*ccddtdv))*aspectratio);
tpxpersample = sqrt((1/(N*ccddtdv))/aspectratio);
if(showprogress)
	disp(['Vertical pixels per freq (v) sample: ' num2str(vpxpersample)]);
	disp(['Horizontal pixels per delay (t) sample: ' num2str(tpxpersample)]);
end

%For me these are around 5 pixels.


%%%%%%%%%%%%%%%%% IMAGE FILTERING %%%%%%%%%%%%%%%%%%%%%
if(showprogress)
	figure
	subplot(2,2,1)
	imagesc(ccdimg);
	title('(1) Original');
end
%%%% LOW-PASS FOURIER FILTERING %%%%
%See Taft and DeLong, chapter 10 in FROG textbook
rho=0.3; %lower rho means more extreme filtering. Make sure image looks OK.
ccdimgfft=fftshift(fft2(ccdimg));
tophatfilter=zeros(ccdsize);
for ii=1:ccdsize(1)
	for jj=1:ccdsize(2)
		if(((ii-ccdsize(1)/2)^2+(jj-ccdsize(2)/2)^2)^(1/2)<max(ccdsize)*rho)
			tophatfilter(ii,jj)=1;
		end
	end
end
ccdimgfft=tophatfilter .* ccdimgfft;
ccdimg=abs(ifft2(ifftshift(ccdimgfft)));
if(showprogress)
	subplot(2,2,2)
	imagesc(ccdimg);
	title('(2) After Fourier filter')
end
%%%% BACKGROUND SUBTRACTION %%%%
%The lowest-average-intensity 8x8 block of pixels is assumed to be the
%background and is subtracted off
imgblocks=zeros(ccdsize);
for ii=1:8
	for jj=1:8
		imgblocks = imgblocks + circshift(ccdimg, [ii jj]);
	end
end
background=min(min(imgblocks))/(8*8);
ccdimg=ccdimg-background;
ccdimg(ccdimg<0)=0; %negative values are set to zero
if(showprogress)
	subplot(2,2,3)
	imagesc(ccdimg);
	title('(3) After background subtraction');
end

%%%% DOWNSAMPLING TO NxN %%%%
%Want an NxN pixel image to process. Go through each pixel of the original,
%and have it contribute to the nearest pixel of the final (in an average).
if(isequal(size(ccdimg),[N N]) && ccddt * ccddv == 1/N)
	fnlimg = ccdimg; %skip downsampling if ccdimg is already sampled correctly.
	fnldt = ccddt;
else
	fnlimg=zeros(N);
	fnlimgcount=zeros(N); %how many times you've added onto that pixel
	for ii=1:ccdsize(1) %which row? (which freq?)
		rowinfinal = round(N/2+(ii-centerrow)/vpxpersample);
		if(rowinfinal<1 || rowinfinal > N)
			continue;
		end
		for jj=1:ccdsize(2)
			colinfinal = round(N/2+(jj-centercol)/tpxpersample);
			if(colinfinal<1 ||  colinfinal > N)
				continue;
			end
			fnlimgcount(rowinfinal,colinfinal) = fnlimgcount(rowinfinal,colinfinal)+1;
			fnlimg(rowinfinal,colinfinal)= fnlimg(rowinfinal,colinfinal) + ccdimg(ii,jj);
		end
	end
	fnlimgcount(fnlimgcount==0)=1; %avoid dividing by zero. Pixels that haven't been written into should be set to zero, and they are.
	fnlimg = fnlimg./fnlimgcount;
	fnldt = ccddt * tpxpersample;
end
	
if(showprogress)
	subplot(2,2,4)
	imagesc(fnlimg);
	title(['(4) After downsampling to ' num2str(N) 'x' num2str(N)]);
end

if(showautocor)
	figure
	plot((-(ccdsize(2)-1)/2*ccddt : ccddt : (ccdsize(2)-1)/2*ccddt),sum(ccdimg))
	title('Autocorrelation')
	xlabel('Delay')
	ylim([0 1.05*max(sum(ccdimg))])
end

return;