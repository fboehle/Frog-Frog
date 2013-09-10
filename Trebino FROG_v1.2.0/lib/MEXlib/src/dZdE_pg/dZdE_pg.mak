# Microsoft Developer Studio Generated NMAKE File, Based on dZdE_shg.dsp
!IF "$(CFG)" == ""
CFG=dZdE_shg - Win32 Debug
!MESSAGE No configuration specified. Defaulting to dZdE_shg - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "dZdE_shg - Win32 Release" && "$(CFG)" != "dZdE_shg - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "dZdE_shg.mak" CFG="dZdE_shg - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "dZdE_shg - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "dZdE_shg - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "dZdE_shg - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\dZdE_shg.dll" "$(OUTDIR)\dZdE_shg.bsc" "..\..\bin\dZdE_shg.dll"

!ELSE 

ALL : "Util - Win32 Release" "$(OUTDIR)\dZdE_shg.dll" "$(OUTDIR)\dZdE_shg.bsc" "..\..\bin\dZdE_shg.dll"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"Util - Win32 ReleaseCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\dZdE_shg.obj"
	-@erase "$(INTDIR)\dZdE_shg.sbr"
	-@erase "$(INTDIR)\mexversion.res"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\dZdE_shg.bsc"
	-@erase "$(OUTDIR)\dZdE_shg.dll"
	-@erase "$(OUTDIR)\dZdE_shg.exp"
	-@erase "..\..\bin\dZdE_shg.dll"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /Gi /GX /O2 /I "C:\MATLAB6p1\extern\include" /D "WIN32" /D "_WINDOWS" /D "_WINDLL" /D "_AFXDLL" /D "_MBCS" /D "_USRDLL" /D "IBMPC" /D "MSVC" /D "MSWIND" /D "__STDC__" /D "MATLAB_MEX_FILE" /D "NDEBUG" /D "ARRAY_ACCESS_INLINING" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\dZdE_shg.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\dZdE_shg.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\dZdE_shg.sbr"

"$(OUTDIR)\dZdE_shg.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib libmx.lib libmex.lib libmatlb.lib libmat.lib /nologo /subsystem:windows /dll /incremental:no /pdb:"$(OUTDIR)\dZdE_shg.pdb" /machine:I386 /out:"$(OUTDIR)\dZdE_shg.dll" /implib:"$(OUTDIR)\dZdE_shg.lib" /libpath:"C:\MATLAB6p1\extern\lib\win32\microsoft\msvc60" /export:"mexFunction" 
LINK32_OBJS= \
	"$(INTDIR)\dZdE_shg.obj" \
	"$(INTDIR)\mexversion.res"

"$(OUTDIR)\dZdE_shg.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

InputPath=.\Release\dZdE_shg.dll
InputName=dZdE_shg
SOURCE="$(InputPath)"

"..\..\bin\dZdE_shg.dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	<<tempfile.bat 
	@echo off 
	copy $(InputPath) ..\..\bin\$(InputName).dll
<< 
	

!ELSEIF  "$(CFG)" == "dZdE_shg - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\dZdE_shg.dll" "$(OUTDIR)\dZdE_shg.bsc" "..\..\bin\dZdE_shg.dll"

!ELSE 

ALL : "Util - Win32 Debug" "$(OUTDIR)\dZdE_shg.dll" "$(OUTDIR)\dZdE_shg.bsc" "..\..\bin\dZdE_shg.dll"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"Util - Win32 DebugCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\dZdE_shg.obj"
	-@erase "$(INTDIR)\dZdE_shg.sbr"
	-@erase "$(INTDIR)\mexversion.res"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\dZdE_shg.bsc"
	-@erase "$(OUTDIR)\dZdE_shg.dll"
	-@erase "$(OUTDIR)\dZdE_shg.exp"
	-@erase "$(OUTDIR)\dZdE_shg.ilk"
	-@erase "$(OUTDIR)\dZdE_shg.pdb"
	-@erase "..\..\bin\dZdE_shg.dll"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /Gm /Gi /GX /ZI /Od /I "C:\MATLAB6p1\extern\include" /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "_WINDLL" /D "_AFXDLL" /D "_MBCS" /D "_USRDLL" /D "IBMPC" /D "MSVC" /D "MSWIND" /D "__STDC__" /D "MATLAB_MEX_FILE" /D "NDEBUG" /D "ARRAY_ACCESS_INLINING" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\dZdE_shg.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\dZdE_shg.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\dZdE_shg.sbr"

