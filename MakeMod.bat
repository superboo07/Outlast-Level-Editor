@echo off

echo Please enter the name of your mod
Set /p ModName=

if exist .\Development\Src\%ModName%\ (
    echo This mod already exists.
    TIMEOUT /T 3 /nobreak > NUL
    exit
)

mkdir .\Development\Src\%ModName%\
mkdir .\Development\Src\%ModName%\Classes
mkdir .\Development\Src\%ModName%\Src
mkdir .\Development\Src\%ModName%\Src\Config
mkdir .\Development\Src\%ModName%\Src\Localization
mkdir .\Development\Src\%ModName%\Compilier\

:Config
echo Config=true >> .\Development\Src\%ModName%\Src\Config.ini
goto Content

:Content
echo Does your mod include custom Content files[Y/N]
set /p c=

if /I "%C%" EQU "Y" echo Content=true >> .\Development\Src\%ModName%\Src\Config.ini & goto Localization
if /I "%C%" EQU "N" echo Content=false >> .\Development\Src\%ModName%\Src\Config.ini & goto Localization
goto Content

:Localization
echo Does your mod include custom Localization files[Y/N]
set /p c=

if /I "%C%" EQU "Y" echo Localization=true >> .\Development\Src\%ModName%\Src\Config.ini & goto SaveData
if /I "%C%" EQU "N" echo Localization=false >> .\Development\Src\%ModName%\Src\Config.ini & goto SaveData
goto Localization

:SaveData
echo Does your mod need seperated SaveData [Y/N]
set /p c=

if /I "%C%" EQU "Y" echo SaveData=true >> .\Development\Src\%ModName%\Src\Config.ini & goto Convert
if /I "%C%" EQU "N" echo SaveData=false >> .\Development\Src\%ModName%\Src\Config.ini & goto Convert
goto SaveData

:Convert
echo Do you want to automatically convert imported files to the OL naming scheme [Y/N]
set /p c=

if /I "%C%" EQU "Y" echo Convert=true >> .\Development\Src\%ModName%\Compilier\Options & goto BuildCompilier
if /I "%C%" EQU "N" echo Convert=false >> .\Development\Src\%ModName%\Compilier\Options & goto BuildCompilier
goto Convert

:BuildCompilier
echo %ModName%>.\Development\Src\%ModName%\Compilier\Name
echo. %ModName%> .\Development\Src\%ModName%\Compilier\Scripts
echo. > .\Development\Src\%ModName%\Compilier\Content

robocopy ./MakeModSrcFiles .\Development\Src\%ModName%\ Compile
ren .\Development\Src\%ModName%\Compile Compile.bat

robocopy ./MakeModSrcFiles .\Development\Src\%ModName%\ Recompile
ren .\Development\Src\%ModName%\Recompile Recompile.bat

robocopy ./MakeModSrcFiles .\Development\Src\%ModName%\ Run
ren .\Development\Src\%ModName%\Run Run.bat

robocopy ./MakeModSrcFiles .\Development\Src\%ModName%\src\Config DefaultEngine
ren .\Development\Src\%ModName%\src\Config\DefaultEngine DefaultEngine.ini

robocopy ./MakeModSrcFiles .\Development\Src\%ModName%\ VSCodeWorkspace
ren .\Development\Src\%ModName%\VSCodeWorkspace %ModName%.code-workspace
mkdir \Development\Src\%ModName%\.vscode
robocopy ./MakeModSrcFiles .\Development\Src\%ModName%\.vscode tasks
ren .\Development\Src\%ModName%\.vscode\tasks tasks.json
echo.Development/Src/%ModName%/Output >> .gitignore
pause