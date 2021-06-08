@echo off
set /p ModName=<.\Compilier\Name
..\..\..\Binaries\Win32\UDK.com make

:: Make directorys if they do not exist
if not exist "Output" mkdir Output > nul
if not exist "Output\%ModName%\" mkdir Output\%ModName%\ > nul
if not exist "Output\%ModName%\Content" mkdir Output\%ModName%\Content > nul
if not exist "Output\%ModName%\Config" mkdir Output\%ModName%\Config > nul
if not exist "Output\%ModName%\Localization" mkdir Output\%ModName%\Localization > nul

for /F "tokens=1 delims=" %%a in (.\Compilier\Scripts) do (
	if exist "Output\%ModName%\Content\%%a.OLScript" del Output\%ModName%\Content\%%a.OLScript
    robocopy ..\..\..\UDKGame\Script\ Output\%ModName%\Content %%a.u > nul
    Ren Output\%ModName%\Content\%%a.u %%a.OLScript
)

for /F "tokens=1 delims=" %%a in (.\Compilier\Content) do (
    if exist "Output\%ModName%\Content\%%~nxa" del Output\%ModName%\Content\%%~nxa
    robocopy ..\..\..\UDKGame\Content%%~pa Output\%ModName%\Content\ %%~nxa > nul
)

robocopy /MIR Src\Config\ Output\%ModName%\Config > nul
robocopy /MIR Src\Localization\ Output\%ModName%\Localization > nul

if exist "Output\%ModName%\Config.ini" del Output\%ModName%\Config.ini
robocopy Src\ Output\%ModName%\ Config.ini > nul