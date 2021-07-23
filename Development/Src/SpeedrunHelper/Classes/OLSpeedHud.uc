Class OLSpeedHud extends OLHud
config(tool);

Struct ButtonStruct
{
	var String Name;
	var string ConsoleCommand;
	var vector2d Start_Points;
	var vector2d End_Point;
	var vector2D Location;
	var vector2D Offset;
	var vector2D ScaledOffset;
	var vector2D ClipStart;
	var vector2D ClipEnd;
	var vector2D AbsoluteLocation;
	var bool template;
	var int Row;
	Var int Column;
};

Struct InputBox
{
	var String ID;
	var String Contents;
	var vector2d Start_Points;
	var vector2d End_Point;
};


Struct RGBA
{
	var Byte Red;
	var Byte Green;
	var Byte Blue;
	var Byte Alpha;
};

Struct ControllerSelection
{
	var int Row;
	var int Column;
};

Enum Menu
{
	Normal,
	Show,
	Collision,
	Cheats,
	SavePositionSelect,
	SaveOrLoad,
	Funny,
	PlayerModel,
	Credits,
	Teleporter,
	Logging,
	PlayerScale
};

Enum EOffset
{
	O_None,
	O_Center,
	O_Full
};

var bool Show_Menu;
var bool Pressed;
var bool AlreadyCommited;
var bool bShouldDrawMouse;
var config bool bShouldPauseWithoutFocus;
var string Command;
var array<ButtonStruct> Buttons;
var ButtonStruct Previous_Button;
var Menu CurrentMenu;
var ECollision_Type Current_Collision;
var config string Cursor;
var config float CursorScale;
var config float CursorOutline;
var config RGBA BackgroundColor;
var config RGBA DefaultTextColor;
var config RGBA ButtonColor;
var config RGBA ButtonHoveredColor;
var config RGBA CommandLineColor;
var config RGBA CommandLineTextColor;
var config RGBA CursorColor;
var config RGBA CursorOutlineColor;
var Vector2D TeleporterOffset;
var float BaseX;
var float BaseY;
var ControllerSelection SelectedButton;
var LocalPlayer Player;

