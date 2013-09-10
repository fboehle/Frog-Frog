# Microsoft Developer Studio Generated NMAKE File, Based on CalcEsig_wW.dsp
!IF "$(CFG)" == ""
CFG=CalcEsig_wW - Win32 Debug
!MESSAGE No configuration specified. Defaulting to CalcEsig_wW - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "CalcEsig_wW - Win32 Release" && "$(CFG)" != "CalcEsig_wW - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "CalcEsig_wW.mak" CFG="CalcEsig_wW - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "CalcEsig_wW - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "CalcEsig_wW - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "CalcEsig_wW - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\CalcEsig_wW.dll" "$(OUTDIR)\CalcEsig_wW.bsc" "..\..\bin\CalcEsig_wW.dll"

!ELSE 

ALL : "Util - Win32 Release" "$(OUTDIR)\CalcEsig_wW.dll" "$(OUTDIR)\CalcEsig_wW.bsc" "..\..\bin\CalcEsig_wW.dll"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"Util - Win32 ReleaseCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\CalcEsig_wW.obj"
	-@erase "$(INTDIR)\CalcEsig_wW.sbr"
	-@erase "$(INTDIR)\mexversion.res"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\CalcEsig_wW.bsc"
	-@erase "$(OUTDIR)\CalcEsig_wW.dll"
	-@erase "$(OUTDIR)\CalcEsig_wW.exp"
	-@erase "..\..\bin\CalcEsig_wW.dll"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /Gi /GX /O2 /I "C:\MATLAB6p1\extern\include" /D "WIN32" /D "_WINDOWS" /D "_WINDLL" /D "_AFXDLL" /D "_MBCS" /D "_USRDLL" /D "IBMPC" /D "MSVC" /D "MSWIND" /D "__STDC__" /D "MATLAB_MEX_FILE" /D "NDEBUG" /D "ARRAY_ACCESS_INLINING" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\CalcEsig_wW.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\mexversion.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\CalcEsig_wW.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\CalcEsig_wW.sbr"

"$(OUTDIR)\CalcEsig_wW.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib libmx.lib libmex.lib libmatlb.lib libmat.lib /nologo /subsystem:windows /dll /incremental:no /pdb:"$(OUTDIR)\CalcEsig_wW.pdb" /machine:I386 /out:"$(OUTDIR)\CalcEsig_wW.dll" /implib:"$(OUTDIR)\CalcEsig_wW.lib" /libpath:"C:\MATLAB6p1\extern\lib\win32\microsoft\msvc60" /export:"mexFunction" 
LINK32_OBJS= \
	"$(INTDIR)\CalcEsig_wW.obj" \
	"$(INTDIR)\mexversion.res"

"$(OUTDIR)\CalcEsig_wW.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

InputPath=.\Release\CalcEsig_wW.dll
InputName=CalcEsig_wW
SOURCE="$(InputPath)"

"..\..\bin\CalcEsig_wW.dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	<<tempfile.bat 
	@echo off 
	copy $(InputPath) ..\..\bin\$(InputName).dll
<< 
	

!ELSEIF  "$(CFG)" == "CalcEsig_wW - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\CalcEsig_wW.dll" "$(OUTDIR)\CalcEsig_wW.bsc" "..\..\bin\CalcEsig_wW.dll"

!ELSE 

ALL : "Util - Win32 Debug" "$(OUTDIR)\CalcEsig_wW.dll" "$(OUTDIR)\CalcEsig_wW.bsc" "..\..\bin\CalcEsig_wW.dll"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"Util - Win32 DebugCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\CalcEsig_wW.obj"
	-@erase "$(INTDIR)\CalcEsig_wW.sbr"
	-@erase "$(INTDIR)\mexversion.res"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\CalcEsig_wW.bsc"
	-@erase "$(OUTDIR)\CalcEsig_wW.dll"
	-@erase "$(OUTDIR)\CalcEsig_wW.exp"
	-@erase "$(OUTDIR)\CalcEsig_wW.ilk"
	-@erase "$(OUTDIR)\CalcEsig_wW.pdb"
	-@erase "..\..\bin\CalcEsig_wW.dll"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /Gm /Gi /GX /ZI /Od /I "C:\MATLAB6p1\extern\include" /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "_WINDLL" /D "_AFXDLL" /D "_MBCS" /D "_USRDLL" /D "IBMPC" /D "MSVC" /D "MSWIND" /D "__STDC__" /D "MATLAB_MEX_FILE" /D "NDEBUG" /D "ARRAY_ACCESS_INLINING" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\CalcEsig_wW.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\mexversion.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\CalcEsig_wW.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\CalcEsig_wW.sbr"

