Class OLSpeedController extends OLPlayerController
Config(Tool);

struct Saved_Position
{
    var vector Location;
    var Rotator Rotation;
    var string Name;
};

enum Save_State
{
    SS_None,
    SS_Save,
    SS_Load
};

Enum Collision_Type
{
    Normal,
    Vault,
    Door,
    Shimmy
};

Enum PlayerMeshOverride
{
    No_Override,
    Miles,
    MilesNoFingers,
    WaylonIT,
    WaylonPrisoner,
    Nude
};

var config float Refresh;
var config float Max_View_Distance;
var config Array<String> Ignore_Actors;
var Array<Saved_Position> Saved_Positions;
var int Selected_Save;
var Save_State Current_State;
var Collision_Type Collision_Type_Override;
var OLSpeedController.PlayerMeshOverride PlayerModel;

var bool Enabled;
var bool DoorUnlocker;
var bool Full_Bright;
var bool Martin;
var bool WernikSkipEnable;

var SkeletalMesh Current_SkeletalMesh;
var array<MaterialInterface> Materials;

Function InitPlayerModel()
{
    WorldInfo.Game.SetTimer(0.0005, false, 'LoadCurrent', self);
}

Function LoadCurrent()
{
    local PlayerMeshOverride PlayerModelState;
    Current_SkeletalMesh=OLHero(Pawn).Mesh.SkeletalMesh;
    Materials=OLHero(Pawn).Mesh.Materials;

    if (PlayerModel!=No_Override) 
    {
        ConsoleCommand("UpdatePlayerModel " $ PlayerModel); 
    }
}

Exec Function OpenConsoleMenu(int Selection)
{
    Switch (Selection)
    {
        Case 1:
        OLSpeedHUD(HUD).Show_Menu=true;
        OLSpeedInput(PlayerInput).MoveCommand="No";
        OLSpeedInput(PlayerInput).StrafeCommand="Stop Fucking Moving";
        OLSpeedInput(PlayerInput).LookXCommand="Stop Fucking turning too";
        OLSpeedInput(PlayerInput).LookYCommand="Seriously fucking quit it";
        IgnoreLookInput(True);
        IgnoreMoveInput(True);
        break;

        Case 0: 
        OLSpeedHUD(HUD).Show_Menu=false;
        OLSpeedInput(PlayerInput).MoveCommand=OLSpeedInput(PlayerInput).Default.MoveCommand;
        OLSpeedInput(PlayerInput).StrafeCommand=OLSpeedInput(PlayerInput).Default.StrafeCommand;
        OLSpeedInput(PlayerInput).LookXCommand=OLSpeedInput(PlayerInput).Default.LookXCommand;
        OLSpeedInput(PlayerInput).LookYCommand=OLSpeedInput(PlayerInput).Default.LookYCommand;
        IgnoreLookInput(False);
        IgnoreMoveInput(false);
        break;
    }
    return;
}

Exec Function ToggleGod()
{
    Local OLSpeedPawn Hero;

    Hero=OLSpeedPawn(Pawn);

    Hero.GodMode=!Hero.GodMode;
    if (OLSpeedPawn(Pawn).GodMode)
    {
        Hero.HealthRegenDelay=0.00001;
        Hero.HealthRegenRate=100;
    }
    else
    {
        Hero.HealthRegenDelay=Hero.Default.HealthRegenDelay;
        Hero.HealthRegenRate=Hero.Default.HealthRegenRate;
    }

}

Exec Function ToogleKillBound()
{
    Local OLSpeedPawn Hero;
    Hero=OLSpeedPawn(Pawn);
    Hero.DisableKillBound=!Hero.DisableKillBound;
}

Exec Function SetPlayerCollisionRadius(Float Radius)
{
    OLHero(Pawn).SetCollisionSize(Radius, OLHero(Pawn).CylinderComponent.CollisionHeight);
}

Exec Function SetPlayerCollisionType(Collision_Type Type)
{
    local float Radius;
    
    //Credit to G40sty for finding the values, seriously thank you so much.
    Switch(Type)
    {
        case Normal:
        Radius=30;
        Break;

        Case Vault:
        Radius=15;
        Break;

        Case Door:
        Radius=5;
        Break;

        Case Shimmy:
        Radius=2;
        Break;
    }
    Collision_Type_Override=type;
    SetPlayerCollisionRadius(Radius);
    OLHero(Pawn).CrouchRadius=Radius;
}

