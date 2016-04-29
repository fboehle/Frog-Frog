#pragma once

namespace utilities {
	

	std::string currentTime(void);
	struct error{
		std::string errorMsg;
		error(std::string passedMsg) {errorMsg = passedMsg;}
	};

}