#pragma once

class cameracontrol; //forward class declaration

class imageprocessing {
	
private:
	static const int BUFSIZE = 4096;
	char matlabEcho[BUFSIZE+1];
	Engine *matlabEngine;
	mxArray *matlabArrayFrog;
	mxArray *pixelAvg;
	cameracontrol *associatedCamera;
	std::string createFilename;
	std::string updateFilename;
	std::string deleteFilename;
	struct image{
		unsigned char* pointer;
		int size;
	} frogtrace;
public:
	imageprocessing(cameracontrol *, std::string, std::string, std::string);
	~imageprocessing(void);
	void saveImage(void);
	void loadNewImage(void);
	void updateMatlab(void);

public:
	struct error{
		std::string errorMsg;
		error(std::string passedMsg) {errorMsg = passedMsg;}
	};

};