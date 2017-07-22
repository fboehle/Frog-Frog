#pragma once

class imageprocessing {

	
public:
	Engine *m_pEngine;
	struct image{
		unsigned char* pointer;
		int size;
		int readFinished;
	} frogTrace;
public:
	imageprocessing();
	~imageprocessing();

};