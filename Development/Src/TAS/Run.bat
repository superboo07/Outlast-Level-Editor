@echo off
set /p ModName=<.\Compilier\Name

if not exist .\Output\%ModName% (
    Echo You need to compile your mod
)

if not exist ..\..\..\GlobalCompilierOptions\OutlastDir (
    Echo Please make an empty file in the folder "[LevelEditorRoot]\GlobalCompilierOptions" and name it "OutlastDir" then put the path to your outlast installation in it.
    exit
)

Set /p OutlastPath=<..\..\..\GlobalCompilierOptions\OutlastDir

if not exist "%OutlastPath%\Level_Launcher.bat" (
    Echo The Level_Launcher has not been installed
    exit
)
if not exist "%OutlastPath%\Custom" (
    Echo Your Outlast Install does not have a custom folder
    Exit
)
:Retry
if exist "%OutlastPath%\Custom\%ModName%" (
    Echo A mod with the same name is already there. are you sure you want to override it [Y/N]
    set /p c=
)
if /I "%C%" EQU "N" (
    Exit
)
if /I "%C%" EQU "y" (
    rmdir /Q /S "%OutlastPath%\Custom\%ModName%"
    goto CreateLink
)
if exist "%OutlastPath%\Custom\%ModName%" (
    goto Retry
)

:CreateLink
mklink /J %OutlastPath%\Custom\%ModName% Output\%ModName% > nul

for %%1 in ("%OutlastPath%") do (
    %%~d1
    cd %%1
)

call Level_Launcher.bat %ModName%
rmdir /Q /S %OutlastPath%\Custom\%ModName%