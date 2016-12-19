   	Set vSrcPath=G:\System\Apps\WSLTools\WSLToolsL1\Latest
   	Set vDesPath=C:\Program Files (x86)\ArcGIS\Desktop10.3\bin\Addins
	echo %vDesPath%
   	IF NOT EXIST "%vDesPath%\WSLTools" GOTO CREATEWSLDIR
   	GOTO DELWSLFILES
:CREATEWSLDIR
   MKDIR "%vDesPath%\WSLTools"

   GOTO COPYFILES
:DELWSLFILES
	call uninstall.bat	
   	DEL "%vDesPath%\WSLTools" /Q
   	GOTO COPYFILES
:COPYFILES
	xcopy %vSrcPath% "%vDesPath%\WSLTools\*.*" /E /I /Y /Q
	call install.bat
   	GOTO EXITROUTINE
:EXITROUTINE
	PAUSE
