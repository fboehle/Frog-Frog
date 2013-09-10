# Microsoft Developer Studio Generated NMAKE File, Based on Extern.dsp
!IF "$(CFG)" == ""
CFG=Extern - Win32 Help
!MESSAGE No configuration specified. Defaulting to Extern - Win32 Help.
!ENDIF 

!IF "$(CFG)" != "Extern - Win32 Help"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Extern.mak" CFG="Extern - Win32 Help"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Extern - Win32 Help" (based on "Win32 (x86) Generic Project")
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

ALL : ".\extern\html\index.html" 


CLEAN :
	-@erase 
	-@erase "extern\html\index.html"

MTL=midl.exe
MTL_PROJ=

!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Extern.dep")
!INCLUDE "Extern.dep"
!ELSE 
!MESSAGE Warning: cannot find "Extern.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Extern - Win32 Help"
SOURCE=.\extern.dox
InputPath=.\extern.dox
InputName=extern

".\extern\html\index.html" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	<<tempfile.bat 
	@echo off 
	doxygen $(InputPath)
<< 
	

!ENDIF 

