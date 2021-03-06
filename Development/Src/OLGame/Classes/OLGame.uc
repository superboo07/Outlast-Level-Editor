/*******************************************************************************
 * OLGame generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib © 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class OLGame extends UDKGame
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

enum EDifficultyMode
{
    EDM_Normal,
    EDM_Hard,
    EDM_Nightmare,
    EDM_Insane,
    EDM_MAX
};

var OLGame.EDifficultyMode DifficultyMode;
var config name DefaultMapName;
var config name DemoMapName;
var config name DLCInstalledMapName;
var name CurrentCheckpointName;
var config bool bIsDemo;
var config bool bForcePlayingDLC;
var bool bIsPlayingDLC;
var bool bSoundOnPause;
var OLVoiceManager VoiceManager;
var name PendingCheckpointName;

// Export UOLGame::execIsDemo(FFrame&, void* const)
native static function bool IsDemo();

// Export UOLGame::execIsPlayingDLC(FFrame&, void* const)
native static function bool IsPlayingDLC();

// Export UOLGame::execIsDLCInstalled(FFrame&, void* const)
native static function bool IsDLCInstalled();

// Export UOLGame::execMatchCheckpoint(FFrame&, void* const)
native function OLCheckpoint MatchCheckpoint(string PortalName);

// Export UOLGame::execUpdateGameType(FFrame&, void* const)
native function UpdateGameType();

event TravelToStartupMap()
{
}

defaultproperties
{
    DefaultPawnClass=class'OLHero'
}