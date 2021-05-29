/*******************************************************************************
 * OLUIFrontEnd_PauseMenu generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2021 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLUIFrontEnd_PauseMenu extends OLUIFrontEnd_Screen within OLUIFrontEnd
    config(UI);

var const localized string ReturnText;
var const localized string OptionsText;
var const localized string ExitToMenuText;
var const localized string SaveAndExitText;
var const localized string SaveText;
var const localized string ConfirmExitText;
var const localized string ConfirmExitInsaneText;
var const localized string ConfirmExitTitle;
var const localized string ExitToWindowsText;
var transient GFxClikWidget ButtonBar;
var transient bool bHasSaveOption;
var transient bool bShowingConfirmExitDialog;

function OnViewLoaded()
{
}

function OnTopMostView(optional bool bPlayOpenAnimation)
{
}

function PopulateButtons()
{
}

private final function OnButtonClick(EventData ev)
{
}

private final function OnReturnButtonPress(EventData ev)
{
}

private final function OnOptionsButtonPress(EventData ev)
{
}

private final function OnSaveButtonPress(EventData ev)
{
}

function OnSaveCompleted(bool bSuccess)
{
}

private final function OnExitToMenuButtonPress(EventData ev)
{
}

function OnExitConfirmed(bool bOk)
{
}

private final function ASShowConfirmExitDialog(string Title, string Message, string okButtonLabel, string cancelButtonLabel, string callbackName)
{
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
}

defaultproperties
{
    // Object Offset:0x002370BA
    ReturnText="Return To Game"
    OptionsText="Options"
    ExitToMenuText="Exit"
    SaveAndExitText="Save & Exit"
    SaveText="Save"
    ConfirmExitText="Are you sure you want to quit?"
    ConfirmExitInsaneText="All progress will be lost. Are you sure you want to quit?"
    ConfirmExitTitle="Exit?"
    ExitToWindowsText="Exit To Windows"
    SubWidgetBindings=/* Array type was not detected. */
}