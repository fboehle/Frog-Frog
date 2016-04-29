#pragma once

class cameracontrol {

private:
	Euresys::MultiCam::Channel * channel;
	int sizeX;
	int sizeY;
	int bufferpitch;
	bool update;
	struct image{
		unsigned char* pointer;
		int size;
		int accessing;
	} rawImage;

public:
	struct error{
		std::string errorMsg;
		error(std::string passedMsg) {errorMsg = passedMsg;}
	};

private:
	void cameracontrol::imageLock(void);
	void cameracontrol::imageRelease(void);

public:
	cameracontrol(void);
	~cameracontrol(void);
	void callback(Euresys::MultiCam::Channel &, Euresys::MultiCam::SignalInfo &);
	void acquisitionfailure(Euresys::MultiCam::Channel &, Euresys::MultiCam::SignalInfo &);
	void setActive(void);
	void setIdle(void);
	void getImage(unsigned char *, int);
	int getImageSize(void){return sizeX * sizeY;}
	int getImageSizeX(void){return sizeX;}
	int getImageSizeY(void){return sizeY;}
	bool cameracontrol::updateAvailable(void);

};