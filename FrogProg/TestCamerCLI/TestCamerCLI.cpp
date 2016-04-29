/*********************************************************
*	Main Application 
*	
*	12-2012
*	Frederik Böhle code@fboehle.de
**********************************************************
*
*
*
*
*********************************************************/

#include "stdafx.h"		//I think nothing is allowed to be included before this
#include "TestCameraCLI.h"
#include "imageprocessing.h"
#include "cameracontrol.h"
#include "utilities.h"

#pragma comment( lib, "Libmx.lib"    )
#pragma comment( lib, "libmex.lib"   )
#pragma comment( lib, "libeng.lib"    )



int _tmain(int argc, _TCHAR* argv[])
{
	int autolog = 0;
	enum modes {raw, retrieval} runMode;

try{	


	cameracontrol myCamera;
	imageprocessing liveView(&myCamera, "rawFrogtraceCreate", "rawFrogtraceUpdate", "rawFrogtraceDelete");
	imageprocessing retrievalView(&myCamera, "retrieveFrogtraceCreate", "retrieveFrogtraceUpdate", "retrieveFrogtraceDelete");
	myCamera.setActive();


	std::cout << "Please press:\nS: Save Next Image\nQ: Quit program\nL: Switch to live view of raw image\nF: Switch to frog retrieval mode\n";

	int saveNextImage = 0;
	int keepRunning = 1;
	runMode = raw;
	while(keepRunning){

		if(!_kbhit()){
			if(myCamera.updateAvailable()){

				switch(runMode){
				case raw:
					liveView.loadNewImage();
					liveView.updateMatlab();
					break;
				case retrieval:
					std::cout << "Starting retrieval ... ";
					retrievalView.loadNewImage();
					retrievalView.updateMatlab();
					std::cout << "Retrieval done!\n";
					break;
				}

				if(saveNextImage){
					liveView.saveImage();
					saveNextImage = 0;
				}

				autolog++;
				autolog = autolog % 256;

				if(autolog == 0){
					//liveView.saveImage();
				}

			}else{
			Sleep(10);
			}
		}else{
			char command;
			command = _getch();
			switch (command) {
			case 's': 
				saveNextImage = 1;
				break;
			case 'q':
				keepRunning = 0;
				break;
			case 'l':
				runMode = raw;
				break;
			case 'f':
				runMode = retrieval;
				break;
			case 'p':
				std::cout << "In pause mode, press any key to continure!\n";
				while(!_kbhit());
				break;
			default:
				std::cout << "Sorry, I couldn't understand your input!\nPlease press:\nS: Save Next Image\nQ: Quit program\nL: Switch to live view of raw image\nF: Switch to frog retrieval mode\n";
				break;
			}
		}
	}
	

	myCamera.setIdle();




	//Myprocessing.~imageprocessing();  //should be anyway also atomatically be destroyed
	

}
catch(Euresys::MultiCam::Exception error){
	std::cerr << error.What() << "\n";
}
catch(cameracontrol::error error){
	std::cerr << error.errorMsg << std::endl;
}
catch(imageprocessing::error error){
	std::cerr << error.errorMsg << std::endl;
}
catch(utilities::error error){
	std::cerr << error.errorMsg << std::endl;
}
catch(...){
	std::cerr << "An Unknown Error occured! Very BAD!!!\n";
}

	//std::cout << "Press key to close driver and exit!\n";
	//(void) _getch();

	return 0;
}