"$(OUTDIR)\dZdE_shg.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib libmx.lib libmex.lib libmatlb.lib libmat.lib /nologo /subsystem:windows /dll /incremental:yes /pdb:"$(OUTDIR)\dZdE_shg.pdb" /debug /machine:I386 /out:"$(OUTDIR)\dZdE_shg.dll" /implib:"$(OUTDIR)\dZdE_shg.lib" /pdbtype:sept /libpath:"C:\MATLAB6p1\extern\lib\win32\microsoft\msvc60" /export:"mexFunction" 
LINK32_OBJS= \
	"$(INTDIR)\dZdE_shg.obj" \
	"$(INTDIR)\mexversion.res"

"$(OUTDIR)\dZdE_shg.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

InputPath=.\Debug\dZdE_shg.dll
InputName=dZdE_shg
SOURCE="$(InputPath)"

"..\..\bin\dZdE_shg.dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	<<tempfile.bat 
	@echo off 
	copy $(InputPath) ..\..\bin\$(InputName).dll
<< 
	

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("dZdE_shg.dep")
!INCLUDE "dZdE_shg.dep"
!ELSE 
!MESSAGE Warning: cannot find "dZdE_shg.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "dZdE_shg - Win32 Release" || "$(CFG)" == "dZdE_shg - Win32 Debug"
SOURCE=.\dZdE_shg.cpp

"$(INTDIR)\dZdE_shg.obj"	"$(INTDIR)\dZdE_shg.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE=..\..\..\..\..\extern\include\mexversion.rc

!IF  "$(CFG)" == "dZdE_shg - Win32 Release"


"$(INTDIR)\mexversion.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x409 /fo"$(INTDIR)\mexversion.res" /i "\MATLAB6p1\extern\include" /d "NDEBUG" /d "_AFXDLL" $(SOURCE)


!ELSEIF  "$(CFG)" == "dZdE_shg - Win32 Debug"


"$(INTDIR)\mexversion.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x409 /fo"$(INTDIR)\mexversion.res" /i "\MATLAB6p1\extern\include" /d "_DEBUG" /d "_AFXDLL" $(SOURCE)


!ENDIF 

!IF  "$(CFG)" == "dZdE_shg - Win32 Release"

"Util - Win32 Release" : 
   cd "\MATLAB6p1\work\matlablib\MEXlib\src\Util"
   $(MAKE) /$(MAKEFLAGS) /F .\Util.mak CFG="Util - Win32 Release" 
   cd "..\dZdE_shg"

"Util - Win32 ReleaseCLEAN" : 
   cd "\MATLAB6p1\work\matlablib\MEXlib\src\Util"
   $(MAKE) /$(MAKEFLAGS) /F .\Util.mak CFG="Util - Win32 Release" RECURSE=1 CLEAN 
   cd "..\dZdE_shg"

!ELSEIF  "$(CFG)" == "dZdE_shg - Win32 Debug"

"Util - Win32 Debug" : 
   cd "\MATLAB6p1\work\matlablib\MEXlib\src\Util"
   $(MAKE) /$(MAKEFLAGS) /F .\Util.mak CFG="Util - Win32 Debug" 
   cd "..\dZdE_shg"

"Util - Win32 DebugCLEAN" : 
   cd "\MATLAB6p1\work\matlablib\MEXlib\src\Util"
   $(MAKE) /$(MAKEFLAGS) /F .\Util.mak CFG="Util - Win32 Debug" RECURSE=1 CLEAN 
   cd "..\dZdE_shg"

!ENDIF 


!ENDIF 