`FunctVar

delegate ButtonPress();

Function String LocalizedString(Name Tag, Optional Name Catagory='Text')
{
	Return Localize(String(Catagory), String(Tag), "SpeedrunHelper");
}

function DrawHUD() //Called every frame
{
	local OLSpeedController Controller;
	local OLGame CurrentGame;
	local OLSpeedPawn SpeedPawn;
	local string PlayerDebug;

	Super.DrawHUD(); //Run Parent Function First

	Controller = OLSpeedController(PlayerOwner); //Cast to OLSpeedController using 'PlayerOwner'
	CurrentGame = OLSpeedGame(WorldInfo.Game);
	SpeedPawn = OLSpeedPawn(Controller.Pawn);
	Buttons.Remove(0, Buttons.Length);

	BaseX=GetCorrectSizeX();


	DrawScaledBox( Vect2D(0, 0), Vect2D(130, 25), MakeRGBA(0,0,255));

	UpdateActorDebug(Controller, CurrentGame, SpeedPawn);

	ScreenTextDraw("Outlast Speedrun Helper\nProgrammed by Superboo07", vect2D(0,0), MakeRGBA(255,255,255));

	if (Controller.Collision_Type_Override!=Normal && OLHero(Controller.Pawn).CylinderComponent.CollisionRadius==30)
	{
		Controller.SetPlayerCollisionType(Controller.Collision_Type_Override);
	}
	if (Show_Menu)
	{
		Save_Position_Interface();
	}
}

Event UpdateActorDebug(OLSpeedController Controller, OLGame CurrentGame, OLSpeedPawn SpeedPawn)
{
	Local OLCheckpoint Checkpoint;
	local OLGameplayMarker GameplayMarker;
	local OLPickableObject PickableObject;
	local OLEnemyPawn EnemyPawn;
	local SkeletalMeshActor SkeletalMesh0;
	local OLDoor Door;
	local string string;
	local string PlayerDebug;
	local SequenceObject KismetCheckpoint;
	local bool IsCalledInKismet;
	local vector Forward;
	local vector Right;
	local vector Up;
	local vector NewLocationForward;
	local vector NewLocationRight;

	if (Controller.bIsActorDebugEnabled) 
	{
		PlayerDebug = PlayerDebug $ "\n\nPlayer Debug Info: \nCurrent Collision Size: " $ SpeedPawn.CylinderComponent.CollisionRadius $ "\nHealth: " $ SpeedPawn.Health;
		PlayerDebug = PlayerDebug $ "\nLocation: " $ SpeedPawn.Location $ "\nRotation: " $ Function.ConvertRotationUnitToDegrees(SpeedPawn.Rotation).Yaw $ ", " $ SpeedPawn.Camera.ViewCS.Pitch $ "\nIsPlayingDLC: " $ CurrentGame.bIsPlayingDLC;
		PlayerDebug = PlayerDebug $ "\nCurrent Speed: " $ SpeedPawn.CurrentRunSpeed $ "\nCurrent Movement State: " $ SpeedPawn.GetPlayerMovementState() $ "\nSpecial Move: " $ SpeedPawn.SpecialMove $ "\nbPlayingRunSnd: " $ SpeedPawn.bPlayingRunSnd;
		PlayerDebug = PlayerDebug $ "\nCurrent Objective Tag: " $ Controller.CurrentObjective $ "\nCurrent Checkpoint: " $ CurrentGame.CurrentCheckpointName;

		foreach AllActors(class'OLCheckpoint', Checkpoint)
		{
			string = string(Checkpoint.Class) $ "\nName: " $ String(Checkpoint.CheckpointName) $ "\nChapter: " $ Localize("Locations", String(Checkpoint.Tag), "OLGame"); //Pull Chapter Name from Localization Files.
			IsCalledInKismet=false;
			foreach Controller.AllCheckpointSeq(KismetCheckpoint)
			{
				if (KismetCheckpoint.Class == Class'OLSeqAct_Checkpoint') 
				{
					if (OLSeqAct_Checkpoint(KismetCheckpoint).CheckpointName == Checkpoint.CheckpointName) {IsCalledInKismet=true; }
				}
			}
			String = String $ "\nIsCalledInKismet: " $ IsCalledInKismet;
			if (CurrentGame.CurrentCheckpointName==Checkpoint.CheckpointName) {string = string $ "\nCurrent Checkpoint";} //If the Current Chapter is equal to the ChapterName of this Checkpoint, print Current Chapter.
			WorldTextDraw(string, Checkpoint.location, Controller.Max_View_Distance, 200, vect(100,0,0));
		}

		foreach AllActors(class'OLGameplayMarker', GameplayMarker)
		{
			if ( ContainsString( controller.Ignore_Actors, String(GameplayMarker.Class) ) ) { break; } //Check if the Ignore_Actor array from the player controller contains this class, if it does tell it to fuck off.

			string = string(GameplayMarker.class) $ "\n";
			if (GameplayMarker.BEnabled)
			{
				string = string $ "Enabled\n";
			}
			else
			{
				string = string $ "Disabled\n";
			}
			Switch(GameplayMarker.class) //Use Switch because i'm not Yandare Dev.
			{
				Case class'OLRecordingMarker':
					if (CurrentGame.IsPlayingDLC() )
					{
						string = string $ "Title: " $ Localize("Recordings", String(OLRecordingMarker(GameplayMarker).MomentName) $ "_Title", "OLNarrativeDLC");
					}
					else
					{
						string = string $ "Title: " $ Localize("Recordings", String(OLRecordingMarker(GameplayMarker).MomentName) $ "_Title", "OLNarrative"); /*Pull recording name from localization*/
					}
					string = string $ "\nName: " $ String(OLRecordingMarker(GameplayMarker).MomentName);
					string = string $ "\nNotification Delay: " $ OLRecordingMarker(GameplayMarker).NotificationDelay $ "\nRecording Time: " $ OLRecordingMarker(GameplayMarker).MinRecordingDuration;
					if ( ContainsName(Controller.CompletedRecordingMoments, OLRecordingMarker(GameplayMarker).MomentName) ) { string = string $ "\nRecorded"; }
					goto Print;
				break;

				case class'OLCSA':
					string = string $ "Required Item: " $ OLCSA(GameplayMarker).RequiredItem $ "\nMax Trigger Count: " $ OLCSA(GameplayMarker).MaxTriggerCount $ "\nRemaining Trigger Count: " $ OLCSA(GameplayMarker).MaxTriggerCount - OLCSA(GameplayMarker).TriggerCount;
					goto Print;
				break;

				Default: goto Print; break;
			}
			Print: 
			WorldTextDraw(string, GameplayMarker.location, Controller.Max_View_Distance, 200, vect(100,0,0));
		}

		foreach dynamicactors(Class'OLPickableObject', PickableObject)
		{
			string = string(PickableObject.class) $ "\n";
			if (PickableObject.bUsed==false && PickableObject.bHidden==false)
			{
				Switch(PickableObject.Class) //Use Switch because i'm not Yandare Dev.
				{
					case class'OLGameplayItemPickup':
						string = string $ "Item Name: " $ string( OLGameplayItemPickup(PickableObject).ItemName);
						Goto Print;
					break;

					case class'OLCollectiblePickup':
						if (CurrentGame.IsPlayingDLC() )
						{
							string = string $ "Title: " $ Localize("Documents", String(OLCollectiblePickup(PickableObject).CollectibleName) $ "_Title", "OLNarrativeDLC");
						}
						else
						{
							string = string $ "Title: " $ Localize("Documents", String(OLCollectiblePickup(PickableObject).CollectibleName) $ "_Title", "OLNarrative"); /*Pull recording name from localization*/
						}
						string = string $ "\nCollectable Name: " $ String(OLCollectiblePickup(PickableObject).CollectibleName); 
						Goto Print;
					break;

					Default: Goto Print;
				}
				Print: WorldTextDraw(string, PickableObject.location, Controller.Max_View_Distance, 150, vect(0,0,0));
			}
		}

		foreach dynamicactors(Class'OLEnemyPawn', EnemyPawn)
		{
			string = string(EnemyPawn.class) $ "\n";
			string = string $ "Should Attack: " $ EnemyPawn.Modifiers.bShouldAttack $ "\nDisableKnockbackFromPlayer: " $ EnemyPawn.Modifiers.bDisableKnockbackFromPlayer $ "\nEnemy Mode: " $ EnemyPawn.EnemyMode $ "\nBehavior Tree: " $ EnemyPawn.BehaviorTree;
			WorldTextDraw(string, EnemyPawn.location, Controller.Max_View_Distance, 200, vect(0,-450,0));
		}

		foreach dynamicactors(Class'OLDoor', Door)
		{
			String = Door.Class $ "\nDoes Collide: " $ Door.CollisionComponent.CollideActors $ "\nIs Locked: " $ Door.bLocked $ "\nDoor State: " $ Door.DoorState;
			WorldTextDraw(String, Door.location, Controller.Max_View_Distance, 200, vect(0,-450,0));
		}

	}

	if (Controller.bIsModDebugEnabled)
	{
		PlayerDebug=PlayerDebug $ "\n\nCanvas Debug: \nCurrent AspectRatio: " $ GetAspectRatio() $ "\nWidth: " $ Canvas.SizeX $ "\nHeight: " $ Canvas.SizeY;
		if (Controller.bIsOL2StaminaSimulatorEnabled)
		{
			PlayerDebug=PlayerDebug $ "\n\nStamina Debug: " $ "\nCurrent Stamina: " $ SpeedPawn.RunStamina $ "\nStamina Percent: " $ SpeedPawn.StaminaPercent $ "\nOut of Stamina: " $ SpeedPawn.bOutofStamina;
			PlayerDebug=PlayerDebug $ "\nCurrent Stamina State: " $ SpeedPawn.CurrentStaminaState $ "\nReady to sprint: " $ SpeedPawn.bReadytosprint;
		}

		if (Controller.bIsOL2BandageSimulatorEnabled)
		{
			PlayerDebug=PlayerDebug $ "\n\nBandageDebug: " $ "\nbNeedsBandage: " $ SpeedPawn.bNeedsBandage $ "\nIsBandaging: " $ SpeedPawn.bIsBandaging $ "\nWearing Bandage: " $ SpeedPawn.bHasBandage;
			PlayerDebug=PlayerDebug $ "\nSpeedPercent: " $ SpeedPawn.SpeedPercent;
		}
	}

	ScreenTextDraw(PlayerDebug, vect2d(0,25), MakeRGBA(255,255,255));
}

Event Save_Position_Interface()
{
	local OLSpeedInput PlayerInput;
	local Vector2D StartClip;
	local Vector2D EndClip;
	local OLSpeedController Controller;

	Controller = OLSpeedController(PlayerOwner);
	PlayerInput = OLSpeedInput(PlayerOwner.PlayerInput);

	DrawScaledBox( Vect2D( ( BaseX / 2) - 250, 250), Vect2D(500, 250),  BackgroundColor, StartClip, EndClip);

	EndClip = EndClip;

	DrawScaledBox( Vect2D( ( BaseX / 2) - 250, 250), Vect2D( 500, 10),  CommandLineColor,,);

	ScreenTextDraw(Command, vect2D( ( BaseX / 2) - 250, 250 ), CommandLineTextColor);

	Switch(CurrentMenu)
	{
		case Normal:
		AddLocalizedButton('CheckpointLoader', "LoadCheckpoint ", vect2d(15, 25),, true, StartClip, EndClip, true);
		AddLocalizedButton('ShowCheats', "SetMenu Cheats",, true);
		AddLocalizedButton('ShowDebug', "SetMenu Show",, true);
		AddLocalizedButton('ShowFunny', "SetMenu Funny",, true);
		AddLocalizedButtonDisplay('ShowPlayerModel', Controller.PlayerModel, "SetMenu PlayerModel",, true);
		AddLocalizedButton('ShowPositionSaver', "SetMenu SavePositionSelect",, true );
		AddLocalizedButton('ShowTeleporter', "SetMenu Teleporter",, true);
		AddLocalizedButton('ShowCredits', "SetMenu Credits",, true );
		AddLocalizedButton('ShowLogging', "SetMenu Logging",, true );
		break;

		case SavePositionSelect:
		DrawLocalizedText('SavePositionSelect', Vect2D( ( BaseX / 2), 300),,,, O_Center);
		AddButton(Vectortostring(Controller.Saved_Positions[1].Location), "Check_Position 1 | SetMenu SaveOrLoad", vect2d(15, 25),, true, StartClip, EndClip);
		AddButton(Vectortostring(Controller.Saved_Positions[2].Location), "Check_Position 2 | SetMenu SaveOrLoad", vect2d(1, 35),true, true);
		AddButton(Vectortostring(Controller.Saved_Positions[3].Location), "Check_Position 3 | SetMenu SaveOrLoad", vect2d(10, 35),true, true);
		AddButton(Vectortostring(Controller.Saved_Positions[4].Location), "Check_Position 4 | SetMenu SaveOrLoad", vect2d(5, 45),true, true);
		AddLocalizedButton('BackText', "SetMenu Normal", , true);
		break;

		case SaveOrLoad:
		ScreenTextDraw("Location: " $ Controller.Saved_Positions[Controller.Selected_Save].Location $ "\nRotation: " $ Function.Vect2DtoString( Controller.Saved_Positions[Controller.Selected_Save].Rotation ), vect2D(750, 350 ),,,, O_Center );
		AddLocalizedButton('Save', "Save_Position " $ Controller.Selected_Save, vect2d(15, 25),,, StartClip, EndClip);
		AddLocalizedButton('Load', "Load_Position " $ Controller.Selected_Save,, true);
		AddLocalizedButton('BackText', "SetMenu SavePositionSelect" , , true);
		break;

		case Show:
		AddLocalizedButton('FPS', "Stat FPS", vect2d(15, 25),,, StartClip, EndClip);
		AddLocalizedButton('LevelInformation', "Stat Levels", , true);
		AddLocalizedButton('ActorDebugInfo', "ToogleDebugView", , true);
		AddLocalizedButton('Collision', "Show Collision", , true);
		AddLocalizedButton('Volumes', "Show Volumes", , true);
		AddLocalizedButton('Fog', "Show Fog", , true);
		AddLocalizedButton('LevelColoration', "Show Levelcoloration", , true); 
		AddLocalizedButton('PostProcessing', "Show PostProcess", , true);
		AddLocalizedButton('ModDebugInfo', "ShowModDebug", , true); 
		AddLocalizedButton('ShowGrain', "ToogleGrain", , true);
		AddLocalizedButton('BackText', "SetMenu Normal", , true);
		break;

		case Collision:
		DrawLocalizedText('G40styCredit', vect2D( 500, 250 ),,,, O_Full, O_Full, StartClip );

		AddLocalizedButton('CollisionNormal', "SetPlayerCollisionType CT_Normal | SetMenu Cheats", vect2d(15, 25),,, StartClip, EndClip );
		AddLocalizedButton('CollisionVaulting', "SetPlayerCollisionType CT_Vault | SetMenu Cheats", , true );
		AddLocalizedButton('CollisionDoor', "SetPlayerCollisionType CT_Door | SetMenu Cheats", , true );
		AddLocalizedButton('CollisionShimmy', "SetPlayerCollisionType CT_Shimmy | SetMenu Cheats", , true );
		AddLocalizedButton('BackText', "SetMenu Cheats", , true);
		break;

		case Cheats:

		AddLocalizedButton('KillAllCheat', "KillAllEnemys",vect2d(15, 25),,, StartClip, EndClip );
		AddLocalizedButtonDisplay('FreecamCheat', !Controller.UsingFirstPersonCamera(), "ToogleFreeCam",, true);
		AddLocalizedButton('TeleportToFreecamCheat', "Teleporttofreecam",, true );
		AddLocalizedButtonDisplay('PlayerColliderSizeCheat', OLSpeedController(PlayerOwner).Collision_Type_Override, "SetMenu Collision",, true );
		AddLocalizedButtonDisplay('GodmodeCheat', Controller.bGodMode, "ToggleGod",, true );
		AddLocalizedButtonDisplay('ToggleDeathBoundsCheat', Controller.bDisableKillBound, "ToogleKillBound",, true );
		AddLocalizedButtonDisplay('UnlockAllDoorsCheat', Controller.bShouldUnlockAllDoors, "UnlockDoorsToggle",, true );
		AddLocalizedButtonDisplay('InfiniteBatteryCheat', Controller.bShouldHaveInfiniteBattery, "ToogleInfiniteBattery",, true );
		AddLocalizedButton('BackText', "SetMenu Normal", , true);
		break;

		Case Funny:
		AddLocalizedButtonDisplay('EveryoneFatherMartinFunny', Controller.bShouldMartinReplaceEnemyModels, "MartinifyToggle",vect2d(15, 25),,, StartClip, EndClip );
		AddLocalizedButtonDisplay('EveryoneWieldFatherMartin', Controller.bShouldWieldFatherMartin, "ToogleWieldFatherMartin",,true);
		AddLocalizedButtonDisplay('WernickeSkipFunny', Controller.bIsWernickeSkipEnabled, "WernikSkipToggle", , true);
		AddLocalizedButtonDisplay('FreeBhopsFunny', Controller.bShouldMakeBhopsFree, "FreeBhop", , true);
		AddLocalizedButtonDisplay('OL2BandageFunny', Controller.bIsOL2BandageSimulatorEnabled, "SimulateBandages", , true);
		AddLocalizedButtonDisplay('OL2StaminaFunny', Controller.bIsOL2StaminaSimulatorEnabled, "SimulateOL2Stamina", , true);
		AddLocalizedButtonDisplay('SeizureFunny', Controller.SpeedPawn.bShouldSeizure,"ToggleSeizure",,True);
		AddLocalizedButton('BackText', "SetMenu Normal", , true);
		Break;

		Case PlayerModel:
		DrawLocalizedText('PlayerModelHelp', vect2D( 0, 10 ),,,, ,, StartClip );
		AddButton("Miles", "UpdatePlayerModel PM_Miles",vect2d(15, 125),,, StartClip, EndClip );
		AddButton("Miles No Fingers", "UpdatePlayerModel PM_MilesNoFingers",, true);
		AddButton("WaylonIT", "UpdatePlayerModel PM_WaylonIT",, true);
		AddButton("Waylon Prisoner", "UpdatePlayerModel PM_WaylonPrisoner",, true);
		if (OLSpeedGame( Worldinfo.Game).IsDLCInstalled() ) {AddButton("Waylon Nude", "UpdatePlayerModel PM_Nude",, true); }
		if (Class'OLPlayerModel'!=None) {AddLocalizedButton('CustomPM', "UpdatePlayerModel PM_Custom ",, true,,,, true); }
		AddLocalizedButton('NoOverridePM', "UpdatePlayerModel PM_NoOverride",, true);
		AddLocalizedButton('BackText', "SetMenu Normal",, true);
		break;

		Case Credits:
		DrawLocalizedText('Credits', vect2D(0, 10 ),,, true,,,StartClip);
		AddLocalizedButton('BackText', "SetMenu Normal",vect2d(5, 205),,, StartClip, EndClip );
		break;

		Case Teleporter:
		ScreenTextDraw("Offset: " $ TeleporterOffset.X $ ", " $ TeleporterOffset.Y, vect2D(250, 50 ),,,, O_Center, O_Center, StartClip );
		AddLocalizedButton('Forward', "AddTeleportOffset 25 0", vect2d(15, 25),false, false, StartClip, EndClip);
		AddLocalizedButton('Left', "AddTeleportOffset 0 -25", vect2d(5, 50),false, false, StartClip, EndClip);
		AddLocalizedButton('Right', "AddTeleportOffset 0 25", vect2d(50, 50),false, false, StartClip, EndClip);
		AddLocalizedButton('Back', "AddTeleportOffset -25 0", vect2d(15, 75),false, false, StartClip, EndClip);
		AddLocalizedButton('Teleport', "Teleport_In_Direction " $ TeleporterOffset.X $ " " $ TeleporterOffset.Y, vect2d(5, 200),, true, StartClip, EndClip);
		AddLocalizedButton('BackText', "SetMenu Normal",vect2d(425, 425), true,, StartClip, EndClip );
		break;

		Case Logging:
		AddLocalizedButton('PrintCompObjectives', "OLLog Objectives", vect2d(15, 25),true, false, StartClip, EndClip);
		AddLocalizedButton('PrintAllCheckpoints', "OLLog Checkpoints",,true, false,);
		AddLocalizedButton('BackText', "SetMenu Normal", , true);
		break;

		Case PlayerScale:
		AddButton("Up", "OLLog Objectives", vect2d(15, 25),true, false, StartClip, EndClip);
	}
	DrawMouse();
}

Exec Function OLLog(String Log)
{
	local Sequence GameSeq;

	local name Name;
	local OLCheckpoint SavedCheckpoint;
	local SequenceObject SavedSequence;
	Local array<SequenceObject> SavedSequences;
	local bool bool;
	local int Index;

	GameSeq = WorldInfo.GetGameSequence();

	Switch(Log)
	{
		Case "Objectives":
			foreach OLSpeedController(PlayerOwner).CompletedObjectives(Name)
			{
				`log("ID: " $ Name);
				++Index;
			}
		break;

		Case "Checkpoints":
			`log("Beginning to print checkpoints (Not in order)");
			`log("------------------------------");
			Foreach AllActors(Class'OLGame.OLCheckpoint', SavedCheckpoint)
			{
				if (SavedCheckpoint == none) {break;}
				`log("Name: " $ SavedCheckpoint.CheckpointName);
				`log( "Chapter: " $ Localize("Locations", String(SavedCheckpoint.Tag), "OLGame") );
				`log("Location: " $ SavedCheckpoint.Location);
				bool=false;
				GameSeq.FindSeqObjectsByClass(class'OLSeqAct_Checkpoint', true, SavedSequences);
				foreach SavedSequences(SavedSequence)
				{
					if (SavedSequence.Class == Class'OLSeqAct_Checkpoint') 
					{
						if (OLSeqAct_Checkpoint(SavedSequence).CheckpointName == SavedCheckpoint.CheckpointName) {bool=true;}
					}
				}
				`log("Is triggered by Kismet: " $ bool);
				`log("------------------------------");
				++Index;
			}
		break;
	}
}

Exec Function MoveSelection( int Right, int Up)
{	
	local ButtonStruct Button;
	local Int StoredColumn;

	Button = FindButton(Buttons, SelectedButton.Row + Right, SelectedButton.Column);
	If (Button.Row==-1)
	{
		if (Right>0)
		{
			SelectedButton.Row = 1;
		}
		else if (Right<0)
		{
			Button = FindButton(Buttons, Buttons[Buttons.Length - 1].Row, SelectedButton.Column);
			if (Button.Row!=-1)
			{
				SelectedButton.Row = Button.Row;
			}
		}
	}
	else
	{
		SelectedButton.Row = SelectedButton.Row + Right;
	}

	Button = FindButton(Buttons, SelectedButton.Row, SelectedButton.Column + Up);
	If (Button.Row==-1)
	{
		if (Up<0) //Going up
		{
			if (SelectedButton.Row==1)
			{
				Button = FindButton(Buttons,  Buttons[Buttons.Length - 1].Row, Buttons[Buttons.Length - 1].Column);
				SelectedButton.Row=Button.Row;
				SelectedButton.Column=Button.Column;
			}
			else
			{
				Button = FindButton(Buttons,  SelectedButton.Row - 1, 1);
				StoredColumn=1;
				While (Button.Row!=-1)
				{
					Button = FindButton(Buttons,  SelectedButton.Row - 1, StoredColumn + 1);
					if (Button.Row!=-1)
					{
						StoredColumn = Button.Column;
					}
				}
				SelectedButton.Row=SelectedButton.Row - 1;
				SelectedButton.Column=StoredColumn;
			}
		}
		else if (Up>0) //Going down
		{
			Button = FindButton(Buttons,  Buttons[Buttons.Length - 1].Row, Buttons[Buttons.Length - 1].Column);
			if (SelectedButton.Row==Button.Row)
			{
				Button = FindButton(Buttons,  1, 1);
				SelectedButton.Row=Button.Row;
				SelectedButton.Column=Button.Column;
			}
			else
			{
				SelectedButton.Row=SelectedButton.Row + 1;
				SelectedButton.Column=1;
			}
		}
	}
	else
	{
		SelectedButton.Column = SelectedButton.Column + Up;
	}
}

Exec Function AddTeleportOffset(float X, Float Y)
{
	TeleporterOffset.X = TeleporterOffset.X + X;
	TeleporterOffset.Y = TeleporterOffset.Y + Y;
}

Exec Function SelectButton()
{
	local ButtonStruct Button;

	Button = FindButton(Buttons, SelectedButton.Row, SelectedButton.Column);

	if (Button.Template)
	{
		Command=Button.ConsoleCommand;
		return;
	}
	PlayerOwner.ConsoleCommand(Button.ConsoleCommand);
	return;
}

Function String VariableDisplay(String String, coerce String Var)
{
	Return String $ ": " $ Var;
}

Function String LocalizedVariableDisplay(Name ID, coerce String Var, Optional bool Button)
{
	if (Button) {Return VariableDisplay(LocalizedString(ID, 'Buttons'), Var);}
	Return VariableDisplay(LocalizedString(ID), var);
}

Function AddLocalizedButtonDisplay(Name ID, coerce string var, String ConsoleCommand, optional vector2D Location, optional bool AutoDown=False, optional bool Extend=False, optional vector2D Bound_Start, optional vector2D Bound_End, optional bool template)
{
	AddButton(LocalizedVariableDisplay(ID, Var, True), ConsoleCommand, Location, AutoDown, Extend, Bound_Start, Bound_End, template);
}

Function DrawMouse()
{
	local OLSpeedInput PlayerInput;
	local Vector2D scale;

	if (!bShouldDrawMouse) { Return; }

	PlayerInput = OLSpeedInput(PlayerOwner.PlayerInput);
	if (!PlayerInput.bLeftClick)
	{
		ScreenTextDraw(Cursor, Vect2d(PlayerInput.MousePosition.X,PlayerInput.MousePosition.Y), CursorOutlineColor,vect2d(CursorScale * CursorOutline,CursorScale * CursorOutline), false, O_Center, O_Center);
		ScreenTextDraw(Cursor, Vect2d(PlayerInput.MousePosition.X,PlayerInput.MousePosition.Y), CursorColor,vect2d(CursorScale,CursorScale), false, O_Center, O_Center);
	}
	else
	{
		ScreenTextDraw(Cursor, Vect2d(PlayerInput.MousePosition.X,PlayerInput.MousePosition.Y), CursorColor,vect2d(CursorScale * CursorOutline,CursorScale * CursorOutline), false, O_Center, O_Center);
		ScreenTextDraw(Cursor, Vect2d(PlayerInput.MousePosition.X,PlayerInput.MousePosition.Y), CursorOutlineColor,vect2d(CursorScale,CursorScale), false, O_Center, O_Center);
	}
}

Function WorldTextDraw( string Text, vector location, Float Max_View_Distance, float scale, optional vector offset ) //Simple function for drawing text in 3D space
{
	Local Vector DrawLocation; //Location to Draw Text
	Local Vector CameraLocation; //Location of Player Camera
	Local Vector2D AdditionLocation;
	Local Rotator CameraDir; //Direction the camera is facing
	Local Float Distance; //Distance between Camera and text
	Local Vector2D TextSize;
	Local Vector2D ScaledOffset2D;
	Local Array<String> StringArray;
	local FontRenderInfo FontRenderInfo;

	PlayerOwner.GetPlayerViewPoint( CameraLocation, CameraDir );
	distance =  ScalebyCam( VSize(CameraLocation - Location) ); //Get the distance between the camera and the location of the text being placed, then scale it by the camera's FOV. 
	DrawLocation = Canvas.Project(Location); //Project the 3D location into 2D space.
	ScaledOffset2D.X = Offset.X;
	ScaledOffset2D.Y = Offset.Y;
	ScaledOffset2D = Scale2dVector(ScaledOffset2D);
	Offset.X = ScaledOffset2D.X;
	Offset.Y = ScaledOffset2D.Y;
	if ( vector(CameraDir) dot (location - CameraLocation) > 0.0 && distance < Max_View_Distance )
	{
		Scale = Scale / Distance; //Scale By distance. 
		StringArray = SplitString(Text, "\n", false);
		foreach StringArray(Text)
		{
			FontRenderInfo.bClipText = True;
			Canvas.SetPos(DrawLocation.X + ( Offset.X * Scale ), ( (DrawLocation.Y + AdditionLocation.Y) + ( Offset.Y * Scale ) ), DrawLocation.Z ); //Set the Position of text using the Draw Location and an optional Offset. 
		
			canvas.strlen(Text, TextSize.X, TextSize.Y);
			canvas.SetDrawColor(BackgroundColor.Red, BackgroundColor.Green, BackgroundColor.Blue, BackgroundColor.Alpha);
			Canvas.DrawRect( (TextSize.X * scale) / 1280.0f * Canvas.SizeX, (TextSize.Y * scale) / 1280.0f * Canvas.SizeX);
		
			canvas.SetDrawColor(DefaultTextColor.Red, DefaultTextColor.Green, DefaultTextColor.Blue, DefaultTextColor.Alpha);
			Canvas.SetPos( DrawLocation.X + ( Offset.X * Scale ), ( (DrawLocation.Y + AdditionLocation.Y) + ( Offset.Y * Scale ) ), DrawLocation.Z ); //Set the Position of text using the Draw Location and an optional Offset. 
			Canvas.DrawText(Text, false, Scale / 1280.0f * Canvas.SizeX, Scale / 1280.0f * Canvas.SizeX, FontRenderInfo ); //Draw the text
			AdditionLocation.Y = AdditionLocation.Y + ( (TextSize.Y * scale) / 1280.0f * Canvas.SizeX );
			// / 720.0f * Canvas.SizeY
		}
	}
}

Function ScreenTextDraw(String Text, Vector2D Location, optional RGBA Color=DefaultTextColor, optional Vector2D Scale=Vect2D(1,1), optional bool Scale_Location=True, optional EOffset OffsetX, optional EOffset OffsetY, optional vector2D Bound_Start)
{
	local vector2D ScaleCalc;
	local vector2D TextSize;
	local vector2D PreviousOrigin;

	PreviousOrigin = vect2d(Canvas.OrgX, Canvas.OrgY);

	Canvas.SetOrigin(Bound_Start.X, Bound_Start.Y);

	ScaleCalc=Scale2dVector( Vect2D( 0.70 * Scale.X ,  0.70 * Scale.Y));

	canvas.TextSize(Text, TextSize.X, TextSize.Y, ScaleCalc.X, ScaleCalc.Y);
	
	if (Scale_Location)
	{
		Location=Scale2dVector(Location);
	}
	Switch(OffsetX)
	{
		Case O_Center:
		Location.X=Location.X - (TextSize.X / 2);
		Break;

		Case O_Full:
		Location.X=Location.X - TextSize.X;
		break;
	}
	Switch (OffsetY)
	{
		Case O_Center:
		Location.Y = Location.Y - (TextSize.Y / 2);
		break;

		Case O_Full:
		Location.Y=Location.Y - TextSize.Y;
		break;
	}
	Canvas.SetPos(Location.X,Location.Y);
	canvas.SetDrawColor(Color.Red,Color.Green,Color.Blue,Color.Alpha);
	Canvas.DrawText(Text, false, ScaleCalc.X, ScaleCalc.Y);
	Canvas.SetOrigin(PreviousOrigin.X, PreviousOrigin.Y);
}

Function DrawLocalizedText(Name ID, Vector2D Location, optional RGBA Color=DefaultTextColor, optional Vector2D Scale=Vect2D(1,1), optional bool Scale_Location=True, optional EOffset OffsetX, optional EOffset OffsetY, optional vector2D Bound_Start)
{
	ScreenTextDraw(LocalizedString(ID),Location,Color,Scale,Scale_Location,OffsetX, OffsetY, Bound_Start);
}

Function Float ScalebyCam(Float Float) //Function to scale a float by the players current FOV. 
{
	Local Float Scale;
	Scale = ( PlayerOwner.GetFOVAngle() / 100 );

	Return Float * Scale;
}

Function RGBA MakeRGBA(byte R, byte G, byte B, optional byte A=255)
{
	local RGBA RGBShit;

	RGBShit.Red=R;
	RGBShit.Green=G;
	RGBShit.Blue=B;
	RGBShit.Alpha=A;

	Return RGBShit;
}
Function Bool ContainsName(Array<Name> Array, Name find) //Check if Array contains Name Variable. 
{
	Switch(Array.Find(find) )
	{
		case -1: Return False;

		Default: Return true;
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

function click()
{
	local OLSpeedInput PlayerInput;
	local ButtonStruct buttonvar;
	local IntPoint MousePosition;

	PlayerInput = OLSpeedInput(PlayerOwner.PlayerInput);

	MousePosition = PlayerInput.MousePosition;

	foreach Buttons(buttonvar)
	{
		if ( MouseInbetween(buttonvar.AbsoluteLocation, buttonvar.AbsoluteLocation + buttonvar.ScaledOffset ) )
		{
			if (ButtonVar.Template)
			{
				Command=buttonvar.ConsoleCommand;
				return;
			}
			PlayerOwner.ConsoleCommand(buttonvar.ConsoleCommand);
			return;
		}
	}
	return;
}

Function Commit()
{
	PlayerOwner.ConsoleCommand(Command);
	Command="";
}

Function AddButton(String Name, String ConsoleCommand, optional vector2D Location, optional bool AutoDown=False, optional bool Extend=False, optional vector2D Bound_Start, optional vector2D Bound_End, optional bool template)
{
	local vector2D Begin_PointCalc, End_PointCalc, Offset, Center_Vector, TextSize, AbsoluteLocation, PreviousOrigin;
	local RGBA Color, TextColor;
	local ButtonStruct ButtonBase, PreviousButton, FirstButtonInRow, ButtonInColumn;
	local int Row, Column;

	PreviousOrigin = vect2d(Canvas.OrgX, Canvas.OrgY); // Set previous origin for later

	Canvas.SetOrigin(Bound_Start.X, Bound_Start.Y);

	//Default Color Values
	Color=ButtonColor;
	TextColor=ButtonHoveredColor;

	Canvas.TextSize(Name, TextSize.X, TextSize.Y);
	offset=vect2D( 15 + (TextSize.X / 1.5), 5 + (TextSize.Y / 1.5) );

	if (Buttons.Length==0) //Set Defaults
	{
	   Row=1;
	   Column=1;
	   Location.X = Location.X;
	   Location.Y = Location.Y;
	}
	else
	{
		PreviousButton=Buttons[ (Buttons.Length - 1 ) ]; //Fuck you unreal 3 and you not having a proper array length. it counts from 0, NOT FUCKING 1. Bitch
		Row=PreviousButton.Row;
		Column=PreviousButton.Column+1;
		FirstButtonInRow=FindButton(Buttons, Row, 1);
		if (FirstButtonInRow.Row!=-1)
		{
			Bound_Start = FirstButtonInRow.ClipStart;
			Bound_End = FirstButtonInRow.ClipEnd;
			if (AutoDown)
			{
				Location.X = PreviousButton.Location.X;
				Location.Y = (PreviousButton.Location.Y + PreviousButton.Offset.Y) + 10;
				if( !InRange( Scale2dVector(Location).Y + Bound_Start.Y + Offset.Y, Bound_Start.Y, Bound_Start.Y + Bound_End.Y) )
				{
					Location.X = (FirstButtonInRow.Location.X + FirstButtonInRow.Offset.X) + 10;
					Location.Y = FirstButtonInRow.Location.Y;
					++ Row;
					Column=1;
				}
				else if (Column>1)
				{
					ButtonInColumn=FindButton(Buttons, (Row - 1), Column);
					if (ButtonInColumn.Row!=-1)
					{
						Location.X = (ButtonInColumn.Location.X + ButtonInColumn.Offset.X) + 10;
					}
				}
			}
		}
	}

	AbsoluteLocation = Scale2dvector(Location) + Bound_Start;

	If ( ( MouseInbetween(AbsoluteLocation, AbsoluteLocation + Scale2DVector(Offset ) ) && bShouldDrawMouse ) || SelectedButton.Row==Row && SelectedButton.Column==Column && !bShouldDrawMouse) //Use your eyes :Kappap:
	{
		Color=ButtonHoveredColor;
		TextColor=ButtonColor;
	}

	//Draw the button box
	DrawScaledBox(Location, offset, Color, Begin_PointCalc, End_PointCalc, Bound_Start);

	Begin_PointCalc = Begin_PointCalc - Bound_Start;
	End_PointCalc = End_PointCalc - Bound_Start;

	//Get the center of the button
	Center_Vector=vect2D( ( Begin_PointCalc.X + (Begin_PointCalc.X + End_PointCalc.X) ) / 2, ( Begin_PointCalc.Y + ( Begin_PointCalc.Y + End_PointCalc.Y ) ) / 2);

	//Draw Button Text Centered.
	ScreenTextDraw(Name, Center_Vector,  TextColor,, false, O_Center, O_Center, Bound_Start);

	Begin_PointCalc = Begin_PointCalc + Bound_Start; //Add the bound offset to get absolute value
	End_PointCalc = End_PointCalc + Bound_Start;

	//Add the button info to the array
	ButtonBase.Name=Name;
	ButtonBase.ConsoleCommand=ConsoleCommand;
	ButtonBase.Start_Points=Begin_PointCalc;
	ButtonBase.End_Point=vect2d( (Begin_PointCalc.X + End_PointCalc.X), (Begin_PointCalc.Y + End_PointCalc.Y ) ); //Do math and add the calcs together to get the absolute end point.
	ButtonBase.Template=template; //Does button require user input after pressing
	ButtonBase.Location=Location;
	ButtonBase.Offset=Offset;
	ButtonBase.ClipStart=Bound_Start;
	ButtonBase.ClipEnd=Bound_End;
	ButtonBase.Row=Row;
	ButtonBase.Column=Column;
	ButtonBase.AbsoluteLocation=AbsoluteLocation;
	ButtonBase.ScaledOffset=Scale2dVector(Offset);

	Buttons.AddItem(ButtonBase);

	Canvas.SetOrigin(PreviousOrigin.X, PreviousOrigin.Y); //Set the origin back to the previous offset
}

Function AddLocalizedButton(Name ID, String ConsoleCommand, optional vector2D Location, optional bool AutoDown=False, optional bool Extend=False, optional vector2D Bound_Start, optional vector2D Bound_End, optional bool template)
{
	AddButton(LocalizedString(ID, 'Buttons'), ConsoleCommand, Location, AutoDown, Extend, Bound_Start, Bound_End, template);
}

function bool InRange(float Target, Float RangeMin, Float RangeMax)
{
	Return Target>RangeMin && Target<RangeMax;
}

Exec Function SetMenu(Menu Menu)
{
	CurrentMenu=Menu;
	SelectedButton=Default.SelectedButton;
}

Function IntPoint GetMousePosition()
{
	local OLSpeedInput PlayerInput;

	PlayerInput = OLSpeedInput(PlayerOwner.PlayerInput);

	return PlayerInput.MousePosition;
}

Function Bool Mouseinbetween(Vector2D Vector1, Vector2D Vector2)
{
	local intpoint MousePosition;

	MousePosition=GetMousePosition();
	
	Return InRange(MousePosition.X, Vector1.X, Vector2.X) && InRange(MousePosition.Y, Vector1.Y, Vector2.Y );
}

Function DrawScaledBox(Vector2D Begin_Point, Vector2D End_Point, optional RGBA Color=MakeRGBA(255,255,255,255), optional out Vector2D Begin_Point_Calculated, optional out Vector2D End_Point_Calculated, optional vector2D Bound_Start  )
{
	local vector2D PreviousOrigin;

	PreviousOrigin = vect2d(Canvas.OrgX, Canvas.OrgY);

	Canvas.SetOrigin(Bound_Start.X, Bound_Start.Y);

	Begin_Point_Calculated = Scale2DVector(Begin_Point);

	End_Point_Calculated = Scale2DVector(End_Point);

	Canvas.SetPos( Begin_Point_Calculated.X, Begin_Point_Calculated.Y);
	canvas.SetDrawColor(Color.Red,Color.Green,Color.Blue,Color.Alpha);
	Canvas.DrawRect( End_Point_Calculated.X, End_Point_Calculated.Y);

	Begin_Point_Calculated = Scale2DVector(Begin_Point) + Bound_Start;

	End_Point_Calculated = Scale2DVector(End_Point) + Bound_Start;

	Canvas.SetOrigin(PreviousOrigin.X, PreviousOrigin.Y);
}

Function Vector2D Scale2DVector(Vector2D Vector)
{
	local Float AspectRatio;

	AspectRatio = GetAspectRatio();

	if (AspectRatio>=1.7) //16:9
	{
		Vector.X=Vector.X / 1280.0f * Canvas.SizeX;
		Vector.Y=Vector.Y / 1280.0f * Canvas.SizeX;
	}
	else if (AspectRatio>=1.3) //4:3
	{
		Vector.X=Vector.X / 1024.0f * Canvas.SizeX;
		Vector.Y=Vector.Y / 1024.0f * Canvas.SizeX;
	}

	Return Vector;
}

Function Float GetCorrectSizeX()
{
	local Float AspectRatio;

	AspectRatio = GetAspectRatio();

	if (AspectRatio>=1.7) //16:9
	{
		Return 1280.0f;
	}
	else if (AspectRatio>=1.3) //4:3
	{
		Return 1024.0f;
	}

}

Function Float GetAspectRatio()
{
	local vector2D ViewportSize;

	if (Player==None)
	{
		Player = LocalPlayer(PlayerOwner.Player);
	}
	Player.ViewportClient.GetViewportSize(ViewportSize);
	Return ViewportSize.X / ViewportSize.Y;
}

Function ButtonStruct FindButton(Array<ButtonStruct> Array, Int Row, Int Column)
{
	local ButtonStruct Button;

	foreach array(Button)
	{
		if (Button.Row==Row)
		{
			if (Button.Column==Column)
			{
				Return Button;
			}
		}
	}
	Button.Row=-1;
	Return Button;
}

exec function HideMenu()
{
	PlayerOwner.ConsoleCommand("OpenConsoleMenu 0");
	super.HideMenu();
}

Function Bool Vector2DInRange(Vector2D Target, Vector2D Vector1, Vector2D Vector2)
{
	Return InRange(Target.X, Vector1.X, Vector2.X) && InRange(Target.Y, Vector1.Y, Vector2.Y );
}

Function String Vectortostring(Vector Target)
{
	local string String;

	string=Target.X $ ", " $ Target.Y $ ", " $ Target.Z;

	Return string;
}

Function String CamViewtoString(CamView View)
{
	Return View.Pitch $ ", " $ View.Yaw $ ", " $ View.Roll;
}

Function Vector2d GetAdjustedTextSize(String Text, EOffset Offset)
{
	Local Vector2D SavedPos;
	Local Vector2D Location;
	Local Vector2D TextSize;
	Local Vector2D AdjustedTextSize;
	Canvas.TextSize(Text, TextSize.X, TextSize.Y);
	Switch(Offset)
	{
		Case O_Center:
		Location=Vect2D(Location.X - (TextSize.X / 2), Location.Y - (TextSize.Y / 2) );
		Break;

		Case O_Full:
		Location=Vect2D(Location.X - TextSize.X, Location.Y - TextSize.Y);
		break;
	}
	SavedPos=Vect2d(Canvas.CurX,Canvas.CurY);
	Canvas.SetPos(Location.X,Location.Y);
	Canvas.TextSize(Text,AdjustedTextSize.X, AdjustedTextSize.Y);
	Canvas.SetPos(SavedPos.X,SavedPos.Y);
	Return Scale2dVector(AdjustedTextSize);
}


//This function pauses the game when the window loses focus.
event OnLostFocusPause(bool bEnable)
{
	bLostFocus = bEnable; //Still set bLostFocus in case a function relys on it. 
	/*Check if the caller is asking to pause the game and if 'bShouldPauseWithoutFocus' is not true, if so return the function to avoid pausing. 
	It should not return the function if the game is asking to unpause, even if somehow 'bShouldPauseWithoutFocus' is suddenly not true while it's paused.*/
	if (bEnable && !bShouldPauseWithoutFocus) {Return;}
	Super.OnLostFocusPause(bEnable); //Call parent event
}

DefaultProperties
{
	`FunctObj

	SelectedButton=(Row=1, Column=1)
	bShouldDrawMouse=true;
}