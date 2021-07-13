@echo off
set /p ModName=<.\Compilier\Name
echo -------------------
echo -Compiling Scripts-
echo -------------------
echo.
..\..\..\Binaries\Win32\UDK.com make
echo.
if ERRORLEVEL 1 (
	Echo Failed to Compile Mod & goto Exit
)
set config=False
set Localization=False
set Content=False

:: Make directorys if they do not exist
if not exist "Output" mkdir Output > nul & Echo Create Output directory
if not exist "Output\%ModName%\" mkdir Output\%ModName%\ > nul

for /f "tokens=1,2 delims==" %%a in (.\Src\config.ini) do (
	if /i %%a==Config set Config=%%b 
	if /i %%a==Localization set Localization=%%b
	if /i %%a==Content set Content=%%b
)

echo --------------------
echo -Mounting Mod files-
echo --------------------
echo.

if not exist ".\Compilier\Options" goto Begin

for /f "tokens=1,2 delims==" %%a in (.\Compilier\Options) do (
	if /I %%a==Convert set Convert=%%b 
)

:Begin
if /I %Content%==True (
	if not exist "Output\%ModName%\Content" mkdir Output\%ModName%\Content > nul & Echo Create Content Directory
	
	Echo -Mounting Scripts-
	for /F "tokens=1 delims=" %%a in (.\Compilier\Scripts) do (
		call 
		if exist Output\%ModName%\Content\%%a.OLScript del Output\%ModName%\Content\%%a.OLScript
		robocopy ..\..\..\UDKGame\Script\ Output\%ModName%\Content %%a.u > nul

		if /I %Convert%==true (
			Ren Output\%ModName%\Content\%%a.u %%a.OLScript
		)

		if ERRORLEVEL 3 (
			Echo Failed to Mount Script %%a & goto Exit
		) 
		Echo. Mounted %%a
	)

	if not exist Compilier\Content goto CopyConfig
	Echo.
	Echo -Mounting Content-
	for /F "tokens=1 delims=" %%a in (.\Compilier\Content) do (
		if exist Output\%ModName%\Content\%%~nxa del Output\%ModName%\Content\%%~nxa
		if /I %Convert%==true (
			if exist Output\%ModName%\Content\%%~na.OLContent del Output\%ModName%\Content\%%~na.OLContent
		)
		call 
		robocopy ..\..\..\UDKGame\Content\%%~pa Output\%ModName%\Content\ %%~nxa > nul

		if /I %Convert%==true ren Output\%ModName%\Content\%%~nxa %%~na.OLContent

		if ERRORLEVEL 3 (
			Echo Failed to Mount Content %%a & goto Exit
		)
		Echo. Mounted %%~nxa
	)
)

:CopyConfig

if /I %Config%==True (
	echo.
	echo -Mounting Configs-
	if not exist Output\%ModName%\Config mkdir Output\%ModName%\Config > nul
	robocopy /MIR Src\Config\ Output\%ModName%\Config > nul
	if ERRORLEVEL 3 (
		Echo Failed to Mount Configs & goto Exit
	)
	echo. Mounted Configs
)

:CopyLocalization

if /I %Localization%==True (
	if not exist Output\%ModName%\Localization mkdir Output\%ModName%\Localization > nul
	robocopy /MIR Src\Localization\ Output\%ModName%\Localization > nul
	if ERRORLEVEL 3 (
		Echo Failed to Mount Localization & goto Exit
	)
	echo.
	Echo. Mounted Localization
)

if exist Output\%ModName%\Config.ini del Output\%ModName%\Config.ini
robocopy Src .\Output\%ModName% Config.ini > nul

echo.
Echo %ModName% Compiled Successfully

:Exit
TIMEOUT /T 3 /nobreak > NUL