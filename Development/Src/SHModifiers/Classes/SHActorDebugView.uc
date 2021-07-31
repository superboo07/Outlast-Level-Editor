Class SHActorDebugView extends SHModifier;

var config array<String> IgnoreActors;
var config Float MaxViewDistance;

Event onDisable()
{
    local spriteview Just_Spawned;

    foreach AllActors(class'spriteview', Just_Spawned) //Destory all currently spawned Sprites
	{
		Just_Spawned.Destroy();
	}
}

Event onTimer()
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

	SHOptions(Owner).PlayerController.GetPlayerViewPoint( CameraLocation, CameraDir );

	foreach AllActors(class'spriteview', Just_Spawned) //Destory all currently spawned sprites
	{
		Just_Spawned.Destroy();
	}

	foreach AllActors(class'OLGameplayMarker', GameplayMarker)
	{
		Location = GameplayMarker.Location;
		ignore=false;

		if (IgnoreActors.Find(String(GameplayMarker.Class))!=Index_NONE ) { break; } //Check if Ignore_Actor array contains this class, if it does tell it to fuck off.

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

Event onDrawHUD(SHHUD Caller)
{
	Local OLCheckpoint Checkpoint;
	local OLGameplayMarker GameplayMarker;
	local OLPickableObject PickableObject;
	local OLEnemyPawn EnemyPawn;
	local SkeletalMeshActor SkeletalMesh0;
	local OLDoor Door;
	local string string, PlayerDebug;
	local SequenceObject KismetCheckpoint;
	local bool IsCalledInKismet;
	local vector Forward, Right, Up, NewLocationForward, NewLocationRight;

	if (True) 
	{
		PlayerDebug = PlayerDebug $ "\n\nPlayer Debug Info: \nCurrent Collision Size: " $ Caller.SpeedPawn.CylinderComponent.CollisionRadius $ "\nHealth: " $ Caller.SpeedPawn.Health;
		PlayerDebug = PlayerDebug $ "\nLocation: " $ Caller.SpeedPawn.Location $ "\nRotation: " $ Caller.Function.ConvertRotationUnitToDegrees(Caller.SpeedPawn.Rotation).Yaw $ ", " $ Caller.SpeedPawn.Camera.ViewCS.Pitch $ "\nIsPlayingDLC: " $ Caller.CurrentGame.bIsPlayingDLC;
		PlayerDebug = PlayerDebug $ "\nCurrent Speed: " $ Caller.SpeedPawn.CurrentRunSpeed $ "\nCurrent Movement State: " $ Caller.SpeedPawn.GetPlayerMovementState() $ "\nSpecial Move: " $ Caller.SpeedPawn.SpecialMove $ "\nbPlayingRunSnd: " $ Caller.SpeedPawn.bPlayingRunSnd;
		PlayerDebug = PlayerDebug $ "\nCurrent Objective Tag: " $ Caller.Controller.CurrentObjective $ "\nCurrent Checkpoint: " $ Caller.CurrentGame.CurrentCheckpointName $ "\nDelta Time: " $ Caller.DeltaTimeHUD;

		foreach AllActors(class'OLCheckpoint', Checkpoint)
		{
			string = string(Checkpoint.Class) $ "\nName: " $ String(Checkpoint.CheckpointName) $ "\nChapter: " $ Localize("Locations", String(Checkpoint.Tag), "OLGame"); //Pull Chapter Name from Localization Files.
			IsCalledInKismet=false;
			/*foreach Controller.AllCheckpointSeq(KismetCheckpoint)
			{
				if (KismetCheckpoint.Class == Class'OLSeqAct_Checkpoint') 
				{
					if (OLSeqAct_Checkpoint(KismetCheckpoint).CheckpointName == Checkpoint.CheckpointName) {IsCalledInKismet=true; }
				}
			}*/
			String = String $ "\nIsCalledInKismet: " $ IsCalledInKismet;
			if (Caller.CurrentGame.CurrentCheckpointName==Checkpoint.CheckpointName) {string = string $ "\nCurrent Checkpoint";} //If the Current Chapter is equal to the ChapterName of this Checkpoint, print Current Chapter.
			Caller.WorldTextDraw(string, Checkpoint.location, MaxViewDistance, 200, vect(100,0,0));
		}

		foreach AllActors(class'OLGameplayMarker', GameplayMarker)
		{
			if ( IgnoreActors.find(string(GameplayMarker.Class))!=INDEX_NONE ) { break; } //Check if the Ignore_Actor array from the player controller contains this class, if it does tell it to fuck off.

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
					if (Caller.CurrentGame.IsPlayingDLC() )
					{
						string = string $ "Title: " $ Localize("Recordings", String(OLRecordingMarker(GameplayMarker).MomentName) $ "_Title", "OLNarrativeDLC");
					}
					else
					{
						string = string $ "Title: " $ Localize("Recordings", String(OLRecordingMarker(GameplayMarker).MomentName) $ "_Title", "OLNarrative"); /*Pull recording name from localization*/
					}
					string = string $ "\nName: " $ String(OLRecordingMarker(GameplayMarker).MomentName);
					string = string $ "\nNotification Delay: " $ OLRecordingMarker(GameplayMarker).NotificationDelay $ "\nRecording Time: " $ OLRecordingMarker(GameplayMarker).MinRecordingDuration;
					if ( Caller.ContainsName(Caller.Controller.CompletedRecordingMoments, OLRecordingMarker(GameplayMarker).MomentName) ) { string = string $ "\nRecorded"; }
					goto Print;
				break;

				case class'OLCSA':
					string = string $ "Required Item: " $ OLCSA(GameplayMarker).RequiredItem $ "\nMax Trigger Count: " $ OLCSA(GameplayMarker).MaxTriggerCount $ "\nRemaining Trigger Count: " $ OLCSA(GameplayMarker).MaxTriggerCount - OLCSA(GameplayMarker).TriggerCount;
					goto Print;
				break;

				Default: goto Print; break;
			}
			Print: 
			Caller.WorldTextDraw(string, GameplayMarker.location, MaxViewDistance, 200, vect(100,0,0));
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
						if (Caller.CurrentGame.IsPlayingDLC() )
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
				Print: Caller.WorldTextDraw(string, PickableObject.location, MaxViewDistance, 150, vect(0,0,0));
			}
		}

		foreach dynamicactors(Class'OLEnemyPawn', EnemyPawn)
		{
			string = string(EnemyPawn.class) $ "\n";
			string = string $ "Should Attack: " $ EnemyPawn.Modifiers.bShouldAttack $ "\nDisableKnockbackFromPlayer: " $ EnemyPawn.Modifiers.bDisableKnockbackFromPlayer $ "\nEnemy Mode: " $ EnemyPawn.EnemyMode $ "\nBehavior Tree: " $ EnemyPawn.BehaviorTree;
			Caller.WorldTextDraw(string, EnemyPawn.location, MaxViewDistance, 200, vect(0,-450,0));
		}

		foreach dynamicactors(Class'OLDoor', Door)
		{
			String = Door.Class $ "\nDoes Collide: " $ Door.CollisionComponent.CollideActors $ "\nIs Locked: " $ Door.bLocked $ "\nDoor State: " $ Door.DoorState;
			Caller.WorldTextDraw(String, Door.location, MaxViewDistance, 200, vect(0,-450,0));
		}

	}

	Caller.PlayerDebug = Caller.PlayerDebug $ PlayerDebug;
}