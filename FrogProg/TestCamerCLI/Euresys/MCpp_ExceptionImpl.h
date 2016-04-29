// MCpp_ExceptionImpl.h - MULTICAM C++ API - ExceptionImpl
#if !defined(__MCPP_EXCEPTIONIMPL_H__)
#define __MCPP_EXCEPTIONIMPL_H__

#include "MCpp_Exception.h"

namespace Euresys
{
  namespace MultiCam
  {
    inline Exception::Exception(INT32 anError, const char *desc)
    {
      Error = anError ;
      strncpy_s(McDescription, desc, MCPP_MAX_EXCEPTION_DESCRIPTION_SIZE);
    }

    inline Exception::Exception(Exception &e)
    {
      Error = e.Error ;
      strncpy_s(McDescription, e.What(), MCPP_MAX_EXCEPTION_DESCRIPTION_SIZE);
    }

    inline Exception& Exception::operator=(Exception& e) 
    { 
      Error = e.Error ;
      strncpy_s(McDescription, e.What(), MCPP_MAX_EXCEPTION_DESCRIPTION_SIZE);
      return *this; 
    }

    inline Exception::~Exception()
    {
    }

    inline const char *Exception::What()
    {
      return McDescription;
    }
  }
}
#endif
