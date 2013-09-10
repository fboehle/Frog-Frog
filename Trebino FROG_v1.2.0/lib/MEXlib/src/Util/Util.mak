# Microsoft Developer Studio Generated NMAKE File, Based on Util.dsp
!IF "$(CFG)" == ""
CFG=Util - Win32 Debug
!MESSAGE No configuration specified. Defaulting to Util - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Util - Win32 Release" && "$(CFG)" != "Util - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Util.mak" CFG="Util - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Util - Win32 Release" (based on "Win32 (x86) Generic Project")
!MESSAGE "Util - Win32 Debug" (based on "Win32 (x86) Generic Project")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

OUTDIR=.\Release
INTDIR=.\Release

ALL : 


CLEAN :
	-@erase 

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

!IF  "$(CFG)" == "Util - Win32 Release"

MTL=midl.exe
MTL_PROJ=

!ELSEIF  "$(CFG)" == "Util - Win32 Debug"

MTL=midl.exe
MTL_PROJ=

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("Util.dep")
!INCLUDE "Util.dep"
!ELSE 
!MESSAGE Warning: cannot find "Util.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "Util - Win32 Release" || "$(CFG)" == "Util - Win32 Debug"

!ENDIF 

