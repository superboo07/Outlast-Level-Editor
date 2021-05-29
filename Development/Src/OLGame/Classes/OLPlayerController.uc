/**
 * Copyright 1998-2013 Epic Games, Inc. All Rights Reserved.
 */
class OLPlayerController extends GamePlayerController
    native
	config(Game);


enum EPlayerInteractionType
{
    PIT_CSA,
    PIT_PickupObject,
    PIT_BatteriesFull,
    PIT_EnterBed,
    PIT_EnterLocker,
    PIT_ExitLocker,
    PIT_OpenDoor,
    PIT_OpenPartiallyOpenDoor,
    PIT_CloseDoor,
    PIT_LockedDoor,
    PIT_AutoCloseDoor,
    PIT_ClimbUpLedge,
    PIT_ReloadBatteries,
    PIT_Struggle,
    PIT_PushObject,
    PIT_MAX
};

enum ZoomMovementType
{
    Zoom_Undefined,
    Zoom_MovingLeft,
    Zoom_NotMoving,
    Zoom_MovingRight,
    Zoom_MAX
};

enum StruggleInputDirection
{
    SID_Undefined,
    SID_Left,
    SID_Right,
    SID_MAX
};

enum EAIMusicState
{
    EAIMS_None,
    EAIMS_Patrol,
    EAIMS_Investigate,
    EAIMS_Chase,
    EAIMS_MAX
};

enum EOutlastAchievement
{
    OA_000_StartedGenerator,
    OA_001_DrainedSewer,
    OA_002_StartedSprinklers,
    OA_003_FoundFemaleWardKey,
    OA_004_MilestoneCollectibles,
    OA_005_FinishedGame,
    OA_006_AllCollectibles,
    OA_007_FinishedNightmare,
    OA_008_TurnOffGas,
    OA_009_TurnOffPower,
    OA_010_FinishDLC,
    OA_011_FinishDLCInsane,
    OA_012_AllDLCDocs,
    OA_013_AllDLCRecordings,
    OA_MAX
};

struct native DigitalInputs
{
    var bool bPerformedUseAction;
    var bool bPressedUseButton;
    var bool bReleasedUseButton;
    var bool bPressedToggleCamcorder;
    var bool bPressedToggleNightVision;
    var bool bPressedZoomIn;
    var bool bPressedZoomOut;
    var bool bPressedJump;
    var bool bPressedReloadBatteries;
    var bool bStartedActiveZoom;

    structdefaultproperties
    {
        // Object Offset:0x03456D3B
        bPerformedUseAction=false
        bPressedUseButton=false
        bReleasedUseButton=false
        bPressedToggleCamcorder=false
        bPressedToggleNightVision=false
        bPressedZoomIn=false
        bPressedZoomOut=false
        bPressedJump=false
        bPressedReloadBatteries=false
        bStartedActiveZoom=false
    }
};

struct native TouchZoomData
{
    var float bActive;
    var float SmoothedPosition;
    var OLPlayerController.ZoomMovementType CurrentDirection;
    var float LastPosition;
    var float LastInputTime;

    structdefaultproperties
    {
        // Object Offset:0x034574EB
        bActive=0.0
        SmoothedPosition=0.0
        CurrentDirection=ZoomMovementType.Zoom_Undefined
        LastPosition=0.0
        LastInputTime=0.0
    }
};

struct native CheckpointRecord
{
    var int CheckpointRecordVersion;
    var int NumBatteries;
    var name CurrentObjective;
    var array<name> CompletedObjectives;
    var array<name> CompletedRecordingMoments;
    var array<name> UnreadRecordingMoments;
    var array<name> ActivatedGameState;
    var array<name> CollectedDocuments;
    var array<name> UnreadDocuments;
    var array<Vector> CollectedBatteries;
    var bool bBatteryTutorialComplete;
    var bool bClimbUpTutorialComplete;
    var bool bDocumentTutorialComplete;
    var bool bFoundBySoldierWhileHidden;
    var bool bFoundBySurgeonWhileHidden;
    var float RecordingTimeSeconds;
    var int DifficultyMode;
    var float BatteryEnergy;

    structdefaultproperties
    {
        // Object Offset:0x034553F2
        CheckpointRecordVersion=0
        NumBatteries=0
        CurrentObjective=None
        CompletedObjectives=none
        CompletedRecordingMoments=none
        UnreadRecordingMoments=none
        ActivatedGameState=none
        CollectedDocuments=none
        UnreadDocuments=none
        CollectedBatteries=none
        bBatteryTutorialComplete=false
        bClimbUpTutorialComplete=false
        bDocumentTutorialComplete=false
        bFoundBySoldierWhileHidden=false
        bFoundBySurgeonWhileHidden=false
        RecordingTimeSeconds=0.0
        DifficultyMode=0
        BatteryEnergy=0.0
    }
};

struct native DeprecatedCheckpointRecord
{
    var int NumBatteries;
    var name CurrentObjective;
    var array<name> CompletedObjectives;
    var array<name> CompletedRecordingMoments;
    var array<name> UnreadRecordingMoments;
    var array<name> ActivatedGameState;
    var array<name> CollectedDocuments;
    var array<name> UnreadDocuments;
    var array<Vector> CollectedBatteries;
    var bool bBatteryTutorialComplete;
    var bool bClimbUpTutorialComplete;
    var bool bDocumentTutorialComplete;
    var bool bFoundBySoldierWhileHidden;
    var bool bFoundBySurgeonWhileHidden;
    var float RecordingTimeSeconds;

