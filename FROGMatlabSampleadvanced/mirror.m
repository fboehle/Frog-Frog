function I2 = mirror()
%Prompts for a picture, then mirrors the bottom half to the top half or
%vice-versa. I2 is the final result. In SHG-FROG, the image is
%theoretically symmetric, but in practice sometimes one half is partly
%cropped off, or noisy, or corrupted in some other way. Therefore you may
%want to make one half the exact mirror image of the other half. With a
%good FROG trace, both halves contain good data and you should NOT do this!

%This specific program assumes the vertical axis is delay and horizontal is
%frequency, so the top and bottom should be the same.

%%%SET THESE OPTIONS MANUALLY BEFORE RUNNING
aboveorbelow=2; %1 for copying above to below; 2 for copying below to above.
imageorplot=1; %Two ways to choose the center of the image: Option 1 for clicking in the center of an image, option 2 for typing the row number based on a graph.

%When you run the program multiple times, it should start in the previous
%directory you used. A variable 'lastdirectory' is written in the base
%workspace memory to store that information.
if evalin('base','exist(''lastdirectory'')')
	defaultpath = evalin('base','lastdirectory');
	[filename1,pathname1] = uigetfile({'*.bmp;*.gif;*.jpg';'*.*'},'Pick files...',defaultpath);
else
	[filename1,pathname1] = uigetfile({'*.bmp;*.gif;*.jpg';'*.*'});
end

if pathname1 == 0 %if the dialog box was cancelled...
	I2=[];
	return;
end

assignin('base','lastdirectory',pathname1); %save as new default directory for next time.

disp(['mirroring: ' pathname1 filename1]);
I1 = double(imread([pathname1 filename1]));
[I1numrows,I1numcols,I1pxdata]=size(I1);
if(I1pxdata==1) % if image has just one piece of data instead of 3 (grayvalue instead of RGB), copy it three times to make it RGB, because MATLAB can't display the gravalue bmps.
	I1 = cat(3,I1,I1,I1);
	I1pxdata=3;
end
I2numcols=I1numcols;
I2pxdata=I1pxdata;

if(imageorplot==1)
	figure
	image(I1/255);
	axis image;
	[x,y]=ginput(1);
	disp(['You picked: ' num2str(y)]);
	y=round(y);
end

if(imageorplot==2)
	myguess=find(sum(I1(:,:,1),2)==max(sum(I1(:,:,1),2))); %In theory, the center is where the row-sum attains its maximum value. So that's the initial guess.
	myguess=round(mean(myguess)); %in case there's a tie
	disp(['Guess: ' num2str(myguess)]);
	bot=max([myguess-120 1]); %bottom row displayed
	top=min([myguess+120 I1numrows]); %top row displayed
	figure
	rowsums=sum(I1(bot:top,:,1),2)';
	if(0) %Method A: Plot the row-sums. Should be a symmetric peak, and you select the center.
		plot(bot:top , rowsums/max(rowsums))
	end
	if(1) %Method B: Plot a higher fourier component of each row. This can be a more complex pattern, so you can select the center more reliably.
		fouriercomp=10; %pick an integer larger than 1. Use trial-and-error to find the number that makes it easiest to select the center.
		rowffts=fft(I1(bot:top,:,1),[],2);
		plotthis=abs(rowffts(:,fouriercomp)')./rowsums; %normalize by rowsums gives more reliable center if there are intensity variations across the image.
		plot(bot:top , plotthis/max(plotthis) , bot:top , rowsums/max(rowsums))
	end
	grid on
	y=input('Where is center? ');
end

if(aboveorbelow==1) %copy above (lower indices) to below (higher indices)
	I1=I1(1:y,:,:);
	I2numrows = 2*y;
	I2=zeros(I2numrows,I2numcols,I2pxdata);
	I2(1:y,:,:)=I1;
	I1=flipdim(I1,1);
	I2(y+1:2*y,:,:)=I1;
else %copy below (higher indices) to above (lower indices)
	I1=I1(y:end,:,:);
	I2numrows=2*size(I1,1);
	I2=zeros(I2numrows,I2numcols,I2pxdata);
	I2(I2numrows/2+1:end,:,:)=I1;	
	I1=flipdim(I1,1);
	I2(1:I2numrows/2,:,:)=I1;
end
	
figure
image(I2/255);
return;