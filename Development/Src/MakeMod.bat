@echo off

echo Please enter the name of your mod
Set /p ModName=

if exist .\%ModName%\ (
    echo This mod already exists.
    TIMEOUT /T 3 /nobreak > NUL
    exit
)

mkdir .\%ModName%\
mkdir .\%ModName%\Classes
mkdir .\%ModName%\Src
mkdir .\%ModName%\Src\Config
mkdir .\%ModName%\Src\Localization
mkdir .\%ModName%\Compilier\

:Config
echo Config=true >> .\%ModName%\Src\Config.ini
goto Content

:Content
echo Does your mod include custom Content files[Y/N]
set /p c=

if /I "%C%" EQU "Y" echo Content=true >> .\%ModName%\Src\Config.ini & goto Localization
if /I "%C%" EQU "N" echo Content=false >> .\%ModName%\Src\Config.ini & goto Localization
goto Content

:Localization
echo Does your mod include custom Localization files[Y/N]
set /p c=

if /I "%C%" EQU "Y" echo Localization=true >> .\%ModName%\Src\Config.ini & goto BuildCompilier
if /I "%C%" EQU "N" echo Localization=false >> .\%ModName%\Src\Config.ini & goto BuildCompilier
goto Localization

:BuildCompilier
echo %ModName%>.\%ModName%\Compilier\Name
echo. > .\%ModName%\Compilier\Scripts
echo. > .\%ModName%\Compilier\Content
robocopy ./MakeModSrcFiles .\%ModName%\ Compile
ren .\%ModName%\Compile Compile.bat
robocopy ./MakeModSrcFiles .\%ModName%\src\Config DefaultEngine
ren \%ModName%\src\Config\DefaultEngine DefaultEngine.ini

robocopy ./MakeModSrcFiles .\%ModName%\ VSCodeWorkspace
ren .\%ModName%\VSCodeWorkspace %ModName%.code-workspace
mkdir \%ModName%\.vscode
robocopy ./MakeModSrcFiles .\%ModName%\.vscode tasks
ren .\%ModName%\.vscode\tasks tasks.json