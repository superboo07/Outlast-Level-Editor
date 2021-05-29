/*******************************************************************************
 * OLUIFrontEnd_Screen generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2021 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLUIFrontEnd_Screen extends OLUIFrontEnd_View within OLUIFrontEnd
    config(UI);

var config string ViewTitle;
var const localized string BackText;
var const localized string EnterText;
var const localized string YesText;
var const localized string NoText;
var const localized string CloseText;
var const localized string AcceptText;
var transient GFxObject CircleLabel;
var transient GFxObject CrossLabel;

function bool IsTopMostView()
{
}

function bool IsDemo()
{
}

function bool IsDLCInstalled()
{
}

function string LocalizeNarrative(string SectionName, string KeyName)
{
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
}

defaultproperties
{
    // Object Offset:0x0021621A
    BackText="Back"
    EnterText="Enter"
    YesText="Yes"
    NoText="No"
    CloseText="Close"
    AcceptText="Accept"
}