    structdefaultproperties
    {
        // Object Offset:0x0345586F
        NumBatteries=0
        CurrentObjective=None
        CompletedObjectives=none
        CompletedRecordingMoments=none
        UnreadRecordingMoments=none
        ActivatedGameState=none
        CollectedDocuments=none
        UnreadDocuments=none
        CollectedBatteries=none
        bBatteryTutorialComplete=false
        bClimbUpTutorialComplete=false
        bDocumentTutorialComplete=false
        bFoundBySoldierWhileHidden=false
        bFoundBySurgeonWhileHidden=false
        RecordingTimeSeconds=0.0
    }
};

var OLHero HeroPawn;
var OLHUD HUD;
var OLInventoryManager InventoryManager;
var OLTutorialManager TutorialManager;
var OLSoundEnvironmentManager SoundEnvManager;
var OLFXManager FXManager;
var OLSeqAct_SplashScreen ActiveSplashScreen;
var bool bFlushingStreaming;
var bool bHasCamcorder;
var bool bBlockedOnLoading;
var bool bShowingKismetControlledLoadingScreen;
var bool bShowingLoadingOverlay;
var bool bProfileSettingsUpdated;
var bool bValidDoorHold;
var bool bInvalidateLeanInput;
var bool bInvalidateReleasedUse;
var bool bToggleCrouch;
var bool bOverriddenMusic;
var bool bTravellingToCheckpoint;
var bool bTravelCheckPersistent;
var bool bForceLevelReset;
var bool bFoundBySoldierWhileHidden;
var bool bFoundBySurgeonWhileHidden;
var config bool bEnableShadowOptimisation;
var config bool bEnableLightOptimisation;
var bool bBehindView;
var bool bDebugFixedCam;
var bool bDebugFreeCam;
var bool bDebugGhost;
var bool bSlowDownFPS;
var name CurrentObjective;
var array<name> CompletedObjectives;
var int NumBatteries;
var int MaxNumBatteries;
var config int NrmMaxNumBatteries;
var config int HardMaxNumBatteries;
var config int NightmareMaxNumBatteries;
var config int DefaultNumBatteries;
var float GameOverActivatedTimestamp;
var array<OLPlayerController.EPlayerInteractionType> AvailableInteractions;
var string CSAPrompt;
var string PickupTargetName;
var OLProfileSettings ProfileSettings;
var DigitalInputs Inputs;
var input byte bLeanInputLeft;
var input byte bLeanInputRight;
var input byte bRunInput;
var input byte bUseButtonDown;
var OLPlayerController.EAIMusicState AIMusic;
var OLPlayerController.EAIMusicState OverriddenMusicState;
var input float PureMouseX;
var input float AnalogLeanInputLeft;
var input float AnalogLeanInputRight;
var int ZoomInput;
var float UsePressedTime;
var Vector LastPlayerInputIntent;
var TouchZoomData TouchZoom;
var LinearColor LightBarColor;
var float LightBarPulsePhase;
var array<name> CompletedRecordingMoments;
var array<name> UnreadRecordingMoments;
var OLRecordingMarker PendingRecordingMarker;
var float RecordingCompletedTime;
var config float StruggleInputThresholdForWin;
var config float StruggleShakesThresholdForWin;
var config float StruggleInputThresholdForWinNoFail;
var config float StruggleShakesThresholdForWinNoFail;
var float AIDistance;
var float OverriddenMusicDistance;
var float AIChaseMusicTimer;
var config float AIChaseMusicTimeDelay;
var const name MusicAIStateGroup;
var const name MusicAIStateNone;
var const name MusicAIStatePatrol;
var const name MusicAIStateInvestigate;
var const name MusicAIStateChase;
var const name LoadingStateGroup;
var const name LoadingStateOn;
var const name LoadingStateOff;
var const name AIDistanceRTPC;
var int NumDeathsSinceLastCheckpoint;
var float StableLevelsTimestamp;
var int NumBatteriesAtLastCheckpoint;
var float BatteryEnergyAtLastCheckpoint;
var config name FirstSoldierFindableCheckpoint;
var config name FirstSurgeonFindableCheckpoint;
var int FindHiddenPlayerSkipCount;
var Vector LastLightOptimCamPos;
var array<name> LevelsResetAfterPlayerDeath;
var Vector DesiredLocation;
var float LastCameraTimeStamp;
var class<Camera> MatineeCameraClass;
var Actor CalcViewActor;
var Vector CalcViewActorLocation;
var Rotator CalcViewActorRotation;
var Vector CalcViewLocation;
var Rotator CalcViewRotation;
var globalconfig float OnFootDefaultFOV;
var Rotator DebugCamRot;
var Vector DebugCamPos;
var float DebugFreeCamSpeed;
var float DebugFreeCamFOV;
var float SlowDownFactor;

event OnSetMesh(SeqAct_SetMesh Action)
{

}

event StartNewGameAtCheckpoint(string CheckpointStr, bool bSaveToDisk)
{
}

native function ClearAllProgress();

native function StopAllSounds();