Exec Function KillAllEnemys()
{
    local OLEnemyPawn Enemy;

    Foreach AllActors(Class'OLEnemyPawn', Enemy)
    {
        Enemy.Destroy();
    }
}

Exec Function ShowUseful()
{
    ConsoleCommand("Show COLLISION");
    ConsoleCommand("Stat LEVELS");
}

Exec Function LoadCheckpoint(string Checkpoint)
{
    local OLCheckpoint CheckpointObj;
    local OLSpeedGame TheGame;

    TheGame = OLSpeedGame(WorldInfo.Game);

    foreach allactors(Class'OLCheckpoint', CheckpointObj)
    {
        if( CheckpointObj.CheckpointName == Name(Checkpoint) )
        {
            if (TheGame.IsPlayingDLC() )
            {
                ConsoleCommand("StreamMap DLC_Checkpoints");
            }
            else
            {
                ConsoleCommand("StreamMap Intro_Persistent");
            }
            StartNewGameAtCheckpoint(Checkpoint, true);
            Return;
        }
    }
    WorldInfo.Game.BroadcastHandler.Broadcast(self, "Please enter the name of a valid checkpoint");
}

exec Function UnlockDoorsToggle()
{
    DoorUnlocker=!DoorUnlocker;
    UnlockDoors();
}

exec Function UnlockDoors()
{
    local OLDoor Door;

    foreach allactors(class'OLDoor', Door)
    {
        Door.bLocked=false;
    }
    
    if (DoorUnlocker)
    {
        WorldInfo.Game.SetTimer(1, false, 'UnlockDoors', self);
    }
}

Exec Function ShowFPS()
{
    ConsoleCommand("Stat FPS");
}

Exec Function ToogleFreeCam()
{
    if ( UsingFirstPersonCamera() )
    {
        ConsoleCommand("Camera Freecam");
    }
    else
    {
        ConsoleCommand("Camera Default");
    }
}

Exec Function ToogleDebugView() //Toggle Visibility
{
    local spriteview Just_Spawned;

    Switch(Enabled)
    {
        Case True: //Toggle Off
            Enabled = False;
            foreach AllActors(class'spriteview', Just_Spawned) //Destory all currently spawned Sprites
            {
                Just_Spawned.Destroy();
            }
        Break;

        Case False: //Toggle On
            Enabled = True;
            View();
        Break;
    }
 
}

exec function Save_Position(int Save)
{
    local Saved_Position Saved_Position;
    local vector Camera_Location;
    local rotator Camera_Dir;

    GetPlayerViewPoint(Camera_Location,Camera_Dir);
    Saved_Position.Location=Pawn.Location;
    Saved_Position.Rotation=Pawn.Rotation;
    //ViewWS
    Saved_Positions[Save]=Saved_Position;
}

exec function Load_Position(int Save)
{
    Pawn.SetLocation(Saved_Positions[Save].Location);
    Pawn.SetRotation(Saved_Positions[Save].Rotation);
}

exec function Check_Position(int Save)
{
    Selected_Save=Save;
}

