/*********************************************************
*	Camera Control Class
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
#include "cameracontrol.h"
#include "utilities.h"

cameracontrol::cameracontrol(void){
	update = 0;

#ifdef CAMERAEXISTS
	Euresys::MultiCam::Initialize();
	
	channel = new Euresys::MultiCam::Channel(&Euresys::MultiCam::Board::Board(0),  MC_Connector_X);

	channel->SetParam(MC_CamFile, "CV-A1_P16SA");
	//channel.SetParam(MC_Expose_us, 1000);
	channel->SetParam(MC_ColorFormat, MC_ColorFormat_Y8);
	channel->SetParam(MC_TrigMode, MC_TrigMode_IMMEDIATE);
	channel->SetParam(MC_NextTrigMode, MC_NextTrigMode_REPEAT);
	channel->SetParam(MC_SeqLength_Fr, MC_INDETERMINATE);

	//retrieve image dimension

	channel->GetParam(MC_ImageSizeX, sizeX);
	channel->GetParam(MC_ImageSizeY, sizeY);
	channel->GetParam(MC_BufferPitch, bufferpitch);

	std::cout << "Retrieved Image Dimensions: \n"
		"X Dimension: " << sizeX << " Y Dimension: " << sizeY << " Pitch: " << bufferpitch << std::endl;

	channel->SetParam(MC_SurfaceCount, 15); //set the number of preallocated surfaces
	channel->SetParam(MC_SignalEnable + MC_SIG_SURFACE_PROCESSING, MC_SignalEnable_ON);
	channel->SetParam(MC_SignalEnable + MC_SIG_ACQUISITION_FAILURE, MC_SignalEnable_ON);

	channel->RegisterCallback(this, &cameracontrol::callback, MC_SIG_SURFACE_PROCESSING);
	channel->RegisterCallback(this, &cameracontrol::acquisitionfailure, MC_SIG_ACQUISITION_FAILURE);

#else
	sizeX = 1376;
	sizeY = 1035;
#endif
	//create space for the image, write from the callback to this image only if image.readFinished is one
	rawImage.size = sizeX * sizeY;
	rawImage.pointer = new unsigned char[rawImage.size];
	rawImage.accessing = 0;

}

cameracontrol::~cameracontrol(){

#ifdef CAMERAEXISTS
	channel->UnregisterCallback(MC_SIG_SURFACE_PROCESSING);
	channel->UnregisterCallback(MC_SIG_ACQUISITION_FAILURE);

	std::cout << "Driver terminating." << std::endl;
	Euresys::MultiCam::Terminate(); //Disconnecting from driver
#endif

}
	
void cameracontrol::acquisitionfailure(Euresys::MultiCam::Channel &channel, Euresys::MultiCam::SignalInfo &info){
	std::cout << "acquisitionfailure: ";
	std::cout << "Signal " << info.Signal << '\n';

	return;
}

void cameracontrol::imageLock(void){
	int attempts;
	for(attempts = 0; attempts<10; attempts++){
		if(!rawImage.accessing){
			rawImage.accessing = 1;
			return;
		}else{
		Sleep(5);
		}
	}

	throw error("Could not lock the Image");
}

void cameracontrol::imageRelease(void){

	rawImage.accessing = 0;
	return;

}
	
		
void cameracontrol::callback(Euresys::MultiCam::Channel &channel, Euresys::MultiCam::SignalInfo &info){

try{
	
	//std::cout << "Signal " << info.Signal <<": ";
	

	void * surfaceaddress = 0;
	signed long long surfacesize;
	info.Surf->GetParam(MC_SurfaceAddr, surfaceaddress);
	info.Surf->GetParam(MC_SurfaceSize, surfacesize);


	imageLock();
	std::copy((char*)surfaceaddress, (char*)surfaceaddress + rawImage.size, (char*)rawImage.pointer);
	imageRelease();
	update = 1;

}
catch(Euresys::MultiCam::Exception error){
	std::cerr << error.What() << "\n";
}
catch(...){
	std::cerr << "An Unknown Error occured! Very BAD!!!\n";
}

	return;
}

void cameracontrol::getImage(unsigned char * imageDest, int imageMaxSize){

	if(imageMaxSize < rawImage.size) throw error("Image sizes don't match");

#ifdef CAMERAEXISTS
	imageLock();
	memcpy(imageDest, rawImage.pointer, rawImage.size);
	imageRelease();

	update = 0;

#else	//populate the frogtrace pointer with the sample Image

	std::ifstream sampleImage;
	sampleImage.open("sample.frogtrace", std::ios::in | std::ios::binary);
	sampleImage.read( (char *) imageDest, rawImage.size);
	sampleImage.close();

#endif	

	return;
}

void cameracontrol::setActive(void){
#ifdef CAMERAEXISTS
	channel->SetActive();
#endif	
}

void cameracontrol::setIdle(void){
#ifdef CAMERAEXISTS
	channel->SetIdle();
#endif	
}

bool cameracontrol::updateAvailable(void){

#ifdef CAMERAEXISTS
	return update;

#else

	return 1;

#endif	

}