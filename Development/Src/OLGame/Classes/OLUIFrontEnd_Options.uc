/*******************************************************************************
 * OLUIFrontEnd_Options generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2021 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLUIFrontEnd_Options extends OLUIFrontEnd_Screen within OLUIFrontEnd
    config(UI);

enum EOptionSelectorType
{
    OST_CheckBox,
    OST_Dropdown,
    OST_Slider,
    OST_KeyBinding,
    OST_ControllerConfigButton,
    OST_GammaButton,
    OST_MAX
};

enum ENonProfileOption
{
    NPO_None,
    NPO_DisableMotionBlur,
    NPO_Difficulty,
    NPO_MAX
};

enum EOptionTabs
{
    OT_Gameplay,
    OT_Graphics,
    OT_Controls,
    OT_MAX
};

struct OptionInfo
{
    var bool bInProfile;
    var int ProfileSettingId;
    var OLUIFrontEnd_Options.ENonProfileOption NonProfileId;
    var const localized string SettingDescription;
    var const localized string SettingTooltip;
    var OLUIFrontEnd_Options.EOptionSelectorType Type;
    var bool bUsesRawValue;
    var float Slider_Minimum;
    var float Slider_Maximum;
    var transient int CurrentValueInt;
    var transient float CurrentValueFloat;
    var transient string CurrentValueString;

    structdefaultproperties
    {
        // Object Offset:0x00224358
        bInProfile=true
        ProfileSettingId=0
        NonProfileId=ENonProfileOption.NPO_None
        SettingDescription=""
        SettingTooltip=""
        Type=EOptionSelectorType.OST_CheckBox
        bUsesRawValue=false
        Slider_Minimum=0.0
        Slider_Maximum=0.0
        CurrentValueInt=0
        CurrentValueFloat=0.0
        CurrentValueString=""
    }
};

var transient OLProfileSettings MyProfile;
var UniqueNetId OwningId;
var OnlineSubsystem OnlineSub;
var const localized string MouseSettingsText;
var const localized string MouseInvertYText;
var const localized string MouseSensitivityText;
var const localized string ApplyText;
var const localized string GammaText;
var const localized string ResetText;
var const localized string GameplayText;
var const localized string GraphicsText;
var const localized string ControlsText;
var const localized string ConfirmResolutionTitleText;
var const localized string ConfirmResolutionMessageText;
var const localized string ConfirmChangesTitleText;
var const localized string ConfirmChangesMessageText;
var const localized string KeyBindingConflictTitleText;
var const localized string KeyBindingConflictMessageText;
var const localized string MustRestartTitleText;
var const localized string MustRestartMessageText;
var const localized string OKText;
var const localized string CancelText;
var const localized array<localized string> DifficultyOptions;
var GFxClikWidget ApplyButton;
var GFxClikWidget BackButton;
var GFxClikWidget ResetButton;
var transient GFxClikWidget TabButtons;
var transient GFxObject GameplayList;
var transient GFxObject GraphicsList;
var transient GFxObject ControlsList;
var int PreviousResolutionSetting;
var int PreviousFullscreenSetting;
var bool bWaitingForPopup;
var transient bool bSwitchingFromJpn;
var array<name> OriginalResolutionValueNames;
var array<name> DisplayedResolutionValueNames;
var array<OptionInfo> GeneralOptionsWithDifficulty;
var array<OptionInfo> GeneralOptionsNoDifficulty;
var array<OptionInfo> GraphicsOptions;
var array<OptionInfo> ControlsOptions;
var OLUIFrontEnd_Options.EOptionTabs CurrentTab;

function OnViewLoaded()
{
}

function OnViewActivated()
{
}

function bool back()
{
}

function ExitOptionsScreen()
{
}

function OnMustRestartAccepted()
{
}

function Press_Apply(EventData ev)
{
}

function OnDismissKeyBindingConflictDialog(bool bOk)
{
}

function OnConfirmResolution(bool bOk)
{
}

function RevertToPreviousResolution()
{
}

function OnConfirmChanges(bool bOk)
{
}

function Press_Back(EventData ev)
{
}

function Press_Gamma(EventData ev)
{
}

function Press_Reset(EventData ev)
{
}

function Press_OptionItemButton(int PSID)
{
}

function bool UseGeneralOptionsWithDifficulty()
{
}

function PopulateTabButtons()
{
}

function GFxObject GetObjectFromOption(OptionInfo CurrentOptionInfo)
{
}

function PopulateGeneralOptions()
{
}

function PopulateGraphicsOptions()
{
}

function PopulateControlsOptions()
{
}

function FillOptionValuesFromProfile()
{
}

function FillOptionValuesForList(out array<OptionInfo> OptionInfos)
{
}

function SetDefaultOptionValuesForList(out array<OptionInfo> OptionInfos)
{
}

function float GetOptionValueAt(GFxObject OptionsList, int Index)
{
}

function string GetOptionValueStringAt(GFxObject OptionsList, int Index)
{
}

function StoreOptionValuesForList(GFxObject OptionsList, out array<OptionInfo> OptionInfos)
{
}

function TabChanged(EventData ev)
{
}

function bool SaveSettingsForList(array<OptionInfo> OptionInfos)
{
}

function bool HasPropertyChangedInList(GFxObject OptionsList, array<OptionInfo> OptionInfos)
{
}

function bool HasAnyPropertyChanged()
{
}

function bool SaveSettingsToProfile()
{
}

function OLProfileSettings GetOLProfile()
{
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
}

function bool HasResolutionChanged()
{
}

function int GetResolutionOptionIndex()
{
}

function int GetFullscreenOptionIndex()
{
}

function array<name> RemoveUnsupportedResolutionsFromList(array<name> OriginalList)
{
}

function int GetOriginalResolutionIndexFromDisplayedIndex(int DisplayedIndex)
{
}

function int GetDisplayedResolutionIndexFromOriginalIndex(int OriginalIndex)
{
}

function OnKeyBindingCaptured(name KeyName)
{
}

function int GetGamepadConfig()
{
}

function SetGamepadConfigExternally(int ConfigIndex)
{
}

function SetGammaExternally(float Gamma)
{
}

function GFxObject GetCurrentGFxList()
{
}

function array<string> GetKeyBindingConflicts()
{
}

function OnSliderChanged(int ProfileSettingId, float SliderValue)
{
}

function float GetCurrentGammaSetting()
{
}

private final function ShowResolutionConfirmationDialogAfterDelay(string Title, string Message, string okButtonLabel, string cancelButtonLabel, string callbackName)
{
}

private final function ShowChangeConfirmationDialog(string Title, string Message, string okButtonLabel, string cancelButtonLabel, string callbackName)
{
}

private final function ShowKeyBindingConflictDialog(string Title, string Message, string okButtonLabel, string cancelButtonLabel, string callbackName)
{
}

private final function ShowMessageDialog(string Title, string Message, string okButtonLabel, string callbackName)
{
}

private final function ASOnKeyBindingCaptured(string KeyName)
{
}

defaultproperties
{
    // Object Offset:0x0022A412
    ApplyText="Apply"
    GammaText="Adjust Gamma"
    ResetText="Restore Defaults"
    GameplayText="General"
    GraphicsText="Graphics"
    ControlsText="Controls"
    ConfirmResolutionTitleText="Confirm Resolution Change"
    ConfirmResolutionMessageText="Do you want to keep this resolution setting?"
    ConfirmChangesTitleText="Confirm Changes"
    ConfirmChangesMessageText="Do you want to keep these settings?"
    KeyBindingConflictTitleText="Conflicting Key Bindings!"
    KeyBindingConflictMessageText="Please make sure these keys are only bound to a single action:"
    MustRestartTitleText="Restart Required"
    MustRestartMessageText="The game must be restarted for this change to take effect."
    OKText="OK"
    CancelText="Cancel"
    DifficultyOptions(0)="Normal"
    DifficultyOptions(1)="Hard"
    DifficultyOptions(2)="Nightmare"
    GeneralOptionsWithDifficulty(0)=(bInProfile=true,ProfileSettingId=61,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Language",SettingTooltip="",Type=EOptionSelectorType.OST_Dropdown,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsWithDifficulty(1)=(bInProfile=false,ProfileSettingId=0,NonProfileId=ENonProfileOption.NPO_Difficulty,SettingDescription="Difficulty",SettingTooltip="",Type=EOptionSelectorType.OST_Dropdown,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsWithDifficulty(2)=(bInProfile=true,ProfileSettingId=59,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Show Tutorials",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsWithDifficulty(3)=(bInProfile=true,ProfileSettingId=60,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Show Crosshair",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsWithDifficulty(4)=(bInProfile=true,ProfileSettingId=64,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Show Prompts",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsWithDifficulty(5)=(bInProfile=true,ProfileSettingId=2,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Invert Up Axis",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsWithDifficulty(6)=(bInProfile=true,ProfileSettingId=66,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Southpaw",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsWithDifficulty(7)=(bInProfile=true,ProfileSettingId=63,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Toggle Crouch",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsWithDifficulty(8)=(bInProfile=true,ProfileSettingId=13,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Look Sensitivity",SettingTooltip="",Type=EOptionSelectorType.OST_Slider,bUsesRawValue=false,Slider_Minimum=1.0,Slider_Maximum=100.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsWithDifficulty(9)=(bInProfile=true,ProfileSettingId=35,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Controller Configuration",SettingTooltip="",Type=EOptionSelectorType.OST_ControllerConfigButton,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsWithDifficulty(10)=(bInProfile=true,ProfileSettingId=1,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Controller Vibration",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsWithDifficulty(11)=(bInProfile=true,ProfileSettingId=58,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Show Subtitles",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsWithDifficulty(12)=(bInProfile=true,ProfileSettingId=57,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Volume",SettingTooltip="",Type=EOptionSelectorType.OST_Slider,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=1.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsNoDifficulty(0)=(bInProfile=true,ProfileSettingId=61,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Language",SettingTooltip="",Type=EOptionSelectorType.OST_Dropdown,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsNoDifficulty(1)=(bInProfile=true,ProfileSettingId=59,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Show Tutorials",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsNoDifficulty(2)=(bInProfile=true,ProfileSettingId=60,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Show Crosshair",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsNoDifficulty(3)=(bInProfile=true,ProfileSettingId=64,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Show Prompts",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsNoDifficulty(4)=(bInProfile=true,ProfileSettingId=2,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Invert Up Axis",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsNoDifficulty(5)=(bInProfile=true,ProfileSettingId=66,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Southpaw",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsNoDifficulty(6)=(bInProfile=true,ProfileSettingId=63,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Toggle Crouch",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsNoDifficulty(7)=(bInProfile=true,ProfileSettingId=13,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Look Sensitivity",SettingTooltip="",Type=EOptionSelectorType.OST_Slider,bUsesRawValue=false,Slider_Minimum=1.0,Slider_Maximum=100.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsNoDifficulty(8)=(bInProfile=true,ProfileSettingId=35,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Controller Configuration",SettingTooltip="",Type=EOptionSelectorType.OST_ControllerConfigButton,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsNoDifficulty(9)=(bInProfile=true,ProfileSettingId=1,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Controller Vibration",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsNoDifficulty(10)=(bInProfile=true,ProfileSettingId=58,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Show Subtitles",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GeneralOptionsNoDifficulty(11)=(bInProfile=true,ProfileSettingId=57,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Volume",SettingTooltip="",Type=EOptionSelectorType.OST_Slider,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=1.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GraphicsOptions(0)=(bInProfile=true,ProfileSettingId=29,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Textures",SettingTooltip="",Type=EOptionSelectorType.OST_Dropdown,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GraphicsOptions(1)=(bInProfile=true,ProfileSettingId=30,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Shadows",SettingTooltip="",Type=EOptionSelectorType.OST_Dropdown,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GraphicsOptions(2)=(bInProfile=true,ProfileSettingId=31,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Effects",SettingTooltip="",Type=EOptionSelectorType.OST_Dropdown,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GraphicsOptions(3)=(bInProfile=false,ProfileSettingId=0,NonProfileId=ENonProfileOption.NPO_DisableMotionBlur,SettingDescription="Disable Motion Blur",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GraphicsOptions(4)=(bInProfile=true,ProfileSettingId=32,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="VSync",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GraphicsOptions(5)=(bInProfile=true,ProfileSettingId=33,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="FullScreen",SettingTooltip="",Type=EOptionSelectorType.OST_CheckBox,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GraphicsOptions(6)=(bInProfile=true,ProfileSettingId=34,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Resolution",SettingTooltip="",Type=EOptionSelectorType.OST_Dropdown,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    GraphicsOptions(7)=(bInProfile=true,ProfileSettingId=28,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Gamma",SettingTooltip="",Type=EOptionSelectorType.OST_GammaButton,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(0)=(bInProfile=true,ProfileSettingId=36,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Move Forward",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(1)=(bInProfile=true,ProfileSettingId=37,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Move Backward",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(2)=(bInProfile=true,ProfileSettingId=40,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Strafe Left",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(3)=(bInProfile=true,ProfileSettingId=41,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Strafe Right",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(4)=(bInProfile=true,ProfileSettingId=38,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Turn Left",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(5)=(bInProfile=true,ProfileSettingId=39,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Turn Right",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(6)=(bInProfile=true,ProfileSettingId=42,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Crouch",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(7)=(bInProfile=true,ProfileSettingId=43,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Use",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(8)=(bInProfile=true,ProfileSettingId=44,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Run",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(9)=(bInProfile=true,ProfileSettingId=45,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Toggle Camcorder",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(10)=(bInProfile=true,ProfileSettingId=46,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Toggle Nightvision",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(11)=(bInProfile=true,ProfileSettingId=47,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Lean Left",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(12)=(bInProfile=true,ProfileSettingId=48,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Lean Right",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(13)=(bInProfile=true,ProfileSettingId=49,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Zoom Camera In",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(14)=(bInProfile=true,ProfileSettingId=50,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Zoom Camera Out",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(15)=(bInProfile=true,ProfileSettingId=51,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Reload Batteries",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(16)=(bInProfile=true,ProfileSettingId=52,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Jump",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(17)=(bInProfile=true,ProfileSettingId=53,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Show Escape Menu",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(18)=(bInProfile=true,ProfileSettingId=54,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Show Reporter's Notebook",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(19)=(bInProfile=true,ProfileSettingId=55,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Show Notes",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    ControlsOptions(20)=(bInProfile=true,ProfileSettingId=56,NonProfileId=ENonProfileOption.NPO_None,SettingDescription="Show Documents",SettingTooltip="",Type=EOptionSelectorType.OST_KeyBinding,bUsesRawValue=false,Slider_Minimum=0.0,Slider_Maximum=0.0,CurrentValueInt=0,CurrentValueFloat=0.0,CurrentValueString="")
    SubWidgetBindings=/* Array type was not detected. */
}