Class TasPlayerController extends OLPlayerController
Config(Tool);

Enum ECollision_Type
{
	CT_Normal,
	CT_Vault,
	CT_Door,
	CT_Shimmy
};

Enum EPlayerMeshOverride
{
	PM_NoOverride,
	PM_Miles,
	PM_MilesNoFingers,
	PM_WaylonIT,
	PM_WaylonPrisoner,
	PM_Custom,
	PM_Nude
};

struct Saved_Position
{
	var vector Location;
	var Vector2D Rotation;
	var ELocomotionMode LocomotionMode;
	var ESpecialMoveType SpecialMoveType;
	var string Name;
};

var config bool bShouldUnlockAllDoors, bIsWernickeSkipEnabled, bShouldMakeBhopsFree, bIsOL2BandageSimulatorEnabled, bIsOL2StaminaSimulatorEnabled, bIsGrainEnabled;
var config float Refresh, Max_View_Distance, RefreshKismetSequenceArray;
var config Array<String> Ignore_Actors;
var config EPlayerMeshOverride PlayerModel;

var string CustomPM;
var Array<Saved_Position> Saved_Positions;
var int Selected_Save;
var ECollision_Type Collision_Type_Override;
var SHHero SpeedPawn;
var bool bIsActorDebugEnabled, bIsModDebugEnabled, bShouldWieldFatherMartin, bShouldHaveInfiniteBattery, bGodMode, bDisableKillBound, bShouldMartinReplaceEnemyModels;
var SkeletalMesh StoredSkeletalMesh;
var array<MaterialInterface> StoredMaterials;
var Array<SequenceObject> AllCheckpointSeq;

