% Update: v 1.2 
* Issue: 'frogger' and 'binner' are found to be incompatible with new version of MATLAB. The latest tested version of MATLAB is 2008a and new version: 2010b and 2012a are found incompatible. This update resolves compatibility issues on 64 bit Windows 2012a, 2011b, 64 bit Linux 2010b and 64 bit Mac 2009b. Other versions are not tested. 
* There are some requests for an introduction on how to use binner and frogger, here is one. I have included the raw and binned test trace of SHG FROG for demonstration, located in ./example. The raw trace is stored in test_original.frg and the binned traces are in folder bin128 and bin256 which are binned at different size. The retrieval result are also included in the folder. 

* How to use 'binner'
1)	To use 'binner', you need to have your raw FROG trace ready. Binner takes the raw file, .frg, with one line of header information contain: the central wavelength, number of pixels in temporal domain and spectral domain, and calibration factors in temporal and spectral domain. Followed by the header, is the raw data from your camera in matrix form. By default, the arrangement of the matrix should be x-dimension represent time, y-dimension represent wavelength. Here is the file structure of the '.frg' file. 

=== file structure of .frg ===
width(temporal domain) of FROG trace in pixel \t 
height(spectral domain) of FROG trace in pixel \t 
temporal_calibration (fs/px) \t
spectral_calibration (nm/px) \t
central_wavelength (nm) \t\n
FROG_TRACE_RAW_DATA
=== EOF ===

Example 
=== xxx.frg ===
512	512	20.54542	9.506378e-05	0.3747406
[512 x 512] matrix
=== EOF === 

2) Run binner in MATLAB by typing >> binner;  A GUI should come out, open the .frg file you prepared. A pop-up will appear and ask "Delay" or "Wave" is the first axis, if you prepare the file according to step 1), you should choose "Wave". Make sure the FROG trace displayed looks reasonable. Extraction, Background Subtraction, Centering and Filtering can be performed using different tabs. 

3) Binning tab
	3.1) Array Size: Depending on the complexity of the pulse, an appropiate size should be chosen. For pulses with short temporal range and narrow spectral bandwidth, a smaller size can be used. Since the Fourier transform relation has to be satisfied, the temporal range is proportional to the spectral resolution and the spectral range is proportional to the temporal resolution. 
	3.2) Binned Width (%): The program allow users to pad zeros or remove empty space of the traces to increase or decrease of the resolution and range. For example, binned width of 50% means fill the binned trace with 50% of the raw trace and pad the rest with zeros. 
	3.3) Axis Fit: Use along with Binned Width, fit delay means using the temporal domain to consider the binned width. 
	3.4) Spec. Eff. Corr. and Freq. Marginal. Corr.: If a wide range of spectrum is presented in the trace, the response of the grating, camera and lens could play a part to the intensity. These two functions allow users to correct for the response of the optics component. 
	3.5) Bin Data: Once everything is set, click this button to bin the trace. The binned trace will be displayed and if anything goes wrong, click the 'Undo' button to restore. A good binned trace should have energy in most of the area. 

4) After binning the trace, save the binned trace. The program should automatically change the file to xxx.bin.frg. 

* How to use 'frogger'
1) Make sure you have a binned trace. You can use the 'binner' GUI or command version of binner, 'binner_cmd'
2) Run in MATLAB >> frogger;   A GUI should come out, open the binned trace you prepared (should have extension .bin.frg if prepared by binner). A pop-up will appear and ask "Delay" or "Wave" is the first axis, if you prepare the file using GUI 'binner', you should choose "Delay". 
3) Choose the 'Nonlinearity' according to your experimental setup. The current version of frogger provides 'SHG', 'PG' and 'THG'.
4) Click 'Run' button'. The program should start running, stop when the desired error is reached. You can save the retrieved E-field in temporal and spectral domain and also the measured and retrieved trace using 'save' function. The saved files have the following structure: 

=== file structure of Ek.dat and Speck.dat ===
x=1\t Intensity\t Phase\t Real()\t Imaginary()\t\n
:
:
:
x=N\t Intensity\t Phase\t Real()\t Imaginary()\t\n
=== EOF ===
where x:= time in Ek.dat and x:= lambda in Speck.dat

