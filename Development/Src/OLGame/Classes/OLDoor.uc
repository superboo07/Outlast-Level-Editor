/*******************************************************************************
 * OLDoor generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLDoor extends Actor
    native
    placeable
    hidecategories(Navigation)
    classgroup(OL,Ingredient)
    implements(Interface_NavMeshPathObject,Interface_NavMeshPathObstacle);

enum EOLDoorType
{
    DT_Normal,
    DT_Locker,
    DT_MAX
};

enum EDoorMaterial
{
    OLDM_Wood,
    OLDM_Metal,
    OLDM_SecurityDoor,
    OLDM_BigPrisonDoor,
    OLDM_BigWoodenDoor,
    OLDM_MAX
};

enum EOLDoorMeshType
{
    DMesh_Undefined,
    DMesh_Wooden,
    DMesh_WoodenOld,
    DMesh_WoodenWindow,
    DMesh_WoodenWindowSmall,
    DMesh_WoodenWindowOld,
    DMesh_WoodenWindowOldSmall,
    DMesh_WoodenWindowBig,
    DMesh_Metal,
    DMesh_MetalWindow,
    DMesh_MetalWindowSmall,
    DMesh_Enforced,
    DMesh_Grid,
    DMesh_Prison,
    DMesh_Entrance,
    DMesh_Bathroom,
    DMesh_IsolatedCell,
    DMesh_Locker,
    DMesh_LockerRusted,
    DMesh_LockerBeige,
    DMesh_LockerGreen,
    DMesh_Glass,
    DMesh_Fence,
    DMesh_LockerHole,
    DMesh_MAX
};

enum EDoorState
{
    DS_Idle,
    DS_Opening,
    DS_Closing,
    DS_PlayerInteracting,
    DS_Animating,
    DS_MAX
};

enum DoorEventType
{
    DET_StartOpening,
    DET_Opened,
    DET_Closed,
    DET_TriedOnLocked,
    DET_OpenThresholdReached,
    DET_Bashed,
    DET_StartedBashing,
    DET_StartedClosing,
    DET_MAX
};

enum EDoorBreakState
{
    DBS_Normal,
    DBS_Breaking,
    DBS_Broken,
    DBS_MAX
};

enum ECancelBashDirection
{
    ECBD_Both,
    ECBD_Forward,
    ECBD_Backward,
    ECBD_MAX
};

struct native DoorMeshDirData
{
    var StaticMesh MainMesh;
    var SkeletalMesh ForwardBreakingMesh;
    var AnimSet ForwardBreakingAnimSet;
    var name ForwardBreakingAnimation;
    var SkeletalMesh ForwardBrokenMesh;
    var AnimSet ForwardBrokenAnimSet;
    var name ForwardBrokenAnimation;
    var SkeletalMesh BackwardBreakingMesh;
    var AnimSet BackwardBreakingAnimSet;
    var name BackwardBreakingAnimation;
    var SkeletalMesh BackwardBrokenMesh;
    var AnimSet BackwardBrokenAnimSet;
    var name BackwardBrokenAnimation;

    structdefaultproperties
    {
        MainMesh=none
        ForwardBreakingMesh=none
        ForwardBreakingAnimSet=none
        ForwardBreakingAnimation=None
        ForwardBrokenMesh=none
        ForwardBrokenAnimSet=none
        ForwardBrokenAnimation=None
        BackwardBreakingMesh=none
        BackwardBreakingAnimSet=none
        BackwardBreakingAnimation=None
        BackwardBrokenMesh=none
        BackwardBrokenAnimSet=none
        BackwardBrokenAnimation=None
    }
};

struct native DoorMeshTypeData
{
    var DoorMeshDirData NormalData;
    var DoorMeshDirData ReversedData;
    var array<MaterialInstance> Materials;
    var OLDoor.EDoorMaterial DoorMaterialForSound;
    var float OcclusionFactor;

    structdefaultproperties
    {
        NormalData=(MainMesh=none,ForwardBreakingMesh=none,ForwardBreakingAnimSet=none,ForwardBreakingAnimation=None,ForwardBrokenMesh=none,ForwardBrokenAnimSet=none,ForwardBrokenAnimation=None,BackwardBreakingMesh=none,BackwardBreakingAnimSet=none,BackwardBreakingAnimation=None,BackwardBrokenMesh=none,BackwardBrokenAnimSet=none,BackwardBrokenAnimation=None)
        ReversedData=(MainMesh=none,ForwardBreakingMesh=none,ForwardBreakingAnimSet=none,ForwardBreakingAnimation=None,ForwardBrokenMesh=none,ForwardBrokenAnimSet=none,ForwardBrokenAnimation=None,BackwardBreakingMesh=none,BackwardBreakingAnimSet=none,BackwardBreakingAnimation=None,BackwardBrokenMesh=none,BackwardBrokenAnimSet=none,BackwardBrokenAnimation=None)
        Materials=none
        DoorMaterialForSound=EDoorMaterial.OLDM_Wood
        OcclusionFactor=0.0
    }
};

struct native DoorShakeData
{
    var() float Rate;
    var() float RateVariation;
    var() float Intensity;
    var() float IntensityVariation;
    var() float TotalDuration;
    var() float AmplitudeYaw;
    var() float AmplitudeTrans;
    var() float FrequencyYaw;
    var() float FrequencyTrans;
    var() float ShakeDuration;
    var() float FadeExp;
    var() bool bShakeCamera;
    var transient bool bActive;
    var transient float GlobalStartedTime;
    var transient float ShakeStartedTime;
    var transient float NextShakeStartTime;
    var transient float OriginalTranslationX;

    structdefaultproperties
    {
        Rate=0.60
        RateVariation=0.750
        Intensity=1.0
        IntensityVariation=0.50
        TotalDuration=-1.0
        AmplitudeYaw=7.50
        AmplitudeTrans=2.50
        FrequencyYaw=9.50
        FrequencyTrans=3.0
        ShakeDuration=0.40
        FadeExp=3.0
        bShakeCamera=true
        bActive=false
        GlobalStartedTime=0.0
        ShakeStartedTime=0.0
        NextShakeStartTime=0.0
        OriginalTranslationX=0.0
    }
};

var() editconst float MaxOpenAngle;
var() editconst float PlayerOpenedAngle;
var() bool bReverseDirection;
var() bool bLocked;
var() bool bFakeUnlocked;
var() bool bNoLockedInteraction;
var() bool bAutoClose;
var() bool bCantClose;
var() bool bNoPushKnob;
var() bool bAICanUseDoor;
var() bool bDontBreak;
var() bool bAlwaysBreak;
var() bool bWaitForTriggerToBreak;
var() bool bTrimToDoorForInvestigate;
var() bool bSplitNavMesh;
var() bool bAIAlwaysCloses;
var() bool bUseObstacleOnClose;
var() float OpeningSpeed;
var() float ClosingSpeed;
var() float ExplicitOcclusionFactor;
var() editconst float DefaultOcclusionFactor;
var() OLDoor.EOLDoorType DoorType;
var() OLDoor.EOLDoorMeshType DoorMeshType;
var() array<MaterialInstance> MaterialOverrides;
var() Vector DoorKnobOffset;
var() float PathPointOffset;
var() int NumBashesAfterBlocked;
var() float AIOpenDoorKnockback;
var() DoorShakeData BashShakeData;

defaultproperties
{
	begin object name=EditorDoor class=StaticMeshComponent
        StaticMesh=StaticMesh'OLEditorResources.EditorMeshes.door'
        ReplacementPrimitive=none
        bUsePrecomputedShadows=true
        LightingChannels=(Static=true)
        Translation=(X=-7.60,Y=50.0,Z=107.50)
		HiddenEditor=False
    End Object
	Components.add(EditorDoor)
    bEdShouldSnap=true
}