Function View()
{
    local OLGameplayMarker GameplayMarker; //Current Gameplay Marker
    local spriteview Just_Spawned; //Store Current Sprite here
    local OLCheckpoint Checkpoint; //Current Checkpoint
    local Texture2D Sprite; //Current Texture
    local vector Location;
    local string String;
    local bool ignore;

    local name Fuck; //Dummy name piece of shit fuck to force the spawn command into submission.

    foreach AllActors(class'spriteview', Just_Spawned) //Destory all currently spawned sprites
    {
        Just_Spawned.Destroy();
    }

    if (Enabled==true)
    {
        foreach AllActors(class'OLGameplayMarker', GameplayMarker)
        {
            Location = GameplayMarker.Location;
            ignore=false;

            if (ContainsString(Ignore_Actors, String(GameplayMarker.Class) ) ) { break; } //Check if Ignore_Actor array contains this class, if it does tell it to fuck off.

            Just_Spawned = Spawn(Class'SpriteView', GameplayMarker, Fuck, Location);
            Just_Spawned.SetBase(GameplayMarker);
            
            Switch(GameplayMarker.Class) //Select Sprite for Gamemarker based on class, and use a switch because i'm not yandare dev. 
            {
                Case class'OLLedgeMarker':
                sprite=Texture2D'SH_Sprites.OLLedgeMarker_Sprite';
                Break;

                Case class'OLRecordingMarker':
                sprite=Texture2D'SH_Sprites.OLRecordingMarker_Sprite';
                Break;

                Case class'OLCornerMarker':
                sprite=Texture2D'SH_Sprites.OLCornerMarker_Sprite';
                Break;

                Case class'OLBed':
                sprite=Texture2D'SH_Sprites.OLBed_Sprite';
                Break;

                Case class'OLCSA':
                sprite=Texture2D'SH_Sprites.OLCSA_Sprite';
                Break;

                Default:
                Sprite=Texture2D'SH_Sprites.OLGameplayMarker_Sprite';
                Break;
            }
            Just_Spawned.Sprite.SetSprite(Sprite);
        }

        foreach AllActors(class'OLCheckpoint', Checkpoint)
        {
            Location = Checkpoint.Location;
            Just_Spawned = Spawn(Class'SpriteView', Checkpoint, Fuck, Location);
            Just_Spawned.Sprite.SetSprite(Texture2D'SH_Sprites.OLCheckpoint_Sprite');
        }

        WorldInfo.Game.SetTimer(Refresh, false, 'View', self);
    }
}

exec function MartinifyToggle()
{
    Martin=!Martin;
    Martinify();
}

exec function Martinify()
{
    local OLEnemyPawn EnemyPawn;
    foreach allactors(class'OLEnemyPawn', EnemyPawn)
    {
        switch (EnemyPawn.Class)
        {
            Default:
            EnemyPawn.Mesh.SetSkeletalMesh(SkeletalMesh'02_Priest.Pawn.Priest-01');
            EnemyPawn.Mesh.SetMaterial(1, MaterialInstanceConstant'02_Priest.Material.Priest_Face_CINE');
            EnemyPawn.Mesh.SetMaterial(2, MaterialInstanceConstant'02_Priest.Material.Priest_body' );
            EnemyPawn.Mesh.SetMaterial(3, MaterialInstanceConstant'02_Priest.Material.Priest_leg' );
            EnemyPawn.Mesh.SetMaterial(4, MaterialInstanceConstant'02_Priest.Priest_Eye_INST' );
            EnemyPawn.Mesh.SetMaterial(5, MaterialInstanceConstant'02_Priest.Material.Priest_leg_2_sided' );
            break;
        }
    }
    if (Martin) {WorldInfo.Game.SetTimer(1, false, 'Martinify', self);}
}

Exec Function WernikSkipToggle()
{
    local OLGame CurrentGame;
    local SkeletalMeshActor SkeletalMesh;

    CurrentGame = OLGame(WorldInfo.Game);

    WernikSkipEnable=!WernikSkipEnable;

    if (WernikSkipEnable)
    {
        WernikSkip();
    }
    else
    {
        foreach allactors(Class'SkeletalMeshActor', SkeletalMesh)
        {
            if (String(SkeletalMesh.SkeletalMeshComponent.SkeletalMesh)=="LadCellDoor-01" )
            {
                if ( CurrentGame.CurrentCheckpointName=='Lab_PremierAirLock' || CurrentGame.CurrentCheckpointName=='Lab_SpeachDone' || CurrentGame.CurrentCheckpointName=='Lab_SwarmIntro' || CurrentGame.CurrentCheckpointName=='Lab_Soldierdead')
                {
                    SkeletalMesh.ReattachComponent(SkeletalMesh.SkeletalMeshComponent);
                }
            }
        }
    }
}