5) To use XFROG, switch the type to XFROG. Click 'Extra Information' to choose the gate pulse. You can choose from computer generated function like sech and Gaussin or read the gate from a file. Check 'use file' inside 'extra information' to use a measured gate pulse. If you use frogger to retrieve the gate pulse, choose the file contains the temporal E-field, which by default is Ek.dat. If you obtain the gate pulse from other sources, construct a file where the first column is the x-axis and the 4th and 5th columns are the real and imaginary part of the temporal E-field. 


% Update: v 1.1
* Issue: MagRepl.cpp is found to be incompatible with the standard gcc library in 64 bit Linux and 64 bit Mac. 64 bit Window user with MS Visual Studio express installed is not affected. MagRepl.m is included in the package to resolve this issue. Other OS are not tested, but similar issues are expected with gcc installed as the compiler. 
* batch_mex.m is included for batch compiling the cpp to MEX. For other OS users (32bit OS and OS not listed above), please modify the batch_mex.m accordingly to run the batch operation.
* If compiling the MEX files is an issue, pre-complied MEX library package (64bit Linux, 64bit Mac, and 32bit, 64bit Window only) are uploaded separately. Please download the package according to your OS. Due to security issues, the packages are compressed in .7z using freeware called 7-zip. Comman softwares like 7Zip or Winrar can be used to extract files. Winrar can be downloaded from here: http://www.win-rar.com/download.html
* Add in more test case (4 and 5) in SHG FROG. 

% v 1.0
 Thanks for being interested in our works. Here is a general guideline for using and installing our FROG code. The lib folder include all the utility files you will need to run the code properly. The implementation of the core of FROG code is in C++ which allows faster run time. In order to use it, complie the files into MEX is neccessary. Here is a guideline you can follow if you need help on it. 

1) Set path: set the downloaded folder with sub-folders included into the Matlab pathdef.m in order to use the files

2) MEX Library: Download a pre-complied MEX library package according to your OS or follow the instruction below to compile. All the source are written in C++ and tested under Window environment. Pre-complied MEX library package available for download includes 64bit Linux, 64bit Mac, and 32bit, 64bit Window. For other OS user, please compile your own MEX file. 
	2.1) Setup MEX: run mex -setup, follow the instruction for a complier. If complier is already installed, Matlab should be able to locate it and use it. Otherwise, follow the instruction from Matlab to download and install a compatible complier. Details can be found here http://www.mathworks.com/support/compilers/R2011a/win64.html or similar link according to Matlab and OS version. 
	2.2) Complie: once the MEX is setup correctly, complie the MEX file. For example, compile CalcEsig.cpp by using the command >> mex CalcEsig.cpp. Please be aware that different OS and Matlab version gives different file extension, and MEX file compile in Mac is not compatible with the one compiled in Linux nor Window.  Copy the complied mex file to a folder which is under the Matlab path. Make sure the path contain all the mex files is at the highest priority since helper file with the same filename but with extension .m will also present. 
	2.3) Batch compile: batch_mex.m is include in the source directory (/lib/Mexlib/src). Simply run it to compile all the cpp file to generate all the MEX file needed.  
	
	* Issue is found in MagRepl.cpp with standard gcc library in Linux and Mac. If you are using some other C compilers, please be aware that similar kind of issues may also occur. 
	
3) Trial run: run /Test_QuickFROG.m to make sure everything is working. Three sets of pulse are stored inside the test run file. 
Run: 
Test_QuickFROG(128,4,1,2)
Test_QuickFROG(128,4,1,3)
Test_QuickFROG(128,4,1,4)
Test_QuickFROG(128,4,1,5)

for additional testing. If encounter error in running the test file, please make sure all the files are inside Matlab path and MEX files are properly complied. 

