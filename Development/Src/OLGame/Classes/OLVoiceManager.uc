/*******************************************************************************
 * OLVoiceManager generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLVoiceManager extends Object
    native
    config(Game);

struct native VOLine
{
    var name BoneName;
    var float TimeFired;
    var float EndOfLineBuffer;
    var int PlayingID;
    var bool bSkipForPaused;
    var int CallbackFlags;
    var native Pointer CallbackFunction;
    var native Pointer CallbackCookie;

    structdefaultproperties
    {
        Line=none
        BoneName=None
        TimeFired=0.0
        EndOfLineBuffer=0.0
        PlayingID=0
        bSkipForPaused=false
        CallbackFlags=0
    }
};

struct native LineQueue
{
    var Actor Talker;
    var init native array<init VOLine> Lines;
    var bool IsPlaying;
    var bool IsWaiting;
    var bool CancelWait;

    structdefaultproperties
    {
        Talker=none
        IsPlaying=false
        IsWaiting=false
        CancelWait=false
    }
};

struct native QueueTimer
{
    var Actor QueueActor;
    var float TimeRemaining;

    structdefaultproperties
    {
        QueueActor=none
        TimeRemaining=0.0
    }
};

struct native EndOfEventInfo
{
    var Actor QueueActor;
    var int PlayingID;

    structdefaultproperties
    {
        QueueActor=none
        PlayingID=0
    }
};

struct native MarkerInfo
{
    var Actor QueueActor;
    var string MarkerText;

    structdefaultproperties
    {
        QueueActor=none
        MarkerText=""
    }
};

var private native const noexport Pointer VfTable_FTickableObject;
var config array<config name> VOPackages;
var array<LineQueue> LineQueues;
var array<QueueTimer> Timers;
var array<EndOfEventInfo> EventCallbacksToProcess;
var array<MarkerInfo> MarkerCallbacksToProcess;
var native Pointer CriticalSection;

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
}

defaultproperties
{
    VOPackages(0)=VO_Patient
    VOPackages(1)=VO_Player
    VOPackages(2)=VO_Priest
    VOPackages(3)=VO_Soldier
    VOPackages(4)=VO_Stephenson
    VOPackages(5)=VO_Wheelchair
    VOPackages(6)=VO_ACT1_Various
    VOPackages(7)=VO_ACT2_Itvw_Female_Ward
    VOPackages(8)=VO_ACT3_Various
    VOPackages(9)=VO_Patient_Admin_Block_2
    VOPackages(10)=VO_Patient_Ext_Courtyard
    VOPackages(11)=VO_Patient_Female_Ward
    VOPackages(12)=VO_Patient_Male_Ward
    VOPackages(13)=VO_Patient_Male_Ward_Bsmt
    VOPackages(14)=VO_Patient_Male_Ward_Up_Lvls
    VOPackages(15)=VO_Patient_Prison
    VOPackages(16)=VO_Patient_Sewers
    VOPackages(17)=VO_Surgeon
    VOPackages(18)=VO_Patient_AI
    VOPackages(19)=DLC_VO_SE_DDenis_Attic
    VOPackages(20)=DLC_VO_SE_Blaire_AdminRev
    VOPackages(21)=DLC_VO_SE_Blaire_Lab
    VOPackages(22)=DLC_VO_SE_Blaire_prison
    VOPackages(23)=DLC_VO_SE_Cannibal_Build1
    VOPackages(24)=DLC_VO_SE_Groom_Build2
    VOPackages(25)=DLC_VO_SE_Groom_Lab
    VOPackages(26)=DLC_VO_SE_Guard_AdminRev
    VOPackages(27)=DLC_VO_SE_Guard_Build1
    VOPackages(28)=DLC_VO_SE_Guard_Lab
    VOPackages(29)=DLC_VO_SE_Guard_Maleward
    VOPackages(30)=DLC_VO_SE_Guard_PrisonRev
    VOPackages(31)=DLC_VO_SE_FMartin
    VOPackages(32)=DLC_VO_SE_Julian
    VOPackages(33)=DLC_VO_SE_Patients_Build1
    VOPackages(34)=DLC_VO_SE_Patients_Build2
    VOPackages(35)=DLC_VO_SE_Patients_PrisonRev
    VOPackages(36)=DLC_VO_SE_SCI_Build1
    VOPackages(37)=DLC_VO_SE_SCI_Build2
    VOPackages(38)=DLC_VO_SE_SCI_Lab
    VOPackages(39)=DLC_VO_AI_Cannibal
    VOPackages(40)=DLC_VO_AI_Groom
    VOPackages(41)=DLC_VO_AI_PATMANIC
    VOPackages(42)=DLC_VO_AI_PATSOCIO
    VOPackages(43)=DLC_VO_AI_PATTERR
    VOPackages(44)=DLC_VO_AI_SCICALM
    VOPackages(45)=DLC_VO_AI_SCITERRI
}