"$(OUTDIR)\CalcEsig_wW.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib libmx.lib libmex.lib libmatlb.lib libmat.lib /nologo /subsystem:windows /dll /incremental:yes /pdb:"$(OUTDIR)\CalcEsig_wW.pdb" /debug /machine:I386 /out:"$(OUTDIR)\CalcEsig_wW.dll" /implib:"$(OUTDIR)\CalcEsig_wW.lib" /pdbtype:sept /libpath:"C:\MATLAB6p1\extern\lib\win32\microsoft\msvc60" /export:"mexFunction" 
LINK32_OBJS= \
	"$(INTDIR)\CalcEsig_wW.obj" \
	"$(INTDIR)\mexversion.res"

"$(OUTDIR)\CalcEsig_wW.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

InputPath=.\Debug\CalcEsig_wW.dll
InputName=CalcEsig_wW
SOURCE="$(InputPath)"

"..\..\bin\CalcEsig_wW.dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	<<tempfile.bat 
	@echo off 
	copy $(InputPath) ..\..\bin\$(InputName).dll
<< 
	

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("CalcEsig_wW.dep")
!INCLUDE "CalcEsig_wW.dep"
!ELSE 
!MESSAGE Warning: cannot find "CalcEsig_wW.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "CalcEsig_wW - Win32 Release" || "$(CFG)" == "CalcEsig_wW - Win32 Debug"
SOURCE=.\CalcEsig_wW.cpp

"$(INTDIR)\CalcEsig_wW.obj"	"$(INTDIR)\CalcEsig_wW.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE="C:\MATLAB6p1\extern\include\mexversion.rc"

!IF  "$(CFG)" == "CalcEsig_wW - Win32 Release"


"$(INTDIR)\mexversion.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x409 /fo"$(INTDIR)\mexversion.res" /i "\MATLAB6p1\extern\include" /d "NDEBUG" /d "_AFXDLL" $(SOURCE)


!ELSEIF  "$(CFG)" == "CalcEsig_wW - Win32 Debug"


"$(INTDIR)\mexversion.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x409 /fo"$(INTDIR)\mexversion.res" /i "\MATLAB6p1\extern\include" /d "_DEBUG" /d "_AFXDLL" $(SOURCE)


!ENDIF 

!IF  "$(CFG)" == "CalcEsig_wW - Win32 Release"

"Util - Win32 Release" : 
   cd "\MATLAB6p1\work\matlablib\MEXlib\src\Util"
   $(MAKE) /$(MAKEFLAGS) /F .\Util.mak CFG="Util - Win32 Release" 
   cd "..\ClacEsig_wW"

"Util - Win32 ReleaseCLEAN" : 
   cd "\MATLAB6p1\work\matlablib\MEXlib\src\Util"
   $(MAKE) /$(MAKEFLAGS) /F .\Util.mak CFG="Util - Win32 Release" RECURSE=1 CLEAN 
   cd "..\ClacEsig_wW"

!ELSEIF  "$(CFG)" == "CalcEsig_wW - Win32 Debug"

"Util - Win32 Debug" : 
   cd "\MATLAB6p1\work\matlablib\MEXlib\src\Util"
   $(MAKE) /$(MAKEFLAGS) /F .\Util.mak CFG="Util - Win32 Debug" 
   cd "..\ClacEsig_wW"

"Util - Win32 DebugCLEAN" : 
   cd "\MATLAB6p1\work\matlablib\MEXlib\src\Util"
   $(MAKE) /$(MAKEFLAGS) /F .\Util.mak CFG="Util - Win32 Debug" RECURSE=1 CLEAN 
   cd "..\ClacEsig_wW"

!ENDIF 


!ENDIF 

