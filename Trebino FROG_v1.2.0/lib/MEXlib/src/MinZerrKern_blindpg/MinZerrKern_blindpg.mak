# Microsoft Developer Studio Generated NMAKE File, Based on MinZerrKern_blindpg.dsp
!IF "$(CFG)" == ""
CFG=MinZerrKern_blindpg - Win32 Debug
!MESSAGE No configuration specified. Defaulting to MinZerrKern_blindpg - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "MinZerrKern_blindpg - Win32 Release" && "$(CFG)" != "MinZerrKern_blindpg - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "MinZerrKern_blindpg.mak" CFG="MinZerrKern_blindpg - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "MinZerrKern_blindpg - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "MinZerrKern_blindpg - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "MinZerrKern_blindpg - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\MinZerrKern_blindpg.dll" "$(OUTDIR)\MinZerrKern_blindpg.bsc" "..\..\bin\MinZerrKern_blindpg.dll"

!ELSE 

ALL : "Util - Win32 Release" "$(OUTDIR)\MinZerrKern_blindpg.dll" "$(OUTDIR)\MinZerrKern_blindpg.bsc" "..\..\bin\MinZerrKern_blindpg.dll"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"Util - Win32 ReleaseCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\mexversion.res"
	-@erase "$(INTDIR)\MinZerrKern_blindpg.obj"
	-@erase "$(INTDIR)\MinZerrKern_blindpg.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\MinZerrKern_blindpg.bsc"
	-@erase "$(OUTDIR)\MinZerrKern_blindpg.dll"
	-@erase "$(OUTDIR)\MinZerrKern_blindpg.exp"
	-@erase "..\..\bin\MinZerrKern_blindpg.dll"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /Gi /GX /O2 /I "C:\MATLAB6p1\extern\include" /D "WIN32" /D "_WINDOWS" /D "_WINDLL" /D "_AFXDLL" /D "_MBCS" /D "_USRDLL" /D "IBMPC" /D "MSVC" /D "MSWIND" /D "__STDC__" /D "MATLAB_MEX_FILE" /D "NDEBUG" /D "ARRAY_ACCESS_INLINING" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\MinZerrKern_blindpg.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\MinZerrKern_blindpg.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\MinZerrKern_blindpg.sbr"

"$(OUTDIR)\MinZerrKern_blindpg.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib libmx.lib libmex.lib libmatlb.lib libmat.lib /nologo /subsystem:windows /dll /incremental:no /pdb:"$(OUTDIR)\MinZerrKern_blindpg.pdb" /machine:I386 /out:"$(OUTDIR)\MinZerrKern_blindpg.dll" /implib:"$(OUTDIR)\MinZerrKern_blindpg.lib" /libpath:"C:\MATLAB6p1\extern\lib\win32\microsoft\msvc60" /export:"mexFunction" 
LINK32_OBJS= \
	"$(INTDIR)\MinZerrKern_blindpg.obj" \
	"$(INTDIR)\mexversion.res"

"$(OUTDIR)\MinZerrKern_blindpg.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

InputPath=.\Release\MinZerrKern_blindpg.dll
InputName=MinZerrKern_blindpg
SOURCE="$(InputPath)"

"..\..\bin\MinZerrKern_blindpg.dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	<<tempfile.bat 
	@echo off 
	copy $(InputPath) ..\..\bin\$(InputName).dll
<< 
	

!ELSEIF  "$(CFG)" == "MinZerrKern_blindpg - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\MinZerrKern_blindpg.dll" "$(OUTDIR)\MinZerrKern_blindpg.bsc" "..\..\bin\MinZerrKern_blindpg.dll"

!ELSE 

ALL : "Util - Win32 Debug" "$(OUTDIR)\MinZerrKern_blindpg.dll" "$(OUTDIR)\MinZerrKern_blindpg.bsc" "..\..\bin\MinZerrKern_blindpg.dll"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"Util - Win32 DebugCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\mexversion.res"
	-@erase "$(INTDIR)\MinZerrKern_blindpg.obj"
	-@erase "$(INTDIR)\MinZerrKern_blindpg.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\MinZerrKern_blindpg.bsc"
	-@erase "$(OUTDIR)\MinZerrKern_blindpg.dll"
	-@erase "$(OUTDIR)\MinZerrKern_blindpg.exp"
	-@erase "$(OUTDIR)\MinZerrKern_blindpg.ilk"
	-@erase "$(OUTDIR)\MinZerrKern_blindpg.pdb"
	-@erase "..\..\bin\MinZerrKern_blindpg.dll"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /Gm /Gi /GX /ZI /Od /I "C:\MATLAB6p1\extern\include" /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "_WINDLL" /D "_AFXDLL" /D "_MBCS" /D "_USRDLL" /D "IBMPC" /D "MSVC" /D "MSWIND" /D "__STDC__" /D "MATLAB_MEX_FILE" /D "NDEBUG" /D "ARRAY_ACCESS_INLINING" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\MinZerrKern_blindpg.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

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
BSC32_FLAGS=/nologo /o"$(OUTDIR)\MinZerrKern_blindpg.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\MinZerrKern_blindpg.sbr"

