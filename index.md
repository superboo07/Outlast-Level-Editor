<img src="/Repository/Header.png" width=100% object-fit=fill>

# Requirements

Windows

UDK: https://drive.google.com/file/d/1IZed_3QAivpnU2uPlSClFVs-YOZrIpcd/view?usp=sharing

Outlast (Obviously): https://store.steampowered.com/app/238320/Outlast/



# Install

## Clone the repository. 

For those who don't want to use github desktop, 

Navigate to the directory you want to clone the repository to, then type the following commands into the command line.

`git clone https://github.com/superboo07/Outlast-Level-Editor.git`

To update the repository type

`git fetch https://github.com/superboo07/Outlast-Level-Editor.git`

## UDK
First you must launch the UDK installer you downloaded above, or use an installer you downloaded from somewhere else. Make sure not to install it in the same directory you cloned the repository to. The project name doesn't matter. I recommend you start with an empty project, and don't install preforce. You won't need anything it creates except the binaries folder, so no use in installing unreal tournament content. 

<img src="Repository\SETUP\Installer_1.png" width=50% object-fit=fill><img src="Repository\SETUP\Installer_2.png" width=50% object-fit=fill>

When the install finishes, navigate to where you installed it, and copy the folder named `binaries` then paste it into the cloned repository. Now navigate into the binaries folder, and launch the application named `UnrealFrontend.exe`. The compile the scripts, using the button labled `Script`.

<img src="Repository\SETUP\UnrealFrontend_01.png" width=50% object-fit=fill>

Now launch the editor using the UnrealEd button.

## VS Code Stuff

Under normal circumstances you shouldn't need to use unreal script, but I've included an Visual Studio Code Workspace, for those who do. 
The workspace also includes build tasks that allow you to compile, and launch the editor.

P.S If you use Visual Studio Code, I highly recommend using the unreal script plugin by Eliot, it's really good, and makes programming in unreal script way easier. 
https://marketplace.visualstudio.com/items?itemName=EliotVU.uc
