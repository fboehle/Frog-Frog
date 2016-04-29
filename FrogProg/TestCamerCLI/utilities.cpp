/*********************************************************
*	Utility Class
*	
*	03-2013
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


std::string utilities::currentTime(void){
					
	time_t savetime;
	time(&savetime);

	struct tm localSaveTime[1];
	localtime_s(localSaveTime, &savetime);
	char saveImageTime[80];
	strftime(saveImageTime, 80, "%Y-%m-%d--%H-%M-%S", localSaveTime);

	std::string currentTimeStr(saveImageTime);
	return currentTimeStr;
}