"$(OUTDIR)\MinZerrKern_blindpg.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib libmx.lib libmex.lib libmatlb.lib libmat.lib /nologo /subsystem:windows /dll /incremental:yes /pdb:"$(OUTDIR)\MinZerrKern_blindpg.pdb" /debug /machine:I386 /out:"$(OUTDIR)\MinZerrKern_blindpg.dll" /implib:"$(OUTDIR)\MinZerrKern_blindpg.lib" /pdbtype:sept /libpath:"C:\MATLAB6p1\extern\lib\win32\microsoft\msvc60" /export:"mexFunction" 
LINK32_OBJS= \
	"$(INTDIR)\MinZerrKern_blindpg.obj" \
	"$(INTDIR)\mexversion.res"

"$(OUTDIR)\MinZerrKern_blindpg.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

InputPath=.\Debug\MinZerrKern_blindpg.dll
InputName=MinZerrKern_blindpg
SOURCE="$(InputPath)"

"..\..\bin\MinZerrKern_blindpg.dll" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	<<tempfile.bat 
	@echo off 
	copy $(InputPath) ..\..\bin\$(InputName).dll
<< 
	

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("MinZerrKern_blindpg.dep")
!INCLUDE "MinZerrKern_blindpg.dep"
!ELSE 
!MESSAGE Warning: cannot find "MinZerrKern_blindpg.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "MinZerrKern_blindpg - Win32 Release" || "$(CFG)" == "MinZerrKern_blindpg - Win32 Debug"
SOURCE=.\MinZerrKern_blindpg.cpp

"$(INTDIR)\MinZerrKern_blindpg.obj"	"$(INTDIR)\MinZerrKern_blindpg.sbr" : $(SOURCE) "$(INTDIR)"


SOURCE="C:\MATLAB6p1\extern\include\mexversion.rc"

!IF  "$(CFG)" == "MinZerrKern_blindpg - Win32 Release"


"$(INTDIR)\mexversion.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x409 /fo"$(INTDIR)\mexversion.res" /i "\MATLAB6p1\extern\include" /d "NDEBUG" /d "_AFXDLL" $(SOURCE)


!ELSEIF  "$(CFG)" == "MinZerrKern_blindpg - Win32 Debug"


"$(INTDIR)\mexversion.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) /l 0x409 /fo"$(INTDIR)\mexversion.res" /i "\MATLAB6p1\extern\include" /d "_DEBUG" /d "_AFXDLL" $(SOURCE)


!ENDIF 

!IF  "$(CFG)" == "MinZerrKern_blindpg - Win32 Release"

"Util - Win32 Release" : 
   cd "\MATLAB6p1\work\matlablib\MEXlib\src\Util"
   $(MAKE) /$(MAKEFLAGS) /F .\Util.mak CFG="Util - Win32 Release" 
   cd "..\MinZerrKern_blindpg"

"Util - Win32 ReleaseCLEAN" : 
   cd "\MATLAB6p1\work\matlablib\MEXlib\src\Util"
   $(MAKE) /$(MAKEFLAGS) /F .\Util.mak CFG="Util - Win32 Release" RECURSE=1 CLEAN 
   cd "..\MinZerrKern_blindpg"

!ELSEIF  "$(CFG)" == "MinZerrKern_blindpg - Win32 Debug"

"Util - Win32 Debug" : 
   cd "\MATLAB6p1\work\matlablib\MEXlib\src\Util"
   $(MAKE) /$(MAKEFLAGS) /F .\Util.mak CFG="Util - Win32 Debug" 
   cd "..\MinZerrKern_blindpg"

"Util - Win32 DebugCLEAN" : 
   cd "\MATLAB6p1\work\matlablib\MEXlib\src\Util"
   $(MAKE) /$(MAKEFLAGS) /F .\Util.mak CFG="Util - Win32 Debug" RECURSE=1 CLEAN 
   cd "..\MinZerrKern_blindpg"

!ENDIF 


!ENDIF 

