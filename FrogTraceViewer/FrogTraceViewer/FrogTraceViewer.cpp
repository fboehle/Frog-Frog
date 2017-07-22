/*********************************************************
*	Main Application 
*	
*	12-2012
*	Frederik Böhle software@fboehle.de
**********************************************************
*
*
*
*
*********************************************************/

#include "stdafx.h"		//I think nothing is allowed to be included before this
#include "FrogTraceViewer.h"
#include "imageprocessing.h"

#define NOMINMAX
#include <windows.h>
#include <conio.h>
#include <time.h>
#include <fstream>
#include <string>
#include <sstream>

#pragma comment( lib, "Libmx.lib"    )
#pragma comment( lib, "libmex.lib"   )
#pragma comment( lib, "libeng.lib"    )



int _tmain(int argc, _TCHAR* argv[])
{
	if(argc < 2) {
		std::cout << "Please input a file!\n";
		return -1;
	}

try{	
	imageprocessing Myprocessing;
	int size_x = 1376;
	int size_y = 1035;

	std::cout << "Press key to end the loop and set channel do idle...\n";
	Sleep(1000);

	const int BUFSIZE = 512;
	char matlabEcho[BUFSIZE];
	
	mxArray *matlabArray = NULL;
	matlabArray = mxCreateNumericMatrix(size_x, size_y, mxUINT8_CLASS, mxREAL);
	engOutputBuffer(Myprocessing.m_pEngine, matlabEcho, BUFSIZE);
	char str[BUFSIZE];
	engEvalString(Myprocessing.m_pEngine, "cd('C:\\Users\\pco\\Dropbox\\FrogComputer\\FrogTraceViewer\\FrogTraceViewer')");
	printf("%s", matlabEcho);
	engEvalString(Myprocessing.m_pEngine, "disp(cd)");
	printf("%s", matlabEcho);
	engPutVariable(Myprocessing.m_pEngine, "frogtrace", matlabArray);
	printf("%s", matlabEcho);
	engEvalString(Myprocessing.m_pEngine, "rawFrogtraceCreate");
	printf("%s", matlabEcho);


	mxArray * pixelAvg = NULL;
	pixelAvg = mxCreateDoubleMatrix(1, 1, mxREAL);

	//populate the frogTrace pointer with the opened Image

	std::ifstream sampleImage;
	sampleImage.open(argv[1], std::ios::in | std::ios::binary);

	sampleImage.read( (char *) Myprocessing.frogTrace.pointer, Myprocessing.frogTrace.size);
	sampleImage.close();


			
	memcpy( (unsigned char*) mxGetData(matlabArray), Myprocessing.frogTrace.pointer, Myprocessing.frogTrace.size);

	engPutVariable(Myprocessing.m_pEngine, "frogtrace", matlabArray);
	printf("%s", matlabEcho);

	//call Matlab Script
	engEvalString(Myprocessing.m_pEngine, "rawFrogtraceUpdate");
	
	//std::string nextMatlabCommand = "imwrite(frogTrace, '" + argv[1]  + "testimage123123.tif', 'tif');";
//doesn't work as I don't know so far how to process the argv as a wchar
	//nextMatlabCommand = engEvalString(Myprocessing.m_pEngine, nextMatlabCommand.c_str());
	
	printf("%s", matlabEcho);


	pixelAvg = engGetVariable(Myprocessing.m_pEngine, "pixelAvg");
	//std::cout << "And the average matlab pixel value is " << *(double *)mxGetPr(pixelAvg)<< std::endl; 
			



	char input = getchar();


	//Myprocessing.~imageprocessing();  //should be anyway also atomatically be destroyed
	

}

catch(std::ifstream::failure e){
	std::cout << "Exception opening/reading file";
}

	return 0;
}

