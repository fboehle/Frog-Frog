/*********************************************************
*	Image Processing Class
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
#include "cameracontrol.h"
#include "imageprocessing.h"
#include "utilities.h"

#include <algorithm>



imageprocessing::imageprocessing(cameracontrol * camera, std::string createFilenameTmp, std::string updateFilenameTmp,std::string deleteFilenameTmp){

	associatedCamera = camera;
	createFilename = createFilenameTmp;
	updateFilename = updateFilenameTmp;
	deleteFilename = deleteFilenameTmp;



	frogtrace.size = associatedCamera->getImageSize();;
	frogtrace.pointer = new unsigned char[frogtrace.size];

	matlabEngine = engOpen(NULL);
	if (matlabEngine == NULL)
	{
		std::cout << "Error: Matlab Engine not opened!" << std::endl;
		exit(1);
	}
	else std::cout << "Matlab Engine Successfully opened." << std::endl;
	if(engSetVisible(matlabEngine, 1)){
		std::cout << "Error: Matlab Engine Visibility not set" << std::endl;
	}

	matlabArrayFrog = mxCreateNumericMatrix(associatedCamera->getImageSizeX(), associatedCamera->getImageSizeY(), mxUINT8_CLASS, mxREAL);

	
	engOutputBuffer(matlabEngine, matlabEcho, BUFSIZE);
	engEvalString(matlabEngine, "cd('C:\\Users\\loa\\Documents\\Frog\\FrogProg\\Matlab')");
	printf("%s", matlabEcho);
	engPutVariable(matlabEngine, "frogtrace",matlabArrayFrog); 
	printf("%s", matlabEcho);
	engEvalString(matlabEngine, "frogtrace = frogtrace;");
	printf("%s", matlabEcho);
	engEvalString(matlabEngine, createFilename.c_str());
	printf("%s", matlabEcho);

	pixelAvg = mxCreateDoubleMatrix(1, 1, mxREAL);
}

imageprocessing::~imageprocessing(){

	std::cout << "Closing MatLab Engine ..." << std::endl;
	engClose(matlabEngine);
}
	
void imageprocessing::saveImage(void){
	std::ofstream saveImage;
	saveImage.exceptions(std::ofstream::badbit | std::ofstream::failbit);
	std::string filename;			
	std::string input;
	std::cout << "Please enter file appendix" << std::endl;
	std::getline(std::cin, input);
	filename = "C:\\Users\\loa\\Documents\\Frog\\FrogLog\\" + utilities::currentTime() + " " + input + ".frogtrace";
	try{
		saveImage.open(filename, std::ios::out | std::ios::binary);
		saveImage.write( (char *) frogtrace.pointer, frogtrace.size);
		saveImage.close();
		std::cout << "Image \"" << filename << ".dat" << "\" successfully saved!" << std::endl;
	}
	catch (std::ofstream::failure error){
		std::cout << "An ERROR occured: " << error.what() << ". Please try to save again!" << std::endl;
	}
	
		
}

void imageprocessing::loadNewImage(void){
	associatedCamera->getImage(frogtrace.pointer, frogtrace.size);
}

void imageprocessing::updateMatlab(void){

	memcpy( (unsigned char*) mxGetData(matlabArrayFrog), frogtrace.pointer, frogtrace.size);
	engPutVariable(matlabEngine, "frogtrace", matlabArrayFrog);
	//call the matlab script
	engEvalString(matlabEngine, updateFilename.c_str());
	printf("%s", matlabEcho);

	//pixelAvg = engGetVariable(matlabEngine, "pixelAvg");
	//std::cout << "And the average matlab pixel value is " << *(double *)mxGetPr(pixelAvg)<< std::endl; 
}
			
