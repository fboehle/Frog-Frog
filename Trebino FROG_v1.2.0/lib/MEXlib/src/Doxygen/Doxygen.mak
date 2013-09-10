# Microsoft Developer Studio Generated NMAKE File, Based on Doxygen.dsp
!IF "$(CFG)" == ""
CFG=Doxygen - Win32 Help
!MESSAGE No configuration specified. Defaulting to Doxygen - Win32 Help.
!ENDIF 

!IF "$(CFG)" != "Doxygen - Win32 Help"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Doxygen.mak" CFG="Doxygen - Win32 Help"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Doxygen - Win32 Help" (based on "Win32 (x86) Generic Project")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

OUTDIR=.
INTDIR=.

!IF "$(RECURSE)" == "0" 

ALL : ".\MEXlib\html\index.html" 

!ELSE 

ALL : "Extern - Win32 Help" ".\MEXlib\html\index.html" 

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"Extern - Win32 HelpCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase 
	-@erase "MEXlib\html\index.html"

MTL=midl.exe
MTL_PROJ=

!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Doxygen.dep")
!INCLUDE "Doxygen.dep"
!ELSE 
!MESSAGE Warning: cannot find "Doxygen.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Doxygen - Win32 Help"
SOURCE=.\MEXlib.dox
InputPath=.\MEXlib.dox
InputName=MEXlib
USERDEP__MEXLI="extern.xml"	

".\MEXlib\html\index.html" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)" $(USERDEP__MEXLI)
	<<tempfile.bat 
	@echo off 
	doxygen $(InputPath)
<< 
	

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

"Extern - Win32 Help" : 
   cd "."
   $(MAKE) /$(MAKEFLAGS) /F .\Extern.mak CFG="Extern - Win32 Help" 
   cd "."

"Extern - Win32 HelpCLEAN" : 
   cd "."
   $(MAKE) /$(MAKEFLAGS) /F .\Extern.mak CFG="Extern - Win32 Help" RECURSE=1 CLEAN 
   cd "."

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 

!IF  "$(CFG)" == "Doxygen - Win32 Help"

!ENDIF 


!ENDIF 

