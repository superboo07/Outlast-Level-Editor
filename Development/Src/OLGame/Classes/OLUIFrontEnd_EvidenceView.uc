/*******************************************************************************
 * OLUIFrontEnd_EvidenceView generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2021 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLUIFrontEnd_EvidenceView extends OLUIFrontEnd_Screen within OLUIFrontEnd
    config(UI);

var name Collectible;
var transient GFxObject ContentsLabel;
var transient GFxClikWidget BackButton;
var transient GFxClikWidget CloseButton;
var transient GFxClikWidget PreviousButton;
var transient GFxClikWidget NextButton;
var bool bActivatedWithShortcut;

function OnViewLoaded()
{
}

function OnViewActivated()
{
}

function Press_Previous(EventData ev)
{
}

function Press_Next(EventData ev)
{
}

function Press_Back(EventData ev)
{
}

function Press_Close(EventData ev)
{
}

function GoBeforeFirstPage();

function GoAfterLastPage();

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
}

function ASPaginateText()
{
}

function ASNextPage()
{
}

function ASPreviousPage()
{
}

defaultproperties
{
    // Object Offset:0x0021C084
    SubWidgetBindings=/* Array type was not detected. */
}