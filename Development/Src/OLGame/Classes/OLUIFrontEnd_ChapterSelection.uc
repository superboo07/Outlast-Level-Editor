/*******************************************************************************
 * OLUIFrontEnd_ChapterSelection generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2021 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLUIFrontEnd_ChapterSelection extends OLUIFrontEnd_Screen within OLUIFrontEnd
    config(UI);

var const localized string ChapterSelectionTitle;
var const localized string LoadText;
var int SelectedIndex;
var transient array<string> SelectionNames;
var transient array<string> SelectionCPs;
var const array<string> MainChapters;
var const array<string> MainCPs;
var const array<string> DLCChapters;
var const array<string> DLCCPs;
var transient GFxClikWidget ChapterList;
var transient GFxClikWidget BackButton;
var transient GFxClikWidget LoadButton;
var transient GFxObject TitleLabel;

function OnTopMostView(optional bool bPlayOpenAnimation)
{
}

function OnViewDeactivated();

function Pop()
{
}

function PopulateChapterList()
{
}

function ChapterListChanged(EventData ev)
{
}

function SetSelectedIndex(int Index)
{
}

function LoadSelectedChapter()
{
}

private final function Press_Load(EventData ev)
{
}

function Press_Back(EventData ev)
{
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
}

defaultproperties
{
    // Object Offset:0x00217519
    ChapterSelectionTitle="Chapters"
    LoadText="Select"
    MainChapters(0)="Admin"
    MainChapters(1)="Prison"
    MainChapters(2)="Sewer"
    MainChapters(3)="Male"
    MainChapters(4)="Courtyard"
    MainChapters(5)="Female"
    MainChapters(6)="AdminRevisit"
    MainChapters(7)="Lab"
    MainCPs(0)="StartGame"
    MainCPs(1)="Prison_Start"
    MainCPs(2)="Sewer_Start"
    MainCPs(3)="Male_Start"
    MainCPs(4)="Courtyard_Start"
    MainCPs(5)="Female_Start"
    MainCPs(6)="Revisit_Soldier1"
    MainCPs(7)="Lab_Start"
    DLCChapters(0)="DLC_Lab"
    DLCChapters(1)="DLC_Hospital"
    DLCChapters(2)="DLC_Courtyard1"
    DLCChapters(3)="DLC_Prison"
    DLCChapters(4)="DLC_Courtyard2"
    DLCChapters(5)="DLC_Building2"
    DLCChapters(6)="DLC_Exit"
    DLCCPs(0)="DLC_Start"
    DLCCPs(1)="Hospital_Start"
    DLCCPs(2)="Courtyard1_Start"
    DLCCPs(3)="PrisonRevisit_Start"
    DLCCPs(4)="Courtyard2_Start"
    DLCCPs(5)="Building2_Start"
    DLCCPs(6)="MaleRevisit_Start"
    SubWidgetBindings=/* Array type was not detected. */
}