Exec Function WernikSkip()
{
    local SkeletalMeshActor SkeletalMesh;
    local OLGame CurrentGame;

    CurrentGame = OLGame(WorldInfo.Game);

    if (!WernikSkipEnable) {Return;}

    foreach allactors(Class'SkeletalMeshActor', SkeletalMesh)
    {
        if (String(SkeletalMesh.SkeletalMeshComponent.SkeletalMesh)=="LadCellDoor-01" )
        {
            if ( CurrentGame.CurrentCheckpointName=='Lab_PremierAirLock' || CurrentGame.CurrentCheckpointName=='Lab_SpeachDone' || CurrentGame.CurrentCheckpointName=='Lab_SwarmIntro' || CurrentGame.CurrentCheckpointName=='Lab_Soldierdead')
            {
                SkeletalMesh.DetachComponent(SkeletalMesh.SkeletalMeshComponent);
            }
            else
            {
                SkeletalMesh.ReattachComponent(SkeletalMesh.SkeletalMeshComponent);
            }
        }
    }
    if (WernikSkipEnable) {WorldInfo.Game.SetTimer(1, false, 'WernikSkip', self);}
}

event OnSetMesh(SeqAct_SetMesh Action)
{

    `log("Called SetMesh");
    Current_SkeletalMesh=Action.NewSkeletalMesh;
    if (PlayerModel==No_Override)
    {
        Super.OnSetMesh(Action);
    }
}

event OnSetMaterial(SeqAct_SetMaterial Action)
{
    local OLHero Hero;
    Hero = OLHero(Pawn);

    `log("Called SetMaterial");
    Materials[Action.MaterialIndex]=Action.NewMaterial;

    if (PlayerModel==No_Override)
    {
        Hero.OnSetMaterial(Action);
    }
}

exec Function UpdatePlayerModel(OLSpeedController.PlayerMeshOverride PlayerModelState)
{
    local MaterialInterface Mat;
    local int Index;

    if (PlayerModel==No_Override)
    {
        Current_SkeletalMesh=OLHero(Pawn).Mesh.SkeletalMesh;
        Materials=OLHero(Pawn).Mesh.Materials;
    }

    if (PlayerModelState==PlayerModel) {Return;}

    switch (PlayerModelState)
    {
        Case Miles:
        OLHero(Pawn).Mesh.SetSkeletalMesh(SkeletalMesh'02_Player.Pawn.Miles_beheaded');
        RestoreDefaultMaterials();
        break;

        Case MilesNoFingers:
        OLHero(Pawn).Mesh.SetSkeletalMesh(OLHero(Pawn).FingerlessMesh);
        RestoreDefaultMaterials();
        break;

        Case WaylonIT:
        OLHero(Pawn).Mesh.SetSkeletalMesh(OLHero(Pawn).ITTechMesh);
        RestoreDefaultMaterials();
        break;

        Case WaylonPrisoner:
        OLHero(Pawn).Mesh.SetSkeletalMesh(OLHero(Pawn).PrisonerMesh);
        RestoreDefaultMaterials();
        break;

        Case Nude:
        OLHero(Pawn).Mesh.SetSkeletalMesh(SkeletalMesh'DLC_Build2Floor2-01_SE.02_Waylon_Park.Mesh.Waylon_Park_Nude');
        RestoreDefaultMaterials();
        break;

        Case No_Override:
        OLHero(Pawn).Mesh.SetSkeletalMesh(Current_SkeletalMesh);
        Index=0;
        RestoreDefaultMaterials();
        foreach OLHero(Pawn).Mesh.SkeletalMesh.Materials(Mat)
        {
            OLHero(Pawn).Mesh.SetMaterial( Index, Materials[Index] );
            ++Index;
        }
        break;
    }
    PlayerModel=PlayerModelState;
}

Function RestoreDefaultMaterials()
{
    local int Index;
    local MaterialInterface Mat;
    foreach OLHero(Pawn).Mesh.SkeletalMesh.Materials(Mat)
    {
        OLHero(Pawn).Mesh.SetMaterial(Index, none);
        ++Index;
    }
    return;
}

Function Bool ContainsString(Array<String> Array, String find)
{
    Switch(Array.Find(find))
    {
        case -1:
            Return False;
        break;

        Default:
            Return true;
        Break;
    }
}

Function Bool ContainsName(Array<Name> Array, Name find)
{
    Switch(Array.Find(find))
    {
        case -1:
            Return False;
        break;

        Default:
            Return true;
        Break;
    }
}


DefaultProperties
{
    Refresh=1
    Max_View_Distance=500
    InputClass=class'OLSpeedInput'

    PlayerModel=No_Override

    Saved_Positions[0]=
    Saved_Positions[1]=
    Saved_Positions[2]=
    Saved_Positions[3]=
    Saved_Positions[4]=
}