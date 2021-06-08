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

if /I "%C%" EQU "Y" echo Localization=true >> .\Development\Src\%ModName%\Src\Config.ini & goto BuildCompilier
if /I "%C%" EQU "N" echo Localization=false >> .\Development\Src\%ModName%\Src\Config.ini & goto BuildCompilier
goto Localization

:BuildCompilier
echo %ModName%>.\Development\Src\%ModName%\Compilier\Name
echo. > .\Development\Src\%ModName%\Compilier\Scripts
echo. > .\Development\Src\%ModName%\Compilier\Content
robocopy ./MakeModSrcFiles .\Development\Src\%ModName%\ Compile
ren .\Development\Src\%ModName%\Compile Compile.bat
robocopy ./MakeModSrcFiles .\Development\Src\%ModName%\src\Config DefaultEngine
ren .\Development\Src\%ModName%\src\Config\DefaultEngine DefaultEngine.ini

robocopy ./MakeModSrcFiles .\Development\Src\%ModName%\ VSCodeWorkspace
ren .\Development\Src\%ModName%\VSCodeWorkspace %ModName%.code-workspace
mkdir \Development\Src\%ModName%\.vscode
robocopy ./MakeModSrcFiles .\Development\Src\%ModName%\.vscode tasks
ren .\Development\Src\%ModName%\.vscode\tasks tasks.json