4) Customize: To work with different system at your own lab, you will have to customize the FROG code according to your needs. Test_QuickFROG.m is a good start. In general, there are some important parameters you will have to know before running the algorithm. 
	4.1) Calibration: This is important. It defines your resolution and range of your experimental setup. Everyone FROG system needs a correct calibration to function properly.
	4.2) Bin size: binning is a process to make sure the signal recorded by your apparatus follows the Fourier transformer relation, i.e. the resolution and range relationship between time and frequency domain. For example, your spectrometer has a high resolution, which means you will need a long temporal range to support this resolution. In fact, this high resolution in spectral domain may not be necessary. Binning allows you to choose a suitable setting between the resolution and range such that essential details in the FROG trace are recorded while keeping the trace size small. Typical bin size are 128, 256, or 512 (2^N will work) depending your needs.
	4.3) Core FROG Algorithm: different geometry: PG, SHG, TG, SFG, require differenet nonlinear-optical constraint. And therefore, please make sure you are using the correct constraint when you run the algorithm. 
	
Example: PG_XFROG

5) Automation: Working with loads of data could be time consuming. With the correct parameters in your hand, the FROG code could be customized to automate the retrevial process. 
	5.0) PG_XFROG_auto.m. Run this file to automatically load the saved raw data and run the retrieval algorithm. The flow of the file is explained as follow. 
	5.1) calibrate.m. This is used to generate the .frg file. The calibration number inside this file, should be changed according to your system. The file load the trace saved in .mat and save it into a .frg file.
	5.2) binner_cmd.m. This is used to bin the trace according to your specification. 
	5.3) PG_XFROG.m. In this example, PG XFROG is used. Please modify the retrieval part according to your own system. The code automatically read the gate pulse from file, and use it to retrieve. After retrieval, figures are plotted and output are saved as "output.mat". G error and TBP are also calculated and printed out in the command prompt. 
	
To run this example, change your directory to "demo", and then run >> PG_XFROG_auto. This will automatically start data loading, calibration, binning, and retrieving the pulse. In this example, X120522_1 contain raw data from camera with background noise. Two set of background is recorded by blocking each arm (I am doing XFROG). A simple Gaussian pulse is measured. The G error is about 0.9% and TBP is around 13.5. This not the best data set, but just a set of data in my current experimental setup (not a standard PG XFROG setup, but essentially doing the same thing) taken for this demonstration. Nevertheless, this is a good demonstration of how the code can be automated to take the raw camera data as input and output the retrieved intensity and phase. The retrieval time is about 50 seconds on my computer (Intel Pentium D 3.0GHz with 4GB memory on Win7 + Matlab 2011). It is a 5-6 years old computer and definitely not a fast one. I am sure with a faster computer, the retrieval time could be a lot faster. And, the grid size I am using is large because the TBP is high. Another parameter that can be tuned is the number of iteration, here it is 200, but as you can see the G error does not go down after 100 iterations. An adaptive algorithm can be made so that the retreival will be terminated automatically. By optimizing your experimental setup so that the trace fills up more of your camera, you can decrease the grid size and make it even faster. In fact, a commerical GRENOUILLE and FROG program can retrieve pulses in real time with refresh rate of 5-10fps. 

In general, to make a good measurement you will have to make sure the following, 
1) Place the FROG trace completely inside your camera for a single shot measurement (move your delay line to ensure you cover the ensure pulse for multi-shot measurement), no cropping should occur
2) Obtain a good calibration number 
3) Optimize grid size so that you have a good range and resolution
4) Optimize the number of iteration 
6) Check to see if the retrieved trace match the measured one
5) A typical good measurement has G error less than 1%

If you happen to have only a few pulses to retrieve, we also built GUIs to bin and retrieve the trace for you. Simply call "binner" to bin the trace and "frogger" to run the retrieval algorithm. 

Hope this package can make your life in graduate school easier. You can find out more in our website, http://frog.gatech.edu/
Enjoy. 
	
If you have any question, please contact 
Jeff Wong at jeff.wong@gatech.edu or 
Prof. Trebino at rick.trebino@physics.gatech.edu. 

--
Tsz Chun "Jeff" Wong
UltraFast Optics Lab
Georgia Institute of Technology
837 State Street
Atlanta, GA 30332
USA

Last modified: 2012-05-25 12:38 v 1.0
Last modified: 2012-06-13 01:04 v 1.1
Last modified: 2013-04-24 12:55 v 1.2