`Functvar

Event InitializeHelper(SHHero Pawn)
{
	SpeedPawn=Pawn;
	if ( bShouldHaveInfiniteBattery ) { EnableInfiniteBattery(); }
	if ( HasOL2SimulatorEnabled() ) { Pawn.EnableOL2Simulator(); }
	if (!bIsGrainEnabled) { ToogleGrain(True, false);}
	if (bShouldUnlockAllDoors) {UnlockDoors();}
	if (bIsWernickeSkipEnabled) {bIsWernickeSkipEnabled=false; WernikSkipToggle();}
}

Exec Function OpenConsoleMenu(int Selection)
{
	if (Selection==-1) {Selection=int(!SHHud(HUD).Show_Menu);}
	Switch (Selection)
	{
		Case 1:
		DisableInput(True);
		PlayerInput.ResetInput();
		SHHud(HUD).Show_Menu=true;
		break;

		Case 0: 
		SHHud(HUD).Show_Menu=false;
		DisableInput(False);
		PlayerInput.ResetInput();
		break;
	}
	return;
}

Exec Function FreeBhop()
{
	bShouldMakeBhopsFree=!bShouldMakeBhopsFree;
}

Exec Function SimulateBandages()
{
	if (bGodMode) 
	{
		WorldInfo.Game.BroadcastHandler.Broadcast(self, "Simulate Bandages cannot be turned on while GodMode is enabled");
		Return;
	}
	bIsOL2BandageSimulatorEnabled=!bIsOL2BandageSimulatorEnabled;
	if (!bIsOL2BandageSimulatorEnabled)
	{
		SpeedPawn.DisableBandage();
		return;
	}
	SpeedPawn.EnableOL2Simulator();
}

exec Function ShowModDebug()
{
	bIsModDebugEnabled=!bIsModDebugEnabled;
}

exec Function SimulateOL2Stamina()
{
	bIsOL2StaminaSimulatorEnabled=!bIsOL2StaminaSimulatorEnabled;
	SpeedPawn.EnableOL2Simulator();
	if (!bIsOL2StaminaSimulatorEnabled)
	{
		SpeedPawn.DisableStamina();
	}
}

Function DisableInput(Bool Input)
{
	local SHPlayerInput HeroInput;
	local OLHero Hero;

	HeroInput=SHPlayerInput(PlayerInput);
	Hero=OLHero(Pawn);

	if (Input)
	{
		IgnoreLookInput(True);
		IgnoreMoveInput(True);
	}
	else
	{
		IgnoreLookInput(False);
		IgnoreMoveInput(false);
	}
}

Exec Function ToggleGod()
{
	Local SHHero Hero;

	Hero=SHHero(Pawn);

	bGodMode=!bGodMode;
	if (bGodMode)
	{
		if (bIsOL2BandageSimulatorEnabled) { SimulateBandages(); }
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
	Local SHHero Hero;
	Hero=SHHero(Pawn);
	bDisableKillBound=!bDisableKillBound;
}

Exec Function SetPlayerCollisionRadius(Float Radius)
{
	OLHero(Pawn).SetCollisionSize(Radius, OLHero(Pawn).CylinderComponent.CollisionHeight);
}

Exec Function SetPlayerCollisionType(ECollision_Type Type)
{
	local float Radius;
	
	//Credit to G40sty for finding the values, seriously thank you so much.
	Switch(Type)
	{
		case CT_Normal:
		Radius=30;
		Break;

		Case CT_Vault:
		Radius=15;
		Break;

		Case CT_Door:
		Radius=5;
		Break;

		Case CT_Shimmy:
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
	bShouldUnlockAllDoors=!bShouldUnlockAllDoors;
	UnlockDoors();
}

exec Function UnlockDoors()
{
	local OLDoor Door;

	foreach allactors(class'OLDoor', Door)
	{
		Door.bLocked=false;
		Door.bBlocked=false;
	}
	
	if (bShouldUnlockAllDoors)
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

Exec Function ToogleWieldFatherMartin()
{
	bShouldWieldFatherMartin=!bShouldWieldFatherMartin;

	if (bShouldWieldFatherMartin)
	{
		WorldInfo.Game.SetTimer(0.1, true, 'WieldFatherMartin', self);
	}
	else
	{
		WorldInfo.Game.ClearTimer('WieldFatherMartin', self);
	}
}

Exec Function ToogleGrain(Optional Bool bForce, Optional Bool bShouldEnable)
{
	bIsGrainEnabled=!bIsGrainEnabled;
	if ( (bIsGrainEnabled && !bForce) || bForce && bShouldEnable)
	{
		FXManager.CurrentUberPostEffect.GrainOpacity=FXManager.CurrentUberPostEffect.Default.GrainOpacity;
	}
	else if ( (!bIsGrainEnabled && !bForce) || bForce && !bShouldEnable)
	{
		FXManager.CurrentUberPostEffect.GrainOpacity=0;
	}
}

Exec Function ToogleInfiniteBattery()
{
	bShouldHaveInfiniteBattery=!bShouldHaveInfiniteBattery;

	if (bShouldHaveInfiniteBattery)
	{
		EnableInfiniteBattery();
	}
	else
	{
		SpeedPawn.UpdateDifficultyBasedValues();
	}
}

Function EnableInfiniteBattery()
{
	SpeedPawn.BatteryDuration=999999999999;
}

Function WieldFatherMartin()
{
	Local OLEnemyPawn EnemyPawn;
	Local DynamicLightEnvironmentComponent LightEnviro;
	local SkeletalMeshComponent Meshcomp;

	ForEach Allactors(class'OLEnemyPawn', EnemyPawn)
	{
		MeshComp = New Class'SkeletalMeshComponent';
		MeshComp.SetSkeletalMesh(SkeletalMesh'02_Priest.Pawn.Priest-01');
		LightEnviro = DynamicLightEnvironmentComponent'Default__EnemyPawn.MyLightEnvironment';
		MeshComp.SetLightEnvironment(LightEnviro);
		EnemyPawn.AttachComponent(LightEnviro);
		EnemyPawn.Mesh.AttachComponent(MeshComp, EnemyPawn.WeaponAttachBone);
	}
}

Exec Function TeleportToFreecam()
{
	local rotator Rotation;
	Local Vector Location;
	Local Camview View;

	GetPlayerViewPoint(Location,Rotation);

	View.Loc=Location;
	View.Pitch=Function.ConvertRotationUnitToDegrees(Rotation).Pitch;
	View.Yaw=Rotation.Yaw;
	View.Roll=Rotation.Roll;


	if ( !UsingFirstPersonCamera() )
	{
		Pawn.SetLocation( Location - vect(5,0,25) );
		SpeedPawn.SetRotation(Rotation);
		SpeedPawn.Camera.ViewCS=View;

		ConsoleCommand("Camera Default");
	}
}

exec function Save_Position(int Save)
{
	local Saved_Position Saved_Position;

	Saved_Position.Location=Pawn.Location;
	Saved_Position.Rotation=Vect2D(Pawn.Rotation.Yaw, SpeedPawn.Camera.ViewCS.Pitch);
	Saved_Position.LocomotionMode=SpeedPawn.LocomotionMode;
	Saved_Positions[Save]=Saved_Position;
}

exec function Load_Position(int Save)
{
	/* To Do, set current locomotion mode without crashing.
	SpeedPawn.LocomotionMode=Saved_Positions[Save].LocomotionMode;*/
	Pawn.SetLocation( Saved_Positions[Save].Location );
	Pawn.SetRotation( MakeRotator( Pawn.Rotation.Pitch, Saved_Positions[Save].Rotation.X, Pawn.Rotation.Roll ) );
	SpeedPawn.Camera.ViewCS.Pitch=Saved_Positions[Save].Rotation.Y;
}

exec function Check_Position(int Save)
{
	Selected_Save=Save;
}

exec function Teleport_In_Direction(float X, float Y)
{
	local vector Forward;
	local vector Right;
	local vector Up;
	local vector NewLocationForward;
	local vector NewLocationRight;

	GetAxes(Pawn.Rotation, Forward, Right, up);
	NewLocationForward=Forward * X;
	NewLocationRight=Right * Y;

	Pawn.SetLocation( Pawn.Location + ( NewLocationForward + NewLocationRight ) );
}

Exec Function ToogleDebugView() //Toggle Visibility
{
	local spriteview Just_Spawned;
	local TriggerVolume Volume;

	bIsActorDebugEnabled=!bIsActorDebugEnabled;
	if (bIsActorDebugEnabled)
	{
		SpawnDebugViewActors();
		WorldInfo.Game.SetTimer(Refresh, true, 'SpawnDebugViewActors', self);
		GetCheckpointSequenceObjects();
		if (RefreshKismetSequenceArray != -1) { WorldInfo.Game.SetTimer(RefreshKismetSequenceArray, true, 'GetCheckpointSequenceObjects', self); }
		//WorldInfo.Game.SetTimer(RefreshKismetSequenceArray, true, 'GetTriggerSequenceObjects', self);
	}
	else
	{
		WorldInfo.Game.ClearTimer('SpawnDebugViewActors', self);
		WorldInfo.Game.ClearTimer('GetCheckpointSequenceObjects', self);
		foreach AllActors(class'spriteview', Just_Spawned) //Destory all currently spawned Sprites
		{
			Just_Spawned.Destroy();
		}
		foreach AllActors(Class'TriggerVolume', Volume)
		{
			Volume.BrushComponent.SetHidden(True);
			Volume.SetHidden(True);
		}
	}
}

Function GetCheckpointSequenceObjects()
{
	local Sequence GameSeq;

	AllCheckpointSeq=Default.AllCheckpointSeq;
	GameSeq = WorldInfo.GetGameSequence();
	GameSeq.FindSeqObjectsByClass(class'OLSeqAct_Checkpoint', true, AllCheckpointSeq);
}

Function SpawnDebugViewActors()
{
	local OLGameplayMarker GameplayMarker; //Current Gameplay Marker
	local spriteview Just_Spawned; //Store Current Sprite here
	local OLCheckpoint Checkpoint; //Current Checkpoint
	local Texture2D Sprite; //Current Texture
	local vector Location;
	local string String;
	local bool ignore;
	local Vector CameraLocation;
	Local Rotator CameraDir;

	GetPlayerViewPoint( CameraLocation, CameraDir );

	foreach AllActors(class'spriteview', Just_Spawned) //Destory all currently spawned sprites
	{
		Just_Spawned.Destroy();
	}

	if (bIsActorDebugEnabled)
	{
		foreach AllActors(class'OLGameplayMarker', GameplayMarker)
		{
			Location = GameplayMarker.Location;
			ignore=false;

			if (Function.ContainsString(Ignore_Actors, String(GameplayMarker.Class) ) ) { break; } //Check if Ignore_Actor array contains this class, if it does tell it to fuck off.

			Just_Spawned = Spawn(Class'SpriteView', GameplayMarker, 'idc', Location);
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
			Just_Spawned = Spawn(Class'SpriteView', Checkpoint, 'idc', Location);
			Just_Spawned.Sprite.SetSprite(Texture2D'SH_Sprites.OLCheckpoint_Sprite');
		}
	}
}

Exec Function ScalePlayer(Float Scale)
{
	local vector vector;
	local float Radius;

	SpeedPawn.Mesh.SetScale(Scale);
	SpeedPawn.CollisionComponent.SetScale(Scale);
	SpeedPawn.SetCollisionSize(SpeedPawn.GetCollisionRadius(), SpeedPawn.GetCollisionHeight() * SpeedPawn.Mesh.Scale);
}

Function Float ScalebyCam(Float Float) //Function to scale a float by the players current FOV. 
{
	Local Float Scale;
	Scale = ( GetFOVAngle() / 100 );

	Return Float * Scale;
}

exec function MartinifyToggle()
{
	bShouldMartinReplaceEnemyModels=!bShouldMartinReplaceEnemyModels;
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
	if (bShouldMartinReplaceEnemyModels) {WorldInfo.Game.SetTimer(1, false, 'Martinify', self);}
}

Exec Function WernikSkipToggle()
{
	local OLGame CurrentGame;
	local SkeletalMeshActor SkeletalMesh;

	CurrentGame = OLGame(WorldInfo.Game);

	bIsWernickeSkipEnabled=!bIsWernickeSkipEnabled;

	if (bIsWernickeSkipEnabled)
	{
		WernikSkip();
		WorldInfo.Game.SetTimer(1, true, 'WernikSkip', self);
	}
	else
	{
		WorldInfo.Game.ClearTimer('WernikSkip', self);
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

	if (!bIsWernickeSkipEnabled) {Return;}

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
}

event OnSetMesh(SeqAct_SetMesh Action)
{
	`log("Called SetMesh");
	StoredSkeletalMesh=Action.NewSkeletalMesh;
	if (PlayerModel==PM_NoOverride)
	{
		Super.OnSetMesh(Action);
		`log("Set Mesh Allowed");
		Return;
	}
	`log("Set Mesh Blocked");
}

