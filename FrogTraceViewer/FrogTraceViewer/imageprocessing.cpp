/*********************************************************
*	Image Processing Class
*	
*	12-2012
*	Frederik Böhle software@fboehle.de
**********************************************************
*
*
*
*
*********************************************************/



#include "stdafx.h"
#include "imageprocessing.h"

#include <algorithm>
#include "FrogTraceViewer.h"


imageprocessing::imageprocessing(){
	
	m_pEngine = engOpen(NULL);
	if (m_pEngine == NULL)
	{
		std::cout << "Error: Matlab Engine not opened!" << std::endl;
		exit(1);
	}
	else std::cout << "Matlab Engine Successfully opened." << std::endl;
	if(engSetVisible(m_pEngine, 1)){
		std::cout << "Error: Matlab Engine Visibility not set" << std::endl;
	}


	int size_x = 1376;
	int size_y = 1035;

	//create space for the image, write from the callback to this image only if image.readFinished is one
	frogTrace.size = size_x * size_y;
	frogTrace.pointer = new unsigned char[frogTrace.size];
	frogTrace.readFinished = 1;

}

imageprocessing::~imageprocessing(){

	std::cout << "Closing MatLab Engine ..." << std::endl;
	engClose(m_pEngine);
}
	