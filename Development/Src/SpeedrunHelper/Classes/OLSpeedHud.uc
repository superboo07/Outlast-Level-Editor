Class OLSpeedHud extends OLHud;

function DrawHUD() //Called every frame
{
    local OLSpeedController Controller;
    Local OLCheckpoint Checkpoint;
    local OLGameplayMarker GameplayMarker;
    local OLPickableObject PickableObject;
    local OLEnemyPawn EnemyPawn;
    local string string;

    Super.DrawHUD(); //Run Parent Function First

    Controller = OLSpeedController(PlayerOwner); //Cast to OLSpeedController using 'PlayerOwner'

    if (Controller.Enabled) 
    {
        foreach AllActors(class'OLCheckpoint', Checkpoint)
        {
            string = string(Checkpoint.Class) $ "\nName: " $ String(Checkpoint.CheckpointName) $ "\nChapter: " $ Localize("Locations", String(Checkpoint.Tag), "OLGame"); //Pull Chapter Name from Localization Files.
            if (OLGame(WorldInfo.Game).CurrentCheckpointName==Checkpoint.CheckpointName) {string = string $ "\nCurrent Checkpoint";} //If the Current Chapter is equal to the ChapterName of this Checkpoint, print Current Chapter.
            WorldTextDraw(string, Checkpoint.location, Controller.Max_View_Distance, 200, vect(100,0,0));
        }

        foreach AllActors(class'OLGameplayMarker', GameplayMarker)
        {
            if ( ContainsString( controller.Ignore_Actors, String(GameplayMarker.Class) ) ) { break; } //Check if the Ignore_Actor array from the player controller contains this class, if it does tell it to fuck off.

            string = string(GameplayMarker.class) $ "\n";
            Switch(GameplayMarker.class) //Use Switch because i'm not Yandare Dev.
            {
                Case class'OLRecordingMarker':
                    string = string $ "Title: " $ Localize("Recordings", String(OLRecordingMarker(GameplayMarker).MomentName) $ "_Title", "OLNarrative") /*Pull recording name from localization*/ $ "\nName: " $ String(OLRecordingMarker(GameplayMarker).MomentName);
                    if ( ContainsName(Controller.CompletedRecordingMoments, OLRecordingMarker(GameplayMarker).MomentName) ) { string = string $ "\nRecorded"; }
                    goto Print;
                break;

                case class'OLCSA':
                    string = string $ "Required Item: " $ OLCSA(GameplayMarker).RequiredItem $ "\nMax Trigger Count: " $ OLCSA(GameplayMarker).MaxTriggerCount $ "\nRemaining Trigger Count: " $ OLCSA(GameplayMarker).MaxTriggerCount - OLCSA(GameplayMarker).TriggerCount;
                    goto Print;
                break;

                Default: goto Print; break;
            }
            Print: WorldTextDraw(string, GameplayMarker.location, Controller.Max_View_Distance, 200, vect(100,0,0));
        }

        foreach allactors(Class'OLPickableObject', PickableObject)
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
                        string = string $ "Title: " $ Localize("Documents", String(OLCollectiblePickup(PickableObject).CollectibleName) $ "_Title", "OLNarrative") /*Pull document name from localization*/ $ "\nCollectable Name: " $ String(OLCollectiblePickup(PickableObject).CollectibleName); 
                        Goto Print;
                    break;

                    Default: Goto Print;
                }
                Print: WorldTextDraw(string, PickableObject.location, Controller.Max_View_Distance, 150, vect(0,0,0));
            }
        }

        foreach allactors(Class'OLEnemyPawn', EnemyPawn)
        {
            string = string(EnemyPawn.class) $ "\n";
            string = string $ "Should Attack: " $ EnemyPawn.Modifiers.bShouldAttack $ "\nEnemy Mode: " $ EnemyPawn.EnemyMode $ "\nBehavior Tree: " $ EnemyPawn.BehaviorTree;
            WorldTextDraw(string, EnemyPawn.location, Controller.Max_View_Distance, 200, vect(0,-450,0));
        }
    }
}

Function WorldTextDraw( string Text, vector location, Float Max_View_Distance, float scale, optional vector offset ) //Simple function for drawing text in 3D space
{
    Local Vector DrawLocation; //Location to Draw Text
    Local Vector CameraLocation; //Location of Player Camera
    Local Rotator CameraDir; //Direction the camera is facing
    Local Float Distance; //Distance between Camera and text

    PlayerOwner.GetPlayerViewPoint( CameraLocation, CameraDir );
    distance = ScalebyCam( VSize(CameraLocation - Location) ); //Get the distance between the camera and the location of the text being placed, then scale it by the camera's FOV. 
    DrawLocation = Canvas.Project(Location); //Project the 3D location into 2D space. 
    if ( vector(CameraDir) dot (location - CameraLocation) > 0.0 && distance < Max_View_Distance )
    {
        Scale = Scale / Distance; //Scale By distance. 
        Canvas.SetPos( DrawLocation.X + (Offset.X * Scale), DrawLocation.Y + (Offset.Y * Scale), DrawLocation.Z + (Offset.Z * Scale) ); //Set the Position of text using the Draw Location and an optional Offset. 
        Canvas.DrawText(Text, false, Scale, Scale); //Draw the text
    }
}

Function Float ScalebyCam(Float Float) //Function to scale a float by the players current FOV. 
{
    Local Float Scale;
    Scale = ( PlayerOwner.GetFOVAngle() / 100 );

    Return Float * Scale;
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