event OnSetMaterial(SeqAct_SetMaterial Action)
{
	local OLHero Hero;
	Hero = OLHero(Pawn);

	`log("Called SetMaterial");
	StoredMaterials[Action.MaterialIndex]=Action.NewMaterial;

	if (PlayerModel==PM_NoOverride)
	{
		Hero.OnSetMaterial(Action);
		`log("Set Material Allowed");
		Return;
	}
	`log("Set Material Blocked");
}

Function bool IsPlayerModelSDKInstalled()
{
	Return Class'OLPlayerModel' != None;
}

Function bool ApplyCustomPlayerModel(string CustomPlayerModel)
{
	local OLPlayerModel FoundCustomPlayerModel;
	if ( IsPlayerModelSDKInstalled() ) 
	{
		FoundCustomPlayerModel = OLPlayerModel( DynamicLoadObject(CustomPlayerModel, Class'Object') );
		if (FoundCustomPlayerModel==None) 
		{
			WorldInfo.Game.BroadcastHandler.Broadcast(self, "Could not find Playermodel '" $ CustomPlayerModel $ "'");
			WorldInfo.Game.BroadcastHandler.Broadcast(self, "Please ensure the playermodel is properly installed, and the path you have inputted is correct");
			Return false;
		}
		CustomPM=CustomPlayerModel;
		OLHero(Pawn).Mesh.SetSkeletalMesh(FoundCustomPlayerModel.HeroBody);
		Return true;
	}
	else
	{
		WorldInfo.Game.BroadcastHandler.Broadcast(self, "The CustomPlayerModelSDK is either not installed, or is corrupted");
		return false;
	}
}

Function RestoreFromStoredMaterials()
{
	local int Index;
	local MaterialInterface Mat;
	Index=0;
	foreach OLHero(Pawn).Mesh.SkeletalMesh.Materials(Mat)
	{
		OLHero(Pawn).Mesh.SetMaterial( Index, StoredMaterials[Index] );
		++Index;
	}
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

Exec Function TeleportAllEnemies()
{
	local OLEnemyPawn EnemyPawn;

	Foreach AllActors(class'OLEnemyPawn', EnemyPawn)
	{
		EnemyPawn.SetLocation(Pawn.Location);
	}
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

Function Bool HasOL2SimulatorEnabled()
{
	Return bIsOL2BandageSimulatorEnabled || bIsOL2StaminaSimulatorEnabled;
}

Function Bool ToggleBool(Bool Result)
{
	Result=!Result;
	Return Result;
}

event UnlockAchievement(OLPlayerController.EOutlastAchievement achievement)
{
}

function SetCinematicMode(SeqAct_ToggleCinematicMode Action, bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons)
{
    super(PlayerController).SetCinematicMode(Action, bInCinematicMode, bHidePlayer, bAffectsHUD, bAffectsMovement, bAffectsTurning, bAffectsButtons);
    if(!bInCinematicMode && !SHHud(HUD).Show_Menu)
    {
        bIgnoreMoveInput = 0;
        bIgnoreLookInput = 0;
    }
    if((Action != none) && HeroPawn != none)
    {
        if(bInCinematicMode)
        {
            HeroPawn.EnterCinematicMode(Action);
        }
        else
        {
            HeroPawn.ExitCinematicMode(Action);
        }
    }
}

DefaultProperties
{
	Refresh=1
	Max_View_Distance=500
	InputClass=class'SHPlayerInput'

	PlayerModel=PM_NoOverride

	Saved_Positions[0]=
	Saved_Positions[1]=
	Saved_Positions[2]=
	Saved_Positions[3]=
	Saved_Positions[4]=

	`FunctObj
}